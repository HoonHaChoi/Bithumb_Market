//
//  String+Extension.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/25.
//

import Foundation

extension String {
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[start..<end])
    }
    
    func withComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value: Int(self) ?? 0))!
    }
}
