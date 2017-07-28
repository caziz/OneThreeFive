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

        NewsSourceService.save()
        //ArticleService.buildDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        //configureDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view did appear")

        configureDisplay()
    }
    
    func configureDisplay() {
        print("to configure")

        // TODO: only do this if news sources have changed
        option1Button.isEnabled = false
        option2Button.isEnabled = false
        option3Button.isEnabled = false
        ArticleService.cache {
            DispatchQueue.main.async { [weak self] in
                self?.configureButtons()
            }
        }
    }
    
    func configureButtons() {
        configureButton(self.option1Button)
        configureButton(self.option2Button)
        configureButton(self.option3Button)
    }
    
    func configureButton(_ button: UIButton) {
        print("configuring")
        let tag = button.tag
        let unviewedArticles = ArticleService.getSaved(context: CoreDataHelper.managedContext).filter{!$0.isViewed}
        articleCache[tag] = unviewedArticles.filter{Int($0.time) == Constants.Settings.timeOptions[tag]}
        if articleCache[tag].isEmpty {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let button = sender as? UIButton {
            articleViewController.articleCache = articleCache[button.tag]
        }
    }
 
}
