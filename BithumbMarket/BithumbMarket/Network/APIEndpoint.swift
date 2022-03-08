//
//  APIEndpoint.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/27.
//

import Foundation

enum APIEndpoint: Endpoint {
    
    case ticker(symbol: String = "all")
    case transactionHistory(symbol: String)
    case orderBook(symbol: String)
    case assetsstatus(symbol: String)
    case candlestick(symbol: String, interval: ChartIntervals)
    case socket
    
    var baseURLString: String {
        switch self {
        case .socket:
            return "wss://pubwss.bithumb.com/pub/ws"
        default:
            return "https://api.bithumb.com/public"
        }
    }
    
    var path: String {
        switch self {
        case .ticker(let symbol):
            return "/ticker/\(symbol)"
        case .orderBook(let symbol):
            return "/orderbook/\(symbol)"
        case .transactionHistory(let symbol):
            return "/transaction_history/\(symbol)"
        case .assetsstatus(let symbol):
            return "/assetsstatus/\(symbol)"
        case .candlestick(let symbol,let interval):
            return "/candlestick/\(symbol)/\(interval.type)"
        case .socket:
            return ""
        }
    }
    
}
