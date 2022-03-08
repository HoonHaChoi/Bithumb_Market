//
//  ChartIntervals.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/08.
//

import Foundation

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
    
    var second: TimeInterval {
        switch self {
        case .oneminute:
            return 60
        case .tenminute:
            return 600
        case .halfhour:
            return 1800
        case .anhour:
            return 3600
        case .day:
            return 86400
        }
    }
    
}
