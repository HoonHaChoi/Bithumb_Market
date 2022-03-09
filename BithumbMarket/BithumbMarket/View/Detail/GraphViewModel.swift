//
//  GraphViewModel.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/03.
//

import Foundation

final class GraphViewModel {
    
    private let service: APIService
    private let storage: GraphStorage
    private var graphData: GraphData
    
    init(service: APIService, storage: GraphStorage) {
        self.service = service
        self.storage = storage
        self.graphData = .init(dateList: [],
                               closePriceList: [],
                               openPriceList: [],
                               minPriceList: [],
                               maxPriceList: [])
    }
    
    var errorHandler: ((Error) -> Void)?
    var loadingHandelr: ((Bool) -> Void)?
    var updateGraphHandler: ((GraphData) -> Void)?
    var passGraphHandler: ((GraphData) -> Void)?
    
    func fetchGraph(symbol: String, interval: ChartIntervals) {
        if let graphData = hasGraphData(symbol: symbol, interval: interval) {
            if hasNotPassedDate(entity: graphData, interval: interval) {
                self.graphData = graphData.toDomain()
                updateGraphHandler?(graphData.toDomain())
            } else {
                deleteGraph(entity: graphData) { [weak self] in
                    self?.loadingHandelr?(false)
                    self?.fetchDataSave(symbol: symbol, interval: interval) { entity in
                        self?.loadingHandelr?(true)
                        self?.graphData = entity.toDomain()
                        self?.updateGraphHandler?(entity.toDomain())
                    }
                }
            }
        } else {
            loadingHandelr?(false)
            fetchDataSave(symbol: symbol, interval: interval) { [weak self] entity in
                self?.loadingHandelr?(true)
                self?.graphData = entity.toDomain()
                self?.updateGraphHandler?(entity.toDomain())
            }
        }
    }
    
    private func hasGraphData(symbol: String, interval: ChartIntervals) -> GraphEntity? {
        return storage.fetch(symbol: symbol, interval: interval)
    }
    
    private func hasNotPassedDate(entity: GraphEntity, interval: ChartIntervals) -> Bool  {
        guard let saveDateTime = entity.createTime?.addingTimeInterval(interval.second) else {
            return false
        }
        return Date() < saveDateTime
    }
    
    private func fetchDataSave(symbol: String, interval: ChartIntervals, completion: @escaping (GraphEntity) -> Void) {
        fetchCandleStick(symbol: symbol, interval: interval) { [weak self] graphData in
            let graphDataEntity = graphData.map { $0.toEntity() }
            self?.saveGraph(symbol: symbol, interval: interval, graphData: graphDataEntity) { result in
                switch result{
                case.success(let entity):
                    completion(entity)
                case .failure(let error):
                    self?.errorHandler?(error)
                }
            }
        }
    }
    
    private func fetchCandleStick(symbol: String, interval: ChartIntervals, compleiton: @escaping ([GraphDataDTO]) -> Void) {
        service.request(endpoint: .candlestick(symbol: symbol, interval: interval)) { [weak self] (result: Result<CandleStick, HTTPError>) in
            switch result {
            case .success(let candleStick):
                compleiton(candleStick.data)
            case .failure(let error):
                self?.errorHandler?(error)
                return
            }
        }
    }
    
    private func saveGraph(symbol: String,
                           interval: ChartIntervals,
                           graphData: [GraphDataEntity],
                           completion: @escaping (Result<GraphEntity, CoreDataError>) -> Void) {
        storage.save(symbol: symbol, graphData: graphData, interval: interval.type, completion: completion)
    }
    
    private func deleteGraph(entity: GraphEntity, completion: (() -> Void)?) {
        storage.delete(entity: entity) { [weak self] result in
            switch result {
            case.success(_):
                completion?()
            case.failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    func passGraphData() {
        passGraphHandler?(graphData)
    }
}
