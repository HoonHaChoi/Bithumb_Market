//
//  TickerCell.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/24.
//

import UIKit

final class TickerCell: UITableViewCell {
    
    static var reuseidentifier: String {
        return String(describing: self)
    }
    
    let symbolLabel = UILabel()
    let paymentLabel = UILabel()
    let currentPriceLabel = UILabel()
    let changeRateLabel = UILabel()
    let changePriceLabel = UILabel()
    let favoriteButton = UIButton(type: .system)
    
    let symbolStackView = UIStackView()
    let currentStackView = UIStackView()
    let changeStackView = UIStackView()
    let bundleStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabel()
        configureStackView()
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
        configureStackView()
        setConstraintLayout()
    }
    
    func configure(ticker: Ticker) {
        symbolLabel.text = ticker.symbol
        currentPriceLabel.text = ticker.market.closingPrice
        changeRateLabel.text = ticker.market.changeOfRate()
        changePriceLabel.text = ticker.market.changeOfPrice()
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
        
        symbolLabel.font = .preferredFont(forTextStyle: .body)
        paymentLabel.font = .preferredFont(forTextStyle: .footnote)
        currentPriceLabel.font = .preferredFont(forTextStyle: .body)
        changeRateLabel.font = .preferredFont(forTextStyle: .body)
        changePriceLabel.font = .preferredFont(forTextStyle: .footnote)
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        paymentLabel.text = "KRW"
        paymentLabel.textColor = .darkGray
        
        currentPriceLabel.textAlignment = .right
        changeRateLabel.textAlignment = .right
        changePriceLabel.textAlignment = .right
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
        
        symbolStackView.distribution = .equalSpacing
        currentStackView.distribution = .fill
        changeStackView.distribution = .equalSpacing
        bundleStackView.distribution = .fill
        
        symbolStackView.alignment = .fill
        currentStackView.alignment = .top
        changeStackView.alignment = .fill
        bundleStackView.alignment = .fill
        
        bundleStackView.spacing = 20
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
        
        addSubview(bundleStackView)
        addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            bundleStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bundleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bundleStackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -20),
            
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            
            changeStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }
    
}



