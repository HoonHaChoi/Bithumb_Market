//
//  MainViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var detailViewControllerFactory: (Ticker) -> UIViewController
    private var isUpdateLayout: Bool
    
    init(detailViewControllerFactory: @escaping (Ticker) -> UIViewController) {
        self.detailViewControllerFactory = detailViewControllerFactory
        isUpdateLayout = true
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fetchTickersHandler: (() -> Void)?
    var disconnectHandler: (() -> Void)?
    var updateTickers: (() -> Void)?
    
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
        fetchTickersHandler?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isUpdateLayout = true
        updateVisibleRows()
        updateTickers?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isUpdateLayout = false
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
        self?.setEmptyTableView()
    }
    
    lazy var updateDiffableDataSource = { [weak self] (items: [Ticker]) -> Void in
        self?.diffableDatasource.updateItems(tickers: items)
    }
    
    lazy var updateTableViewRows = { [weak self] (index: Int) in
        guard let self = self else { return }
        if self.isUpdateLayout {
            guard let ticker = self.diffableDatasource.findTicker(index: index) else {
                return
            }
            self.diffableDatasource.reloadSnapshot(ticker: ticker) {
                let cell = self.mainTableView.cellForRow(at: IndexPath(row: index, section: .zero)) as? TickerCell
                cell?.updateAnimation(state: ticker.change)
            }
        }
    }
    
    private func setEmptyTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.diffableDatasource.isEmptyItems() {
                self.mainTableView.backgroundView = TableEmptyView()
            } else {
                self.mainTableView.backgroundView = .init()
            }
        }
    }
    
    private func updateVisibleRows() {
        diffableDatasource.reloadIndexPath(rows: mainTableView.indexPathsForVisibleRows)
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
