//
//  ArticleService.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/24/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseDatabase

class ArticleService {
    static func getSaved() -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func getFavorited() -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorited == true")
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func getCached(readTime: Int) -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isViewed == false && readTime == \(readTime)")
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func cache() {
        DispatchQueue.global(qos: .background).async {
            let newsSourceIDs = NewsSourceService.getSaved().filter{$0.isEnabled}.map{$0.id!}
            let ref = Database.database().reference()
            Constants.Settings.timeOptions.forEach { time in
                let timeRef = ref.child("time\(time)minutes")
                newsSourceIDs.forEach { newsSourceID in
                    timeRef.child(newsSourceID).observeSingleEvent(of: .value, with: { (snapshot) in
                        CoreDataHelper.persistentContainer.performBackgroundTask { (context) in
                            debugPrint(snapshot.value!)
                            guard let value = snapshot.value as? [String: [String:String]] else {
                                return
                            }
                            value.values.forEach { articleDict in
                                let article = Article(context: context)
                                article.date = articleDict["date"]
                                article.source = newsSourceID
                                article.time = Int16(time)
                                article.title = articleDict["title"]
                                article.url = articleDict["url"]
                                article.urlToImage = articleDict["urlToImage"]
                                debugPrint(article)
                            }
                            do {
                                // attempt to save
                                try context.save()
                            } catch {
                                fatalError("Failure to save context: \(error)")
                            }
                        }
                    })
                }
            }
        }
        
    }

    /* build database using relevant articles from saved news sources */
    static func buildDatabase() {
        DispatchQueue.global(qos: .background).async {
            // TODO: not correct thread ughghhhh
            let newsSourceIDs = NewsSourceService.getSaved().map{$0.id!}
            newsSourceIDs.forEach { newsSourceID in
                let sourcesUrl = Constants.NewsAPI.articlesUrl(source: newsSourceID)
                // get json for each news source
                Alamofire.request(sourcesUrl).validate().responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let value = response.result.value else {
                            print("Error: Alamofire response JSON could not be evaluated.")
                            return
                        }
                        let jsonArticles = JSON(value)["articles"].arrayValue
                        // upload article for each json
                        jsonArticles.forEach { jsonArticle in
                            let url = jsonArticle["url"].stringValue
                            ReadabilityService.textIn(url: url) { text in
                                // calculate read time
                                let characters = text.characters.count
                                let words = Double(characters) / Double(Constants.Settings.charactersPerWord)
                                let roundedReadTime = Int16(round(words / Constants.Settings.wordsPerMinute))
                                // skip articles with unspecified read times
                                if !Constants.Settings.timeOptions.contains(Int(roundedReadTime)) {return}
                                // create reference
                                let ref = Database.database().reference().child("time\(roundedReadTime)minutes").child(newsSourceID).childByAutoId()
                                // create/upload article
                                let article: [String : String] = ["url" : jsonArticle["url"].stringValue,
                                                                  "date" : jsonArticle["publishedAt"].stringValue,
                                                                  "title" : jsonArticle["title"].stringValue,
                                                                  "urlToImage" : jsonArticle["urlToImage"].stringValue]
                                ref.updateChildValues(article)
                            }
                        }
                    case .failure:
                        print("Error: Alamofire request to fetch article json failed.")
                        return
                    }
                }
            }
        }
    }
}
