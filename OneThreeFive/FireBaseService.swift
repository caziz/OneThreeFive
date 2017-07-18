//
//  FBService.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/15/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import Firebase
import FirebaseDatabase


class FireBaseService {
    static func save(article: ValidArticle) {
        let ref = Database.database().reference().child("Option\(article.readTime.rawValue)").child(article.source)
        let dict : [String: String] = [article.date : article.url]
        ref.updateChildValues(dict)
    }
    
    static func getUrl(with option: Constants.ArticleLengthInMinutes, completion: @escaping ([String]) -> Void) {
        // /posts/currentUID/snapshot
        let ref = Database.database().reference().child("Option\(option.rawValue)").child("abc-news-au")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
            guard let dict = snapshot.value as? [String : String] else {
                return completion([])
            }
            let sortedArray = dict.sorted{$0.0 < $1.0}.map{$0.key}
            print(sortedArray)
            return completion([])

        })
    }
}
