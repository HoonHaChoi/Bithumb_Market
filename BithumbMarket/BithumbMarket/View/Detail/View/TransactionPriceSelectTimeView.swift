//
//  TransactionPriceSelectTimeView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class TransactionPriceSelectTimeView: UIView {
    
    private let chartIntervals: [ChartIntervals]
    private var intervalButtons: [UIButton]
    private lazy var selectStackView = UIStackView(arrangedSubviews: intervalButtons)
    
    override init(frame: CGRect) {
        chartIntervals = ChartIntervals.allCases
        intervalButtons = []
        super.init(frame: frame)
        configureStackViewUI()
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        chartIntervals = ChartIntervals.allCases
        intervalButtons = []
        super.init(coder: coder)
        configureStackViewUI()
        setConstraintLayout()
    }
    
}

extension TransactionPriceSelectTimeView {
    
    private func configureStackViewUI() {
        chartIntervals.forEach { interval in
            let button = UIButton(type: .custom)
            button.setTitle(interval.name, for: .normal)
            button.setTitleColor(.textPrimary, for: .selected)
            button.setTitleColor(.actionTextSecondary, for: .highlighted)
            button.setTitleColor(.textSecondary, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
            intervalButtons.append(button)
        }
        intervalButtons.last?.isSelected = true
        
        selectStackView.translatesAutoresizingMaskIntoConstraints = false
        selectStackView.alignment = .fill
        selectStackView.distribution = .equalSpacing
    }
    
    private func setConstraintLayout() {
        addSubview(selectStackView)
        
        NSLayoutConstraint.activate([
            selectStackView.topAnchor.constraint(equalTo: topAnchor),
            selectStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
}
