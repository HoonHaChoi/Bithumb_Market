//
//  OrderbookViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

protocol OrderbookViewModelType {
    var orderbook: Observable<Orderbook> { get }
    var updateTableHandler: (() -> Void)? { get set }
    var errorHandler: ((HTTPError) -> Void)? { get set }
    func featchOrderbook(completion: @escaping () -> Void)
}

final class OrderbookViewModel: OrderbookViewModelType {

    var symbol: String
    var orderbook: Observable<Orderbook>
    private var service: APIService
    
    init(service: APIService = APIService(), symbol: String) {
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
    
    private var orderbookData: OrderbookData?
    var errorHandler: ((HTTPError) -> Void)?
    var updateTableHandler: (() -> Void)?
    
    func featchOrderbook(completion: @escaping () -> Void) {
        completion()
        requestOrderbook { [weak self] in
            self?.updateOrderbook()
        }
    }
    
    private func requestOrderbook(completion: @escaping () -> Void) {
        service.request(endpoint: .orderBook(symbol: symbol)) { [weak self] (result: Result<OrderbookEntity, HTTPError>) in
            switch result {
            case .success(let success):
                let orderbook = success.data
                self?.orderbookData = orderbook
                guard let asks = self?.convert(from: orderbook.asks),
                      let bids = self?.convert(from: orderbook.bids) else {
                          return
                      }
                self?.orderbook.value = Orderbook(asks: asks, bids: bids)
                self?.updateTableHandler?()
                self?.sendMessage()
                DispatchQueue.main.async {
                    completion()
                }
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
                guard let orderbookData = self?.orderbookData else {
                    return }
                let receivedOrderbook = success.content.list
                let receivedAsks = receivedOrderbook.filter { $0.orderType == "ask" }
                let receivedBids = receivedOrderbook.filter { $0.orderType == "bid" }
                guard let asksEntity = self?.mergeOrders(orderbookData.asks, into: receivedAsks),
                      let bidsEntity = self?.mergeOrders(orderbookData.bids, into: receivedBids) else {
                          return
                      }
                guard let asks = self?.convert(from: asksEntity).suffix(30),
                      let bids = self?.convert(from: bidsEntity).prefix(30) else {
                          return
                      }
                self?.orderbook.value = Orderbook(
                    asks: Array(asks),
                    bids: Array(bids)
                )
                self?.updateTableHandler?()
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    private func mergeOrders(_ old: [OrderEntity], into new: [ReceiveOrder]) -> [OrderEntity] {
        var order = old
        let newOrderPrice = new.map { $0.price }
        let previousOrderPrice = old.map { $0.price }
        
        for (index, price) in newOrderPrice.enumerated() {
            if previousOrderPrice.contains(price) {
                guard let samePrice = order.firstIndex(where: {
                    $0.price == price
                }) else {
                    continue
                }
                order.remove(at: samePrice)
                if new[index].quantity != "0" {
                    order.append(
                        OrderEntity(
                            quantity: new[index].quantity,
                            price: new[index].price)
                    )
                }
            } else if new[index].quantity != "0" {
                order.append(
                    OrderEntity(
                        quantity: new[index].quantity,
                        price: new[index].price)
                )
            }
        }
        order.sort{ Double($0.price) ?? 0 < Double($1.price) ?? 0 }
        
        return order
    }
    
    private func convert(from entity: [OrderEntity]) -> [Order]{
        return entity
            .map {
                Order(
                    price: $0.price.withComma(),
                    quantity: $0.quantity.withDecimal(maximumDigit: 4),
                    rateOfQuantity: self.calculateRateOfQuintity(
                        quantities: entity.map{ $0.quantity },
                        quantity: $0.quantity))
            }
    }
    
    private func calculateRateOfQuintity(quantities: [String], quantity: String) -> Float {
        let quantities = quantities.map { Float($0) ?? 0 }
        let sumOfQuantities = quantities.reduce(0){ $0 + $1}
        let rate = Float(quantity) ?? 0 / sumOfQuantities * 5
        return rate > 1 ? 1 : rate
    }
    
}
