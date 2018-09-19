//
//  ArticleViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/13/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit
import SafariServices

class ArticleViewController:  UIViewController, SFSafariViewControllerDelegate {
    @IBOutlet weak var loadingIndicator: LoadingIndicator!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var articleCache: [Article] = []
    var currentIndex = 0
    override func viewDidLoad() {
        favoriteButton.isEnabled = false
        updateView()
    }
    
    // TODO: improve swipe implementation
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex + 1) % articleCache.count
            updateView()
        }
    }
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex - 1 + articleCache.count) % articleCache.count
            updateView()
        }
    }
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        if let urlString = articleCache[currentIndex].url,
            let link = NSURL(string: urlString)
        {
            let objectsToShare = [link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            return
        }

        let article = articleCache[currentIndex]
        if(!article.isViewed) {
            print("Not loaded yet")
            return
        }
        if(article.isFavorited) {
            favoriteButton.image = #imageLiteral(resourceName: "icon-star-empty")
            ArticleService.unfavoriteArticle(article: article)
        } else {
            favoriteButton.image = #imageLiteral(resourceName: "icon-star-filled")
            ArticleService.favoriteArticle(article: article)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
    }

    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        loadingIndicator.stopLoading()
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            return
        }
        self.articleCache[self.currentIndex].isViewed = true
        self.articleCache[self.currentIndex].readAt = Date() as NSDate
        CoreDataHelper.save()
    }

    func updateView() {
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            
        }
        let article = articleCache[currentIndex]
        updateNavBar(article: article)
        attemptLoadArticle(article: article)
    }
    
    func updateNavBar(article: Article) {
        
        if(article.isFavorited) {
            favoriteButton.image = #imageLiteral(resourceName: "icon-star-filled")
        } else {
            favoriteButton.image = #imageLiteral(resourceName: "icon-star-empty")
        }
        favoriteButton.isEnabled = true

    }
    
    func attemptLoadArticle(article: Article) {
        self.loadingIndicator.startLoading(image: Constants.Settings.timeImage(Int(article.time)))
        if let url = URL(string: (article.url)!) {
            var safariVC: SFSafariViewController
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                safariVC = SFSafariViewController(url: url, configuration: config)
            } else {
                safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            }
            addChildViewController(safariVC)
            safariVC.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(safariVC.view)
            safariVC.delegate = self
            self.view.bringSubview(toFront: loadingIndicator)

            let topOffset = self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
            let bottomOffset = self.tabBarController!.tabBar.frame.height
            NSLayoutConstraint.activate([
                safariVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                safariVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                safariVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -topOffset),
                safariVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: bottomOffset)
                ])
            
            safariVC.didMove(toParentViewController: self)
        } else {
            print("Error: could not load article")
        }
        
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
        }
    }
}
