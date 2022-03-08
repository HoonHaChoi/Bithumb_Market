//
//  AssetsState.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/04.
//

import UIKit

enum AssetsState {

    case possibleDeposit
    case possibleWithdrawal
    case possibleAll
    case impossible
    
    var description: NSMutableAttributedString {
        switch self {
        case .possibleDeposit:
            return setAttributedString("●  입금가능", color: .mainColor)
        case .possibleWithdrawal:
            return setAttributedString("●  출금가능", color: .mainColor)
        case .possibleAll:
            return setAttributedString("●  입출금가능", color: .mainColor)
        case .impossible:
            return setAttributedString("●  입출금불가", color: .systemRed)
        }
    }
    
    private func setAttributedString(_ string: String, color: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(
            .foregroundColor,
            value: color,
            range: (attributedString.string as NSString).range(of: "●"))
        return attributedString
    }
}
