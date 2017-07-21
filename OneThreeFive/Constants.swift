//
//  Constants.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

struct Constants {
    struct NewsAPI {
        static let key = "ca25969cc2f54d5f85ad50868bcebff3"
        static func sourcesUrl() -> String {
            return  "https://newsapi.org/v1/sources?&language=en"
        }
        static func articlesUrl(source: String) -> String {
            return "https://newsapi.org/v1/articles?source=\(source)&apiKey=\(self.key)"
        }
        
        static func imageUrl(url: String) -> String {
            return "https://logo.clearbit.com/:domain:\(url)"
        }
    }
    
    struct Segue {
        static let showArticleForOption1 = "showArticleForOption1"
        static let showArticleForOption2 = "showArticleForOption2"
        static let showArticleForOption3 = "showArticleForOption3"
    }
    
    struct Identifier {
        static let newsToggleCell = "newsToggleCell"
        static let favoritedArticleCell = "favoritedArticleCell"

    }
    
    
    struct Settings {
        static let timeOptions = [1, 3, 5]
        //static let rangeInMinutes = 0.5
        static let charactersPerWord = 5.0
        static let wordsPerMinute = 200.0
    }
    
    
    
    
    
    
}
