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
    
    func setState() -> AssetsState {
        switch true {
        case depositStatus == 1 && withdrawalStatus == 0:
            return .possibleWithdrawal
        case depositStatus == 1 && withdrawalStatus == 1:
            return .possibleAll
        case depositStatus == 0 && withdrawalStatus == 1:
            return .possibleDeposit
        default:
            return .impossible
        }
    }
}
