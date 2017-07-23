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
        let article: [String : String] = ["text" : article.text!,
                                          "url" : article.url!,
                                          "date" : article.date!,
                                          "title" : article.title!,
                                          "urlToImage" : article.urlToImage!]
        ref.updateChildValues(article)
    }
    
    
    /* from a given time and source, pass unviewed articles from firebase to completion handler */
    static func get(time: Int, sourceIDs: [String], articleURLs: [String], completion: @escaping ([Article]) -> Void) {
        let ref = Database.database().reference().child("time\(time)minutes")
        for sourceID in sourceIDs {
            ref.child(sourceID).observeSingleEvent(of: .value, with:{ snapshot in
                
                for article in snapshot.children {
                    guard let article = snap.valu as! [String: Any] else {
                        
                    }
                    
                    
                    
                }
                
                
                guard let articleSnapshots = snapshot.children as? [DataSnapshot] else {
                    print("Error, could not retrieve articles from Firebase")
                    return
                }
                for articleSnapshot in articleSnapshots {
                    guard let articleDictionary = articleSnapshot.value as! [String: [String:String]] else {
                        print("Error, could firebase data is not article")
                    }
                    
                    
                }
                
                snapshot.children
                var articles: [Article] = []
                for article in dict.values {
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
                }
                
                dispatchGroup.leave()
            })
        }
        // TODO: which thread?
        dispatchGroup.notify(queue: .main, execute: {
            // sort articles by date and pass to completion
            let sortedArticles = articles.sorted{$0.date! < $1.date!}
            completion(sortedArticles)
            //completion([])
        })
    }
}
