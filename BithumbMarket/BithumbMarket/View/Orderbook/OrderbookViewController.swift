//
//  OrderbookViewController.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

final class OrderbookViewController: UIViewController {
    
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
    var disconnectHandler: (() -> Void)?
    
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
        view.backgroundColor = .systemBackground
        title = OrderbookNameSpace.navigationTitle
        configureSumOfQuantitiesView()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        orderbookTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: false)
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

extension UIScrollView {
    func scrollToCenter() {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2.0)
        setContentOffset(centerOffset, animated: false)
    }
}
