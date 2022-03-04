//
//  DetailViewModel.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/05.
//

import Foundation

struct DetailViewModel {
    
    private let storage: LikeStorge
    
    init(storage: LikeStorge) {
        self.storage = storage
    }
    
    func hasTicker(symbol: String) -> Bool {
         return storage.find(symbol: symbol)
    }
}
