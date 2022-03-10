//
//  OrderbookTableViewCell.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

final class OrderbookTableViewCell: UITableViewCell {
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: monoFont)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let askQuantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .right
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 12, weight: .heavy)
        label.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: monoFont)
        label.textColor = .fallColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bidQuantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 12, weight: .heavy)
        label.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: monoFont)
        label.textColor = .riseColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let askQuantityBarView: UIProgressView = {
        let progreesBar = UIProgressView()
        progreesBar.semanticContentAttribute = .forceRightToLeft
        progreesBar.progressTintColor = .orderBookSellBackground
        progreesBar.trackTintColor = .clear
        progreesBar.translatesAutoresizingMaskIntoConstraints = false
        return progreesBar
    }()
    
    private let bidQuantityBarView: UIProgressView = {
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
            priceLabel.text = items.asks[index].price.withComma()
            priceLabel.backgroundColor = .orderBookSellBackground
            askQuantityLabel.text = items.asks[index].quantity.withDecimal(maximumDigit: 4)
            UIView.animate(withDuration: 0.3) {
                self.askQuantityBarView.setProgress(items.calculateRateOfAsks()[index], animated: true)
            }
        case 1:
            priceLabel.text = items.bids[index].price.withComma()
            priceLabel.backgroundColor = .orderBookBuyBackground
            bidQuantityLabel.text = items.bids[index].quantity.withDecimal(maximumDigit: 4)
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

        priceLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3),
        priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
        priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),

        askQuantityBarView.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
        askQuantityBarView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
        askQuantityBarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
        askQuantityBarView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -4),

        bidQuantityBarView.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
        bidQuantityBarView.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
        bidQuantityBarView.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
        bidQuantityBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        
        askQuantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        askQuantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        askQuantityLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10),
        
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
