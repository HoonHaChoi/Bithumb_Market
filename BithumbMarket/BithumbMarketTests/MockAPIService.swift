//
//  MockAPIService.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct MockAPIService: Serviceable {
    
    let dummyData = DummyData()
    var isSuccess = true
    
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, HTTPError>) -> Void) {
        if isSuccess {
            completion(.success(dummyData.makeDummydata(type: T.self)))
        } else {
            completion(.failure(.statusCode(404)))
        }
    }
    
}
