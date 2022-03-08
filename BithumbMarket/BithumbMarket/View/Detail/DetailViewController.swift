//
//  DetailViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let ticker: Ticker
    
    private var transactionViewControllerFactory: (Ticker) -> UIViewController
    private var orderbookViewControllerFactory: (Ticker) -> UIViewController
    
    init(ticker: Ticker,
         transactionViewControllerFactory: @escaping (Ticker) -> UIViewController,
         orderbookViewControllerFactory: @escaping (Ticker) -> UIViewController) {
        self.ticker = ticker
        self.transactionViewControllerFactory = transactionViewControllerFactory
        self.orderbookViewControllerFactory = orderbookViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    var fetchAssetsStatusHandler: (() -> Void)?
    var fetchCurrentMarketPrice: (() -> Void)?
    var updateCurrentMarketPriceHandler: (() -> Void)?//
    var likeHandler: Bool?
    var updateLikeHandler: Result<Bool, CoreDataError>?
    var bindPriceHandler: Void?
    var bindAssetsStatusHandler: Void?
    
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
    
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = true
        return loadingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.backgroundColor = .systemBackground
        configureScrollView()
        configureUI()
        
        currentMarketPriceView.orderbookButtonHandler = moveOrderbookViewController
        transactionHistoryView.transactionHistoryButtonHandler = moveTransactionViewController
        
        _ = bindPriceHandler
        _ = bindAssetsStatusHandler
        fetchAssetsStatusHandler?()
        fetchCurrentMarketPrice?()
        transactionPriceSelectTimeView.changeIntervalHandler = selectItem(interval:)
        //graphViewModel.loadingHandelr = showLoadingView
        selectItem(interval: .day)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCurrentMarketPriceHandler?()
    }
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        button.addTarget(self, action: #selector(likeBarButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private func configureNavigationBar() {
        title = ticker.symbol
        navigationController?.isNavigationBarHidden = false
        guard let hasSymbol = likeHandler else {
            return
        }
        likeButton.isSelected = hasSymbol
        likeButton.tintColor = likeButton.isSelected ? .mainColor : .textSecondary
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
    }
    
    @objc private func likeBarButtonAction(_ sender: UIButton) {
        guard let updateLikeHandler = updateLikeHandler else {
            return
        }
        switch updateLikeHandler {
        case .success(_):
            likeButton.isSelected = !likeButton.isSelected
            likeButton.tintColor = likeButton.isSelected ? .mainColor : .textSecondary
        case .failure(let error):
            // 에러표시 추가
            break
        }
    }
    
    lazy var updateAssetsStatusView = { [weak self] (status: AssetsStatusData) -> Void in
        DispatchQueue.main.async {
            print(status)
            self?.assetsStatusView.updateUI(status)
        }
    }
    
    lazy var updatePriceView = { [weak self] (price: CurrentMarketPrice) -> Void in
        DispatchQueue.main.async {
            self?.currentMarketPriceView.updateUI(price)
        }
    }
    
    private func moveTransactionViewController() {
        self.navigationController?.pushViewController(transactionViewControllerFactory(ticker), animated: true)
    }
    
    private func moveOrderbookViewController() {
        self.navigationController?.pushViewController(orderbookViewControllerFactory(ticker), animated: true)
    }
    
    lazy var showLoadingView: ((Bool) -> Void) = { [weak self] state in
        DispatchQueue.main.async {
            self?.loadingView.isHidden = state
        }
    }
    
    func selectItem(interval: ChartIntervals) {
//        graphViewModel.fetchGraph(symbol: ticker.symbol, interval: interval) { [weak self] graph in
//            self?.transactionPricegraphView.updateGraph(graph)
//        }
    }
    
}

extension DetailViewController {
    
    func configureUI() {
        scrollContentView.addSubview(currentMarketPriceView)
        scrollContentView.addSubview(transactionPriceSelectTimeView)
        scrollContentView.addSubview(transactionPricegraphView)
        scrollContentView.addSubview(transactionHistoryView)
        scrollContentView.addSubview(assetsStatusView)
        
        NSLayoutConstraint.activate([
            currentMarketPriceView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            currentMarketPriceView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            currentMarketPriceView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            
            transactionPricegraphView.heightAnchor.constraint(equalToConstant: 350),
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
}
