//
//  AssetsStatusViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

final class AssetsStatusViewModel {
    
    private let symbol: String
    private let service: Serviceable
    
    init(service: Serviceable, symbol: String) {
        self.service = service
        self.symbol = symbol
    }
    
    var assetsStateHandler: ((AssetsState) -> Void)?
    var errorHandler: ((HTTPError) -> Void)?
    
    func fetchAssetsStatus() {
        service.request(endpoint: .assetsstatus(symbol: symbol)) { [weak self] (result: Result<AssetsStatus, HTTPError>) in
            switch result {
            case .success(let assetsStatus):
                self?.assetsStateHandler?(assetsStatus.data.setState())
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
   
}
