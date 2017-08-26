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
    var enabledNewsSources: [NewsSource] = []
    //var enabledNewsSourceIDs = 0;
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsSourceService.save()
        //ArticleService.buildDatabase()
        
        // TODO: make this cleaner
        option1Button.layer.cornerRadius = 10
        option1Button.clipsToBounds = true
        option2Button.layer.cornerRadius = 10
        option2Button.clipsToBounds = true
        option3Button.layer.cornerRadius = 10
        option3Button.clipsToBounds = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        preferencesError.enable(bottom: bottomLayoutGuide, axis: 1.75, size: 30)
        configureDisplay()
    }
    func configureDisplay() {
        hideButtons(true)
        
        let newsArticles = NewsSourceService.getSaved(context: CoreDataHelper.managedContext)
        let newlyEnabledNewsSources = newsArticles.filter{$0.isEnabled}
        
        if enabledNewsSources.isEmpty || newlyEnabledNewsSources != enabledNewsSources {
            enabledNewsSources = newlyEnabledNewsSources
            ArticleService.cache {
                    DispatchQueue.main.async { [weak self] in
                        self?.configureButtons()
                        self?.hideButtons(false)
                    }
            }
        } else {
            configureButtons()
            hideButtons(false)
        }
    }
    
    func hideButtons(_ hide: Bool) {
        option1Button.isHidden = hide
        option2Button.isHidden = hide
        option3Button.isHidden = hide
    }
    
    
    func configureButtons() {
        preferencesError.disable()
        configureButton(self.option1Button)
        configureButton(self.option2Button)
        configureButton(self.option3Button)
    }

    func configureButton(_ button: UIButton) {
        let tag = button.tag
        let allArticles = enabledNewsSources.flatMap{Array($0.mutableSetValue(forKey: "articles")) as! [Article]}
        let articles = allArticles.filter{!$0.isViewed && Int($0.time) == Constants.Settings.timeOptions[tag]}
        articleCache[tag] = Array(Set(articles))
        // change color of button based on availability of articles
        if articleCache[tag].isEmpty {
            button.isEnabled = false
            button.alpha = 0.2
            preferencesError.enable(bottom: bottomLayoutGuide, axis: 1.75, size: 30)
        } else {
            button.isEnabled = true
            button.alpha = 1
        }

    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let button = sender as? UIButton {
            articleViewController.articleCache = articleCache[button.tag]
        }
    }
 
}
