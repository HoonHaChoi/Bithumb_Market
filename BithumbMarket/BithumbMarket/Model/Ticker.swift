//
//  Ticker.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/24.
//

import Foundation

final class Ticker: Hashable {
    
    let symbol: String
    private(set) var market: Market
    var change: ChangeState
    
    enum UpdateState {
        case closePrice
        case tradeValue
    }
    
    init(symbol: String, market: Market) {
        self.symbol = symbol
        self.market = market
        self.change = .even
    }
    
    var paymentCurrency: String {
        symbol + "_KRW"
    }
    
    func equalSymbol(to ticker: ReceiveTicker) -> Bool {
        return paymentCurrency == ticker.content.symbol
    }
    
    func updatePrice(to ticker: ReceiveTicker) {
        updateTickerChangeState(to: ticker.content.closePrice)
        market.closingPrice = ticker.content.closePrice
        market.openingPrice = ticker.content.openPrice
        market.prevClosingPrice = ticker.content.prevClosePrice
        market.unitsTraded24H = ticker.content.volume
        market.accTradeValue24H = ticker.content.value
        market.fluctate24H = ticker.content.chgAmt
        market.fluctateRate24H = ticker.content.chgRate
    }
    
    private func updateTickerChangeState(to closePrice: String) {
        change = market.computeClosepriceState(to: closePrice)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(market)
    }
    
}

extension Ticker: Comparable {
    
    static func > (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.market.accTradeValue24H.convertDouble() > rhs.market.accTradeValue24H.convertDouble()
    }
    
    static func < (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.market.accTradeValue24H.convertDouble() < rhs.market.accTradeValue24H.convertDouble()
    }
    
    static func == (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.market.accTradeValue24H.convertDouble() == rhs.market.accTradeValue24H.convertDouble()
    }
    
}
