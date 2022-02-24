//
//  CoinSortControlView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/25.
//

import UIKit

final class CoinSortControlView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private let coinsortSegmentControl: CoinSortSegmentControl = {
        let segmentControl = CoinSortSegmentControl(items: ["목록", "관심"])
        segmentControl.addTarget(self, action: #selector(changeSegmentedControlLinePosition), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentControl
    }()
    
    private lazy var underLineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leadingDistance: NSLayoutConstraint = {
        return underLineView.leadingAnchor.constraint(equalTo: coinsortSegmentControl.leadingAnchor)
    }()
    
    private func configure() {
        addSubview(coinsortSegmentControl)
        addSubview(underLineView)
        
        NSLayoutConstraint.activate([
            coinsortSegmentControl.topAnchor.constraint(equalTo: topAnchor),
            coinsortSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            coinsortSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            coinsortSegmentControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            underLineView.bottomAnchor.constraint(equalTo: coinsortSegmentControl.bottomAnchor),
            leadingDistance,
            underLineView.heightAnchor.constraint(equalToConstant: 5),
            underLineView.widthAnchor.constraint(equalTo: coinsortSegmentControl.widthAnchor,
                                                 multiplier: 1 / CGFloat(coinsortSegmentControl.numberOfSegments))
        ])
    }
    
    @objc private func changeSegmentedControlLinePosition() {
        changeSegmentControlLine()
    }
    
    func updateSelectIndex(to index: Int) {
        coinsortSegmentControl.selectedSegmentIndex = index
        changeSegmentControlLine()
    }
    
    private func changeSegmentControlLine(){
        let segmentIndex = CGFloat(coinsortSegmentControl.selectedSegmentIndex)
        let segmentWidth = coinsortSegmentControl.frame.width / CGFloat(coinsortSegmentControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.leadingDistance.constant = leadingDistance
            self?.layoutIfNeeded()
        })
    }
    
}
