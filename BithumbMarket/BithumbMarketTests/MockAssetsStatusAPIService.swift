//
//  MockAssetsStatusAPIService.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct MockAssetsStatusAPIService: Serviceable {
    
//    let dummyData = DummyData()
    var isSuccess = true
    var assetsState: AssetsStatus
    
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, HTTPError>) -> Void) {
        if isSuccess {
            completion(.success(assetsState as! T))
        } else {
            completion(.failure(.statusCode(404)))
        }
    }
    
    func requestTickers(endpoint: APIEndpoint, completion: @escaping (Result<[Ticker], HTTPError>) -> Void) {
        return
    }
}
