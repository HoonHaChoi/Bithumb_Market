//
//  MainViewModel.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

final class MainViewModel {
    
    var tickers: Observable<[Ticker]>
    private var service: APIService
    
    init(service: APIService = APIService()) {
        tickers = .init([])
        self.service = service
    }
    
    var updateTableHandler: (() -> Void)?
    var errorHandler: ((HTTPError) -> Void)?
    
    func fetchTickers() {
        service.requestTickers(endpoint: .ticker()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tickers):
                self.tickers.value = tickers
                self.updateTableHandler?()
                
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
}
