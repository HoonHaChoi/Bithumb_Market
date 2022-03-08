//
//  MainViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var detailViewControllerFactory: (Ticker) -> UIViewController
    
    init(detailViewControllerFactory: @escaping (Ticker) -> UIViewController) {
        self.detailViewControllerFactory = detailViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    var fetchTickersHandler: (() -> Void)?
    var updateTickersHandler: (() -> Void)?
    var bindHandler: Void?
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    lazy var diffableDatasource = MainDiffableDataSource(tableView: mainTableView) { tableView, indexPath, ticker in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TickerCell.reuseidentifier, for: indexPath) as? TickerCell else {
            return .init()
        }
        cell.selectionStyle = .none
        cell.configure(ticker: ticker)
        return cell
    }
    
    lazy var coinSortView: CoinSortControlView = {
        let sortView = CoinSortControlView()
        sortView.translatesAutoresizingMaskIntoConstraints = false
        return sortView
    }()
    
    private let headerView: MainHeaderView = {
        let view = MainHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        configureTableView()
        _ = bindHandler
        fetchTickersHandler?()
        updateTickersHandler?()
    }

    private func configureUI() {
        view.addSubview(coinSortView)
        view.addSubview(mainTableView)
        view.addSubview(headerView)
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            coinSortView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            coinSortView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            coinSortView.widthAnchor.constraint(equalToConstant: 140),
            coinSortView.heightAnchor.constraint(equalToConstant: 45),
            
            mainTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: coinSortView.bottomAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func configureTableView() {
        mainTableView.register(TickerCell.self, forCellReuseIdentifier: TickerCell.reuseidentifier)
        mainTableView.dataSource = diffableDatasource
        mainTableView.delegate = self
    }
    
    lazy var updateTableView = { [weak self] (tickers: [Ticker]) in
        self?.diffableDatasource.appendSnapshot(tickers: tickers)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.diffableDatasource.isEmptyItems() {
                self.mainTableView.backgroundView = TableEmptyView()
            } else {
                self.mainTableView.backgroundView = .init()
            }
        }
    }
    
    lazy var updateTableViewRows = { [weak self] (index: Int) in
        guard let ticker = self?.diffableDatasource.itemIdentifier(for: IndexPath(row: index, section: 0)) else {
            return
        }
        self?.diffableDatasource.reloadSnapshot(ticker: ticker, completion: {
            let cell = self?.mainTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TickerCell
            cell?.updateAnimation(state: ticker.change)
        })
    }
    
    private func moveDetailViewController(ticker: Ticker) {
        self.navigationController?.pushViewController(detailViewControllerFactory(ticker), animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ticker = diffableDatasource.itemIdentifier(for: indexPath) else {
            return
        }
        self.moveDetailViewController(ticker: ticker)
    }
    
}
