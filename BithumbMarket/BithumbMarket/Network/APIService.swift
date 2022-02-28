//
//  APIService.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

struct APIService {
    
    private let session: URLSession
    private let socket: SocketService
    
    init(session: URLSession = URLSession(configuration: .ephemeral),
         socket: SocketService = SocketService(url: APIEndpoint.socket.url)) {
        self.session = session
        self.socket = socket
    }
    
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, HTTPError>) -> Void) {
        requestResource(url: endpoint.url) { result in
            switch result {
            case .success(let data):
                let decodeData: Result<T, HTTPError> = decode(data: data)
                
                switch decodeData {
                case .success(let model):
                    completion(.success(model))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestTickers(endpoint: APIEndpoint, completion: @escaping (Result<[Ticker], HTTPError>) -> Void) {
        requestResource(url: endpoint.url) { result in
            switch result {
            case .success(let data):
                let serializeData = serialize(data: data)
                
                switch serializeData {
                case .success(let tickers):
                    completion(.success(tickers))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func requestResource(url: URL?, completion: @escaping (Result<Data, HTTPError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.invalidRequset))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard 200..<300 ~= response.statusCode else {
                completion(.failure(.statusCode(response.statusCode)))
                return
            }
                    
            guard let data = data else {
                completion(.failure(.emptyData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    private func serialize(data: Data) -> Result<[Ticker], HTTPError> {
        guard let serializeData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let bithumbData = serializeData["data"] as? [String: Any] else {
            return .failure(.failureDecode)
        }
        let symbols = bithumbData.keys.filter { $0 != "date" }
        
        var tickers: [Ticker] = []

        for symbol in symbols {
            guard let data = try? JSONSerialization.data(withJSONObject: bithumbData[symbol] ?? [], options: []) else {
                return .failure(.failureDecode)
            }
            let result: Result<Market, HTTPError> = decode(data: data)
            
            switch result {
            case .success(let market):
                tickers.append(Ticker(symbol: symbol, market: market))
            case .failure(let error):
                 return .failure(error)
            }
        }
        
        return .success(tickers)
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
