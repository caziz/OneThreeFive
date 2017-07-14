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
        let url = "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=ca25969cc2f54d5f85ad50868bcebff3"
        static func sourcesUrl(language: String = "en") -> String {
            return  "https://newsapi.org/v1/sources?language=\(language)"
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
    }
    
    struct Entity {
        static let newsSource = "NewsSource"
    }
}
