//
//  OrderbookViewController.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

class OrderbookViewController: UIViewController {
    
    private let dataSource: OrderbookDataSource
    private var viewModel: OrderbookViewModelType
    
    init(viewModel: OrderbookViewModelType = OrderbookViewModel(symbol: "BTC_KRW"), dataSource: OrderbookDataSource) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = OrderbookViewModel(symbol: "BTC_KRW")
        self.dataSource = .init()
        super.init(coder: coder)
    }
    
    private let orderbookTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OrderbookTableViewCell.self, forCellReuseIdentifier: OrderbookNameSpace.cellReuseIdentifier)
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = OrderbookNameSpace.navigationTitle
        configureTableView()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.featchOrderbook()
   }
    
    private lazy var orderbookTableViewConstraints = [
        orderbookTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        orderbookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        orderbookTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        orderbookTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
    ]
    
    private func configureTableView() {
        view.addSubview(orderbookTableView)
        NSLayoutConstraint.activate(orderbookTableViewConstraints)
        orderbookTableView.dataSource = dataSource
    }

    private func bind() {
        viewModel.updateTableHandler = updateTableView
        viewModel.orderbook.subscribe { [weak self] observer in
            self?.dataSource.items = observer
        }
    }

    private func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.orderbookTableView.reloadData()
        }
    }

}
