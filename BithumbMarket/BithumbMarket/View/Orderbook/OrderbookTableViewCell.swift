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
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let askQuantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bidQuantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemRed
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let askQuantityBarView: UIProgressView = {
        let progreesBar = UIProgressView()
        progreesBar.semanticContentAttribute = .forceRightToLeft
        progreesBar.progressTintColor = .systemBlue.withAlphaComponent(0.2)
        progreesBar.trackTintColor = .clear
        progreesBar.translatesAutoresizingMaskIntoConstraints = false
        return progreesBar
    }()
    
    let bidQuantityBarView: UIProgressView = {
        let progreesBar = UIProgressView()
        progreesBar.progressTintColor = .systemRed.withAlphaComponent(0.2)
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
    
    func configure(items: Orderbook, section: Int, index: Int) {
        switch section {
        case 0:
            priceLabel.text = items.asks[index].price
            askQuantityLabel.text = items.asks[index].quantity
            askQuantityBarView.setProgress(items.asks[index].rateOfQuantity, animated: true)
        case 1:
            priceLabel.text = items.bids[index].price
            bidQuantityLabel.text = items.bids[index].quantity
            bidQuantityBarView.setProgress(items.bids[index].rateOfQuantity, animated: true)
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
