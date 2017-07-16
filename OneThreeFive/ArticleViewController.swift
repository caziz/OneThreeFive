//
//  ArticleViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/13/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ArticleViewController:  UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var articleLengthInMinutes: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attemptLoadWebPage("www.google.com")
    }
    
    func attemptLoadWebPage(_ string: String) -> Bool {
        if let url = URL(string: string) {
            let urlRequest = URLRequest(url: url)
            webView.loadRequest(urlRequest)
            return true
        }
        return false
    }
    
}

extension ArticleViewController: UIWebViewDelegate {

}
