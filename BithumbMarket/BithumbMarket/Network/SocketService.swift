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
    
    init(url: URL?) {
        let urlRequest = URLRequest(url: url!)
        self.webSocket = .init(request: urlRequest)
        self.webSocket.connect()
    }
        
    func sendMessage(data: Data) {
        webSocket.write(data: data)
    }
    
    func disconnect() {
        webSocket.disconnect()
    }
    
    func reciveText(completion: @escaping (String) -> Void) {
        webSocket.onEvent = { result in
            switch result {
            case .text(let string):
                shouldConfirm(message: string, completion: completion)
            default:
                break
            }
        }
    }
    
    private func isSuccessMessage(to message: String) -> Bool {
        let prefix = "{\"status\":\"0000\""
        return message.hasPrefix(prefix)
    }
    
    private func shouldConfirm(message: String, completion: @escaping (String) -> Void) {
        if !isSuccessMessage(to: message) {
            completion(message)
        }
    }
    
}
