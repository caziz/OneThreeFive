//
//  SettingsViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class SettingsViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    //TODO:
    // show all button
    // show me articles ive already viewed button

    @IBOutlet weak var seachButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchBarTopConstraint: NSLayoutConstraint!
    // all news sources
    var newsSources: [NewsSource] = []
    var filteredNewsSources: [NewsSource] = []

    // representation of enabled news sources from core data
    @IBAction func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        if searchBarTopConstraint.constant != 0 {
            showSeachBar()
        } else {
            dismissSearch()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSearchbar()
        self.addDismissGestures()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.newsSources = NewsSourceService.getSaved(context: CoreDataHelper.managedContext).sorted{$0.name! < $1.name!}
        self.displayFilteredNewsSources()
    }
    
    // MARK: - Keyboard
    
    func addDismissGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissSearch))
        newsTableView.addGestureRecognizer(tap)
    }
}


// MARK: - TableView Data Source

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.newsToggleCell, for: indexPath) as! NewsToggleCell
        cell.delegate = self
        
        let newsSource = filteredNewsSources[indexPath.row]
        
        // label
        cell.label.text = newsSource.name!
        
        // toggle
        if newsSource.isEnabled {
            cell.toggle.setOn(true, animated: false)
        } else {
            cell.toggle.setOn(false, animated: false)
        }
        
        // icon
        if let image = ImageService.loadImage(path: "\(newsSource.id!)") {
            cell.icon.image = image
        } else {
            cell.icon.image = #imageLiteral(resourceName: "source_default")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNewsSources.count
    }
}

// MARK: - TableView Delegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissSearch()
    }
    
}

// TOFO: - News Toggle Delegate

extension SettingsViewController: NewsToggleCellDelegate {
    func didToggleNewsSource(on cell: NewsToggleCell) {
        
        // TODO: change to table view included delegate?
        guard let indexPath = newsTableView.indexPath(for: cell) else { return }
        
        if cell.toggle.isOn {
            filteredNewsSources[indexPath.row].isEnabled = true
        } else {
            filteredNewsSources[indexPath.row].isEnabled = false
        }
        CoreDataHelper.save()
    }
}

extension SettingsViewController: UISearchBarDelegate {

    func initSearchbar() {
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .none
        //self.searchBar.placeholder = "Search by name or category"
    }
    
    func showSeachBar() {
        UIView.animate(withDuration: 0.2) {
            self.searchBarTopConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.searchBar.becomeFirstResponder()
        }
    }
    func dismissSeachbar() {
        UIView.animate(withDuration: 0.2) {
            self.searchBarTopConstraint.constant = -self.searchBar.bounds.height
            self.view.layoutIfNeeded()
        }
    }
    
    func displayFilteredNewsSources() {
        
        //TODO: add filtered news sources functionality
        if searchBar.text == nil || searchBar.text == "" {
            self.filteredNewsSources = self.newsSources
        } else {
            self.filteredNewsSources = self.newsSources.filter {
                let text = searchBar.text!.capitalized
                return $0.name!.capitalized.contains(text) ||
                    $0.category!.capitalized.contains(text)
            }
        }
        newsTableView.reloadData()
    }
    
    func dismissSearch() {
        view.endEditing(true)
        if searchBar.text == nil || searchBar.text == "" {
            dismissSeachbar()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayFilteredNewsSources()
    }
}
