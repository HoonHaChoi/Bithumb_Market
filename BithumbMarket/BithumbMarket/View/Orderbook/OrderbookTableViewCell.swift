//
//  OrderbookTableViewCell.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

final class OrderbookTableViewCell: UITableViewCell {
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: monoFont)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let askQuantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .right
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        label.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: monoFont)
        label.textColor = .fallColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bidQuantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        label.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: monoFont)
        label.textColor = .riseColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let askQuantityBarView: UIProgressView = {
        let progreesBar = UIProgressView()
        progreesBar.semanticContentAttribute = .forceRightToLeft
        progreesBar.progressTintColor = .orderBookSellBackground
        progreesBar.trackTintColor = .clear
        progreesBar.translatesAutoresizingMaskIntoConstraints = false
        return progreesBar
    }()
    
    let bidQuantityBarView: UIProgressView = {
        let progreesBar = UIProgressView()
        progreesBar.progressTintColor = .orderBookBuyBackground
        progreesBar.trackTintColor = .clear
        progreesBar.translatesAutoresizingMaskIntoConstraints = false
        return progreesBar
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    func configure(items: OrderbookData, section: Int, index: Int) {
        switch section {
        case 0:
            priceLabel.text = items.asks[index].price.withComma().withDecimal(maximumDigit: 4)
            askQuantityLabel.text = items.asks[index].quantity.withComma().withDecimal(maximumDigit: 4)
            UIView.animate(withDuration: 0.3) {
                self.askQuantityBarView.setProgress(items.calculateRateOfAsks()[index], animated: true)
            }
        case 1:
            priceLabel.text = items.bids[index].price.withComma().withDecimal(maximumDigit: 4)
            bidQuantityLabel.text = items.bids[index].quantity.withComma().withDecimal(maximumDigit: 4)
            UIView.animate(withDuration: 0.3) {
                self.bidQuantityBarView.setProgress(items.calculateRateOfBids()[index], animated: true)
            }
        default:
            break
        }
    }
    
    private func configureUI() {
        contentView.addSubview(priceLabel)
        contentView.addSubview(askQuantityBarView)
        contentView.addSubview(bidQuantityBarView)
        contentView.addSubview(askQuantityLabel)
        contentView.addSubview(bidQuantityLabel)
        NSLayoutConstraint.activate(cellConstraint)
    }
    
    private lazy var cellConstraint = [
        ///Tag - Price Constraint
        priceLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3),
        priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
        priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ///Tag - 매도량 그래프 Constraint
        askQuantityBarView.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
        askQuantityBarView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
        askQuantityBarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        askQuantityBarView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
        ///Tag - 매수량 그래프 Constraint
        bidQuantityBarView.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
        bidQuantityBarView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
        bidQuantityBarView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
        bidQuantityBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ///Tag - 매도 수량 Constraint
        askQuantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        askQuantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        askQuantityLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10),
        ///Tag - 매수 수량 Constraint
        bidQuantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        bidQuantityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        bidQuantityLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10)
    ]
    
    override func prepareForReuse(){
        super.prepareForReuse()
        askQuantityLabel.text = nil
        bidQuantityLabel.text = nil
        askQuantityBarView.progress = .zero
        bidQuantityBarView.progress = .zero
    }
}
