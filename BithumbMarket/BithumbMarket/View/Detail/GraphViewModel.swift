//
//  GraphViewModel.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/03.
//

import UIKit

class GraphViewModel {
    
    let symbole = "BTC"
    var data: Observable<[GraphData]> = .init([])
    var dateList: [String] = []
    var closePriceList: [Int] = []
    var openPriceList: [Int] = []
    var minPriceList: [Int] = []
    var maxPriceList: [Int] = []

    private var service: APIService
    
    init(service: APIService = APIService()) {
        self.service = service
    }
    
    func fetchGraphPrice(interval: ChartIntervals = .day
                         //, completion: @escaping () -> Void
    ) {
        service.request(endpoint: .candlestick(symbol: symbole, interval: interval)) { [weak self] (result: Result<CandleStick, HTTPError>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
    
                //MARK: Data 초기화
                self.dateList = []
                self.closePriceList = []
                self.openPriceList = []
                self.minPriceList = []
                self.maxPriceList = []
                
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
                self.data.value = model.data
                print((model.data.first?.date)!)
                print(model.data[model.data.count - 100].date)
                print(model.data.last!.date)
//                completion()
                
            case .failure(let error):
                print(error)
//                completion()
            }
        }
    }
}
