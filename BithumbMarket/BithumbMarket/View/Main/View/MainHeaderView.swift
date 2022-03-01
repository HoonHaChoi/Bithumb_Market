//
//  MainHeaderView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class MainHeaderView: UIView {
    
    private let symbolsTitleLabel = UILabel()
    private let currentPriceTitleLabel = UILabel()
    private let fluctuateTitleLabel = UILabel()
    private let accTradeValueTitleLabel = UILabel()
    
    private let titleStackView = UIStackView()
    private let separatorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabels()
        configureStackView()
        configureSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabels()
        configureStackView()
        configureSeparatorView()
    }
    
    func configureLabels() {
        [symbolsTitleLabel, currentPriceTitleLabel, fluctuateTitleLabel, accTradeValueTitleLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .preferredFont(forTextStyle: .caption1)
            label.textColor = .typoColor
        }
                
        symbolsTitleLabel.text = "가산자산명"
        currentPriceTitleLabel.text = "현재가"
        fluctuateTitleLabel.text = "변동률"
        accTradeValueTitleLabel.text = "거래금액"
    }
    
    func configureStackView() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .horizontal
        titleStackView.distribution = .equalCentering
        titleStackView.alignment = .fill
        titleStackView.spacing = 0
        
        [symbolsTitleLabel, currentPriceTitleLabel, fluctuateTitleLabel, accTradeValueTitleLabel].forEach { label in
            titleStackView.addArrangedSubview(label)
        }
        
        addSubview(titleStackView)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .textSecondary
        
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
}
