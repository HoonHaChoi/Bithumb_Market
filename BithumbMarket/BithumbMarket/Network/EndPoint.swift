//
//  EndPoint.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/23.
//

import Foundation

protocol Endpoint {
    var baseURLString: String { get }
    var path: String { get }
}

extension Endpoint {
    var url: URL? {
        return URL(string: baseURLString + path)
    }
}
