//
//  SocketService.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation
import Starscream

final class SocketService {
    
    private var webSocket: WebSocket
    
    init() {
        let urlRequest = URLRequest(url: APIEndpoint.socket.url!)
        self.webSocket = .init(request: urlRequest)
        self.webSocket.connect()
    }
    
    func sendMessage(message: Message) {
        guard let encoder = try? JSONEncoder().encode(message) else {
            return
        }
        webSocket.write(data: encoder)
    }
    
    func disconnect() {
        webSocket.disconnect()
    }
    
    func reciveText(completion: @escaping (String) -> Void) {
        webSocket.onEvent = { [weak self] result in
            switch result {
            case .text(let string):
                self?.shouldConfirm(message: string, completion: completion)
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
    
    func perform<T: Decodable>(completion: @escaping (Result<T, HTTPError>) -> Void) {
        reciveText { [weak self] tickerString in
            guard let self = self else { return }
            guard let data = tickerString.data(using: .utf8) else {
                completion(.failure(.failureDecode))
                return
            }
            completion(self.decode(data: data))
        }
    }
    
    private func decode<T: Decodable>(data: Data) -> Result<T, HTTPError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let decoding = try? decoder.decode(T.self, from: data) else {
            return .failure(.failureDecode)
        }
        return .success(decoding)
    }
    
}
