//
//  PirceViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

final class CurrentMarketPriceViewModel {
    
    private var service: APIService
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
    
    func fetchPrice() {
        service.request(endpoint: .ticker(symbol: symbol)) { [weak self] (result: Result<CurrentPrice, HTTPError>) in
            switch result {
            case .success(let ticker):
                guard let currentPrice = self?.convert(from: ticker.data) else { return }
                self?.price.value = currentPrice
                self?.sendMessage()
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
    
    private func sendMessage() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let symbol = self?.symbol else { return }
            let message = Message(type: .ticker, symbols: .name(symbol), tickTypes: .mid)
            self?.service.sendSocketMessage(to: message)
        }
    }
    
    func updatePrice() {
        service.perform { [weak self] (result: Result<ReceiveTicker, HTTPError>) in
            switch result {
            case .success(let ticker):
                guard let currentPrice = self?.convert(from: ticker) else {
                    return
                }
                self?.price.value = currentPrice
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
