//
//  NewsService.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/15/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import Alamofire
import SwiftyJSON
import ReadabilityKit
import CoreData

class NewsService {

    
    /* calls completion handler with array of News Sources from API */
    static func getNewsSources(completion: @escaping ([NewsSource]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sourcesUrl = Constants.NewsAPI.sourcesUrl()
            Alamofire.request(sourcesUrl).validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else {
                        return completion([])
                    }
                    var newsSources: [NewsSource] = []
                    let sources = JSON(value)["sources"].arrayValue
                    for source in sources {
                        let newsSource = NewsSource(context: CoreDataHelper.managedContext)
                        newsSource.id = source["id"].stringValue
                        newsSource.category = source["category"].stringValue
                        newsSource.name = source["name"].stringValue
                        newsSource.url = source["url"].stringValue
                        newsSources.append(newsSource)
                    }
                    return completion(newsSources)
                case .failure:
                    return completion([])

                }
            }
            
        }
    }
    
    /* calls completion handler with array of Articles from specified source */
    static func getArticles(from source: NewsSource, completion: @escaping ([Article]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let sourcesUrl = Constants.NewsAPI.articlesUrl(source: source.id!)
            Alamofire.request(sourcesUrl).validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else {
                        return
                    }
                    var articles: [Article] = []
                    let jsonArticles = JSON(value)["articles"].arrayValue
                    let dispatchGroup = DispatchGroup()
                    for jsonArticle in jsonArticles {
                        let url = jsonArticle["url"].stringValue
                        dispatchGroup.enter()
                        ReadabilityService.textIn(url: url) { text in
                            let characters = text.characters.count
                            let words = Double(characters) / Double(Constants.Settings.charactersPerWord)
                            let roundedReadTime = Int16(round(words / Constants.Settings.wordsPerMinute))
                            let article = Article(context: CoreDataHelper.unmanagedContext)
                            article.text = text
                            article.url = url
                            article.source = source.id
                            article.time = roundedReadTime
                            article.date = jsonArticle["publishedAt"].stringValue
                            article.title = jsonArticle["title"].stringValue
                            article.urlToImage = jsonArticle["urlToImage"].stringValue
                            articles.append(article)
                            debugPrint(article)
                            dispatchGroup.leave()
                        }
                    }
                    // TODO which queue here?
                    dispatchGroup.notify(queue: .main) {
                        completion(articles)
                }
                case .failure:
                    return completion([])
                }
            }
        }
    }
}
