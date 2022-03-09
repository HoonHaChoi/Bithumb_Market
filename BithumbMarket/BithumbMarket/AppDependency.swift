//
//  AppDependency.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/08.
//

import Foundation

struct AppDependency {
    
    let service = APIService()
    let likeStorage = LikeStorge()
    let graphStorage = GraphStorage()
    
    func detailViewControllerFactory(ticker: Ticker) -> DetailViewController {
        return initialDetailViewController(ticker: ticker)
    }
    
    func transactionViewControllerFactory(ticker: Ticker) -> TransactionViewController {
        return initialTransactionViewController(ticker: ticker)
    }
    
    func orderbookViewControllerFactory(ticker: Ticker) -> OrderbookViewController {
        return initialOrderbookViewController(ticker: ticker)
    }
    
    func graphDetailViewControllerFactory(graphData: GraphData) -> GraphDetailViewController {
        return GraphDetailViewController(graphData: graphData)
    }
    
    func initialMainViewController() -> MainViewController {
        let mainViewController = MainViewController(detailViewControllerFactory: detailViewControllerFactory)
        let mainViewModel = MainViewModel(service: service,
                                          storage: likeStorage)
        
        mainViewModel.tickers.bind = mainViewController.updateDiffableDataSource
        mainViewController.fetchTickersHandler = mainViewModel.fetchTickers
        
        mainViewController.coinSortView.sortControlHandler = mainViewModel.executeFilterTickers
        mainViewController.disconnectHandler = mainViewModel.disconnect
        
        mainViewModel.updateTickersHandler = mainViewController.updateTableView
        mainViewModel.changeIndexHandler = mainViewController.updateTableViewRows
        return mainViewController
    }
    
    private func initialDetailViewController(ticker: Ticker) -> DetailViewController {
        let detailViewController = DetailViewController(ticker: ticker,
                                                        transactionViewControllerFactory: transactionViewControllerFactory,
                                                        orderbookViewControllerFactory: orderbookViewControllerFactory,
        graphDetailViewControllerFactory: graphDetailViewControllerFactory(graphData:))
        let currentMarketPriceViewModel = CurrentMarketPriceViewModel(service: service,
                                                                      symbol: ticker.paymentCurrency)
        let assetsStatusViewModel = AssetsStatusViewModel(service: service,
                                                          symbol: ticker.paymentCurrency)
        let detailViewModel = DetailViewModel(storage: likeStorage)
        let graphViewModel = GraphViewModel(service: service, storage: graphStorage)
        detailViewController.fetchCurrentMarketPrice = currentMarketPriceViewModel.fetchPrice
        //detailViewContrller.updateCurrentMarketPriceHandler = currentMarketPriceViewModel.updatePrice
        detailViewController.fetchCurrentMarketPrice = currentMarketPriceViewModel.fetchPrice
        detailViewController.disconnectHandler = currentMarketPriceViewModel.disconnect
        
        detailViewController.fetchAssetsStatusHandler = assetsStatusViewModel.fetchAssetsStatus
        assetsStatusViewModel.assetsStateHandler = detailViewController.updateAssetsStatusView
        
        detailViewController.likeHandler = detailViewModel.hasLike(symbol:)
        detailViewModel.hasLikeHandler = detailViewController.hasSymbolButton
        detailViewController.updateLikeHandler = detailViewModel.updateLike(symbol:)
        detailViewModel.updateCompleteHandler = detailViewController.updateSymbolButton
        
        detailViewController.fetchGraphHandler = graphViewModel.fetchGraph(symbol:interval:)
        graphViewModel.updateGraphHandler = detailViewController.updateGraphView
        graphViewModel.loadingHandelr = detailViewController.showLoadingView
        
        // assetsStatusViewModel.errorHandler
        // detailViewModel.errorHandler
        // graphViewModel.errorHandler
        
        detailViewController.passGraphHandler = graphViewModel.passGraphData
        graphViewModel.passGraphHandler = detailViewController.showGraphDetailViewController
        
        detailViewController.bindPriceHandler = currentMarketPriceViewModel.price.subscribe(bind: detailViewController.updatePriceView)
        
        return detailViewController
    }
    
    private func initialTransactionViewController(ticker: Ticker) -> TransactionViewController {
        let transactionViewModel = TransactionViewModel(
            service: service,
            symbol: ticker.paymentCurrency)
        let transactionViewController = TransactionViewController(datasource: .init())
        
        //transactionViewModel.updateTableHandler = transactionViewController.updateTableView
        transactionViewController.fetchTransactionHandler = transactionViewModel.fetchTransaction
        transactionViewController.disconnectHandler = transactionViewModel.disconnect
        transactionViewModel.insertTableHandler = transactionViewController.insertRowTableView
        transactionViewModel.transactionData.bind = transactionViewController.updateDataSource
        return transactionViewController
    }
    
    private func initialOrderbookViewController(ticker: Ticker) -> OrderbookViewController {
        let orderbookViewModel = OrderbookViewModel(service: service,
                                                    symbol: ticker.paymentCurrency)
        let orderbookViewController = OrderbookViewController(dataSource: .init())
        orderbookViewController.disconnectHandler = orderbookViewModel.disconnect
        orderbookViewController.fetchHandler = orderbookViewModel.fetchOrderbook
        orderbookViewModel.orderbook.bind = orderbookViewController.updateDataSource
        orderbookViewModel.updateHandler = orderbookViewController.updateTableView
        return orderbookViewController
    }
    
}
