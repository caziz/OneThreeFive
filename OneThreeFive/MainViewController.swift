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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preloadArticles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let identifier = segue.identifier {
            switch identifier {
            case Constants.Segue.showArticleForOption1:
                articleViewController.articleLengthInMinutes = 1
            case Constants.Segue.showArticleForOption2:
                articleViewController.articleLengthInMinutes = 3
            case Constants.Segue.showArticleForOption3:
                articleViewController.articleLengthInMinutes = 5
            default: break
            }
        }
    }
    
    func preloadArticles() {
        
    }
}
