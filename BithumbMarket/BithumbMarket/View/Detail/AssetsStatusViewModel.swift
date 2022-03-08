//
//  AssetsStatusViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/03.
//

import Foundation

final class AssetsStatusViewModel {
    
    private var symbol: String
    private var service: APIService
    
    var assetsStatus: Observable<AssetsStatusData>
    var errorHandler: ((HTTPError) -> Void)?
    
    init(service: APIService = APIService(), symbol: String) {
        self.assetsStatus = .init(AssetsStatusData(
            depositStatus: 0,
            withdrawalStatus: 0
        ))
        self.service = service
        self.symbol = symbol
    }
    
    lazy var fetchAssetsStatus: () -> Void =  { 
        self.service.request(endpoint: .assetsstatus(symbol: self.symbol)) { [weak self] (result: Result<AssetsStatus, HTTPError>) in
            switch result {
            case .success(let assetsStatus):
                self?.assetsStatus.value = assetsStatus.data
            case .failure(let error):
                self?.errorHandler?(error)
            }
        }
    }
   
}
