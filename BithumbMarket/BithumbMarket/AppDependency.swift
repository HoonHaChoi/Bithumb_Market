//
//  AppDependency.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/08.
//

import Foundation

struct AppDependency {
    
    let service = APIService()
    let storage = LikeStorge()
    
    func detailViewControllerFactory(ticker: Ticker) -> DetailViewController {
        return initialDetailViewController(ticker: ticker)
    }
    
    func transactionViewControllerFactory(ticker: Ticker) -> TransactionViewController {
        return initialTransactionViewController(ticker: ticker)
    }
    
    func orderbookViewControllerFactory(ticker: Ticker) -> OrderbookViewController {
        return initialOrderbookViewController(ticker: ticker)
    }
    
    func initialMainViewController() -> MainViewController {
        let mainViewController = MainViewController(detailViewControllerFactory: detailViewControllerFactory)
        let mainViewModel = MainViewModel(service: service,
                                          storage: storage)
        
        mainViewController.bindHandler = mainViewModel.tickers.subscribe(bind: mainViewController.diffableDatasource.updateItems)
        mainViewController.fetchTickersHandler = mainViewModel.fetchTickers
        mainViewController.updateTickersHandler = mainViewModel.updateTickers
        mainViewController.coinSortView.sortControlHandler = mainViewModel.executeFilterTickers
        
        mainViewModel.updateTickersHandler = mainViewController.updateTableView
        mainViewModel.changeIndexHandler = mainViewController.updateTableViewRows
        return mainViewController
    }
    
    private func initialDetailViewController(ticker: Ticker) -> DetailViewController {
        let detailViewController = DetailViewController(ticker: ticker,
                                                        transactionViewControllerFactory: transactionViewControllerFactory,
                                                        orderbookViewControllerFactory: orderbookViewControllerFactory)
        let currentMarketPriceViewModel = CurrentMarketPriceViewModel(service: service,
                                                                      symbol: ticker.paymentCurrency)
        let assetsStatusViewModel = AssetsStatusViewModel(service: service,
                                                          symbol: ticker.paymentCurrency)
        let detailViewModel = DetailViewModel(storage: storage)
        
        detailViewController.fetchCurrentMarketPrice = currentMarketPriceViewModel.fetchPrice
        detailViewController.updateCurrentMarketPriceHandler = currentMarketPriceViewModel.updatePrice
        detailViewController.fetchAssetsStatusHandler = assetsStatusViewModel.fetchAssetsStatus
        
        detailViewController.likeHandler = detailViewModel.hasLike(symbol: ticker.symbol)
        detailViewController.updateLikeHandler = detailViewModel.updateLike(symbol: ticker.symbol)
        
        detailViewController.bindPriceHandler = currentMarketPriceViewModel.price.subscribe(bind: detailViewController.updatePriceView)
        detailViewController.bindAssetsStatusHandler = assetsStatusViewModel.assetsStatus.subscribe(bind: detailViewController.updateAssetsStatusView)
        
        return detailViewController
    }
    
    private func initialTransactionViewController(ticker: Ticker) -> TransactionViewController {
        let transactionViewModel = TransactionViewModel(
            service: service,
            symbol: ticker.paymentCurrency)
        let transactionViewController = TransactionViewController(datasource: .init())
        
        transactionViewModel.updateTableHandler = transactionViewController.updateTableView
        transactionViewController.fetchTransactionHandler = transactionViewModel.fetchTransaction
        transactionViewModel.insertTableHandler = transactionViewController.insertRowTableView
        transactionViewModel.transactionData.bind = transactionViewController.updateDataSource
        return transactionViewController
    }
    
    private func initialOrderbookViewController(ticker: Ticker) -> OrderbookViewController {
        let orderbookViewModel = OrderbookViewModel(service: service,
                                                    symbol: ticker.paymentCurrency)
        let orderbookViewController = OrderbookViewController(dataSource: .init())
        orderbookViewController.fetchHandler = orderbookViewModel.fetchOrderbook
        orderbookViewModel.orderbook.bind = orderbookViewController.updateDataSource
        orderbookViewModel.updateHandler = orderbookViewController.updateTableView
        return orderbookViewController
    }
    
}
