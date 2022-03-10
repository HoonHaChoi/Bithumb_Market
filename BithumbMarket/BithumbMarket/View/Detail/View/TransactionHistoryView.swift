//
//  TransactionHistoryView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class TransactionHistoryView: UIView {
    
    private let transactionHistoryNameLabel = UILabel()
    private let transactionHistoryButton = UIButton(type: .system)
    private lazy var transactionHistoryStackView = UIStackView(arrangedSubviews: [transactionHistoryNameLabel, transactionHistoryButton])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabelButttonUI()
        configureStackViewUI()
        setConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabelButttonUI()
        configureStackViewUI()
        setConstraintLayout()
    }
    
    var transactionHistoryButtonHandler: (() -> Void)?
    
    @objc
    private func showTransactionView() {
        transactionHistoryButtonHandler?()
    }
    
}

extension TransactionHistoryView {
    
    private func configureLabelButttonUI() {
        transactionHistoryNameLabel.textColor = .typoColor
        transactionHistoryNameLabel.font = .preferredFont(forTextStyle: .headline)
        transactionHistoryNameLabel.text = "채결 내역 보기"
        
        transactionHistoryButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        transactionHistoryButton.tintColor = .textTertiary
        transactionHistoryButton.addTarget(self, action: #selector(showTransactionView), for: .touchUpInside)
    }
    
    private func configureStackViewUI() {
        transactionHistoryStackView.translatesAutoresizingMaskIntoConstraints = false
        transactionHistoryStackView.axis = .horizontal
        transactionHistoryStackView.distribution = .fill
        transactionHistoryStackView.alignment = .fill
    }
    
    private func setConstraintLayout() {
        addSubview(transactionHistoryStackView)
        
        NSLayoutConstraint.activate([
            transactionHistoryStackView.topAnchor.constraint(equalTo: topAnchor),
            transactionHistoryStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transactionHistoryStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transactionHistoryStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            transactionHistoryButton.widthAnchor.constraint(equalToConstant: 35)
        ])
    }
    
}
