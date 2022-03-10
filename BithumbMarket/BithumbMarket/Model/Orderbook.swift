//
//  Orderbook.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

struct Orderbook: Decodable {
    let data: OrderbookData
}

struct OrderbookData: Decodable {
    var asks: [Order]
    var bids: [Order]
    
    func sumOfAsks() -> Float {
        asks
            .map { Float($0.quantity) ?? 0 }
            .reduce(0) { $0 + $1 }
    }
    
    func sumOfBids() -> Float {
        bids
            .map { Float($0.quantity) ?? 0 }
            .reduce(0) { $0 + $1 }
    }
    
    func calculateRateOfAsks() -> [Float] {
        return calculateRateOfQuintity(orders: asks)
    }
    
    func calculateRateOfBids() -> [Float] {
        return calculateRateOfQuintity(orders: bids)
    }
}

extension OrderbookData {
    
    func calculateRateOfQuintity(orders: [Order]) -> [Float] {
        var rate = [Float]()
        let quantities = orders
            .map { Float($0.quantity) ?? 0 }
        var sum = quantities
            .reduce(0) { $0 + $1 }
        if sum == 0 {
            sum = 1
        }
        quantities.forEach {
            rate.append($0 / sum * 5 )
        }
        return rate
    }
    
}

struct Order: Decodable {
    let quantity: String
    let price: String
}
