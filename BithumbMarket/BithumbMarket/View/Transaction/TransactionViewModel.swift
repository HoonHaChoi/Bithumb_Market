//
//  TransactionViewModel.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/25.
//

import Foundation

final class TransactionViewModel {
    
    var transactionData: Observable<[TransactionData]>
    private var service: APIService
    
    init(service: APIService = APIService()) {
        self.transactionData = .init([])
        self.service = service
    }
    
    var updateTableHandler: (() -> Void)?
    var insertTableHandler: (() -> Void)?
    var errorHandler: ((HTTPError) -> Void)?
    
    func fetchTransaction() {
        service.request(endpoint: .transactionHistory(symbol: "BTC")) { (result:  Result<Transaction, HTTPError>)  in
            switch result {
            case .success(let transaction):
                self.transactionData.value = transaction.data.reversed()
                self.updateTableHandler?()
                self.sendMessage()
                self.updateTransaction()
            case.failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
    private func sendMessage() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            let message = Message(type: .transaction, symbols: .name(self.name))
            self.service.sendSocketMessage(to: message)
        }
    }
    
    func updateTransaction() {
        service.perform { [weak self] (result: Result<ReceiveTransaction, HTTPError>) in
            guard let self = self else { return }
            switch result {
            case .success(let transaction):
                if let data = transaction.content.list.first {
                    let transactionData = TransactionData(
                        transactionDate: data.contDtm,
                        type: data.buySellGb,
                        unitsTraded: data.contQty,
                        price: data.contPrice,
                        total: data.contAmt
                    )
                    print(transactionData)
                    self.transactionData.value.insert(transactionData, at: 0)
                    self.insertTableHandler?()
                }
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
}
