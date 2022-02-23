//
//  APIService.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

struct APIService {
    
    private let session: URLSession
    private let endpoint: EndPoint
    
    init(session: URLSession = URLSession.shared, endpoint: EndPoint = EndPoint()) {
        self.session = session
        self.endpoint = endpoint
    }
    
    func request<T: Decodable>(url: URL?, completion: @escaping (Result<T, HTTPError>) -> Void) {
        requestResource(url: url) { result in
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
    
    private func decode<T: Decodable>(data: Data) -> Result<T, HTTPError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let decoding = try? decoder.decode(T.self, from: data) else {
            return .failure(.failureDecode)
        }
        return .success(decoding)
    }
    
}
