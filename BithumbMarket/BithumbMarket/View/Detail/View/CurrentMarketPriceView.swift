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
    
    var orderbookButtonHandler: (() -> Void)?
    
    @objc
    func showOrderbook() {
        orderbookButtonHandler?()
    }

    func initialUI(_ ticker: Ticker) {
        currentPriceLabel.text = ticker.market.closingPrice.withComma() + "원"
        changePriceLabel.text = ticker.market.fluctate24H.withComma() + "원"
        changeRateLabel.text = "(\(ticker.market.fluctateRate24H.withComma())%)"
        changeRateLabel.textColor = ticker.market.computePriceChangeState().textColor
        changePriceLabel.textColor = ticker.market.computePriceChangeState().textColor
    }
    
    func updateUI(_ currentPrice: CurrentMarketPrice) {
        currentPriceLabel.text = currentPrice.currentPrice.withComma() + "원"
        changePriceLabel.text = currentPrice.changePrice.withComma() + "원"
        changeRateLabel.text =  "(\(currentPrice.changeRate.withComma())%)"
        changePriceLabel.textColor = currentPrice.setChange.textColor
        changeRateLabel.textColor = currentPrice.setChange.textColor
    }
    
}

extension CurrentMarketPriceView {
    
    private func configureLabelButttonUI() {
        let boldMonoFont: UIFont = .monospacedDigitSystemFont(ofSize: 28, weight: .bold)
        currentPriceLabel.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: boldMonoFont)
        let regularMonoFont: UIFont = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        changePriceLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: regularMonoFont)
        changeRateLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: regularMonoFont)
        
        changePriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        changePriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        orderBookButton.translatesAutoresizingMaskIntoConstraints = false
        orderBookButton.setTitle("호가", for: .normal)
        orderBookButton.setTitleColor(.typoColor, for: .normal)
        orderBookButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        orderBookButton.backgroundColor = .actionBackgroundTertiary
        orderBookButton.layer.cornerRadius = 10
        orderBookButton.addTarget(self, action: #selector(showOrderbook), for: .touchUpInside)
        
        currentPriceLabel.textColor = .typoColor
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
        changeStackView.spacing = 5
        
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
