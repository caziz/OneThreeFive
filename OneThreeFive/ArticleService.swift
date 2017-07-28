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
    static func getSaved(context: NSManagedObjectContext) -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func favoriteArticle(article: Article) {
        
        CoreDataHelper.persistentContainer.performBackgroundTask { context in
            article.isFavorited = true
            let uniquePath = UUID().uuidString
            article.imagePath = uniquePath
            print(uniquePath)
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save \(error)")
            }
            
            
            if let url = URL(string: article.urlToImage!),
                let image = ImageService.fetchImage(url: url) {
                print("saving image")
                ImageService.saveImage(path: uniquePath, image: image)
            }

        }
    }
    
    static func cache(completion: @escaping (Void) -> Void) {
        CoreDataHelper.persistentContainer.performBackgroundTask { (context) in
            let dispatchGroup = DispatchGroup()
            // fetch enabled news source IDs
            let newsSourceIDs = NewsSourceService.getSaved(context: CoreDataHelper.managedContext).filter{$0.isEnabled}.map{$0.id!}
            // delete previously cached articles
            ArticleService.getSaved(context: context).filter{!$0.isViewed}.forEach{context.delete($0)}
            let viewedArticleURLs = ArticleService.getSaved(context: CoreDataHelper.managedContext).map{$0.url!}
            // create firebase database reference
            let ref = Database.database().reference()
            Constants.Settings.timeOptions.forEach { time in
                dispatchGroup.enter()
                let timeRef = ref.child("time\(time)minutes")
                newsSourceIDs.forEach { newsSourceID in
                    // pull from Firebase Database
                    dispatchGroup.enter()
                    timeRef.child(newsSourceID).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let newsSourceDict = snapshot.value as? [String: [String:String]] else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        newsSourceDict.values.forEach { articleDict in
                            dispatchGroup.enter()
                            // create article entity with firebase data
                            if viewedArticleURLs.contains(articleDict["url"]!) {
                                dispatchGroup.leave()
                                return
                            }
                            let article = Article(context: context)
                            article.source = newsSourceID
                            article.time = Int16(time)
                            article.title = articleDict["title"]
                            article.url = articleDict["url"]
                            article.urlToImage = articleDict["urlToImage"]
                            dispatchGroup.leave()
                            print("finished article")
                        }
                        dispatchGroup.leave()
                        print("finished source")
                    })
                }
                dispatchGroup.leave()
                print("finished time")
            }
            dispatchGroup.notify(queue: .global()) {
                do {
                    
                    try context.save()
                    completion()
                    print("called completion")
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
        
    }
    
    /* build database using relevant articles from saved news sources */
    static func buildDatabase() {
        DispatchQueue.global(qos: .utility).async {
            // TODO: not correct thread ughghhhh
            let newsSourceIDs = NewsSourceService.getSaved(context: CoreDataHelper.managedContext).map{$0.id!}
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
