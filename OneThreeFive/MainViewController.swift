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
        
    
    }
    /*
    
    @IBAction func option1Pressed(_ sender: Any) {
        performSegue(withIdentifier: "showArticleViewController", sender: 1)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController, let _ = segue.identifier, let length = sender as? Int{
            articleViewController.articleLengthInMinutes = length
        }
        
        
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let identifier = segue.identifier {
            switch identifier {
            case Constants.Segue.showArticleForOption1:
                articleViewController.articleLengthInMinutes = Constants.ArticleLengthInMinutes.option1.rawValue
            case Constants.Segue.showArticleForOption2:
                articleViewController.articleLengthInMinutes = Constants.ArticleLengthInMinutes.option2.rawValue
            case Constants.Segue.showArticleForOption3:
                articleViewController.articleLengthInMinutes = Constants.ArticleLengthInMinutes.option3.rawValue
            default: break
            }
        }
    }
 
}
