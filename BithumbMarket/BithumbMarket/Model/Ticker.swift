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
    
    func changeOfRate() -> Double {
        return (Double(changeOfPrice()) - 1) * 100
    }
    
    func changeOfPrice() -> Int {
        return market.closingPrice.convertInt() - market.openingPrice.convertInt()
    }
}
