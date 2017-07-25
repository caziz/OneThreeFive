//
//  MainViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/13/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit
import Firebase

class MainViewController : UIViewController {
    
    var articleCache: [[Article]] = [[],[],[]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /* initialize */
        //self.cacheArticles()
        self.saveNewsSources()
        //self.deleteAllNewsSources()
        //debugPrint(NewsSource.getAll().map{$0.id!})
        // TODO: hide all buttons
        //self.uploadArticles()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* upload articles from news api to firebase */
    func uploadArticles() {
        DispatchQueue.global(qos: .userInitiated).async {
            let newsSources = NewsSource.getAll()
            let dispatchGroup = DispatchGroup()
            for newsSource in newsSources {
                dispatchGroup.enter()
                NewsService.getArticles(from: newsSource) { articles in
                    for article in articles {
                        FireBaseService.save(article: article)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.wait()
        }
    }
    
    func deleteAllNewsSources() {
        DispatchQueue.global(qos: .userInitiated).async {
            for newsSource in NewsSource.getAll() {
                CoreDataHelper.delete(object: newsSource)
            }
        }
    }
    
    /* fetch unsaved news sources */
    func saveNewsSources() {
        // TODO: not thread safe!?
        //DispatchQueue.global(qos: .userInitiated).async {
        
        let savedNewsSourceIDs = NewsSource.getAll().map{$0.id!}
            NewsService.getNewsSources { newsSources in
                for newsSource in newsSources {
                    if !savedNewsSourceIDs.contains(newsSource.id!) {

                    }
                }
                CoreDataHelper.save()
            }
        //}
    }
    
    func cacheArticles() {
        // TODO: disable buttons
        // TODO: show buttons that are available, otherwise show error message
        let sourceIDs = NewsSource.getAll().map{ $0.id! }
        let articleURLs = Article.getAll().map{ $0.url! }
        let dispatchGroup = DispatchGroup()
        for time in Constants.Settings.timeOptions {
            dispatchGroup.enter()
            FireBaseService.fetchArticles(time: time, sourceIDs: sourceIDs, articleURLs: articleURLs) { articles in
                self.articleCache.append(articles)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            // if articles are empty show error message, otherwise .mapshow button
        }
    }    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let identifier = segue.identifier {
            switch identifier {
            case Constants.Segue.showArticleForOption1:
                articleViewController.articleCache = self.articleCache[0]
            case Constants.Segue.showArticleForOption2:
                articleViewController.articleCache = self.articleCache[1]
            case Constants.Segue.showArticleForOption3:
                articleViewController.articleCache = self.articleCache[2]
            default: break
            }
        }
    }
 
}
