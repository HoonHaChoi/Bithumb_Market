//
//  CurrentMarketPriceView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class CurrentMarketPriceView: UIView {
    
    private let currentPriceLabel = UILabel()
    private let changeRateLabel = UILabel()
    private let changePriceLabel = UILabel()
    private let orderBookButton = UIButton(type: .system)
    
    private let currentMarketPriceStackView = UIStackView()
    private let currnetPriceStackView = UIStackView()
    private let changeStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabelButttonUI()
        configureStackViewUI()
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabelButttonUI()
        configureStackViewUI()
        setConstraintLayout()
    }
    
}

extension CurrentMarketPriceView {
    
    private func configureLabelButttonUI() {
        currentPriceLabel.font = .preferredFont(forTextStyle: .title1)
        changePriceLabel.font = .preferredFont(forTextStyle: .headline)
        changeRateLabel.font = .preferredFont(forTextStyle: .headline)
        
        changePriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        changePriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func configureStackViewUI() {
        currentMarketPriceStackView.axis = .horizontal
        currnetPriceStackView.axis = .vertical
        changeStackView.axis = .horizontal
        
        currentMarketPriceStackView.distribution = .fill
        currnetPriceStackView.distribution = .fill
        changeStackView.distribution = .fill
        
        currentMarketPriceStackView.alignment = .fill
        currnetPriceStackView.alignment = .fill
        changeStackView.alignment = .fill
        
        currentMarketPriceStackView.spacing = 0
        currnetPriceStackView.spacing = 5
        changeStackView.spacing = 15
        
        currentMarketPriceStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraintLayout() {
        changeStackView.addArrangedSubview(changePriceLabel)
        changeStackView.addArrangedSubview(changeRateLabel)
        currnetPriceStackView.addArrangedSubview(currentPriceLabel)
        currnetPriceStackView.addArrangedSubview(changeStackView)
        currentMarketPriceStackView.addArrangedSubview(currnetPriceStackView)
        currentMarketPriceStackView.addArrangedSubview(orderBookButton)
        
        addSubview(currentMarketPriceStackView)
        
        NSLayoutConstraint.activate([
            currentMarketPriceStackView.topAnchor.constraint(equalTo: topAnchor),
            currentMarketPriceStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentMarketPriceStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            currentMarketPriceStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
