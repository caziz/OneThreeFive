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
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //NewsSourceService.save()
        //ArticleService.buildDatabase()
        
        ArticleService.cache()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let unviewedArticles = ArticleService.getSaved().filter{!$0.isViewed}
        articleCache[0] = unviewedArticles.filter{Int($0.time) == Constants.Settings.timeOptions[0]}
        articleCache[1] = unviewedArticles.filter{Int($0.time) == Constants.Settings.timeOptions[1]}
        articleCache[2] = unviewedArticles.filter{Int($0.time) == Constants.Settings.timeOptions[2]}
        if articleCache[0].isEmpty {option1Button.isHidden = true} else {option1Button.isHidden = false}
        if articleCache[1].isEmpty {option2Button.isHidden = true} else {option2Button.isHidden = false}
        if articleCache[2].isEmpty {option3Button.isHidden = true} else {option3Button.isHidden = false}
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let identifier = segue.identifier {
            switch identifier {
            case Constants.Segue.showArticleForOption1: articleViewController.articleCache = articleCache[0]
            case Constants.Segue.showArticleForOption2: articleViewController.articleCache = articleCache[1]
            case Constants.Segue.showArticleForOption3: articleViewController.articleCache = articleCache[2]
            default: break
            }
        }
    }
 
}
