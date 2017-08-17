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
    static func getSaved(context: NSManagedObjectContext = CoreDataHelper.managedContext) -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Error: Could not fetch \(error)")
        }
        return []
    }
    
    static func unfavoriteArticle(article: Article) {
        article.isFavorited = false
        // TODO: delete image
        CoreDataHelper.save()
        print("unfavorited")
    }
    
    static func favoriteArticle(article: Article) {
        article.isFavorited = true
        if let urlToImage = URL(string: article.urlToImage!),
            let image = ImageService.fetchImage(url: urlToImage) {
            ImageService.saveImage(path: article.uid!, image: image)
        }
        CoreDataHelper.save()
    }

    static func cache(completion: @escaping (Void) -> Void) {
        //CoreDataHelper.persistentContainer.performBackgroundTask { (context) in
            let dispatchGroup = DispatchGroup()
            // fetch enabled news source IDs
            let enabledNewsSources = NewsSourceService.getSaved().filter{$0.isEnabled}
            let cachedArticleURLs = ArticleService.getSaved().map{$0.url!}
            // create firebase database reference
            let ref = Database.database().reference()
            Constants.Settings.timeOptions.forEach { time in

                let timeRef = ref.child("time\(time)minutes")
                for enabledNewsSource in enabledNewsSources {
                    // pull from Firebase Database
                    dispatchGroup.enter()
                    timeRef.child(enabledNewsSource.id!).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let articleDictsForSource = snapshot.value as? [String: [String:String]] else {
                            dispatchGroup.leave()
                            return
                        }
                        for articleDict in articleDictsForSource.values {
                            dispatchGroup.enter()
                            if cachedArticleURLs.contains(articleDict["url"]!) {
                                dispatchGroup.leave()
                                continue
                            }
                            // create article entity with firebase data
                            let article = Article(context: CoreDataHelper.managedContext)
                            article.time = Int16(time)
                            article.title = articleDict["title"]
                            article.url = articleDict["url"]
                            article.urlToImage = articleDict["urlToImage"]
                            article.publishedAt = articleDict["date"]
                            article.uid = UUID().uuidString
                            enabledNewsSource.addToArticles(article)
                            dispatchGroup.leave()
                        }
                        dispatchGroup.leave()
                    })
                }
            }
            dispatchGroup.notify(queue: .main) {
                CoreDataHelper.save()
                completion()
            }
        //}
        
    }

    
    // TODO: make this more asnyc
    /* build database using relevant articles from saved news sources */
    static func buildDatabase() {
        //DispatchQueue.global(qos: .background).async {
            let newsSourceIDs = NewsSourceService.getSaved(context: CoreDataHelper.managedContext).map{$0.id!}
            let queue = DispatchQueue(label: "build-database-queue",
                                  qos: .background,
                                  attributes:.concurrent)
            newsSourceIDs.forEach { newsSourceID in
                let sourceURL = Constants.NewsAPI.articlesUrl(source: newsSourceID)
                // create queue
                // get json for each news source
                Alamofire
                    .request(sourceURL)
                    .validate()
                    .responseJSON(queue: queue, options: .allowFragments) { response in
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
            //}
        }
    }
}
