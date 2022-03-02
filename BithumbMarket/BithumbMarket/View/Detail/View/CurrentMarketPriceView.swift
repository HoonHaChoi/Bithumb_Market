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
        
        currentPriceLabel.text = "512334213".withComma()
        changePriceLabel.text = "531231234".withComma()
        changeRateLabel.text = "-10.12%"
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
        currentPriceLabel.font = .boldSystemFont(ofSize: 20)
        changePriceLabel.font = .preferredFont(forTextStyle: .callout)
        changeRateLabel.font = .preferredFont(forTextStyle: .callout)
        
        changePriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        changePriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        orderBookButton.translatesAutoresizingMaskIntoConstraints = false
        orderBookButton.setTitle("호가", for: .normal)
        orderBookButton.setTitleColor(.textSecondary, for: .normal)
        orderBookButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        orderBookButton.backgroundColor = .actionBackgroundPrimary
        orderBookButton.layer.cornerRadius = 10
        
        currentPriceLabel.textColor = .riseColor
        changePriceLabel.textColor = .riseColor
        changeRateLabel.textColor = .riseColor
    }
    
    private func configureStackViewUI() {
        currentMarketPriceStackView.axis = .horizontal
        currnetPriceStackView.axis = .vertical
        changeStackView.axis = .horizontal
        
        currentMarketPriceStackView.distribution = .fill
        currnetPriceStackView.distribution = .equalSpacing
        changeStackView.distribution = .fill
        
        currentMarketPriceStackView.alignment = .fill
        currnetPriceStackView.alignment = .fill
        changeStackView.alignment = .fill
        
        currentMarketPriceStackView.spacing = 0
        currnetPriceStackView.spacing = 5
        changeStackView.spacing = 10
        
        currentMarketPriceStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraintLayout() {
        changeStackView.addArrangedSubview(changePriceLabel)
        changeStackView.addArrangedSubview(changeRateLabel)
        currnetPriceStackView.addArrangedSubview(currentPriceLabel)
        currnetPriceStackView.addArrangedSubview(changeStackView)
        currentMarketPriceStackView.addArrangedSubview(currnetPriceStackView)
        
        addSubview(currentMarketPriceStackView)
        addSubview(orderBookButton)
        
        NSLayoutConstraint.activate([
            currentMarketPriceStackView.topAnchor.constraint(equalTo: topAnchor),
            currentMarketPriceStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentMarketPriceStackView.trailingAnchor.constraint(equalTo: orderBookButton.leadingAnchor),
            currentMarketPriceStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            orderBookButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            orderBookButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            orderBookButton.widthAnchor.constraint(equalToConstant: 60),
            orderBookButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
}
