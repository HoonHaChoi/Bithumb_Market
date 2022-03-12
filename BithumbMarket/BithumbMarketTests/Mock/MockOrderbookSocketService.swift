//
//  MockOrderbookSocketService.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import Foundation

struct MockOrderbookSocketService: SocketServiceable {
    
    var isSuccess = true
    var receiveOrderbook: ReceiveOrderbook
    
    func sendMessage(message: Message) {
        return
    }
    
    func perform<T>(completion: @escaping (Result<T, HTTPError>) -> Void) where T : Decodable {
        if isSuccess {
            completion(.success(receiveOrderbook as! T))
        } else {
            completion(.failure(.statusCode(404)))
        }
    }
    
    func disconnect() {
        return
    }
    
}
