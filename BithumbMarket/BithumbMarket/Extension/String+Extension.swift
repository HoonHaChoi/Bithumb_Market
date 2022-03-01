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
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[start..<end])
    }
    
}
