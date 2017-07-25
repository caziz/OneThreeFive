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
        if !Constants.Settings.timeOptions.contains(Int(article.time)) {return}
        let ref = Database.database().reference().child("time\(article.time)minutes").child(article.source!).childByAutoId()
        let article: [String : String] = ["url" : article.url!,
                                          "date" : article.date!,
                                          "title" : article.title!,
                                          "urlToImage" : article.urlToImage!]
        ref.updateChildValues(article)
    }
    
    
    /* from a given time and source, pass unviewed articles from firebase to completion handler */
    static func fetchArticles(time: Int, sourceIDs: [String], articleURLs: [String], completion: @escaping ([Article]) -> Void) {
        let ref = Database.database().reference().child("time\(time)minutes")
        let dispatchGroup = DispatchGroup()
        var articles: [Article] = []
        for sourceID in sourceIDs {
            ref.child(sourceID).observe(.childAdded, with:{ snapshot in
                dispatchGroup.enter()
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return
                }
                let article = Article(context: CoreDataHelper.unmanagedContext)
                article.setValuesForKeys(dictionary)
                articles.append(article)
                dispatchGroup.leave()
            })
            dispatchGroup.notify(queue: .main) {
                let sortedArticles = articles.sorted{$0.date! < $1.date!}
                completion(sortedArticles)
            }
        }
    }
}
