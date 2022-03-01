//
//  MainViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

final class MainViewController: UIViewController {
    
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
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    private lazy var coinSortView: CoinSortControlView = {
        let sortView = CoinSortControlView()
        sortView.translatesAutoresizingMaskIntoConstraints = false
        return sortView
    }()
    
    private let headerView: MainHeaderView = {
        let view = MainHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureTableView()
        bind()
        viewmodel.fetchTickers()
        viewmodel.updateTickers()
    }

    private func configureUI() {
        view.addSubview(coinSortView)
        view.addSubview(mainTableView)
        view.addSubview(headerView)
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            coinSortView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            coinSortView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            coinSortView.widthAnchor.constraint(equalToConstant: 140),
            coinSortView.heightAnchor.constraint(equalToConstant: 45),
            
            mainTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: coinSortView.bottomAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
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
        viewmodel.changeIndexHandler = updateTableViewRows(index:state:)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.mainTableView.reloadData()
        }
    }
    
    private func updateTableViewRows(index: Int, state: ChangeState) {
        DispatchQueue.main.async { [weak self] in
            self?.mainTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            let cell = self?.mainTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TickerCell
            cell?.updateAnimation(state: state)
        }
    }
    
}
