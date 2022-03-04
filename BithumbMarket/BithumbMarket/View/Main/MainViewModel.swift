//
//  MainViewModel.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

final class MainViewModel {
    
    var tickers: Observable<[Ticker]>
    var filterTickers: Observable<[Ticker]>
    var isFilter: Observable<Bool>
    private var service: APIService
    private let storage: LikeStorge
    
    init(service: APIService = APIService(),
         storage: LikeStorge = LikeStorge()) {
        self.tickers = .init([])
        self.filterTickers = .init([])
        self.service = service
        self.isFilter = .init(false)
        self.storage = storage
    }
    
    var updateTableHandler: (() -> Void)?
    var changeIndexHandler: ((Int, ChangeState) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
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
                guard let index = self.findIndex(from: self.tickers, to: ticker) else {
                    return
                }
                self.updateTicker(index: index, to: ticker)
                
                if self.isFilter.value {
                    self.startFilterTickers(to: ticker)
                }
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
    private func updateTicker(index: Int, to ticker: ReceiveTicker) {
        tickers.value[index].compare(to: ticker) { [weak self] state in
            guard let self = self else { return }
            tickers.value[index].updatePrice(to: ticker)
            
            if !isFilter.value {
                let colorState = self.tickers.value[index].change
                changeIndexHandlerAction(index: index, color: colorState, updateState: state)
            }
        }
    }
    
    private func startFilterTickers(to ticker: ReceiveTicker) {
        guard let filterIndex = self.findIndex(from: self.filterTickers, to: ticker) else {
            return
        }
        self.updateFilterTicker(index: filterIndex, to: ticker)
    }
    
    private func updateFilterTicker(index: Int, to ticker: ReceiveTicker) {
        filterTickers.value[index].compare(to: ticker) { [weak self] state in
            guard let self = self else { return }
            self.filterTickers.value[index].updatePrice(to: ticker)
            let colorState = self.filterTickers.value[index].change
            changeIndexHandlerAction(index: index, color: colorState, updateState: state)
        }
    }
    
    private func findIndex(from ticker: Observable<[Ticker]>, to newTicker: ReceiveTicker) -> Int? {
        return ticker.value.firstIndex(where: { $0.equalSymbol(to: newTicker) })
    }
    
    private func changeIndexHandlerAction(index: Int, color: ChangeState,
                                          updateState: Ticker.UpdateState) {
        switch updateState {
        case .closePrice:
            self.changeIndexHandler?(index, color)
        case .tradeValue:
            self.changeIndexHandler?(index, .even)
        }
    }
    
    func executeFilterTickers() {
        isFilter.value = !isFilter.value
        let symbols: [String] = fetctLikeSymbols()
        
        let tickerFilter = tickers.value.filter({
            symbols.contains($0.symbol) == true
        })
        
        filterTickers.value = tickerFilter.sorted() { first, second in
            if let first = symbols.firstIndex(of: first.symbol),
               let second = symbols.firstIndex(of: second.symbol) {
               return first < second
            }
            return false
        }
    }
    
    private func fetctLikeSymbols() -> [String] {
        switch storage.fetch() {
        case .success(let likes):
            return likes.compactMap { $0.symbol }
        case .failure(let error):
            errorHandler?(error)
        }
        return .init()
    }

}
