//
//  UIScrollView+Extension.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/10.
//

import UIKit

extension UIScrollView {

    func scrollToEnd(x: CGFloat) {
        self.layoutIfNeeded()
        let offset = CGPoint(x: x - UIScreen.main.bounds.width, y: 0)
            self.setContentOffset(offset, animated: false)
    }
    
    func scrollToCenter(y: CGFloat) {
        let centerOffset = CGPoint(x: 0, y: y)
        setContentOffset(centerOffset, animated: false)
    }
    
}
