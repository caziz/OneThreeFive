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
    
    static func getURLs(option: Constants.ArticleLengthInMinutes, sources: [String], completion: @escaping ([String:[String]]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let ref = Database.database().reference().child("Option\(option.rawValue)")
        var dict: [String: [String]] = [:]

        for source in sources {
            dispatchGroup.enter()
            ref.child(source).observeSingleEvent(of: .value, with:{ snapshot in
                guard let dateDictionary = snapshot.value as? [String : String] else {
                    dict[source] = []
                    dispatchGroup.leave()
                    return
                }
                // sort urls by date into an array
                let sortedURLs = dateDictionary.sorted{$0.0 < $1.0}.map{$0.value}
                dict[source] = sortedURLs.reversed()
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main, execute: {
            completion(dict)
        })

    }
}
