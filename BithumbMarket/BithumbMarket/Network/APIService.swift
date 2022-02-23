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
    
    func requestResource(url: URL?, completion: @escaping (Result<Data, HTTPError>) -> Void) {
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
        }
    }
    
}
