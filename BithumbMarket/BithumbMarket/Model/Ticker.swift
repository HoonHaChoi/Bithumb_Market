//
//  Ticker.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/24.
//

import Foundation

struct Ticker {
    let symbol: String
    var market: Market
    
    var paymentCurrency: String {
        symbol + "_KRW"
    }
    
    func equalSymbol(to ticker: ReceiveTicker) -> Bool {
        return paymentCurrency == ticker.content.symbol
    }
    
    func compare(to ticker: ReceiveTicker) -> Bool {
        market.closingPrice != ticker.content.closePrice
    }
    
    mutating func updatePrice(to ticker: ReceiveTicker) {
        market.closingPrice = ticker.content.closePrice
        market.openingPrice = ticker.content.openPrice
    }
    
}

extension Ticker: Comparable {
    
    static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.market.accTradeValue24H.convertDouble() > rhs.market.accTradeValue24H.convertDouble()
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.market.accTradeValue24H.convertDouble() < rhs.market.accTradeValue24H.convertDouble()
    }
    
    static func == (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.market.accTradeValue24H.convertDouble() == rhs.market.accTradeValue24H.convertDouble()
    }
    
}
