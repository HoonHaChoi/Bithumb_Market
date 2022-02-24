//
//  Market.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/24.
//

import Foundation

struct Market: Decodable {
    let openingPrice: String
    let closingPrice: String
    let minPrice: String
    let maxPrice: String
    let unitsTraded: String
    let accTradeValue: String
    let prevClosingPrice: String
    let unitsTraded24H: String
    let accTradeValue24H: String
    let fluctate24H: String
    let fluctateRate24H: String
}
