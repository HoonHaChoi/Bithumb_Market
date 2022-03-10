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
    private var graphDetailViewControllerFactory: (GraphData) -> UIViewController
    
    init(ticker: Ticker,
         transactionViewControllerFactory: @escaping (Ticker) -> UIViewController,
         orderbookViewControllerFactory: @escaping (Ticker) -> UIViewController,
         graphDetailViewControllerFactory: @escaping (GraphData) -> UIViewController) {
        self.ticker = ticker
        self.transactionViewControllerFactory = transactionViewControllerFactory
        self.orderbookViewControllerFactory = orderbookViewControllerFactory
        self.graphDetailViewControllerFactory = graphDetailViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fetchAssetsStatusHandler: (() -> Void)?
    var fetchCurrentMarketPrice: (() -> Void)?
    var updateCurrentMarketPriceHandler: (() -> Void)?
    var likeHandler: ((String) -> Void)?
    var updateLikeHandler: ((String) -> Void)?
    var fetchGraphHandler: ((String, ChartIntervals) -> Void)?
    var passGraphHandler: (() -> Void)?
    var bindPriceHandler: Void?
    
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
    
    private let graphDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "scale"), for: .normal)
//        button.layer.borderColor = UIColor.textSecondary.cgColor
//        button.layer.borderWidth = 1
//        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(showGraph), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureScrollView()
        configureUI()
        bind()
//        _ = bindPriceHandler
//        fetchCurrentMarketPrice?()
    }
    
    func bind() {
        currentMarketPriceView.orderbookButtonHandler = moveOrderbookViewController
        transactionHistoryView.transactionHistoryButtonHandler = moveTransactionViewController
        transactionPriceSelectTimeView.changeIntervalHandler = selectIntervalAction
        transactionPriceSelectTimeView.changeGraphTypeHandler = changeGraphType
        fetchAssetsStatusHandler?()
        fetchGraphHandler?(ticker.symbol, .day)
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        likeHandler?(ticker.symbol)
    }
    
    @objc private func likeBarButtonAction(_ sender: UIButton) {
        updateLikeHandler?(ticker.symbol)
    }
    
    lazy var hasSymbolButton = { [weak self] (state: Bool) -> Void in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.likeButton.isSelected = state
            self.likeButton.tintColor = self.likeButton.isSelected ? .mainColor : .textSecondary
        }
    }
    
    lazy var updateSymbolButton = { [weak self] () -> Void in
        guard let self = self else { return }
        DispatchQueue.main.async {
            self.likeButton.isSelected = !self.likeButton.isSelected
            self.likeButton.tintColor = self.likeButton.isSelected ? .mainColor : .textSecondary
        }
    }
    
    lazy var updateAssetsStatusView = { [weak self] (status: AssetsState) -> Void in
        DispatchQueue.main.async {
            self?.assetsStatusView.updateUI(status)
        }
    }
    
    lazy var updatePriceView = { [weak self] (price: CurrentMarketPrice) -> Void in
        DispatchQueue.main.async {
            self?.currentMarketPriceView.updateUI(price)
        }
    }
    
    lazy var moveTransactionViewController = { [weak self] in
        guard let self = self else { return }
        self.navigationController?.pushViewController(self.transactionViewControllerFactory(self.ticker), animated: true)
    }
    
    lazy var moveOrderbookViewController = { [weak self] in
        guard let self = self else { return }
        self.navigationController?.pushViewController(self.orderbookViewControllerFactory(self.ticker), animated: true)
    }
    
    lazy var moveGraphDetailViewController = { [weak self] (graph: GraphData) -> Void in
        guard let self = self else { return }
        self.present(self.graphDetailViewControllerFactory(graph), animated: true)
    }
    
    lazy var showLoadingView = { [weak self] (state: Bool) -> Void in
        DispatchQueue.main.async {
            self?.loadingView.isHidden = state
        }
    }
    
    lazy var selectIntervalAction = { [weak self] (interval: ChartIntervals) -> Void in
        self?.fetchGraphHandler?(self?.ticker.symbol ?? "", interval)
    }
    
    lazy var updateGraphView = { [weak self] (graphData: GraphData) -> Void in
        guard let self = self else { return }
        self.transactionPricegraphView.updateGraph(graphData)
    }
    
    lazy var changeGraphType = { [weak self] (state: Bool) -> Void in
        self?.transactionPricegraphView.changeGraph(isLine: state)
    }
    
    lazy var showGraphDetailViewController = { [weak self] (data: GraphData) -> Void in
        self?.moveGraphDetailViewController(data)
    }
    
    deinit {
        print(#function)
    }

}

extension DetailViewController {
    
    func configureUI() {
        scrollContentView.addSubview(currentMarketPriceView)
        scrollContentView.addSubview(transactionPriceSelectTimeView)
        scrollContentView.addSubview(transactionPricegraphView)
        scrollContentView.addSubview(transactionHistoryView)
        scrollContentView.addSubview(assetsStatusView)
        scrollContentView.addSubview(graphDetailButton)
        scrollContentView.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            graphDetailButton.bottomAnchor.constraint(equalTo: transactionPricegraphView.bottomAnchor),
            graphDetailButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 10),
            graphDetailButton.widthAnchor.constraint(equalToConstant: 50),
            graphDetailButton.heightAnchor.constraint(equalToConstant: 50),
            
            currentMarketPriceView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            currentMarketPriceView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20),
            currentMarketPriceView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -20),
            
            transactionPricegraphView.heightAnchor.constraint(equalToConstant: 350),
            transactionPricegraphView.topAnchor.constraint(equalTo: currentMarketPriceView.bottomAnchor, constant: 20),
            transactionPricegraphView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionPricegraphView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor, constant: -20),
            
            transactionPriceSelectTimeView.topAnchor.constraint(equalTo: transactionPricegraphView.bottomAnchor, constant: 20),
            transactionPriceSelectTimeView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionPriceSelectTimeView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            transactionHistoryView.topAnchor.constraint(equalTo: transactionPriceSelectTimeView.bottomAnchor, constant: 20),
            transactionHistoryView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            transactionHistoryView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            
            assetsStatusView.topAnchor.constraint(equalTo: transactionHistoryView.bottomAnchor, constant: 20),
            assetsStatusView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            assetsStatusView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            assetsStatusView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20),
            
            loadingView.topAnchor.constraint(equalTo: transactionPricegraphView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: currentMarketPriceView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: currentMarketPriceView.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: transactionPriceSelectTimeView.bottomAnchor)
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
    
    @objc private func showGraph() {
        passGraphHandler?()
    }
}
