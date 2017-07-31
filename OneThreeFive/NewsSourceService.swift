//
//  NewsService.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/15/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import Alamofire
import SwiftyJSON
import ReadabilityKit
import CoreData

class NewsSourceService {
    /* get news sources saved to Core Data */
    static func getSaved(context: NSManagedObjectContext = CoreDataHelper.managedContext) -> [NewsSource] {
        let fetchRequest: NSFetchRequest<NewsSource> = NewsSource.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    /* get news sources from News API, save to Core Data */
    static func save() {
        //DispatchQueue.global(qos: .userInitiated).async {
            let sourcesUrl = Constants.NewsAPI.sourcesUrl()
            Alamofire.request(sourcesUrl).validate().responseJSON { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else {
                        return
                    }
                    let existingSources = self.getSaved(context: CoreDataHelper.managedContext).map{$0.id!}
                    let sources = JSON(value)["sources"].arrayValue
                    // create news source in child context and save
                    //CoreDataHelper.persistentContainer.performBackgroundTask { (context) in
                        sources.forEach { source in
                            // skip existing news sources
                            if existingSources.contains(source["id"].stringValue) {return}
                            // create news source
                            let newsSource = NewsSource(context: CoreDataHelper.managedContext)
                            newsSource.id = source["id"].stringValue
                            newsSource.category = source["category"].stringValue
                            newsSource.name = source["name"].stringValue
                            newsSource.url = source["url"].stringValue
                            if  let imageURL = URL(string: Constants.NewsAPI.imageUrl(url: newsSource.url!)),
                                let image = ImageService.fetchImage(url: imageURL) {
                                let path = "\(newsSource.id!)"
                                ImageService.saveImage(path: path, image: image)
                            }
                            
                        }
                        CoreDataHelper.save()
                    //}
                default:
                    return
                }
            }
        //}
    }
}
