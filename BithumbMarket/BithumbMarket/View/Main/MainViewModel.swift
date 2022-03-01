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
        self.tickers = .init([])
        self.service = service
    }
    
    var updateTableHandler: (() -> Void)?
    var changeIndexHandler: ((Int, ChangeState) -> Void)?
    var errorHandler: ((HTTPError) -> Void)?
    
    func fetchTickers() {
        service.requestTickers(endpoint: .ticker()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tickers):
                self.tickers.value = tickers.sorted(by: >)
                self.updateTableHandler?()
                self.sendMessage()
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
    private func sendMessage() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let symbols = self.tickers.value.map { $0.paymentCurrency }
            let message = Message(type: .ticker, symbols: .names(symbols), tickTypes: .twentyfourHour)
            self.service.sendSocketMessage(to: message)
        }
    }
    
    func updateTickers() {
        service.perform { [weak self] (respone: Result<ReceiveTicker, HTTPError>) in
            guard let self = self else { return }
            switch respone {
            case .success(let ticker):
                guard let index = self.findIndex(to: ticker) else {
                    return
                }
                self.apply(index: index, to: ticker)
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
    private func apply(index: Int, to ticker: ReceiveTicker) {
        tickers.value[index].compare(to: ticker) { [weak self] state in
            guard let self = self else { return }
            
            self.updateTicker(index: index, to: ticker)
            let changeState = self.tickers.value[index].change
            
            switch state {
            case .closePrice:
                self.changeIndexHandler?(index, changeState)
            case .tradeValue:
                self.changeIndexHandler?(index, .even)
            }
        }
    }
    
    private func findIndex(to ticker: ReceiveTicker) -> Int? {
        return tickers.value.firstIndex(where: { $0.equalSymbol(to: ticker) })
    }
    
    private func updateTicker(index: Int, to ticker: ReceiveTicker) {
        tickers.value[index].updatePrice(to: ticker)
    }
    
    private func changeIndexHandlerAction(index: Int) {
        let changeState = tickers.value[index].change
        changeIndexHandler?(index, changeState)
    }
    
}
