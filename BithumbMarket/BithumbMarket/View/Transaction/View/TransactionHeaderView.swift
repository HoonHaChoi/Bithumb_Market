//
//  TransactionHeaderView.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/02.
//

import UIKit

final class TransactionHeaderView: UIView {
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    private func drawTitle() {
        let titleText = TransactionNameSpace.tableTitle
        
        for text in titleText {
            let view = UILabel()
            view.textColor = .textPrimary
            view.font = .preferredFont(forTextStyle: .body, compatibleWith: .current)
            view.text = text
            stackView.addArrangedSubview(view)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawTitle()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawTitle()
        setupView()
    }
    
}

extension TransactionHeaderView {
    
    private func setupView() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}