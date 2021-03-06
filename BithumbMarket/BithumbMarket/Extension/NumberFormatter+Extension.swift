//
//  NumberFormatter+Extension.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

extension NumberFormatter {
    
    func computeDecimal(str: String, min: Int, max: Int) -> String {
        self.numberStyle = .decimal
        self.minimumFractionDigits = min
        self.maximumFractionDigits = max
        let number = self.number(from: str)
        return self.string(from: number ?? 0) ?? ""
    }
    
    func computeDecimal(str: String, maximumDigit: Int) -> Double {
        self.numberStyle = .decimal
        self.maximumFractionDigits = maximumDigit
        let number = self.number(from: str)
        return Double(truncating: number ?? 0)
    }
    
}
