//
//  MainViewModel.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

final class MainViewModel {
    
    var tickers: Observable<[Ticker]>
    private var isFilter: Bool
    private var service: APIService
    private let storage: LikeStorge
    private var symbols: [String]
    
    init(service: APIService = APIService(),
         storage: LikeStorge = LikeStorge()) {
        self.tickers = .init([])
        self.isFilter = false
        self.service = service
        self.storage = storage
        self.symbols = []
    }
    
    var updateTickersHandler: (([Ticker]) -> Void)?
    var changeIndexHandler: ((Int) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func fetchTickers() {
        service.requestTickers(endpoint: .ticker()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let tickers):
                self.tickers.value = tickers.sorted(by: >)
                self.updateTickersHandler?(self.tickers.value)
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
                self.update(index: index, to: ticker)
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
    private func update(index: Int, to ticker: ReceiveTicker) {
        tickers.value[index].compare(to: ticker) { [weak self] state in
            guard let self = self else { return }
            tickers.value[index].updatePrice(to: ticker)
            
            if isFilter {
                if symbols.contains(tickers.value[index].symbol) {
                    guard let filterIndex = symbols.firstIndex(of: tickers.value[index].symbol) else {
                        return
                    }
                    self.changeIndexHandler?(filterIndex)
                }
            } else {
                self.changeIndexHandler?(index)
            }
        }
    }
    
//    private func startFilterTickers(to ticker: ReceiveTicker) {
//        guard let filterIndex = self.findIndex(from: self.filterTickers, to: ticker) else {
//            return
//        }
//        self.updateFilterTicker(index: filterIndex, to: ticker)
//    }
//
//    private func updateFilterTicker(index: Int, to ticker: ReceiveTicker) {
//        filterTickers.value[index].compare(to: ticker) { [weak self] state in
//            guard let self = self else { return }
//            self.filterTickers.value[index].updatePrice(to: ticker)
//            let colorState = self.filterTickers.value[index].change
//            changeIndexHandlerAction(index: index, color: colorState, updateState: state)
//        }
//    }
    
    private func findIndex(from ticker: Observable<[Ticker]>, to newTicker: ReceiveTicker) -> Int? {
        return ticker.value.firstIndex(where: { $0.equalSymbol(to: newTicker) })
    }
    
    private func changeIndexHandlerAction(index: Int, updateState: Ticker.UpdateState) {
        switch updateState {
        case .closePrice:
            self.changeIndexHandler?(index)
        case .tradeValue:
            self.changeIndexHandler?(index)
        }
    }
    
    func executeFilterTickers() {
        isFilter = !isFilter
        symbols = fetctLikeSymbols()
        
        if isFilter {
            updateTickersHandler?(tickers.value.filter { symbols.contains($0.symbol) })
        } else {
            updateTickersHandler?(tickers.value)
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
