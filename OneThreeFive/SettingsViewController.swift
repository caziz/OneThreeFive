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

    @IBOutlet weak var searchBar: UISearchBar!
    // all news sources
    var newsSources: [NewsSource] = []
    var filteredNewsSources: [NewsSource] = []

    // representation of enabled news sources from core data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSearchbar()
        self.addDismissGestures()
        self.loadNewsSources()
        self.loadEnabledNewsSources()
    }
    
    func addDismissGestures() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        newsTableView.addGestureRecognizer(tap)
        
    }
    func dismissKeyboard() {
        //causes the view to resign as first responder
        view.endEditing(true)
    }
    
    func loadNewsSources(){
    }
    
    func loadEnabledNewsSources() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.newsSources = NewsSource.getAll()
        }
    }
    
    func loadImage(forNewsSource newsSource: NewsSource) {
    }
}


extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.newsToggleCell, for: indexPath) as! NewsToggleCell
        cell.delegate = self
        
        let newsSource = newsSources[indexPath.row]
        
        // label
        cell.label.text = newsSource.name!
        
        // toggle
        if newsSource.isEnabled {
            cell.toggle.setOn(true, animated: false)
        } else {
            cell.toggle.setOn(false, animated: false)
        }
        
        // TODO: icon
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSources.count
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SettingsViewController: NewsToggleCellDelegate {
    func didToggleNewsSource(on cell: NewsToggleCell) {
        
        // TODO: add toggle functionality
        /*
        guard let indexPath = newsTableView.indexPath(for: cell) else { return }
        
        if cell.toggle.isOn {
            let enabledNewsSource = CoreDataHelper.createEnabledNewsSource()
            enabledNewsSource.id =  filteredNewsSources[indexPath.row].id
            CoreDataHelper.save()
        } else {
            for enabledNewsSource in enabledNewSources {
                if enabledNewsSource.id == filteredNewsSources[indexPath.row].id {
                    CoreDataHelper.deleteEnabledNewsSource(enabledNewsSource: enabledNewsSource)
                    break
                }
            }
        }
        enabledNewSources = CoreDataHelper.getEnabledNewsSources()
 */
    }
}

extension SettingsViewController: UISearchBarDelegate {

    func initSearchbar() {
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .none
        //self.searchBar.placeholder = "Search by name or category"
    }
    
    func displayFilteredNewsSources() {
        
        //TODO: add filtered news sources functionality
        /*
        if searchBar.text == nil || searchBar.text == "" {
            self.filteredNewsSources = self.allNewsSources
        } else {
            self.filteredNewsSources = self.allNewsSources.filter {
                let text = searchBar.text!.capitalized
                return $0.name.capitalized.contains(text) ||
                    $0.category.capitalized.contains(text)
            }
        }
        newsTableView.reloadData()
 */
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayFilteredNewsSources()
    }
}
