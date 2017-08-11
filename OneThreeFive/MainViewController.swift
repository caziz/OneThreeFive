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
    @IBOutlet weak var preferencesError: UILabel!
    var articleCache: [[Article]] = [[],[],[]]
    //var enabledNewsSourceIDs = 0;
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    
    @IBOutlet weak var downArrowConstraint: NSLayoutConstraint!
    @IBOutlet weak var downArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //ArticleService.buildDatabase()
    }
    
    
    var frame: CGRect?
    func animateArrow() {
        downArrow.frame(forAlignmentRect: frame!)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.downArrowConstraint.constant = self.downArrow.frame.height
            self.view?.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frame = downArrow.frame
        NewsSourceService.save()
        //ArticleService.buildDatabase()
        
        //configureDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureDisplay() {
        // TODO: only do this if news sources have changed
        hideButtons(true)
        preferencesError.isHidden = true
        downArrow.isHidden = true
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
        configureButton(self.option1Button)
        configureButton(self.option2Button)
        configureButton(self.option3Button)
    }
    
    func configureButton(_ button: UIButton) {
        let tag = button.tag
        let newsArticles = NewsSourceService.getSaved(context: CoreDataHelper.managedContext)
        let filteredNewsArticles = newsArticles.filter{$0.isEnabled}
        let allArticles = filteredNewsArticles.flatMap{Array($0.mutableSetValue(forKey: "articles")) as! [Article]}
        let articles = allArticles.filter{!$0.isViewed && Int($0.time) == Constants.Settings.timeOptions[tag]}
        articleCache[tag] = Array(Set(articles))
        if articleCache[tag].isEmpty {
            button.isEnabled = false
            button.alpha = 0.2
        } else {
            button.isEnabled = true
            button.alpha = 1
        }
        
        if filteredNewsArticles.isEmpty {
            preferencesError.isHidden = false
            downArrow.isHidden = false
            animateArrow()
        } else {
            preferencesError.isHidden = true
            downArrow.isHidden = true
        }
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let button = sender as? UIButton {
            articleViewController.articleCache = articleCache[button.tag]
        }
    }
 
}
