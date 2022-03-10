//
//  OrderbookQuantitiesView.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/10.
//

import UIKit

final class OrderbookQuantitiesView: UIView {

    private let asksQuantitiesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 15, weight: .black)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: monoFont)
        label.textColor = .fallColor
        return label
    }()
    
    private let bidsQuantitiesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        let monoFont: UIFont = .monospacedDigitSystemFont(ofSize: 15, weight: .black)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: monoFont)
        label.textColor = .riseColor
        return label
    }()
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        configureStackViewUI()
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureStackViewUI()
        setConstraintLayout()
    }
    
    func updateUI(sumOfAsks: Float, sumOfBids: Float) {
        asksQuantitiesLabel.text = String(sumOfAsks).withDecimal(maximumDigit: 4)
        bidsQuantitiesLabel.text = String(sumOfBids).withDecimal(maximumDigit: 4)
    }

}

extension OrderbookQuantitiesView {
    
    private func configureStackViewUI() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraintLayout() {
        stackView.addArrangedSubview(asksQuantitiesLabel)
        stackView.addArrangedSubview(bidsQuantitiesLabel)
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}