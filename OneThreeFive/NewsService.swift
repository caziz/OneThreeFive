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

class NewsService {
    
    static func generateArticles() {
        let sources = CoreDataHelper.getEnabledNewsSources()
        for source in sources {
            if let id = source.id {
                NewsService.generateArticles(source: id)
            }
        }
    }
    
    
    static func getNewsSources(completion: ([NewsSource]) -> Void) {
        
    }
    
    
    static func generateArticles(source: String) {
        DispatchQueue.global(qos: .background).async {
            let sourcesUrl = Constants.NewsAPI.articlesUrl(source: source)
            Alamofire.request(sourcesUrl).validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else {
                        return
                    }
                    
                    let articles = JSON(value)["articles"].arrayValue
                    for article in articles {
                        self.isValid(url: article["url"].stringValue) { result in
                            guard let readTime = result
                                else {
                                return
                            }
                            let url = article["url"].stringValue
                            let date = article["publishedAt"].stringValue.replacingOccurrences(of: ":", with: "_").replacingOccurrences(of: ".", with: ",")
                            let validArticle = ValidArticle(url: url, source: source, date: date, readTime: readTime)
                            FireBaseService.save(article: validArticle)
                        }
                    }
                    return
                case .failure:
                    return
                }
            }
        }
    }
    
    static func isValid(url: String, completion: @escaping (Constants.ArticleLengthInMinutes?) -> (Void)) {
        DispatchQueue.global(qos: .background).async {
            guard let urlToParse = URL(string: url) else {
                return
            }
            Readability.parse(url: urlToParse) { result in
                if let article = result {
                    if let text = article.text {
                        let wordCount = Double(text.characters.count) / Constants.Settings.charactersPerWord
                        let timeInMinutes = wordCount / Constants.Settings.wordsPerMinute
                        let options: [Constants.ArticleLengthInMinutes] = [.option1, .option2, .option3]
                        for option in options {
                            if abs(Double(option.rawValue) - timeInMinutes) < Double(Constants.Settings.rangeInMinutes) {
                                return completion(option)
                            }
                        }
                        return completion(nil)
                    }
                }
                
            }
        }
        
    }

}
