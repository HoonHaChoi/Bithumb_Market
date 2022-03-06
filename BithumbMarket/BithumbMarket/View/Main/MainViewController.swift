//
//  MainViewController.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let viewmodel: MainViewModel
    
    init(viewmodel: MainViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewmodel = .init()
        super.init(coder: coder)
    }
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        tableView.delaysContentTouches = false
        return tableView
    }()
    
    private lazy var diffableDatasource = MainDiffableDataSource(tableView: mainTableView) { tableView, indexPath, ticker in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TickerCell.reuseidentifier, for: indexPath) as? TickerCell else {
            return .init()
        }
        cell.configure(ticker: ticker)
        return cell
    }
    
    private lazy var coinSortView: CoinSortControlView = {
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
        bind()
        viewmodel.fetchTickers()
        viewmodel.updateTickers()
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
    
    private func bind() {
        
        viewmodel.tickers.subscribe { [weak self] tickers in
            self?.diffableDatasource.updateItems(tickers: tickers)
        }
        
        viewmodel.updateTickersHandler = updateTableView
        viewmodel.changeIndexHandler = updateTableViewRows(index:)
        coinSortView.sortControlHandler = viewmodel.executeFilterTickers
    }
    
    private func updateTableView(tickers: [Ticker]) {
        diffableDatasource.appendSnapshot(tickers: tickers)
    }
    
    private func updateTableViewRows(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let ticker = self?.diffableDatasource.itemIdentifier(for: IndexPath(row: index, section: 0)) else {
                return
            }
            self?.diffableDatasource.reloadSnapshot(ticker: ticker, completion: {
                let cell = self?.mainTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TickerCell
                cell?.updateAnimation(state: ticker.change)
            })
        }
    }
    
//    private func updateRows(index: Int) {
//        if viewmodel.isFilter.value {
//        } else {
//            updateVisibleRows(index: index)
//        }
//    }
//
//    private func updateVisibleRows(index: Int) {
//        mainTableView.indexPathsForVisibleRows?.forEach({ indexPath in
//            if indexPath.row == index {
//                reloadRow(indexPath: indexPath)
//            }
//        })
//    }
//
//    private func reloadRow(indexPath: IndexPath) {
//        mainTableView.reloadRows(at: [indexPath], with: .none)
//    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ticker = diffableDatasource.itemIdentifier(for: indexPath) else {
            return
        }
        moveDetailViewController(ticker: ticker)
    }
    
    private func moveDetailViewController(ticker: Ticker) {
        let detailViewController = DetailViewController(ticker: ticker)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
