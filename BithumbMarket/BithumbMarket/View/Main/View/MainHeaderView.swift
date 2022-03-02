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
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabels()
        configureStackView()
        configureSeparatorView()
        setConstraintLayout()
    }
    
    private func configureLabels() {
        [symbolsTitleLabel, currentPriceTitleLabel, fluctuateTitleLabel, accTradeValueTitleLabel].forEach { label in
            label.font = .preferredFont(forTextStyle: .caption1)
            label.textColor = .typoColor.withAlphaComponent(0.7)
        }
                
        symbolsTitleLabel.text = "가산자산명"
        currentPriceTitleLabel.text = "현재가"
        fluctuateTitleLabel.text = "변동률"
        accTradeValueTitleLabel.text = "거래금액"
        
        accTradeValueTitleLabel.textAlignment = .right
        fluctuateTitleLabel.textAlignment = .right
    }
    
    private func configureStackView() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .horizontal
        titleStackView.distribution = .equalCentering
        titleStackView.alignment = .fill
        titleStackView.spacing = 0
        
        [symbolsTitleLabel, currentPriceTitleLabel, fluctuateTitleLabel, accTradeValueTitleLabel].forEach { label in
            titleStackView.addArrangedSubview(label)
        }
    }
    
    private func configureSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray.withAlphaComponent(0.5)
    }
    
    private func setConstraintLayout() {
        
        addSubview(titleStackView)
        addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            accTradeValueTitleLabel.widthAnchor.constraint(equalToConstant: 90),
            accTradeValueTitleLabel.leadingAnchor.constraint(equalTo: fluctuateTitleLabel.trailingAnchor, constant:  20),
            
            fluctuateTitleLabel.widthAnchor.constraint(equalToConstant: 75),
            fluctuateTitleLabel.leadingAnchor.constraint(equalTo: currentPriceTitleLabel.trailingAnchor, constant: 10)
        ])
    }
    
}
