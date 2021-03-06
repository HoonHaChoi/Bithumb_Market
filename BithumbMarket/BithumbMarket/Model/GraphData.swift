//
//  GraphData.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/08.
//

import Foundation

struct GraphData {
    
    let dateList: [String]
    let closePriceList: [Double]
    let openPriceList: [Double]
    let minPriceList: [Double]
    let maxPriceList: [Double]
    
    var count: Int {
        dateList.count
    }
    
    var startPoint: Int {
        if dateList.count > 30 {
            return dateList.count - 30
        }
        return .zero
    }
    
    var previewGraphData: GraphData {
        .init(dateList: dateList[startPoint...].map { $0 },
              closePriceList: closePriceList[startPoint...].map { $0 },
              openPriceList: openPriceList[startPoint...].map { $0 },
              minPriceList: minPriceList[startPoint...].map { $0 },
              maxPriceList: maxPriceList[startPoint...].map { $0 })
    }
    
}
