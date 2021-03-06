//
//  MockLikeStorge.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct MockLikeStorage: LikeStorgeType {
    
    var isSuccess: Bool = true 
    var likes: [String] = ["ASD", "ZXC", "Fake"]

    func fetch() -> Result<[String], CoreDataError> {
        if isSuccess {
            return .success(likes)
        } else {
            return .failure(.failureFetch)
        }
    }

    func save(symbol: String) -> Result<Bool, CoreDataError> {
        if isSuccess {
            return .success(true)
        } else {
            return .failure(.failureSave)
        }
    }

    func delete(symbol: String) -> Result<Bool, CoreDataError> {
        if isSuccess {
            return .success(true)
        } else {
            return .failure(.failureDelete)
        }
    }

    func find(symbol: String) -> Bool {
        return likes.contains(symbol)
    }

}
