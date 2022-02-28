//
//  OrderbookViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

protocol OrderbookViewModelType {
    
    var binding: () -> Void { get set}
    var orderbook: Orderbook { get }
    func request(completion: @escaping () -> Void)
    
}

class OrderbookViewModel: OrderbookViewModelType {

    //TODO: 뷰와 의존 관계에 따라 변경 및 추가
    var binding: () -> Void = { }
    var orderbook: Orderbook {
        didSet {
            binding()
        }
    }
    private var service: APIService
    
    init(service: APIService) {
        self.service = service
        self.orderbook = Orderbook(
            asksPrice: Array(repeating: "", count: 30),
            bidsPrice: Array(repeating: "", count: 30),
            asksQuanity: Array(repeating: Quantity(text: "", rate: 0), count: 30),
            bidsQuanity: Array(repeating: Quantity(text: "", rate: 0), count: 30)
        )
    }
    
    private func calculateRateOfQuintity(quantities: [String], quantity: String) -> Float {
        let quantities = quantities.map { Float($0) ?? 0 }
        let sumOfQuantities = quantities.reduce(0){ $0 + $1}
        return Float(quantity) ?? 0 / sumOfQuantities * 5
    }
    
    private let url = EndPoint().makeURL(of: .orderBook, param: "BTC_KRW")
    
    //TODO: 메소드 분리
    func request(completion: @escaping () -> Void) {
        service.request(url: url) { [weak self] (result: Result<OrderbookEntity, HTTPError>) in
            switch result {
            case .success(let success):
                let orderbookData = success.data
                self?.orderbook = Orderbook(
                    asksPrice: orderbookData.asks.reversed().map { $0.price },
                    bidsPrice: orderbookData.bids.reversed().map { $0.price }.reversed(),
                    asksQuanity:  orderbookData.bids.reversed()
                        .map {
                            Quantity(
                                text: $0.quantity,
                                rate: self?.calculateRateOfQuintity(
                                    quantities: orderbookData.asks.map{ $0.quantity },
                                    quantity: $0.quantity
                                ) ?? 0
                            )
                        },
                    bidsQuanity: orderbookData.asks.reversed()
                        .map {
                            Quantity(
                                text: $0.quantity,
                                rate: self?.calculateRateOfQuintity(
                                    quantities: orderbookData.bids.map{ $0.quantity },
                                    quantity: $0.quantity
                                ) ?? 0
                            )
                        }
                )
            case .failure(let failure):
                //TODO: fail 처리
                print(failure)
            }
        }
    }
    
}
