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
    
    let detailViewControllerFactory = { symbol in
       DetailViewController(ticker: symbol)
    }
    
    func initialMainVC() -> MainViewController {
        let mainViewModel = MainViewModel(service: service,
                                          storage: storage)
        let mainViewController = MainViewController(detailViewControllerFactory: detailViewControllerFactory)
        
        mainViewController.bindHandler = mainViewModel.tickers.subscribe(bind: mainViewController.diffableDatasource.updateItems)
        mainViewController.fetchTickersHandler = mainViewModel.fetchTickers
        mainViewController.updateTickersHandler = mainViewModel.updateTickers
        mainViewController.coinSortView.sortControlHandler = mainViewModel.executeFilterTickers
        
        mainViewModel.updateTickersHandler = mainViewController.updateTableView
        mainViewModel.changeIndexHandler = mainViewController.updateTableViewRows
        return mainViewController
    }
    
}
