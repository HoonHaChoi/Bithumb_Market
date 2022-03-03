//
//  Pirce.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

struct CurrentPrice {
    let currentPrice: String
    let changePrice: String
    let changeRate: String
}

struct Price: Decodable {
    let data: Market
}
