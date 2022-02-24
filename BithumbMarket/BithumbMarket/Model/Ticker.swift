//
//  Ticker.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

struct Ticker: Decodable {
    let status: String
    let data: [String: Market]
}
