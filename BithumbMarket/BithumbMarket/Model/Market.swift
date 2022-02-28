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
    let prevClosingPrice: String
    let unitsTraded24H: String
    let accTradeValue24H: String
    let fluctate24H: String
    let fluctateRate24H: String
    
    func changeOfPrice() -> String {
        return String(closingPrice.convertDouble() - openingPrice.convertDouble()).withComma()
    }
    
    func changeOfRate() -> String {
        return String(((closingPrice.convertDouble() / openingPrice.convertDouble()) - 1) * 100).withDecimal(maximumDigit: 2) + "%"
    }
    
    func showChangeState() -> ChangeState {
        if closingPrice.convertDouble().isEqual(to: openingPrice.convertDouble()) {
            return .even
        }
        
        if closingPrice.convertDouble().isLess(than: openingPrice.convertDouble()) {
            return .fall
        } else {
            return .rise
        }
    }

}
