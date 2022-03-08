//
//  GraphDataEntity.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/08.
//

import Foundation

public class GraphDataEntity: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true

    public let time: Double
    public let openPrice: String
    public let closPrice: String
    public let minPrice: String
    public let maxPrice: String
    public let unitsTraded: String

    init(time: Double, openPrice: String, closePrice: String, minPrice: String, maxPrice: String, unitsTraded: String) {
        self.time = time
        self.openPrice = openPrice
        self.closPrice = closePrice
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.unitsTraded = unitsTraded
    }
    
    enum key: String {
        case time = "time"
        case openPrice = "openPrice"
        case closePrice = "closePrice"
        case minPrice = "minPrice"
        case maxPrice = "maxPrice"
        case unitsTraded = "unitsTraded"
    }
    
    var date: Date {
        return Date(timeIntervalSince1970: time / 1000)
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(time, forKey: key.time.rawValue)
        coder.encode(openPrice, forKey: key.openPrice.rawValue)
        coder.encode(closPrice, forKey: key.closePrice.rawValue)
        coder.encode(minPrice, forKey: key.minPrice.rawValue)
        coder.encode(maxPrice, forKey: key.maxPrice.rawValue)
        coder.encode(unitsTraded, forKey: key.unitsTraded.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mtime = coder.decodeDouble(forKey: key.time.rawValue)
        let openPrice = coder.decodeObject(forKey: key.openPrice.rawValue) as! String
        let closPrice = coder.decodeObject(forKey: key.closePrice.rawValue) as! String
        let minPrice = coder.decodeObject(forKey: key.minPrice.rawValue) as! String
        let maxPrice = coder.decodeObject(forKey: key.maxPrice.rawValue) as! String
        let unitsTraded = coder.decodeObject(forKey: key.unitsTraded.rawValue) as! String
        
        self.init(time: mtime,
                  openPrice: openPrice ,
                  closePrice: closPrice,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  unitsTraded: unitsTraded)
    }
    
}
