//
//  PirceViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

final class CurrentMarketPriceViewModel {
    
    private var service: APIService
    var socket: SocketService?
    private var symbol: String
    var price : Observable<CurrentMarketPrice>
    
    var errorHandler: ((HTTPError) -> Void)?
    
    init(service: APIService = APIService(), symbol: String) {
        self.service = service
        self.symbol = symbol
        self.price = .init(CurrentMarketPrice(
            currentPrice: "",
            changePrice: "",
            changeRate: "")
        )
    }
    
    func disconnect() {
        socket?.disconnect()
        socket = nil
    }
    
    func fetchPrice() {
        service.request(endpoint: .ticker(symbol: self.symbol)) { [weak self] (result: Result<CurrentPrice, HTTPError>) in
            switch result {
            case .success(let ticker):
                guard let currentPrice = self?.convert(from: ticker.data) else { return }
                self?.price.value = currentPrice
                self?.sendMessage {
                    self?.updatePrice()
                }
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    private func sendMessage(completion: @escaping () -> Void) {
        self.socket = SocketService()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let symbol = self?.symbol else { return }
            let message = Message(type: .ticker, symbols: .name(symbol), tickTypes: .twentyfourHour)
            self?.socket?.sendMessage(message: message)
        }
        completion()
    }
    
    private func updatePrice() {
        self.socket?.perform { [weak self] (result: Result<ReceiveTicker, HTTPError>) in
            switch result {
            case .success(let ticker):
                if ticker.content.symbol == self?.symbol {
                    guard let currentPrice = self?.convert(from: ticker) else {
                        return
                    }
                    self?.price.value = currentPrice
                }
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    private func convert(from market: Market) -> CurrentMarketPrice {
        return CurrentMarketPrice(
            currentPrice: market.closingPrice,
            changePrice: market.fluctate24H,
            changeRate: market.fluctateRate24H
        )
    }
    
    private func convert(from ticker: ReceiveTicker) -> CurrentMarketPrice {
        return CurrentMarketPrice(
            currentPrice: ticker.content.closePrice,
            changePrice: ticker.content.chgAmt,
            changeRate: ticker.content.chgRate
        )
    }
    
}
