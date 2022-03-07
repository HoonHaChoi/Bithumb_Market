//
//  DetailViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

class DetailViewController: UIViewController {

    private var currentMarketPriceViewModel: CurrentMarketPriceViewModel
    private var assetsStatusViewModel: AssetsStatusViewModel
    
    init(currentMarketPriceViewModel: CurrentMarketPriceViewModel = CurrentMarketPriceViewModel(symbol: "BTC_KRW"), assetsStatusViewModel: AssetsStatusViewModel = AssetsStatusViewModel(symbol: "BTC_KRW")) {
        self.currentMarketPriceViewModel = currentMarketPriceViewModel
        self.assetsStatusViewModel = assetsStatusViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.currentMarketPriceViewModel = CurrentMarketPriceViewModel(symbol: "BTC_KRW")
        self.assetsStatusViewModel = AssetsStatusViewModel(symbol: "BTC_KRW")
        super.init(coder: coder)
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
 
    private let scrollContentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    let transactionPricegraphView: TransactionPriceGraphView = {
        let view = TransactionPriceGraphView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.backgroundColor = .systemBackground
        configureScrollView()
        scrollContentView.addSubview(currentMarketPriceView)
        scrollContentView.addSubview(transactionPriceSelectTimeView)
        scrollContentView.addSubview(transactionPricegraphView)
        scrollContentView.addSubview(transactionHistoryView)
        scrollContentView.addSubview(assetsStatusView)
        
        NSLayoutConstraint.activate([
            currentMarketPriceView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            currentMarketPriceView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            currentMarketPriceView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            
            transactionPricegraphView.heightAnchor.constraint(equalToConstant: 300),
            transactionPricegraphView.topAnchor.constraint(equalTo: currentMarketPriceView.bottomAnchor, constant: 20),
            transactionPricegraphView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionPricegraphView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            transactionPriceSelectTimeView.topAnchor.constraint(equalTo: transactionPricegraphView.bottomAnchor, constant: 20),
            transactionPriceSelectTimeView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionPriceSelectTimeView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            transactionHistoryView.topAnchor.constraint(equalTo: transactionPriceSelectTimeView.bottomAnchor, constant: 20),
            transactionHistoryView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionHistoryView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            assetsStatusView.topAnchor.constraint(equalTo: transactionHistoryView.bottomAnchor, constant: 20),
            assetsStatusView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            assetsStatusView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            assetsStatusView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20)
        ])
        bindPriceView()
        bindAssetsStatusView()
        transactionPriceSelectTimeView.changeIntervalHandler = changeInterval
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentMarketPriceViewModel.fetchPrice()
        currentMarketPriceViewModel.updatePrice()
        assetsStatusViewModel.fetchAssetsStatus()
   }
    
    private func configureNavigationBar(symbol: String = "BTC") {
        title = symbol
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: nil)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
    }
    
    private func bindPriceView() {
        currentMarketPriceViewModel.price.subscribe { [weak self] observer in
            DispatchQueue.main.async {
                self?.currentMarketPriceView.updateUI(observer)
            }
        }
    }
    
    private func bindAssetsStatusView() {
        assetsStatusViewModel.assetsStatus.subscribe { [weak self] observer in
            DispatchQueue.main.async {
                self?.assetsStatusView.updateUI(observer)
            }
        }
    }
    
    private func changeInterval(_ interval: ChartIntervals) {
        transactionPricegraphView.viewmodel.fetchGraphPrice(interval: interval)
    }
}
