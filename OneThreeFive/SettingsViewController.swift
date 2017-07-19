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

    // all news sources
    var newsSources: [NewsSource] = []
    
    // representation of enabled news sources from core data
    var enabledNewSources: [EnabledNewsSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNewsSources()
        self.loadEnabledNewsSources()
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
                        self.newsSources.append(newsSource)
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.newsTableView.reloadData()
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
                for i in 0..<(self?.newsSources.count ?? 0) {
                    if self?.newsSources[i].id == newsSource.id {
                        self?.newsSources[i].icon = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.newsTableView.reloadData()
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
        let source = newsSources[indexPath.row]
        
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
        guard let indexPath = newsTableView.indexPath(for: cell) else { return }
        
        if cell.toggle.isOn {
            let enabledNewsSource = CoreDataHelper.createEnabledNewsSource()
            enabledNewsSource.id =  newsSources[indexPath.row].id
            CoreDataHelper.save()
        } else {
            for enabledNewsSource in enabledNewSources {
                if enabledNewsSource.id == newsSources[indexPath.row].id {
                    CoreDataHelper.deleteEnabledNewsSource(enabledNewsSource: enabledNewsSource)
                    break
                }
            }
        }
        enabledNewSources = CoreDataHelper.getEnabledNewsSources()
    }
}
