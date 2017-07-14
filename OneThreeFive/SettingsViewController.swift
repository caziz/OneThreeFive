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
    
    var newsSources: [NewsSource] = []
    var enabledNewsSources: [EnabledNewsSource] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNewsSources()
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
    
    func loadImage(forNewsSource newsSource: NewsSource) {
        print("adding image")
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let urlString = Constants.NewsAPI.imageUrl(url: newsSource.url)
            if  let url = URL(string: urlString),
                let imageData = try? Data(contentsOf: url) {
                for i in 0..<(self?.newsSources ?? []).count {
                    if self?.newsSources[i].id == newsSource.id {
                        self?.newsSources[i].icon = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.newsTableView.reloadData()
                            print("reloaded")
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
        let source = newsSources[indexPath.row]
        cell.label.text = source.name
        
        if let icon = source.icon {
            print("image not nil")
            cell.icon.image = icon
        } else {
            print("image nil")
            cell.icon.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSources.count
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}
