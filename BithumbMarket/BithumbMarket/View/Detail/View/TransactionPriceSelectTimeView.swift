//
//  TransactionPriceSelectTimeView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class TransactionPriceSelectTimeView: UIView {
    
    private let chartIntervals: [ChartIntervals]
    private var intervalButtons: [UIButton]
    private let graphChangeButton = UIButton(type: .custom)
    
    private lazy var selectStackView = UIStackView(arrangedSubviews: intervalButtons)
    
    override init(frame: CGRect) {
        chartIntervals = ChartIntervals.allCases
        intervalButtons = []
        super.init(frame: frame)
        configureStackViewUI()
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        chartIntervals = ChartIntervals.allCases
        intervalButtons = []
        super.init(coder: coder)
        configureStackViewUI()
        setConstraintLayout()
    }
    
    var changeIntervalHandler: ((_ interval: ChartIntervals) -> Void)?
    var changeGraphTypeHandler: ((Bool) -> Void)?
    
    enum GraphType {
        static let line = "line"
        static let candlestick = "candlestick"
    }
    
    @objc private func changeInterval(_ sender: UIButton) {
        guard sender.isSelected != true else {
            return
        }
        sender.isSelected = true
        intervalButtons.forEach {
            if $0 != sender, $0.isSelected == true {
                $0.isSelected = false
            }
        }
        guard let index = intervalButtons.firstIndex(of: sender) else {
            return
        }
        changeIntervalHandler?(chartIntervals[index])
    }
    
    @objc private func graphChangeButtonAction(_ sender: UIButton) {
        UserDefaults.standard.changeisLine()
        let isLine = UserDefaults.standard.isLine()
        changeGraphTypeHandler?(isLine)
        let imageName = isLine ? GraphType.candlestick : GraphType.line
        DispatchQueue.main.async { [weak self] in
            self?.graphChangeButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
}

extension TransactionPriceSelectTimeView {
    
    private func configureStackViewUI() {
        chartIntervals.forEach { interval in
            let button = UIButton(type: .custom)
            button.setTitle(interval.name, for: .normal)
            button.setTitleColor(.textPrimary, for: .selected)
            button.setTitleColor(.actionTextSecondary, for: .highlighted)
            button.setTitleColor(.textSecondary, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
            button.addTarget(self, action: #selector(changeInterval), for: .touchUpInside)
            intervalButtons.append(button)
        }
        intervalButtons.last?.isSelected = true
        
        let imageName = UserDefaults.standard.isLine() ? GraphType.candlestick : GraphType.line
        graphChangeButton.translatesAutoresizingMaskIntoConstraints = false
        graphChangeButton.setImage(UIImage(named: imageName), for: .normal)
        graphChangeButton.addTarget(self, action: #selector(graphChangeButtonAction(_:)), for: .touchUpInside)
        
        selectStackView.translatesAutoresizingMaskIntoConstraints = false
        selectStackView.alignment = .fill
        selectStackView.distribution = .equalSpacing
    }
    
    private func setConstraintLayout() {
        addSubview(selectStackView)
        addSubview(graphChangeButton)
        
        NSLayoutConstraint.activate([
            selectStackView.topAnchor.constraint(equalTo: topAnchor),
            selectStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectStackView.trailingAnchor.constraint(equalTo: graphChangeButton.leadingAnchor, constant: -20),
            selectStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            graphChangeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            graphChangeButton.topAnchor.constraint(equalTo: topAnchor),
            graphChangeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
}
