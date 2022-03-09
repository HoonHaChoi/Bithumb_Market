//
//  UserDefaults+Extension.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/09.
//

import Foundation

extension UserDefaults {
    
    enum Key {
        static let line = "line"
    }
    
    func isLine() -> Bool {
        self.bool(forKey: Key.line)
    }
    
    func changeisLine() {
        self.set(!isLine(), forKey: Key.line)
    }
    
}
