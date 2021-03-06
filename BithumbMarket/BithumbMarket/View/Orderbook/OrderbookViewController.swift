//
//  OrderbookViewController.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

final class OrderbookViewController: BaseViewController {
    
    private let dataSource: OrderbookDataSource
    
    init(dataSource: OrderbookDataSource = .init()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let orderbookTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OrderbookTableViewCell.self, forCellReuseIdentifier: OrderbookNameSpace.cellReuseIdentifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = 44
        return tableView
    }()
    
    private let sumOfQuantitiesView: OrderbookQuantitiesView = {
        let view = OrderbookQuantitiesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var fetchHandler: (() -> Void)?
    
    lazy var updateDataSource: ((OrderbookData) -> Void)? = { [weak self] orderbook in
        self?.dataSource.items = orderbook
        DispatchQueue.main.async {
            self?.sumOfQuantitiesView.updateUI(sumOfAsks: orderbook.sumOfAsks(),
                                               sumOfBids: orderbook.sumOfBids())
        }
    }
    
    lazy var updateTableView = { [weak self] in
        DispatchQueue.main.async {
            self?.orderbookTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = OrderbookNameSpace.navigationTitle
        configureSumOfQuantitiesView()
        configureTableView()
        orderbookTableView.scrollToCenter(y: (44 * 60 - UIScreen.main.bounds.height) / 1.9)
        fetchHandler?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disconnectHandler?()
    }
    
    private func configureTableView() {
        view.addSubview(orderbookTableView)
        NSLayoutConstraint.activate([
            orderbookTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            orderbookTableView.bottomAnchor.constraint(equalTo: sumOfQuantitiesView.topAnchor),
            orderbookTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            orderbookTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        orderbookTableView.dataSource = dataSource
    }
    
    private func configureSumOfQuantitiesView() {
        view.addSubview(sumOfQuantitiesView)
        NSLayoutConstraint.activate([
            sumOfQuantitiesView.heightAnchor.constraint(equalToConstant: 80),
            sumOfQuantitiesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sumOfQuantitiesView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            sumOfQuantitiesView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
}
