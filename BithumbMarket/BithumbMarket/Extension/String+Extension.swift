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
    
    func convertDouble() -> Double {
        return Double(self) ?? 0
    }
    
    func withComma(min: Int = 0, max: Int = 0) -> String {
        return NumberFormatter().computeDecimal(str: self, min: min, max: max)
    }
    
    func withDecimal(maximumDigit: Int) -> String {
        let numberString = NumberFormatter().computeDecimal(str: self, maximumDigit: maximumDigit)
        return String(format: "%.\(maximumDigit)f", numberString)
    }
    
    func equalStringDouble(_ str: String) -> Bool {
        self.convertDouble().isEqual(to: str.convertDouble())
    }
    
    func isLessStringDouble(_ str: String) -> Bool {
        self.convertDouble().isLess(than: str.convertDouble())
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[start..<end])
    }
    
}
