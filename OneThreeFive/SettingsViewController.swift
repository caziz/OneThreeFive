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
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var animatedSearchBar: AnimatedSearchBar!
    
    //TODO: show all button

    // all news sources
    var newsSources: [NewsSource] = []
    var filteredNewsSources: [NewsSource] = []

    // representation of enabled news sources from core data
    @IBAction func searchBarButtonTapped(_ sender: UIBarButtonItem) {
        animatedSearchBar.toggle()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsSources = NewsSourceService.getSaved(context: CoreDataHelper.managedContext).sorted{$0.name! < $1.name!}
        displayWithFilter(text: "")
        configureSearchBar()
    }
    
    func configureSearchBar() {
        animatedSearchBar.animatedDelegate = self
        animatedSearchBar.constraint = searchBarTopConstraint
        animatedSearchBar.view = view
        animatedSearchBar.initSearchbar()
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
        animatedSearchBar.dismiss()
    }
    
}

// TODO: - News Toggle Delegate

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

extension SettingsViewController: AnimatedSearchBarDelegate {
    func displayWithFilter(text: String = "") {
        if text == "" {
            filteredNewsSources = newsSources
        } else {
            filteredNewsSources = newsSources.filter {
                $0.name!.capitalized.contains(text.capitalized) ||
                    $0.category!.capitalized.contains(text.capitalized)
            }
        }
        
        newsTableView.reloadData()
    }
}
