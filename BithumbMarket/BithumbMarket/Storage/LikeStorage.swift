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
                fatalError("스토어를 로드하지 못했습니다 \(error)")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func fetch() -> Result<[Like], CoreDataError> {
        guard let likes = try? context.fetch(Like.fetchRequest()) else {
            return .failure(.failureFetch)
        }
        return .success(likes)
    }
    
    func save(symbol: String) -> Result<Bool, CoreDataError> {
        let like = Like(context: context)
        like.symbol = symbol
        
        do {
            try context.save()
            return .success(true)
        } catch {
            return .failure(.failureSave)
        }
    }
    
    func delete(symbol: String) -> Result<Bool, CoreDataError> {
        let request = Like.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        do {
            let likes = try context.fetch(request)
            if let like = likes.first {
                context.delete(like)
                try context.save()
            } else {
                return .failure(.failureDelete)
            }
            return .success(true)
        } catch {
            return .failure(.failureDelete)
        }
    }
    
    func find(symbol: String) -> Result<Bool, CoreDataError> {
        let request = Like.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        do {
            let likes = try context.fetch(request)
            return .success(!likes.isEmpty)
        } catch {
            return .failure(.failiureFind)
        }
    }
    
}

enum CoreDataError: Error {
    case failureFetch
    case failureSave
    case failureDelete
    case failiureFind
}

