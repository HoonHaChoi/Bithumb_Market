//
//  Market.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

struct Market: Decodable, Hashable {
    
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
        if fluctate24H.convertDouble() == 0 {
            return .even
        }
        
        if fluctate24H.convertDouble() > 0 {
            return .rise
        }
        return .fall
    }
    
    func computeClosepriceState(to newClosePrice: String) -> ChangeState {
        if closingPrice.equalStringDouble(newClosePrice) {
            return .even
        }
        
        if closingPrice.isLessStringDouble(newClosePrice) {
            return .rise
        }
        return .fall
    }

}
