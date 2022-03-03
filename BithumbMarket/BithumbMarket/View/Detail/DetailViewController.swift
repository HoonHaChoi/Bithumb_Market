//
//  DetailViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

class DetailViewController: UIViewController {

    private var currentMarketPriceViewModel: CurrentMarketPriceViewModel
    
    init(currentMarketPriceViewModel: CurrentMarketPriceViewModel = CurrentMarketPriceViewModel(symbol: "BTC_KRW"), assetsStatusViewModel: AssetsStatusViewModel = AssetsStatusViewModel(symbol: "BTC_KRW")) {
        self.currentMarketPriceViewModel = currentMarketPriceViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.currentMarketPriceViewModel = CurrentMarketPriceViewModel(symbol: "BTC_KRW")
        super.init(coder: coder)
    }
    
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
    
    let assetsStatusView: AssetsStatusView = {
        let view = AssetsStatusView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(currentMarketPriceView)
        view.addSubview(transactionPriceSelectTimeView)
        view.addSubview(transactionHistoryView)
        view.addSubview(assetsStatusView)
        
        NSLayoutConstraint.activate([
            currentMarketPriceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentMarketPriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentMarketPriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            transactionPriceSelectTimeView.topAnchor.constraint(equalTo: currentMarketPriceView.bottomAnchor, constant: 20),
            transactionPriceSelectTimeView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionPriceSelectTimeView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            transactionHistoryView.topAnchor.constraint(equalTo: transactionPriceSelectTimeView.bottomAnchor, constant: 20),
            transactionHistoryView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionHistoryView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            assetsStatusView.topAnchor.constraint(equalTo: transactionHistoryView.bottomAnchor, constant: 20),
            assetsStatusView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            assetsStatusView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
        ])  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindPriceView()
        currentMarketPriceViewModel.fetchPrice()
        currentMarketPriceViewModel.updatePrice()
   }
    
    private func bindPriceView() {
        currentMarketPriceViewModel.price.subscribe { [weak self] observer in
            DispatchQueue.main.async {
                self?.currentMarketPriceView.updateUI(observer)
            }
        }
    }
    
}
