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
    
    func detailViewControllerFactory(symbol: String) -> DetailViewController {
        return initialDetailViewController(symbol: symbol)
    }
    
    func transactionViewControllerFactory(symbol: String) -> TransactionViewController {
        TransactionViewController(viewmodel: .init(), datasource: .init())
    }
    
    func orderbookViewControllerFactory(symbol: String) -> OrderbookViewController {
        OrderbookViewController(viewModel: .init(symbol: symbol), dataSource: .init())
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
    
    private func initialDetailViewController(symbol: String) -> DetailViewController {
        let detailViewController = DetailViewController(
            symbol: symbol,
            transactionViewControllerFactory: transactionViewControllerFactory,
            orderbookViewControllerFactory: orderbookViewControllerFactory)
        let currentMarketPriceViewModel = CurrentMarketPriceViewModel(service: service, symbol: symbol)
        let assetsStatusViewModel = AssetsStatusViewModel(service: service, symbol: symbol)
        let detailViewModel = DetailViewModel(storage: storage)
        
        detailViewController.fetchCurrentMarketPrice = currentMarketPriceViewModel.fetchPrice
        detailViewController.updateCurrentMarketPriceHandler = currentMarketPriceViewModel.updatePrice
        detailViewController.fetchAssetsStatusHandler = assetsStatusViewModel.fetchAssetsStatus

        detailViewController.likeHandler = detailViewModel.hasLike(symbol: symbol)
        detailViewController.updateLikeHandler = detailViewModel.updateLike(symbol: symbol)
        
        detailViewController.bindPriceHandler = currentMarketPriceViewModel.price.subscribe(bind: detailViewController.updatePriceView)
        detailViewController.bindAssetsStatusHandler = assetsStatusViewModel.assetsStatus.subscribe(bind: detailViewController.updateAssetsStatusView)
        
        return detailViewController
    }
    
}
