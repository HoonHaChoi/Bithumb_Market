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
        
        let expectedOrderBookAskPrice = orderbookViewModel.orderbook.value.asks[0].price
        let expectedOrderBookAskQuantity = orderbookViewModel.orderbook.value.asks[0].quantity
        let expectedOrderBookBidsPrice = orderbookViewModel.orderbook.value.bids[0].price
        let expectedOrderBookBidsQuantity = orderbookViewModel.orderbook.value.bids[0].quantity
        
        let expectOrderBookAskPrice = "1"
        let expectOrderBookAskQuantity = "1"
        let expectOrderBookBidsPrice = "11111"
        let expectOrderBookBidsQuantity = "11111"
        
        XCTAssertEqual(expectedOrderBookAskPrice, expectOrderBookAskPrice)
        XCTAssertEqual(expectedOrderBookAskQuantity, expectOrderBookAskQuantity)
        XCTAssertEqual(expectedOrderBookBidsPrice, expectOrderBookBidsPrice)
        XCTAssertEqual(expectedOrderBookBidsQuantity, expectOrderBookBidsQuantity)
    }

    func test_호가_요청실패() throws {
        service = MockAPIService(isSuccess: false)
        service.request(endpoint: .orderBook(symbol: "")) { (result: Result<Orderbook, HTTPError>) -> Void in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let failure):
                XCTAssertEqual(failure.errorDescription, "연결에 실패 하였습니다.")
            }
        }
        
        orderbookViewModel = OrderbookViewModel(service: service, symbol: "")
        orderbookViewModel.fetchOrderbook()
        
        XCTAssertTrue(orderbookViewModel.orderbook.value.bids.isEmpty)
        XCTAssertTrue(orderbookViewModel.orderbook.value.asks.isEmpty)
    }
}
