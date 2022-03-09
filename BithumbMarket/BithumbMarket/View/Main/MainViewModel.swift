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
    
    private var socket: SocketService?
    
    init(service: APIService, storage: LikeStorge) {
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
        self.socket = SocketService()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let symbols = self.tickers.value.map { $0.paymentCurrency }
            let message = Message(type: .ticker, symbols: .names(symbols), tickTypes: .twentyfourHour)
            self.socket?.sendMessage(message: message)
        }
        completion()
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
                guard let filterIndex = symbols.firstIndex(of: tickers.value[index].symbol) else {
                    return
                }
                self.changeIndexHandler?(filterIndex)
            }
        } else {
            self.changeIndexHandler?(index)
        }
    }
    
    func executeFilterTickers() {
        isFilter = !isFilter
        updateFilterTickers()
    }
    
    private func updateFilterTickers() {
        if isFilter {
            symbols = fetctLikeSymbols()
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
