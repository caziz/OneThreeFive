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
    /* save an article to firebase */
    static func save(article: Article) {
        let ref = Database.database().reference().child("Option\(article.time)Minutes").child(article.source!).childByAutoId()
        let article: [String : String] = ["url" : article.url!,
                                          "date" : article.date!,
                                          "title" : article.title!,
                                          "urlToImage" : article.urlToImage!]
        ref.updateChildValues(article)
    }
    
    
    /* from a given time and source, pass unviewed articles from firebase to completion handler */
    static func get(time: Int, sourceIDs: [String], articleURLs: [String], completion: @escaping ([Article]) -> Void) {
        let dispatchGroup = DispatchGroup()
        let ref = Database.database().reference().child("Option\(time)Minutes")
        var articles: [Article] = []
        for sourceID in sourceIDs {
            dispatchGroup.enter()
            ref.child(sourceID).observeSingleEvent(of: .value, with:{ snapshot in
                guard let dict = snapshot.value as? [String : String] else {
                    print("Error, could not retrieve article from Firebase")
                    dispatchGroup.leave()
                    return
                }
                // skip previously viewed articles
                if articleURLs.contains(dict["url"]!) {
                    dispatchGroup.leave()
                    return
                }
                // create temporary article
                let article = Article(context: CoreDataHelper.unmanagedContext)
                article.url = dict["url"]
                article.date = dict["date"]
                article.title = dict["title"]
                article.urlToImage = dict["urlToImage"]
                articles.append(article)
                dispatchGroup.leave()
            })
        }
        // TODO: which thread?
        dispatchGroup.notify(queue: .main, execute: {
            // sort articles by date and pass to completion
            let sortedArticles = articles.sorted{$0.date! < $1.date!}
            completion(sortedArticles)
        })
    }
}
