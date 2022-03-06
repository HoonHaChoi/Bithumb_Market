//
//  ChangeState.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/01.
//

import UIKit

enum ChangeState: Hashable {
    
    case rise
    case fall
    case even
    
    var textColor: UIColor {
        switch self {
        case .rise:
            return .riseColor
        case .fall:
            return .fallColor
        case .even:
            return .typoColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .rise:
            return .riseColor
        case .fall:
            return .fallColor
        case .even:
            return .systemBackground
        }
    }
    
}
