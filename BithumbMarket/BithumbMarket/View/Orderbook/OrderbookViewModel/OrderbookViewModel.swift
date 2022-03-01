//
//  OrderbookViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

protocol OrderbookViewModelType {
    var orderbook: Observable<Orderbook> { get }
    var errorHandler: ((HTTPError) -> Void)? { get set }
    func featchOrderbook()
}

final class OrderbookViewModel: OrderbookViewModelType {

    var symbol: String
    var orderbook: Observable<Orderbook>
    private var service: APIService
    
    init(service: APIService, symbol: String) {
        self.orderbook =  Observable(
            Orderbook(
                asks: Array(
                    repeating: Order(
                        price: "",
                        quantity: "",
                        rateOfQuantity: 0),
                    count: 30),
                bids:  Array(
                    repeating: Order(
                        price: "",
                        quantity: "",
                        rateOfQuantity: 0),
                    count: 30)
            )
        )
        self.service = service
        self.symbol = symbol
    }
    
    var errorHandler: ((HTTPError) -> Void)?
    
    func featchOrderbook() {
        service.request(endpoint: .orderBook(symbol: symbol)) { [weak self] (result: Result<OrderbookEntity, HTTPError>) in
            switch result {
            case .success(let success):
                let orderbook = success.data
                guard let asks = self?.convert(from: orderbook.asks),
                      let bids = self?.convert(from: orderbook.bids) else {
                          return
                      }
                self?.orderbook.value = Orderbook(asks: asks, bids: bids)
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    private func convert(from entity: [OrderEntity]) -> [Order]{
        return entity
            .map {
                Order(
                    price: $0.price,
                    quantity: $0.quantity,
                    rateOfQuantity: self.calculateRateOfQuintity(
                        quantities: entity.map{ $0.quantity },
                        quantity: $0.quantity))
            }
    }
    
    private func calculateRateOfQuintity(quantities: [String], quantity: String) -> Float {
        let quantities = quantities.map { Float($0) ?? 0 }
        let sumOfQuantities = quantities.reduce(0){ $0 + $1}
        return Float(quantity) ?? 0 / sumOfQuantities * 5
    }
    
}
