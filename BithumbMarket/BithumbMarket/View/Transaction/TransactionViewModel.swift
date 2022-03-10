//
//  TransactionViewModel.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/25.
//

import Foundation

final class TransactionViewModel {
    
    private let symbol: String
    
    var transactionData: Observable<[TransactionData]>
    private let service: APIService
    var socket: SocketService?
    
    init(service: APIService, symbol: String) {
        self.transactionData = .init([])
        self.service = service
        self.symbol = symbol
    }
    
    var updateTableHandler: (() -> Void)?
    var insertTableHandler: (() -> Void)?
    var errorHandler: ((String) -> Void)?
    
    func disconnect() {
        socket?.disconnect()
        socket = nil
    }
    
    func fetchTransaction() {
        service.request(endpoint: .transactionHistory(symbol: symbol)) { [weak self] (result: Result<Transaction, HTTPError>)  in
            guard let self = self else { return }
            switch result {
            case .success(let transaction):
                self.transactionData.value = transaction.data
                self.updateTableHandler?()
                self.sendMessage {
                    self.updateTransaction()
                }
            case.failure(let error):
                self.errorHandler?(error.description)
            }
        }
    }
    
    private func sendMessage(completion: @escaping () -> Void) {
        self.socket = SocketService()
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let message = Message(type: .transaction, symbols: .name(self.symbol))
            self.socket?.sendMessage(message: message)
        }
        completion()
    }
    
    private func updateTransaction() {
        self.socket?.perform { [weak self] (result: Result<ReceiveTransaction, HTTPError>) in
            guard let self = self else { return }
            switch result {
            case .success(let transaction):
                if let data = transaction.content.list.first {
                    self.transactionData.value.append(data.toTransaction())
                    self.insertTableHandler?()
                }
            case .failure(let error):
                self.errorHandler?(error.description)
            }
        }
    }
    
}
