//
//  Message.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

struct Message: Encodable {
    
    let type: String
    let symbols: [String]
    var tickTypes: [String]?
    
    init(type: messageType, symbols: Symbols) {
        self.type = type.message
        self.symbols = symbols.warp
    }
    
    init(type: messageType, symbols: Symbols, tickTypes: TickTypes) {
        self.type = type.message
        self.symbols = symbols.warp
        self.tickTypes = [tickTypes.type]
    }
    
    enum messageType: Encodable {
        case ticker
        case transaction
        case orderbookdepth
        
        var message: String {
            return "\(self)"
        }
    }
    
    enum TickTypes: Encodable {
        case halfhour
        case anhour
        case twelvehour
        case twentyfourHour
        case mid
        
        var type: String {
            switch self {
            case .halfhour:
                return "30M"
            case .anhour:
                return "1H"
            case .twelvehour:
                return "12H"
            case .twentyfourHour:
                return "24H"
            case .mid:
                return "MID"
            }
        }
    }
    
    enum Symbols: Encodable {
        case name(String)
        case names([String])
        
        var warp: [String] {
            switch self {
            case .name(let symbol):
                return [symbol]
            case .names(let symbols):
                return symbols
            }
        }
    }
    
}
