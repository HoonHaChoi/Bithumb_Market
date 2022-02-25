//
//  OrderbookViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

class OrderbookViewModel {

    var orderbookData: OrderbookData?
    
    private let url = EndPoint().makeURL(of: .orderBook, param: "BTC_KRW")
    
    init(service: APIService) {
        service.request(url: url) { [weak self] (result: Result<Orderbook, HTTPError>) in
            switch result {
            case .success(let success):
                self?.orderbookData = success.data
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}
