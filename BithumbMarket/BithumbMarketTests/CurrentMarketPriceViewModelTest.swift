//
//  CurrentMarketPriceViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class CurrentMarketPriceViewModelTest: XCTestCase {

    var currentMarketPriceViewModel: CurrentMarketPriceViewModel!
    
    override func setUpWithError() throws {
        currentMarketPriceViewModel = CurrentMarketPriceViewModel(symbol: "")
    }

    override func tearDownWithError() throws {
        currentMarketPriceViewModel = nil
    }
    
}
