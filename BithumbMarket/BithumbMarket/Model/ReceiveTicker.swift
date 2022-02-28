//
//  ReceiveTicker.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

struct ReceiveTicker: Codable {
    let type: String
    let content: Content
}

struct Content: Codable {
    let openPrice: String
    let closePrice: String
    let symbol: String
    let volume: String
    let sellVolume: String
    let buyVolume: String
    let prevClosePrice: String
    let chgRate: String
    let chgAmt: String
    let volumePower: String
}
