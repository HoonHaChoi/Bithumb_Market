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
    var errorHandler: ((HTTPError) -> Void)?
    
    func fetchTransaction() {
        service.request(endpoint: .transactionHistory(symbol: "BTC")) { (result:  Result<Transaction, HTTPError>)  in
            switch result {
            case .success(let transaction):
                self.transactionData.value = transaction.data.reversed()
                self.updateTableHandler?()
            case.failure(let error):
                self.errorHandler?(error)
            }
        }
    }
}
