//
//  Market.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

struct Market: Decodable {
    
    var openingPrice: String
    var closingPrice: String
    let minPrice: String
    let maxPrice: String
    let unitsTraded: String
    let accTradeValue: String
    var prevClosingPrice: String
    var unitsTraded24H: String
    var accTradeValue24H: String
    var fluctate24H: String
    var fluctateRate24H: String
    
    func computePriceChangeState() -> ChangeState {
        return setChangeState(openingPrice, closingPrice)
    }
    
    func computeClosepriceState(to newClosePrice: String) -> ChangeState {
        return setChangeState(closingPrice, newClosePrice)
    }
    
    func isNotEqual(_ newClosePrice: String) -> Bool {
        closingPrice != newClosePrice
    }

    private func setChangeState(_ priceA: String,_ priceB : String) -> ChangeState {
        if priceA.equalStringDouble(priceB) {
            return .even
        }
        
        if priceA.isLessStringDouble(priceB) {
            return .rise
        }
        return .fall
    }
}
