//
//  AssetsStatus.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

struct AssetsStatus: Decodable {
    let data: AssetsStatusData
}

struct AssetsStatusData: Decodable {
    let depositStatus: Int
    let withdrawalStatus: Int
}
