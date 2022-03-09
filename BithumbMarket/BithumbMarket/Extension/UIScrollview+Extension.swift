//
//  UIScrollview+Extension.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/09.
//

import UIKit

extension UIScrollView {
    
    func scrollToEnd(x: CGFloat) {
        let offset = CGPoint(x: x - UIScreen.main.bounds.width, y: 0)
        DispatchQueue.main.async {
            self.setContentOffset(offset, animated: false)
            self.layoutIfNeeded()
        }
    }
    
}
