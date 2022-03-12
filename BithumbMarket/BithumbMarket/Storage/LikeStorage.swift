//
//  LikeStorage.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/04.
//

import CoreData

protocol LikeStorgeType {
    func fetch() -> Result<[String], CoreDataError>
    func save(symbol: String) -> Result<Bool, CoreDataError>
    func delete(symbol: String) -> Result<Bool, CoreDataError>
    func find(symbol: String) -> Bool
}

final class LikeStorge: LikeStorgeType {
    
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
    
    func fetch() -> Result<[String], CoreDataError> {
        guard let likes = try? context.fetch(Like.fetchRequest()) else {
            return .failure(.failureFetch)
        }
        return .success(likes.compactMap { $0.symbol })
    }
    
    @discardableResult
    func save(symbol: String) -> Result<Bool, CoreDataError> {
        let like = Like(context: context)
        like.symbol = symbol
        
        do {
            try context.save()
            return .success(true)
        } catch {
            context.rollback()
            return .failure(.failureSave)
        }
    }
    
    @discardableResult
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
            context.rollback()
            return .failure(.failureDelete)
        }
    }
    
    @discardableResult
    func find(symbol: String) -> Bool {
        let request = Like.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        do {
            let likes = try context.fetch(request)
            return likes.first?.symbol == symbol
        } catch {
            return false
        }
    }
    
}

