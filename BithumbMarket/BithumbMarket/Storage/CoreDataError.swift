//
//  CoreDataError.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/05.
//

import Foundation

enum CoreDataError: Error, CustomStringConvertible {
    case failureFetch
    case failureSave
    case failureDelete
    case failiureFind
    
    var description: String {
        switch self {
        case .failureFetch:
            return "조회에 실패하였습니다."
        case .failureSave:
            return "저장에 실패하였습니다."
        case .failureDelete:
            return "삭제에 실패하였습니다."
        case .failiureFind:
            return "찾기에 실패하였습니다."
        }
    }
}
