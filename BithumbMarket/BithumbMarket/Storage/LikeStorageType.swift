//
//  LikeStorageType.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/13.
//

import Foundation

protocol LikeStorgeType {
    func fetch() -> Result<[String], CoreDataError>
    func save(symbol: String) -> Result<Bool, CoreDataError>
    func delete(symbol: String) -> Result<Bool, CoreDataError>
    func find(symbol: String) -> Bool
}
