//
//  PirceViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

final class CurrentMarketPriceViewModel {
    
    private(set) var price : Observable<CurrentMarketPrice>
    private let symbol: String
    private var socket: SocketServiceable?
    
    var errorHandler: ((HTTPError) -> Void)?
    
    init(symbol: String) {
        self.symbol = symbol
        self.price = .init(CurrentMarketPrice.empty)
    }
    
    func createSocket(_ socket: SocketServiceable) {
        self.socket = socket
        sendMessage()
        updatePrice()
    }
    
    private func sendMessage() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let message = Message(type: .ticker, symbols: .name(self.symbol), tickTypes: .twentyfourHour)
            self.socket?.sendMessage(message: message)
        }
    }
    
    private func updatePrice() {
        self.socket?.perform { [weak self] (result: Result<ReceiveTicker, HTTPError>) in
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
    
    private func convert(from ticker: ReceiveTicker) -> CurrentMarketPrice {
        return CurrentMarketPrice(currentPrice: ticker.content.closePrice,
                                  changePrice: ticker.content.chgAmt,
                                  changeRate: ticker.content.chgRate)
    }
    
    func disconnect() {
        socket?.disconnect()
        socket = nil
    }
    
}
