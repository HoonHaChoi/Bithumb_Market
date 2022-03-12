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
    
    let receiveOrderbook = ReceiveOrderbook(content: ReceiveOrderList(list: [ReceiveOrder(orderType: "ask",
                                                                                                 price: "10000",
                                                                                                 quantity: "10",
                                                                                                 total: "0")]))
    
    let receiveTransaction = ReceiveTransaction(type: "", content: TransactionContent(list: [TransactionList(buySellGb: "1",
                                                                                                             contPrice: "1",
                                                                                                             contQty: "100",
                                                                                                             contAmt: "100.0",
                                                                                                             contDtm: "2022-01-29",
                                                                                                             updn: "dn",
                                                                                                             symbol: "Fake_KRW")]))
    
    func makeDummydata<T: Decodable>(type: T.Type) -> T {
        if Transaction.self == T.self {
            return transaction as! T
        } else {
            return orderbook as! T
        }
    }
    
    func makeSocketDummydata<T: Decodable>(type: T.Type) -> T {
        if ReceiveTransaction.self == T.self {
            return receiveTransaction as! T
        } else {
            return receiveOrderbook as! T
        }
    }
    
}
