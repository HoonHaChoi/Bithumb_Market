//
//  GraphViewModel.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/03.
//

import UIKit

class GraphViewModel {
    
    let symbole = "BTC"
    var data: [GraphData] = []
    var dateList: [String] = []
    var closePriceList: [Double] = []
    var openPriceList: [Double] = []
    var minPriceList: [Double] = []
    var maxPriceList: [Double] = []

    private var service: APIService
    private let storage: GraphStorage
    
    init(service: APIService = APIService(), storage: GraphStorage = GraphStorage()) {
        self.service = service
        self.storage = storage
    }
    
    var errorHandler: ((Error) -> Void)?
    
    func fetchGraphPrice(completion: @escaping () -> Void) {
        service.request(endpoint: .candlestick(symbol: symbole, interval: .day)) { [weak self] (result: Result<CandleStick, HTTPError>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.data = model.data

                print(model.data.count)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
                print(model.data[model.data.count - 30])

                for i in model.data.count - 30..<model.data.count {

                    let date = dateFormatter.string(from: model.data[i].date)
                    self.dateList.append(date)

                    let openPrice = model.data[i].openPrice
                    self.openPriceList.append(openPrice.convertDouble())

                    let closPrice = model.data[i].closPrice
                    self.closePriceList.append(closPrice.convertDouble())

                    let maxPrice = model.data[i].maxPrice
                    self.maxPriceList.append(maxPrice.convertDouble())

                    let minPrice = model.data[i].minPrice
                    self.minPriceList.append(minPrice.convertDouble())
                }

//                print((model.data.first?.date)!)
//                print(model.data[model.data.count - 100].date)
//                print(model.data.last!.date)
                completion()

            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func fetchGraph(symbol: String, interval: ChartIntervals, completion: @escaping (GraphEntity) -> Void) {
        if let graphData = hasGraphData(symbol: symbol, interval: interval) {
            if hasNotPassedDate(entity: graphData, interval: interval) {
                completion(graphData)
            } else {
                deleteGraph(entity: graphData) { [weak self] in
                    self?.fetchDataSave(symbol: symbol, interval: interval) { entity in
                        completion(entity)
                    }
                }
            }
        } else {
            fetchDataSave(symbol: symbol, interval: interval) { entity in
                completion(entity)
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
    
    private func fetchCandleStick(symbol: String, interval: ChartIntervals, compleiton: @escaping ([GraphData]) -> Void) {
        service.request(endpoint: .candlestick(symbol: symbole, interval: interval)) { [weak self] (result: Result<CandleStick, HTTPError>) in
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
    
}
