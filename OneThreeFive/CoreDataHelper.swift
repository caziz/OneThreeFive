//
//  CoreDataHelper.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData
import UIKit

// abid made me:

class CoreDataHelper {
    
    // MARK: - Singleton

    static var singleton = CoreDataHelper()

    private init(){
        CoreDataHelper.childContext.parent = CoreDataHelper.managedContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Databases")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Properties
    
    static let managedContext = persistentContainer.viewContext
    static let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    // MARK: - Functions
    
    static func delete(object: NSManagedObject) {
        self.managedContext.delete(object)
    }
    
    static func save() {
        do {
            try CoreDataHelper.managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    
}
