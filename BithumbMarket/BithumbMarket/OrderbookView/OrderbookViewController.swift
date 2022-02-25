//
//  OrderbookViewController.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

class OrderbookViewController: UIViewController {
    //MARK: UI property
    private let orderbookTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OrderbookTableViewCell.self, forCellReuseIdentifier: OrderbookTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var orderbookTableViewConstraints = [
        orderbookTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        orderbookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        orderbookTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        orderbookTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
    ]
    
    private func configureTableView() {
        view.addSubview(orderbookTableView)
        NSLayoutConstraint.activate(orderbookTableViewConstraints)
    }
    
    //MARK: Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}
