//
//  TableEmptyView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/07.
//

import UIKit

final class TableEmptyView: UIView {
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = MainViewNameSpace.emptyMessage
        label.textColor = .actionTextSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)
        ])
    }
}
