//
//  String+Extension.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/25.
//

import Foundation

extension String {
    
    func convertInt() -> Int {
        return Int(self) ?? 0
    }
    
    func withComma() -> String {
        return NumberFormatter().computeDecimal(str: self)
    }
    
    func withDecimal(maximumDigit: Int) -> String {
        let numberString = NumberFormatter().computeDecimal(str: self, maximumDigit: maximumDigit)
        return String(format: "%.\(maximumDigit)f", numberString)
    }
    
}

