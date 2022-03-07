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
    
    func setChangeState() -> ChangeState {
        switch true{
        case changeRate.convertDouble() == 0:
            return .even
        case changeRate.convertDouble() > 0:
            return .rise
        case changeRate.convertDouble() < 0:
            return .fall
        default:
            fatalError()
        }
    }
    
    
}

struct CurrentPrice: Decodable {
    let data: Market
}
