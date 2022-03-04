//
//  LikeStorage.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/04.
//

import CoreData

final class LikeStorge {
    
    private let storageKey = "LikeSymbol"
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: storageKey)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError()
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
}
