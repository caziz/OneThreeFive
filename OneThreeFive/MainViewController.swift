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
        
        
        // TODO: hide all buttons
        
        
        self.prepareNewsSources()
        
        
        
    }
    
    /* fetch unsaved news sources */
    func prepareNewsSources() {
        
        // TODO: not thread safe!?
        DispatchQueue.global(qos: .userInitiated).async {
            NewsService.getNewsSources { newsSources in
                let savedNewsSourceIDs = NewsSource.getAll().map{$0.id!}
                for newsSource in newsSources {
                    if !savedNewsSourceIDs.contains(newsSource.id!) {
                        let newNewsSource = NewsSource.create()
                        newNewsSource.category = newsSource.category
                        newNewsSource.id = newsSource.id
                        
                    }
                }
                CoreDataHelper.save()
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: disable buttons
        // TODO: show buttons that are available, otherwise show error message
        let viewedURLS = Article.getAll().map{ $0.url! }
        let dispatchGroup = DispatchGroup()
        for (i, time) in Constants.Settings.timeOptions {
            dispatchGroup.enter()
            FireBaseService.get(time: time, sources: viewedURLs) { articles in
                articleCache[i].append()
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            // if articles are empty show error message, otherwise show button
        }
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
