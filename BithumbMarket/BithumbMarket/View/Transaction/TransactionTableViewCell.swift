//
//  TransactionTableViewCell.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/24.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 17, weight: .medium)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: monoFont)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 17, weight: .medium)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: monoFont)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var quntityLabel: UILabel = {
        let label = UILabel()
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 17, weight: .medium)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: monoFont)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func check(type: String) {
        if type == TransactionNameSpace.ask[0] || type == TransactionNameSpace.ask[1] {
            [priceLabel, quntityLabel].forEach{$0.textColor = .fallColor}
        } else {
            [priceLabel, quntityLabel].forEach{$0.textColor = .riseColor}
        }
    }
    
    func configure(transaction: TransactionData) {
        timeLabel.text = transaction.transactionDate[11..<19]
        priceLabel.text = transaction.price.withComma(max: 4)
        quntityLabel.text = transaction.unitsTraded.withComma(min: 4, max: 4)
        check(type: transaction.type)
    }
    
}

extension TransactionTableViewCell {
    
    func setupView() {
        [timeLabel, priceLabel, quntityLabel].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            priceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3),
            
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: quntityLabel.leadingAnchor),
            
            quntityLabel.topAnchor.constraint(equalTo: self.topAnchor),
            quntityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            quntityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
}
