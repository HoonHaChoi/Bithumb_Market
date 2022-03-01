//
//  MainHeaderView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class MainHeaderView: UIView {
    
    private let symbolsTitleLabel = UILabel()
    private let currentPriceTitleLabel = UILabel()
    private let fluctuateTitleLabel = UILabel()
    private let accTradeValueTitleLabel = UILabel()
    
    private let titleStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
