//
//  CoinSortSegmentControl.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/25.
//

import UIKit

final class CoinSortSegmentControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func configure() {
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        self.selectedSegmentIndex = 0
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)
        ], for: .normal)
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline)
        ], for: .selected)
    }
    
}

