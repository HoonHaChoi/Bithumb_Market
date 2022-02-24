//
//  TransactionViewController.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/24.
//

import UIKit

class TransactionViewController: ViewController {

    let row = 20
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "체결 내역"
        
        setupView()
    }
}

extension TransactionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell
        cell?.configure(transaction: transaction[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

extension TransactionViewController: UITableViewDelegate {
    
}

extension TransactionViewController {
    
    func setupView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

