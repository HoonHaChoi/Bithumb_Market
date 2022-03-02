//
//  AssetsStatusView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class AssetsStatusView: UIView {
    
    private let assetsStatusNameLabel = UILabel()
    private let assetsStatusLabel = UILabel()
    private lazy var assetsStatusStackView = UIStackView(arrangedSubviews: [assetsStatusNameLabel, assetsStatusLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabelUI()
        configureStackViewUI()
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabelUI()
        configureStackViewUI()
        setConstraintLayout()
    }
    
}

extension AssetsStatusView {
    
    private func configureLabelUI() {
        assetsStatusNameLabel.font = .preferredFont(forTextStyle: .headline)
        assetsStatusLabel.font = .preferredFont(forTextStyle: .headline)
        assetsStatusNameLabel.textColor = .typoColor
        assetsStatusLabel.textColor = .typoColor
        assetsStatusNameLabel.text = "입출금 현황"
        assetsStatusLabel.text = "입출금 가능"
    }
    
    private func configureStackViewUI() {
        assetsStatusStackView.translatesAutoresizingMaskIntoConstraints = false
        assetsStatusStackView.axis = .horizontal
        assetsStatusStackView.distribution = .equalSpacing
        assetsStatusStackView.alignment = .fill
    }
    
    private func setConstraintLayout() {
        addSubview(assetsStatusStackView)
        
        NSLayoutConstraint.activate([
            assetsStatusStackView.topAnchor.constraint(equalTo: topAnchor),
            assetsStatusStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            assetsStatusStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            assetsStatusStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
