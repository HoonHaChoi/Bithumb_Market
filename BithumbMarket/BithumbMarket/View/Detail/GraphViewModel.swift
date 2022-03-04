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
    var date: [String] = []
    var price: [Int] = []

    private var service: APIService
    
    init(service: APIService = APIService()) {
        self.service = service
    }
    
    func fetchGraphPrice(completion: @escaping () -> Void) {
        service.request(endpoint: .candlestick(symbol: symbole, interval: .day)) { [weak self] (result: Result<CandleStick, HTTPError>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.data = model.data
    
                print(model.data.count)
                
                for i in (model.data.count - 100)..<model.data.count {
                    let closPrice = model.data[i].closPrice
                    self.price.append(Int((closPrice as NSString).floatValue))
                }
                print(model.data[0].closPrice)
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
}
