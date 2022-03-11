//
//  MockAssetsStatusAPIService.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct MockAssetsStatusAPIService: Serviceable {
    
    let dummyData = DummyData()
    var isSuccess = true
    var index = 0
    
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, HTTPError>) -> Void) {
        if isSuccess {
            completion(.success(dummyData.makeDummyAssetStatus(index: index)))
        } else {
            completion(.failure(.statusCode(404)))
        }
    }
    
    func requestTickers(endpoint: APIEndpoint, completion: @escaping (Result<[Ticker], HTTPError>) -> Void) {
        return
    }
}
