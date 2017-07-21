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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        attemptLoadWebPage()
        
        
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        // TODO: favorite article
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        //self.spinner.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    
    
    func attemptLoadWebPage() {
        let url = URL(string: articleCache[0].url!)
        let urlRequest = URLRequest(url: url!)
        self.webView.loadRequest(urlRequest)
    }
}
