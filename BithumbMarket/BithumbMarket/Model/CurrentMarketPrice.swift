//
//  Pirce.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

struct CurrentMarketPrice {
    let currentPrice: String
    let changePrice: String
    let changeRate: String
    
    static let empty = CurrentMarketPrice(currentPrice: "",
                                          changePrice: "",
                                          changeRate: "")
    
    var setChange: ChangeState {
        let currentPrice = changePrice.convertDouble()
        if currentPrice == .zero {
            return .even
        }
        
        if currentPrice > 0 {
            return .rise
        }
        return .fall
    }
    
}
