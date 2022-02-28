//
//  MainViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

class MainViewController: UIViewController {
    
    private let datasource: MainDataSource
    private let viewmodel: MainViewModel
    
    init(viewmodel: MainViewModel, datasource: MainDataSource) {
        self.viewmodel = viewmodel
        self.datasource = datasource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewmodel = .init()
        self.datasource = .init()
        super.init(coder: coder)
    }
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        return tableView
    }()
    
    private lazy var coinSortView: CoinSortControlView = {
        let sortView = CoinSortControlView()
        sortView.translatesAutoresizingMaskIntoConstraints = false
        return sortView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureTableView()
        bind()
        viewmodel.fetchTickers()
    }

    private func configureUI() {
        view.addSubview(coinSortView)
        view.addSubview(mainTableView)
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            coinSortView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            coinSortView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            coinSortView.widthAnchor.constraint(equalToConstant: 150),
            coinSortView.heightAnchor.constraint(equalToConstant: 40),
            
            mainTableView.topAnchor.constraint(equalTo: coinSortView.bottomAnchor, constant: 20),
            mainTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureTableView() {
        mainTableView.register(TickerCell.self, forCellReuseIdentifier: TickerCell.reuseidentifier)
        mainTableView.dataSource = datasource
    }

    private func bind() {
        viewmodel.tickers.subscribe { [weak self] tickers in
            self?.datasource.items = tickers
        }
        viewmodel.updateTableHandler = updateTableView
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.mainTableView.reloadData()
        }
    }
    
}