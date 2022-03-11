//
//  MainViewModel.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

final class MainViewModel {
    
    private(set) var tickers: Observable<[Ticker]>
    private let service: APIService
    private let storage: LikeStorge
    private var socket: SocketService?
    private var symbols: [String]
    private var isFilter: Bool
    
    init(service: APIService, storage: LikeStorge) {
        self.tickers = .init([])
        self.isFilter = false
        self.service = service
        self.storage = storage
        self.socket = .init()
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
                self.updateFilterTickers()
                self.sendMessage {
                    self.updateTickers()
                }
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
    private func sendMessage(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let symbols = self.tickers.value.map { $0.paymentCurrency }
            let message = Message(type: .ticker, symbols: .names(symbols), tickTypes: .twentyfourHour)
            self.socket?.sendMessage(message: message)
        }
        completion()
    }
    
    func disconnect() {
        socket?.disconnect()
        socket = nil
    }
    
    private func updateTickers() {
        self.socket?.perform { [weak self] (respone: Result<ReceiveTicker, HTTPError>) in
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
    
    private func findIndex(from ticker: Observable<[Ticker]>, to newTicker: ReceiveTicker) -> Int? {
        return ticker.value.firstIndex(where: { $0.equalSymbol(to: newTicker) })
    }
    
    private func update(index: Int, to ticker: ReceiveTicker) {
        tickers.value[index].updatePrice(to: ticker)
        
        if isFilter {
            if symbols.contains(tickers.value[index].symbol) {
                guard let filterIndex = findSymbolIndex(of: tickers.value[index].symbol) else {
                    return
                }
                self.changeIndexHandler?(filterIndex)
            }
        } else {
            self.changeIndexHandler?(index)
        }
    }
    
    private func findSymbolIndex(of symbol: String) -> Int? {
        return symbols.firstIndex(of: symbol)
    }
    
    func executeFilterTickers() {
        isFilter = !isFilter
        updateFilterTickers()
    }
    
    func updateFilterTickers() {
        if isFilter {
            updateTickersHandler?(filterTickers())
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
    
    private func filterTickers() -> [Ticker] {
        let likeSymbols = fetctLikeSymbols()
        let filterTickers = tickers.value.filter { likeSymbols.contains($0.symbol) }
        updateSymbol(filterTickers: filterTickers)
        return filterTickers
    }
    
    private func updateSymbol(filterTickers: [Ticker]) {
        symbols = filterTickers.map { $0.symbol }
    }

}
