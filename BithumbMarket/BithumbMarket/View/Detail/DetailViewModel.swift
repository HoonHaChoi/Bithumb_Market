//
//  DetailViewModel.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/05.
//

import Foundation

final class DetailViewModel {
    
    private let storage: LikeStorge
    
    init(storage: LikeStorge) {
        self.storage = storage
    }
    
    var hasLikeHandler: ((Bool) -> Void)?
    var updateCompleteHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func hasLike(symbol: String) {
        hasLikeHandler?(storage.find(symbol: symbol))
    }
    
    func updateLike(symbol: String) {
        if storage.find(symbol: symbol) {
            deleteLike(symbol: symbol)
        } else {
            saveLike(symbol: symbol.description)
        }
    }
    
    private func deleteLike(symbol: String) {
        switch storage.delete(symbol: symbol) {
        case .success(_):
            updateCompleteHandler?()
        case .failure(let error):
            errorHandler?(error)
        }
    }
    
    private func saveLike(symbol: String) {
        switch storage.save(symbol: symbol) {
        case .success(_):
            updateCompleteHandler?()
        case .failure(let error):
            errorHandler?(error)
        }
    }
    
}
