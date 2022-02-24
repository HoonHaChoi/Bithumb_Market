//
//  TickerCell.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/24.
//

import UIKit

final class TickerCell: UITableViewCell {
    
    let symbolLabel = UILabel()
    let paymentLabel = UILabel()
    let currentPriceLabel = UILabel()
    let changeRateLabel = UILabel()
    let changePriceLabel = UILabel()
    let favoriteButton = UIButton()
    
    let symbolStackView = UIStackView()
    let currentStackView = UIStackView()
    let changeStackView = UIStackView()
    let bundleStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension TickerCell {
    
    func configureLabel() {
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        changeRateLabel.translatesAutoresizingMaskIntoConstraints = false
        changePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        symbolLabel.font = .preferredFont(forTextStyle: .title3)
        paymentLabel.font = .preferredFont(forTextStyle: .footnote)
        currentPriceLabel.font = .preferredFont(forTextStyle: .body)
        changeRateLabel.font = .preferredFont(forTextStyle: .body)
        changePriceLabel.font = .preferredFont(forTextStyle: .body)
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        paymentLabel.text = "KRW"
        paymentLabel.textColor = .darkGray
    }
    
    func configureStackView() {
        symbolStackView.translatesAutoresizingMaskIntoConstraints = false
        currentStackView.translatesAutoresizingMaskIntoConstraints = false
        changeStackView.translatesAutoresizingMaskIntoConstraints = false
        bundleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        symbolStackView.axis = .vertical
        currentStackView.axis = .horizontal
        changeStackView.axis = .vertical
        bundleStackView.axis = .horizontal
        
        symbolStackView.distribution = .fill
        currentStackView.distribution = .fill
        changeStackView.distribution = .fill
        bundleStackView.distribution = .fill
        
        symbolStackView.alignment = .fill
        currentStackView.alignment = .top
        changeStackView.alignment = .fill
        bundleStackView.alignment = .fill
    }
    
    func setConstraintLayout() {
        symbolStackView.addArrangedSubview(symbolLabel)
        symbolStackView.addArrangedSubview(paymentLabel)
        currentStackView.addArrangedSubview(currentPriceLabel)
        changeStackView.addArrangedSubview(changeRateLabel)
        changeStackView.addArrangedSubview(changePriceLabel)
        
        bundleStackView.addArrangedSubview(symbolStackView)
        bundleStackView.addArrangedSubview(currentStackView)
        bundleStackView.addArrangedSubview(changeStackView)
        
        NSLayoutConstraint.activate([
            bundleStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bundleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bundleStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -20),
            
            favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        addSubview(bundleStackView)
    }
    
}



