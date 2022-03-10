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
        view.distribution = .fillEqually
        return view
    }()
    
    private func drawTitle() {
        let titleText = TransactionNameSpace.tableTitle
        
        for text in titleText {
            let view = UILabel()
            view.textColor = .textPrimary
            view.textAlignment = .center
            view.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .current)
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
        
        [stackView].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
