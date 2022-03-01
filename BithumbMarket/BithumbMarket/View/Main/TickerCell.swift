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
    let accTradeValueLabel = UILabel()
    
    let symbolStackView = UIStackView()
    let currentStackView = UIStackView()
    let changeStackView = UIStackView()
    let accTradeValueStackView = UIStackView()
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
        currentPriceLabel.text = ticker.market.closingPrice.withComma()
        changeRateLabel.text = ticker.market.fluctateRate24H.withDecimal(maximumDigit: 2) + "%"
        changePriceLabel.text = ticker.market.fluctate24H.withComma()
        accTradeValueLabel.text = ticker.market.accTradeValue24H.convertDouble().formatPrice
        updateLabelColor(to: ticker)
    }
    
    func updateAnimation(state: ChangeState) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.backgroundColor = state.backgroundColor.withAlphaComponent(0.2)
            self?.createCurrentUnderLineLayer(color: state.backgroundColor)
        } completion: { _ in
            self.currentPriceLabel.layer.sublayers?.removeLast()
            self.backgroundColor = .systemBackground
        }
    }
    
    private func updateLabelColor(to ticker: Ticker) {
        let color = ticker.market.computePriceChangeState().textColor
        currentPriceLabel.textColor = color
        changeRateLabel.textColor = color
        changePriceLabel.textColor = color
    }

    private func createCurrentUnderLineLayer(color: UIColor) {
        let underLineLayer = CAShapeLayer()
        currentPriceLabel.layer.addSublayer(underLineLayer)
        
        let path = UIBezierPath()
        path.move(to: .init(x: currentStackView.frame.width,
                            y: currentPriceLabel.frame.height + 3))
        path.addLine(to: .init(x: currentStackView.frame.width - currentPriceLabel.frame.width,
                               y: currentPriceLabel.frame.height + 3))
        underLineLayer.strokeColor = color.cgColor
        underLineLayer.fillColor = color.cgColor
        underLineLayer.lineWidth = 4
        underLineLayer.path = path.cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .systemBackground
        self.currentPriceLabel.text = ""
    }
    
}

extension TickerCell {
    
    func configureLabel() {
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        changeRateLabel.translatesAutoresizingMaskIntoConstraints = false
        changePriceLabel.translatesAutoresizingMaskIntoConstraints = false
        accTradeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        symbolLabel.font = .preferredFont(forTextStyle: .callout)
        paymentLabel.font = .preferredFont(forTextStyle: .footnote)
        currentPriceLabel.font = .preferredFont(forTextStyle: .callout)
        changeRateLabel.font = .preferredFont(forTextStyle: .callout)
        changePriceLabel.font = .preferredFont(forTextStyle: .footnote)
        accTradeValueLabel.font = .preferredFont(forTextStyle: .callout)

        paymentLabel.text = "KRW"
        paymentLabel.textColor = .textSecondary
        accTradeValueLabel.textColor = .typoColor
        
        currentPriceLabel.textAlignment = .right
        changeRateLabel.textAlignment = .right
        changePriceLabel.textAlignment = .right
        accTradeValueLabel.textAlignment = .right
    }
    
    func configureStackView() {
        symbolStackView.translatesAutoresizingMaskIntoConstraints = false
        currentStackView.translatesAutoresizingMaskIntoConstraints = false
        changeStackView.translatesAutoresizingMaskIntoConstraints = false
        accTradeValueStackView.translatesAutoresizingMaskIntoConstraints = false
        bundleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        symbolStackView.axis = .vertical
        currentStackView.axis = .horizontal
        changeStackView.axis = .vertical
        accTradeValueStackView.axis = .horizontal
        bundleStackView.axis = .horizontal
        
        symbolStackView.distribution = .equalSpacing
        currentStackView.distribution = .equalSpacing
        changeStackView.distribution = .equalSpacing
        accTradeValueStackView.distribution = .equalCentering
        bundleStackView.distribution = .equalCentering
        
        symbolStackView.alignment = .fill
        currentStackView.alignment = .top
        changeStackView.alignment = .fill
        bundleStackView.alignment = .fill
        accTradeValueStackView.alignment = .top
        
        bundleStackView.spacing = 0
    }
    
    func setConstraintLayout() {
        symbolStackView.addArrangedSubview(symbolLabel)
        symbolStackView.addArrangedSubview(paymentLabel)
        currentStackView.addArrangedSubview(currentPriceLabel)
        changeStackView.addArrangedSubview(changeRateLabel)
        changeStackView.addArrangedSubview(changePriceLabel)
        accTradeValueStackView.addArrangedSubview(accTradeValueLabel)
        
        bundleStackView.addArrangedSubview(symbolStackView)
        bundleStackView.addArrangedSubview(currentStackView)
        bundleStackView.addArrangedSubview(changeStackView)
        bundleStackView.addArrangedSubview(accTradeValueStackView)
        
        addSubview(bundleStackView)
        
        NSLayoutConstraint.activate([
            bundleStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bundleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bundleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            currentStackView.trailingAnchor.constraint(equalTo: changeStackView.leadingAnchor, constant: -10),
            
            changeStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 75),
            changeStackView.trailingAnchor.constraint(equalTo: accTradeValueStackView.leadingAnchor, constant: -10),
            accTradeValueStackView.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
}



