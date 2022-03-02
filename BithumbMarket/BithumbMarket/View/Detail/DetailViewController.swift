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
    
    let transactionPriceSelectTimeView: TransactionPriceSelectTimeView = {
        let view = TransactionPriceSelectTimeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let transactionHistoryView: TransactionHistoryView = {
        let view = TransactionHistoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(currentMarketPriceView)
        view.addSubview(transactionPriceSelectTimeView)
        view.addSubview(transactionHistoryView)
        
        NSLayoutConstraint.activate([
            currentMarketPriceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentMarketPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentMarketPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            transactionPriceSelectTimeView.topAnchor.constraint(equalTo: currentMarketPriceView.bottomAnchor, constant: 20),
            transactionPriceSelectTimeView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionPriceSelectTimeView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            transactionHistoryView.topAnchor.constraint(equalTo: transactionPriceSelectTimeView.bottomAnchor, constant: 20),
            transactionHistoryView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionHistoryView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor)
        ])  
    }
}
