//
//  SocketService.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation
import Starscream

struct SocketService {
    
    private var webSocket: WebSocket
    
    init(url: URL) {
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 5
        self.webSocket = .init(request: urlRequest)
        self.webSocket.connect()
    }
    
    func sendMessage(data: Data) {
        webSocket.write(data: data)
    }
    
    func disconnect() {
        webSocket.disconnect()
    }
    
    func performString(completion: @escaping (String) -> Void) {
        webSocket.onEvent = { result in
            switch result {
            case .text(let string):
                perform(message: string, completion: completion)
            default:
                break
            }
        }
    }
    
    private func isSuccessMessage(to message: String) -> Bool {
        let prefix = "{\"status\":\"0000\""
        return message.hasPrefix(prefix)
    }
    
    private func perform(message: String, completion: @escaping (String) -> Void) {
        if !isSuccessMessage(to: message) {
            completion(message)
        } else {
            print(message)
        }
    }
    
}
