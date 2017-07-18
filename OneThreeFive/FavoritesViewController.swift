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
        FireBaseService.getUrl(with: Constants.ArticleLengthInMinutes.option1) { a in
            print("hi: \(a)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
