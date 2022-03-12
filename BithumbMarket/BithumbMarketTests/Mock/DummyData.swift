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
    
    let receiveTransaction = ReceiveTransaction(type: "",
                                                content: TransactionContent(list: [TransactionList(buySellGb: "1",
                                                                                                   contPrice: "1",
                                                                                                   contQty: "100",
                                                                                                   contAmt: "100.0",
                                                                                                   contDtm: "2022-01-29",
                                                                                                   updn: "dn",
                                                                                                   symbol: "Fake_KRW")]))
    let receiveTicker = ReceiveTicker(type: "", content: Content(openPrice: "1000",
                                                                 closePrice: "1500",
                                                                 symbol: "Fake_KRW",
                                                                 value: "123.01",
                                                                 volume: "1234.01",
                                                                 sellVolume: "10",
                                                                 buyVolume: "15",
                                                                 prevClosePrice: "1300",
                                                                 chgRate: "50",
                                                                 chgAmt: "500",
                                                                 volumePower: "50.00"))
    
    let tickers = [Ticker(symbol: "Fake", market: Market(openingPrice: "10",
                                                            closingPrice: "12",
                                                            minPrice: "10",
                                                            maxPrice: "15",
                                                            unitsTraded: "",
                                                            accTradeValue: "",
                                                            prevClosingPrice: "",
                                                            unitsTraded24H: "",
                                                            accTradeValue24H: "",
                                                            fluctate24H: "10",
                                                            fluctateRate24H: "10")),
                  .init(symbol: "Faker_KRW", market: Market(openingPrice: "20",
                                                            closingPrice: "25",
                                                            minPrice: "15",
                                                            maxPrice: "30",
                                                            unitsTraded: "",
                                                            accTradeValue: "",
                                                            prevClosingPrice: "",
                                                            unitsTraded24H: "",
                                                            accTradeValue24H: "",
                                                            fluctate24H: "5",
                                                            fluctateRate24H: "5"))]
                  
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
            return receiveTicker as! T
        }
    }
    
}
