//
//  CoreDataHelper.swift
//  Routes
//
//  Created by Vitor Costa on 04/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    // MARK: STATIC OBJECT REFERENCE
    static let shared:CoreDataHelper = CoreDataHelper()
    
    // MARK: Private constants and properties
    private let photoFetch:NSFetchRequest<Search> = Search.fetchRequest()
    private var persistentContainer:NSPersistentContainer!
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // private init for override purpose
    private init() {
    }
    
    // Inital load function
    func load(modelName:String, completion: (() -> Void)? = nil) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    // MARK: - Search functions
    func getFetchedResultsControllerOfSearchs() -> NSFetchedResultsController<Search> {
        let fetchRequest:NSFetchRequest<Search> = Search.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "from", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func deleteSearch(_ search:Search) {
        viewContext.delete(search)
        try? viewContext.save()
    }
}
