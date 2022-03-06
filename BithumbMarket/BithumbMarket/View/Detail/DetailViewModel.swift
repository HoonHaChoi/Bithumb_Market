//
//  DetailViewModel.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/05.
//

import Foundation

struct DetailViewModel {
    
    private let storage: LikeStorge
    
    init(storage: LikeStorge = LikeStorge()) {
        self.storage = storage
    }
    
    func hasLike(symbol: String) -> Bool {
         return storage.find(symbol: symbol)
    }
    
    func updateLike(symbol: String) -> Result<Bool, CoreDataError> {
        if hasLike(symbol: symbol) {
            return storage.delete(symbol: symbol)
        } else {
            return storage.save(symbol: symbol)
        }
    }
    
}
