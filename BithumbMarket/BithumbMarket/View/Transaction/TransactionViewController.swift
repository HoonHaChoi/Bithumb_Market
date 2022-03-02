//
//  TransactionViewController.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/24.
//

import UIKit

class TransactionViewController: UIViewController {
    
    private let viewmodel: TransactionViewModel
    private let datasource: TransactionDataSource
    
    init(viewmodel: TransactionViewModel, datasource: TransactionDataSource) {
        self.viewmodel = viewmodel
        self.datasource = datasource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewmodel = .init()
        self.datasource = .init()
        super.init(coder: coder)
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 45
        view.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionNameSpace.cellReuseIdentifier)
        view.dataSource = datasource
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
    
    private func bind() {
        viewmodel.transactionData.subscribe { [weak self] transactions in
            self?.datasource.items = transactions
        }
        viewmodel.updateTableHandler = updateTableView
        viewmodel.insertTableHandler = insertRowTableView
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            
        }
    }
    
    private func insertRowTableView() {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "체결 내역"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()
        drawTitle()
        setupView()
        bind()
        viewmodel.fetchTransaction()
    }
}

extension TransactionViewController {
    
    func setupView() {
        view.addSubview(tableView)
        
        [stackView, tableView].forEach{view.addSubview($0)}
        
        [stackView, tableView].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

