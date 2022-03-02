//
//  Double+Extension.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import Foundation

extension Double {
        
    var formatPrice: String {
        let unit = ["백만", "십만", "만", "천", "원"]
        var standardValue: Double = 1000000
        
        for i in 0..<unit.count {
            if self/standardValue > 1 {
                return String(self/standardValue).withDecimal(maximumDigit: 0).withComma() + unit[i]
            }
            standardValue /= 10
        }
        return String(self)
    }
    
}
