//
//  ChangeState.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/01.
//

import UIKit

enum ChangeState {
    case rise
    case fall
    case even
    
    var color: UIColor {
        switch self {
        case .rise:
            return .riseColor
        case .fall:
            return .fallColor
        case .even:
            return .typoColor
        }
    }
}
