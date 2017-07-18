//
//  FavoritesViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/17/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FavoritesViewController: UIViewController {
    @IBAction func loadArticles(_ sender: Any) {
        
        //NewsService.generateArticles()
        
        print("leggo")
        FireBaseService.getURLs(option: Constants.ArticleLengthInMinutes.option1, sources: ["abc-news-au", "bbc-news"]) { result in
            debugPrint(result)
            print("done boi")
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
