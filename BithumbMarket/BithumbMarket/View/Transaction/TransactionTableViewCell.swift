//
//  TransactionTableViewCell.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/24.
//

import Foundation
import UIKit

final class TransactionTableViewCell: UITableViewCell {
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var quntityLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private func check(type: String) {
        if type == TransactionNameSpace.ask[0] || type == TransactionNameSpace.ask[1] {
            [priceLabel, quntityLabel].forEach{$0.textColor = .fallColor}
        } else {
            [priceLabel, quntityLabel].forEach{$0.textColor = .riseColor}
        }
    }
    
    func configure(transaction: TransactionData) {
        timeLabel.text = transaction.transactionDate[11..<19]
        priceLabel.text = transaction.price.withComma()
        quntityLabel.text = transaction.unitsTraded.withDecimal(maximumDigit: 4)
        
        check(type: transaction.type)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
}

extension TransactionTableViewCell {
    
    func setupView() {
        
        [
            timeLabel,
            priceLabel,
            quntityLabel

        ].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: quntityLabel.leadingAnchor, constant: -10),
            
            quntityLabel.topAnchor.constraint(equalTo: self.topAnchor),
            quntityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            quntityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            quntityLabel.widthAnchor.constraint(equalToConstant: 100),
        ])

    }
    
}
