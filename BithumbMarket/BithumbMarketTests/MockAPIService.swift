//
//  MockAPIService.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct MockAPIService: Serviceable {
    
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, HTTPError>) -> Void) {
    }
    
    func requestTickers(endpoint: APIEndpoint, completion: @escaping (Result<[Ticker], HTTPError>) -> Void) {
        
    }
}
