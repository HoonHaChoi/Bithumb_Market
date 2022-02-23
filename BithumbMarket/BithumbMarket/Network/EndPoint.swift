//
//  EndPoint.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

struct EndPoint {
    
    private let scheme = "https"
    private let host = "api.bithumb.com"
    private let path = "/public/"
    
    enum RequestType: String {
        case ticker = "ticker"
        case orderBook = "orderbook"
        case transactionHistory = "transaction_history"
        case assetsStatus = "assetsstatus"
        
        var name: String {
            return self.rawValue
        }
    }
    
    func makeURL(of type: RequestType, param: String) -> URL? {
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path + type.name + param
        return component.url
    }
}
