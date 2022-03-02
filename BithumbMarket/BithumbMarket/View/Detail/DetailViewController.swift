//
//  DetailViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

class DetailViewController: UIViewController {

    let currentMarketPriceView: CurrentMarketPriceView = {
        let view = CurrentMarketPriceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(currentMarketPriceView)
        NSLayoutConstraint.activate([
            currentMarketPriceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentMarketPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentMarketPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
