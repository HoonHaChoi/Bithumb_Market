//
//  TransactionViewModel.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/02/25.
//

import Foundation

final class TransactionViewModel {
    
    private let service: APIService
    private var transactionData: [TransactionData] = []

    init(service: APIService) {
        self.service = service
    }
    
    var transaction: [TransactionData] {
        self.transactionData
    }
    
    func fetchTransaction(symbol: String, completion: @escaping () -> Void ) {
        let endPoint = EndPoint()
        let url = endPoint.makeURL(of: .transactionHistory, param: symbol)
        service.request(url: url) { (result: Result<Transaction, HTTPError>) in
            switch result {
            case .success(let model):
                self.transactionData = model.data
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
}
