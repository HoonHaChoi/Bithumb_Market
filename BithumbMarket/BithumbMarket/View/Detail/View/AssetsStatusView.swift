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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
