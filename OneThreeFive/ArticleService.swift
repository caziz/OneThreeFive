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
    

    
    static func getViewed() {
        
    }
    
    static func getFavorited() -> [Article] {
    }
    
    static func getCached() {
        
    }
    
    /* save an article to firebase */
    static func save(article: Article) {
        
        
    }
    
    
    /* from a given time and source, pass unviewed articles from firebase to completion handler */
    static func buildDatabase() {
        DispatchQueue.global(qos: .background).async {
            let newsSourceIDs = NewsSourceService.getSaved().map{$0.id!}
            newsSourceIDs.forEach { newsSourceID in
                let sourcesUrl = Constants.NewsAPI.articlesUrl(source: newsSourceID)
                Alamofire.request(sourcesUrl).validate().responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let value = response.result.value else {
                            print("Error: Alamofire response JSON could not be evaluated.")
                            return
                        }
                        let jsonArticles = JSON(value)["articles"].arrayValue
                        jsonArticles.forEach { jsonArticle in
                            let url = jsonArticle["url"].stringValue
                            ReadabilityService.textIn(url: url) { text in
                                let characters = text.characters.count
                                let words = Double(characters) / Double(Constants.Settings.charactersPerWord)
                                let roundedReadTime = Int16(round(words / Constants.Settings.wordsPerMinute))
                                if !Constants.Settings.timeOptions.contains(Int(roundedReadTime)) {return}
                                let ref = Database.database().reference().child("time\(roundedReadTime)minutes").child(newsSourceID).childByAutoId()
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
