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
    var closePriceList: [Int] = []
    var openPriceList: [Int] = []
    var minPriceList: [Int] = []
    var maxPriceList: [Int] = []

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
                    self.openPriceList.append(Int(openPrice) ?? 0)

                    let closPrice = model.data[i].closPrice
                    self.closePriceList.append(Int(closPrice) ?? 0)

                    let maxPrice = model.data[i].maxPrice
                    self.maxPriceList.append(Int(maxPrice) ?? 0)

                    let minPrice = model.data[i].minPrice
                    self.minPriceList.append(Int(minPrice) ?? 0)
                }

                print((model.data.first?.date)!)
                print(model.data[model.data.count - 100].date)
                print(model.data.last!.date)
                completion()

            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func fetchGraph(symbol: String, interval: ChartIntervals) {
    }
    
    private func hasGraphData(symbol: String, interval: ChartIntervals) -> GraphEntity? {
        return storage.fetch(symbol: symbol, interval: interval)
    }
    
    private func fetchCandleStick(symbol: String, interval: ChartIntervals, compleiton: @escaping ([GraphData]) -> Void) {
        service.request(endpoint: .candlestick(symbol: symbole, interval: .day)) { [weak self] (result: Result<CandleStick, HTTPError>) in
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
    
    private func deleteGraph(symbol: String, interval: ChartIntervals, completion: ((Result<Bool, CoreDataError>) -> Void)?) {
        storage.delete(symbol: symbol, interval: interval, completion: completion)
    }
}
