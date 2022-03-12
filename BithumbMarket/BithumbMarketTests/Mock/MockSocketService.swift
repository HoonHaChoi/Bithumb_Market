//
//  MockSocketService.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct MockSocketService: SocketServiceable {
    
    let dummyData = DummyData()
    var isSuccess = true
    
    func sendMessage(message: Message) {
        return
    }
    
    func perform<T>(completion: @escaping (Result<T, HTTPError>) -> Void) where T : Decodable {
        if isSuccess {
            completion(.success(dummyData.makeSocketDummydata(type: T.self)))
        } else {
            completion(.failure(.statusCode(404)))
        }
    }
    
    func disconnect() {
        return
    }
    
}
