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
    var socket: SocketServiceable!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        socket = MockSocketService()
        orderbookViewModel = OrderbookViewModel(service: service, socket: socket, symbol: "")
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
        
        print(orderbookViewModel.orderbook.value)
        XCTAssertEqual(resultAskPrice, expectationAskPrice)
        XCTAssertEqual(resultAskQuantity, expectationAskQuantity)
        XCTAssertEqual(resultBidsPrice, expectationBidsPrice)
        XCTAssertEqual(resultBidsQuantity, expectationBidsQuantity)
    }

    func test_API네트워크_요청실패() throws {
        service = MockAPIService(isSuccess: false)
        orderbookViewModel = OrderbookViewModel(service: service, socket: socket, symbol: "")
        
        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        orderbookViewModel.errorHandler = executeError
        orderbookViewModel.fetchOrderbook()
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
        XCTAssertTrue(orderbookViewModel.orderbook.value.asks.isEmpty)
        XCTAssertTrue(orderbookViewModel.orderbook.value.bids.isEmpty)
    }
    
    func test_Socket네트워크_요청실패() throws {
        socket = MockSocketService(isSuccess: false)
        orderbookViewModel = OrderbookViewModel(service: service, socket: socket, symbol: "")
        
        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        orderbookViewModel.errorHandler = executeError
        orderbookViewModel.fetchOrderbook()
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
        XCTAssertFalse(orderbookViewModel.orderbook.value.asks.isEmpty)
        XCTAssertEqual(orderbookViewModel.orderbook.value.asks[0].price, "1")
    }
    
}
