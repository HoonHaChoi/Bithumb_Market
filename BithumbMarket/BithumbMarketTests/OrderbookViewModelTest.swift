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

    func test_호가_요청성공() throws {
        orderbookViewModel.fetchOrderbook()
        
        let resultAskPrice = orderbookViewModel.orderbook.value.asks[0].price
        let resultAskQuantity = orderbookViewModel.orderbook.value.asks[0].quantity
        let resultBidsPrice = orderbookViewModel.orderbook.value.bids[0].price
        let resultBidsQuantity = orderbookViewModel.orderbook.value.bids[0].quantity
        
        let expectationAskPrice = "1"
        let expectationAskQuantity = "1"
        let expectationBidsPrice = "11111"
        let expectationBidsQuantity = "11111"
        
        XCTAssertEqual(resultAskPrice, expectationAskPrice)
        XCTAssertEqual(resultAskQuantity, expectationAskQuantity)
        XCTAssertEqual(resultBidsPrice, expectationBidsPrice)
        XCTAssertEqual(resultBidsQuantity, expectationBidsQuantity)
    }

    func test_호가_요청실패() throws {
        service = MockAPIService(isSuccess: false)
        orderbookViewModel = OrderbookViewModel(service: service, symbol: "")
        
        let error: (Error) -> Void = { error in
            XCTAssertEqual(error.localizedDescription, "연결에 실패 하였습니다.")
        }
        orderbookViewModel.errorHandler = error
        orderbookViewModel.fetchOrderbook()
        
        XCTAssertTrue(orderbookViewModel.orderbook.value.bids.isEmpty)
        XCTAssertTrue(orderbookViewModel.orderbook.value.asks.isEmpty)
    }
    
}
