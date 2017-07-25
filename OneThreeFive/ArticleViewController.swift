//
//  ArticleViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/13/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ArticleViewController:  UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!

    var articleCache: [Article] = []
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        attemptLoadWebPage()
        
        
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        articleCache[currentIndex].isFavorited = true
        CoreDataHelper.save()
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        //self.spinner.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
        articleCache[currentIndex].isViewed = true
        CoreDataHelper.save()
    }
    
    
    func attemptLoadWebPage() {
        let url = URL(string: articleCache[currentIndex].url!)
        let urlRequest = URLRequest(url: url!)
        self.webView.loadRequest(urlRequest)
    }
}
