//
//  CandleStick.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/03.
//

import Foundation

struct CandleStick: Decodable {
    let status: String
    let data: [GraphData]
}

struct GraphData: Decodable {
    let time: Double
    let openPrice: String
    let closPrice: String
    let maxPrice: String
    let minPrice: String
    let unitsTraded: String
    
    var date: Date {
        return Date(timeIntervalSince1970: time / 1000 )
    }
}

extension GraphData {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.time = try container.decode(Double.self)
        self.openPrice = try container.decode(String.self)
        self.closPrice = try container.decode(String.self)
        self.maxPrice = try container.decode(String.self)
        self.minPrice = try container.decode(String.self)
        self.unitsTraded = try container.decode(String.self)
    }
    
    func toEntity() -> GraphDataEntity {
        .init(time: self.time,
              openPrice: self.openPrice,
              closePrice: self.closPrice,
              minPrice: self.minPrice,
              maxPrice: self.maxPrice,
              unitsTraded: self.unitsTraded)
    }
}
