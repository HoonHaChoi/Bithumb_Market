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
    
    func changeOfPrice() -> Int {
        return closingPrice.convertInt() - openingPrice.convertInt()
    }
    
    func changeOfRate() -> Double {
        return (Double(changeOfPrice()) - 1) * 100
    }
}
