//
//  OrderbookViewController.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/24.
//

import UIKit

class OrderbookViewController: UIViewController {
    //MARK: UI property
    let orderbookTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero)
        return tableView
    }()
    
    lazy var orderbookTableViewConstraints = [
        orderbookTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        orderbookTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        orderbookTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        orderbookTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
    ]
    
    private func setLayout() {
        orderbookTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(orderbookTableViewConstraints)
    }
    
    //MARK: Life Cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        view.addSubview(orderbookTableView)
        setLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
