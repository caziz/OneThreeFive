//
//  Constants.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//
import UIKit

struct Constants {
    private init() {}
    
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
    
    struct Identifier {
        static let newsToggleCell = "newsToggleCell"
        static let favoritedArticleCell = "favoritedArticleCell"
        static let viewedArticleCell = "viewedArticleCell"

        //segue
        static let showArticleFromFavorites = "showArticleFromFavorites"
        static let showArticleFromViewed = "showArticleFromViewed"

    }
    
    
    struct Settings {
        static let timeOptions = [1, 3, 5]
        static let timeImages = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "five")]
        //static let rangeInMinutes = 0.5
        static let charactersPerWord = 5.0
        static let wordsPerMinute = 200.0
    }
    
    struct UI {
        static let animationDuration = 0.2
        static let borderWidth: CGFloat = 2
        static let borderColor = UIColor.lightGray
        
        //static let mainColor = UIColor(red:0.20, green:0.40, blue:0.88, alpha:1.0) // old blue
        //static let mainColor = UIColor(red:0.22, green:0.30, blue:0.85, alpha:1.0) // button blue
        //static let mainColor = UIColor(red:13, green:35, blue:230, alpha:15) // light purple
        static let mainColor = UIColor(r: 52, g: 102, b: 225)
    }

    
}

extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.00) {
        self.init(red: r/255, green: g/255,blue: b/255, alpha: alpha)
    }
}
