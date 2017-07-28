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
class CoreDataStack {
    
    // MARK: - Properties
    
    // Singleton
    static let sharedInstance = CoreDataStack()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OneThreeFive")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}

struct CoreDataHelper {
    
    // MARK: - Properties
    
    static let persistentContainer = CoreDataStack.sharedInstance.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    // MARK: - Methods
    
    static func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(object: NSManagedObject) {
        managedContext.delete(object)
        save()
    }
    
}


