//
//  Market.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

struct Market: Decodable {
    var openingPrice: String
    var closingPrice: ClosePrice
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
        return String(closingPrice.computeChangePrice(openingPrice)).withComma()
    }
    
    func changeOfRate() -> String {
        return String(closingPrice.computeChangeOfRate(openingPrice)).withDecimal(maximumDigit: 2) + "%"
    }
    
    func showNetChangeState() -> ChangeState {
        return closingPrice.computeNetChangeState(openingPrice)
    }
    
    func compareCloseprice(to closePrice: String) -> ChangeState {
        return closingPrice.compare(than: closePrice)
    }

}

struct ClosePrice {
    
    private(set) var price: String
    
    func computeChangePrice(_ openingPrice: String) -> Double {
        return price.convertDouble() - openingPrice.convertDouble()
    }
    
    func computeChangeOfRate(_ openingPrice: String) -> Double {
        return ((price.convertDouble() / openingPrice.convertDouble()) - 1) * 100
    }
    
    func computeNetChangeState(_ openingPrice: String) -> ChangeState {
        if price.convertDouble().isEqual(to: openingPrice.convertDouble()) {
            return .even
        }
        if price.convertDouble().isLess(than: openingPrice.convertDouble()) {
            return .fall
        }
        return .rise
    }
    
    func compare(than closePrice: String) -> ChangeState {
        if price.convertDouble().isEqual(to: closePrice.convertDouble()) {
            return .even
        }
        if price.convertDouble().isLess(than: closePrice.convertDouble()) {
            return .rise
        }
        return .fall
    }
    
    mutating func updatePrice(_ price: String) {
        self.price = price
    }
    
    func isNotEqual(_ price: String) -> Bool{
        self.price != price
    }
    
}
