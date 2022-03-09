//
//  OrderbookViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

final class OrderbookViewModel {

    var orderbook: Observable<OrderbookData>
    private let symbol: String
    private let service: APIService
    
    init(service: APIService, symbol: String) {
        self.orderbook = .init(OrderbookData(
            asks: Array(repeating: .init(quantity: "", price: ""), count: 30),
            bids: Array(repeating: .init(quantity: "", price: ""), count: 30)))
        self.service = service
        self.symbol = symbol
    }
    
    var errorHandler: ((HTTPError) -> Void)?
    var updateHandler: (() -> Void)?
    
    func fetchOrderbook() {
        service.request(endpoint: .orderBook(symbol: symbol)) { [weak self] (result: Result<Orderbook, HTTPError>) in
            switch result {
            case .success(let success):
                self?.orderbook.value = success.data
                self?.updateHandler?()
                self?.sendMessage()
                self?.updateOrderbook()
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    private func sendMessage() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let symbol = self?.symbol else { return }
            let message = Message(type: .orderbookdepth, symbols: .name(symbol))
            self?.service.sendSocketMessage(to: message)
        }
    }
    
    private func updateOrderbook() {
        self.service.perform { [weak self] (result: Result<ReceiveOrderbook, HTTPError>) in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                let receivedOrderbook = success.content.list
                let receivedAsks = receivedOrderbook.filter { $0.orderType == OrderbookNameSpace.ask }
                let receivedBids = receivedOrderbook.filter { $0.orderType == OrderbookNameSpace.bid }
                
                let asks = Array(self.mergeOrders(self.orderbook.value.asks, into: receivedAsks).prefix(30))
                let bids = Array(self.mergeOrders(self.orderbook.value.bids, into: receivedBids).suffix(30))
                
                self.orderbook.value = .init(asks: asks, bids: bids)
                self.updateHandler?()
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    private func mergeOrders(_ old: [Order], into new: [ReceiveOrder]) -> [Order] {
        var order = old
        let newOrderPrice = new.map { $0.price }
        let previousOrderPrice = old.map { $0.price }
        
        for (index, price) in newOrderPrice.enumerated() {
            if previousOrderPrice.contains(price) {
                guard let samePrice = order.firstIndex(where: { $0.price == price }) else {
                    continue
                }
                order.remove(at: samePrice)
                if new[index].quantity != OrderbookNameSpace.noQuantity {
                    order.append(Order(quantity: new[index].quantity,
                                       price: new[index].price))
                }
            } else if new[index].quantity != OrderbookNameSpace.noQuantity {
                order.append(Order(quantity: new[index].quantity,
                                   price: new[index].price))
            }
        }
        order.sort{ Double($0.price) ?? 0 > Double($1.price) ?? 0 }
        return order
    }
    
}
