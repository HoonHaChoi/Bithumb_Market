//
//  ReceiveOrderbook.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/02.
//

import Foundation

struct ReceiveOrderbook: Decodable {
    let content: ReceiveOrderList
    
}

struct ReceiveOrderList: Decodable {
    let list: [ReceiveOrder]
}

struct ReceiveOrder: Decodable {
    let orderType: String
    let price: String
    let quantity: String
    let total: String
}
