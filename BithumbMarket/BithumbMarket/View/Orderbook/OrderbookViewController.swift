//
//  OrderbookViewController.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

class OrderbookViewController: UIViewController {
    
    let dataSource: OrderbookDataSource
    
    init(dataSource: OrderbookDataSource = .init()) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.dataSource = .init()
        super.init(coder: coder)
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
    
    var fetchHandler: (() -> Void)?
    
    lazy var updateDataSource: ((OrderbookData) -> Void)? = { [weak self] orderbook in
        self?.dataSource.items = orderbook
    }
    
    lazy var updateTableView = { [weak self] in
        DispatchQueue.main.async {
            self?.orderbookTableView.reloadData()
        }
    }
    
    private func scrollToCenter() {
        let indexPath = IndexPath(row: 0, section: 1)
        orderbookTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = OrderbookNameSpace.navigationTitle
        configureTableView()
        fetchHandler?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToCenter()
   }
    
    private func configureTableView() {
        view.addSubview(orderbookTableView)
        NSLayoutConstraint.activate([
            orderbookTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            orderbookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            orderbookTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            orderbookTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        orderbookTableView.dataSource = dataSource
    }

}
