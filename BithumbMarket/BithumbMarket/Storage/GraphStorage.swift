//
//  GraphStorage.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/08.
//

import Foundation
import CoreData

final class GraphStorage {
    
    private let storageKey = "GraphStorage"
    
    private lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: storageKey)
           container.loadPersistentStores { _, error in
               if let error = error {
                   fatalError()
               }
           }
           return container
    }()
    
    private lazy var privateManagedObjectContext = self.persistentContainer.newBackgroundContext()
    
    func save(symbol: String, graphData: [GraphDataEntity], interval: String, completion: @escaping (Result<GraphEntity, CoreDataError>) -> Void) {
        privateManagedObjectContext.perform { [weak self] in
            guard let self = self else { return }
            let graphChartData = GraphChartEntity(context: self.privateManagedObjectContext)
            graphChartData.graphData = graphData
            graphChartData.interval = interval

            let graph = GraphEntity(context: self.privateManagedObjectContext)
            graph.symbol = symbol
            graph.createTime = Date()
            
            graph.addToGraphChartEntity(graphChartData)
            
            do {
                try self.privateManagedObjectContext.save()
                completion(.success(graph))
            } catch {
                self.privateManagedObjectContext.rollback()
                completion(.failure(.failureSave))
            }
        }
    }
    
    func fetch(symbol: String, interval: ChartIntervals) -> GraphEntity? {
        let request = GraphEntity.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@ && ANY graphChartEntity.interval == %@", symbol, interval.type)
         do {
             let fetchResult = try privateManagedObjectContext.fetch(request).first
             return fetchResult
         } catch {
             return nil
         }
     }
    
    func delete(symbol: String, interval: ChartIntervals, completion: ((Result<Bool, CoreDataError>) -> Void)?) {
        privateManagedObjectContext.perform { [weak self] in
            let request = GraphEntity.fetchRequest()
            request.predicate = NSPredicate(format: "symbol == %@ && ANY graphChartEntity.interval == %@", symbol, interval.type)
            
            do {
                let fetchResult = try self?.privateManagedObjectContext.fetch(request)
                if let object = fetchResult?.first {
                    self?.privateManagedObjectContext.delete(object)
                    try self?.privateManagedObjectContext.save()
                    completion?(.success(true))
                }
            } catch {
                self?.privateManagedObjectContext.rollback()
                completion?(.failure(.failureDelete))
            }
        }
     }
    
}
