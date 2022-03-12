//
//  DummyData.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct DummyData {
    
    let transaction: Transaction = Transaction(status: "", data: [
        .init(transactionDate: "2022-03-12",
              type: "ask",
              unitsTraded: "1",
              price: "1",
              total: "1"),
        .init(transactionDate: "2022-03-12",
              type: "bid",
              unitsTraded: "1",
              price: "1",
              total: "1")
    ])
    
    let orderbook: Orderbook = Orderbook(data: OrderbookData(asks: [Order(quantity: "1", price: "1")],
                                                             bids: [Order(quantity: "11111", price: "11111")]))
    
    func makeDummydata<T: Decodable>(type: T.Type) -> T {
        if Transaction.self == T.self {
            return transaction as! T
        } else {
            return orderbook as! T
        }
    }
    
}
