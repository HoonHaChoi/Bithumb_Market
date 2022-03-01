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
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        self.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        self.selectedSegmentIndex = 0
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.textSecondary,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ], for: .normal)
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.typoColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)
        ], for: .selected)
    }
    
}

