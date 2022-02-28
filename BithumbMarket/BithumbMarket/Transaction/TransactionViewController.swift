//
//  TransactionViewController.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/24.
//

import UIKit

class TransactionViewController: ViewController {
    
    let symbol = "BTC"
    let model = TransactionViewModel.init(service: APIService.init(session: URLSession.shared))
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 45
        view.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionNameSpace.cellReuseIdentifier)
        return view
    }()
    
    private func drawTitle() {
        let titleText = TransactionNameSpace.tableTitle
        
        for text in titleText {
            let view = UILabel()
            view.textColor = .label
            view.text = text
            stackView.addArrangedSubview(view)
        }
    }
    
    func fetchData() {
        model.fetchTransaction(symbol: symbol) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "체결 내역"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
        drawTitle()
        fetchData()
        setupView()
    }
}

extension TransactionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionNameSpace.cellReuseIdentifier, for: indexPath) as? TransactionTableViewCell
        cell?.configure(transaction: model.transaction[indexPath.row])
        cell?.selectionStyle = .none
        
        return cell ?? UITableViewCell()
    }
}

extension TransactionViewController: UITableViewDelegate {
    
}

extension TransactionViewController {
    
    func setupView() {
        view.addSubview(tableView)
        
        [stackView, tableView].forEach{view.addSubview($0)}
        
        [stackView, tableView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

