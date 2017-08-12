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
    @IBOutlet weak var preferencesError: ErrorMessage!
    var articleCache: [[Article]] = [[],[],[]]
    //var enabledNewsSourceIDs = 0;
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //ArticleService.buildDatabase()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsSourceService.save()
        //ArticleService.buildDatabase()
        //let dy = view.frame.size.height - preferencesError.frame.size.height - preferencesError.frame.origin.y
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //configureDisplay()
        //preferencesError.enable(view: view, axis: 1.75, bottom: bottomLayoutGuide, size: 30)
        preferencesError.enable(bottom: bottomLayoutGuide, axis: 1.75, size: 30)

    }


    func configureDisplay() {
        // TODO: only do this if news sources have changed
        hideButtons(true)
        /*
        let currentEnabledNewsSourcesCount = NewsSourceService.getSaved().filter{$0.isEnabled}.count
        if(currentEnabledNewsSourcesCount == self.enabledNewsSourcesCount) {
            print("equal")
            print(currentEnabledNewsSourcesCount)
            hideButtons(false)
            return
        }
        print("not equal")
        self.enabledNewsSourcesCount = currentEnabledNewsSourcesCount
        */
        
        ArticleService.cache {
            DispatchQueue.main.async { [weak self] in
                self?.configureButtons()
                self?.hideButtons(false)
            }
        }
    }
    
    func hideButtons(_ hide: Bool) {
        option1Button.isHidden = hide
        option2Button.isHidden = hide
        option3Button.isHidden = hide
    }
    
    func configureButtons() {
        if
        configureButton(self.option1Button) &&
        configureButton(self.option2Button) &&
        configureButton(self.option3Button) {
            preferencesError.disable()
        } else {
            preferencesError.enable(bottom: bottomLayoutGuide, axis: 1.75, size: 30)
        }
    }
    
    func configureButton(_ button: UIButton) -> Bool {
        let tag = button.tag
        let newsArticles = NewsSourceService.getSaved(context: CoreDataHelper.managedContext)
        let filteredNewsArticles = newsArticles.filter{$0.isEnabled}
        let allArticles = filteredNewsArticles.flatMap{Array($0.mutableSetValue(forKey: "articles")) as! [Article]}
        let articles = allArticles.filter{!$0.isViewed && Int($0.time) == Constants.Settings.timeOptions[tag]}
        articleCache[tag] = Array(Set(articles))
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        if articleCache[tag].isEmpty {
            button.isEnabled = false
            button.alpha = 0.2
            return false
        } else {
            button.isEnabled = true
            button.alpha = 1
            return true
        }

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let button = sender as? UIButton {
            articleViewController.articleCache = articleCache[button.tag]
        }
    }
 
}
