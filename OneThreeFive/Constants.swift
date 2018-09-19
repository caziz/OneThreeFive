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
            return  "https://newsapi.org/v2/sources?language=en&apiKey=\(self.key)"
        }
        static func articlesUrl() -> String {
            return "https://newsapi.org/v2/top-headlines?language=en&apiKey=\(self.key)&pageSize=100"
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
        static func timeImage(_ time: Int) -> UIImage {
            switch time {
            case 1:
                return #imageLiteral(resourceName: "1-minute-timer")
            case 3:
                return #imageLiteral(resourceName: "3-minute-timer")
            case 5:
                fallthrough
            default:
                return #imageLiteral(resourceName: "5-minute-timer")
            }
        }
        //static let rangeInMinutes = 0.5
        static let charactersPerWord = 5.0
        static let wordsPerMinute = 200.0
    }
    
    struct UI {
        static let animationDuration = 0.2
        static let borderWidth: CGFloat = 2
        static let borderColor = UIColor.lightGray

        // #6C00FF
        static let mainColor = UIColor(r: 108, g: 0, b: 225)
    }

    
}

extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.00) {
        self.init(red: r/255, green: g/255,blue: b/255, alpha: alpha)
    }
}
