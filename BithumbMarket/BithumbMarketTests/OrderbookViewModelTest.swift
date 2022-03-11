//
//  OrderbookViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class OrderbookViewModelTest: XCTestCase {
    
    var orderbookViewModel: OrderbookViewModel!
    var service: Serviceable!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        orderbookViewModel = OrderbookViewModel(service: service, symbol: "")
    }

    override func tearDownWithError() throws {
        service = nil
        orderbookViewModel = nil
    }

    func testExample() throws {
        
    }

}
