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

enum ChartIntervals: CaseIterable {
    
    case oneminute
    case tenminute
    case halfhour
    case anhour
    case day
    
    var type: String {
        switch self {
        case .oneminute:
            return "1m"
        case .tenminute:
            return "10m"
        case .halfhour:
            return "30m"
        case .anhour:
            return "1h"
        case .day:
            return "24h"
        }
    }
    
    var name: String {
        switch self {
        case .oneminute:
            return "1분"
        case .tenminute:
            return "10분"
        case .halfhour:
            return "30분"
        case .anhour:
            return "1시간"
        case .day:
            return "1일"
        }
    }
    
}
