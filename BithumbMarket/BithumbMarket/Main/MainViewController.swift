//
//  MainViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

class MainViewController: UIViewController {

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
        mainTableView.register(TickerCell.self, forCellReuseIdentifier: TickerCell.reuseidentifier)
    }

}
