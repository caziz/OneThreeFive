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
    var allNewsSources: [NewsSource] = []
    var filteredNewsSources: [NewsSource] = []
    // representation of enabled news sources from core data
    var enabledNewSources: [EnabledNewsSource] = []
    
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
        DispatchQueue.global(qos: .userInitiated).async {
            let sourcesUrl = Constants.NewsAPI.sourcesUrl()
            Alamofire.request(sourcesUrl).validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else {
                        return
                    }
                    
                    let sources = JSON(value)["sources"].arrayValue
                    for source in sources {
                        let newsSource = NewsSource(
                            id: source["id"].stringValue,
                            name: source["name"].stringValue,
                            category: source["category"].stringValue,
                            language: source["language"].stringValue,
                            country: source["country"].stringValue,
                            url: source["url"].stringValue,
                            icon: nil
                        )
                        self.loadImage(forNewsSource: newsSource)
                        self.allNewsSources.append(newsSource)
                    }
                    DispatchQueue.main.async { [weak self] in
                        //self?.filteredNewsSources = self?.allNewsSources ?? []
                        self?.displayFilteredNewsSources()
                    }
                    return
                case .failure:
                    return
                }
            }

        }
    }
    
    func loadEnabledNewsSources() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.enabledNewSources = CoreDataHelper.getEnabledNewsSources()
        }
    }
    
    func loadImage(forNewsSource newsSource: NewsSource) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlString = Constants.NewsAPI.imageUrl(url: newsSource.url)
            if  let url = URL(string: urlString),
                let imageData = try? Data(contentsOf: url) {
                for i in 0..<(self?.allNewsSources.count ?? 0) {
                    if self?.allNewsSources[i].id == newsSource.id {
                        self?.allNewsSources[i].icon = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.displayFilteredNewsSources()
                        }
                        break
                    }
                }
            }
        }
    }
}


extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.newsToggleCell, for: indexPath) as! NewsToggleCell
        cell.delegate = self
        let source = filteredNewsSources[indexPath.row]
        
        // label
        cell.label.text = source.name
        
        // icon
        if let icon = source.icon {
            cell.icon.image = icon
        } else {
            cell.icon.image = #imageLiteral(resourceName: "news")
        }
        
        // toggle
        for enabledNewSource in enabledNewSources {
            if enabledNewSource.id == source.id {
                cell.toggle.setOn(true, animated: false)
                return cell
            }
        }
        cell.toggle.setOn(false, animated: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNewsSources.count
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension SettingsViewController: NewsToggleCellDelegate {
    func didToggleNewsSource(on cell: NewsToggleCell) {
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
    }
}

extension SettingsViewController: UISearchBarDelegate {

    func initSearchbar() {
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .none
        //self.searchBar.placeholder = "Search by name or category"
    }
    
    func displayFilteredNewsSources() {
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
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        displayFilteredNewsSources()
    }
}
