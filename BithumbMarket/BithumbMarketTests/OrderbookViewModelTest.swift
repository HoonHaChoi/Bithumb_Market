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
        socket = nil
        orderbookViewModel = nil
    }

    func test_네트워크정상_새로운매도_호가데이터_추가() throws {
        let receiveOrderbook = ReceiveOrderbook(content: ReceiveOrderList(list: [ReceiveOrder(orderType: "ask",
                                                                                                     price: "10000",
                                                                                                     quantity: "10",
                                                                                                     total: "0")]))
        socket = MockOrderbookSocketService(receiveOrderbook: receiveOrderbook)
        orderbookViewModel = OrderbookViewModel(service: service, socket: socket, symbol: "")
        
        orderbookViewModel.fetchOrderbook()
        
        let resultAskFirstPrice = orderbookViewModel.orderbook.value.asks[1].price
        let resultAskFirstQuantity = orderbookViewModel.orderbook.value.asks[1].quantity
        let resultAskSecondPrice = orderbookViewModel.orderbook.value.asks[0].price
        let resultAskSecondQuantity = orderbookViewModel.orderbook.value.asks[0].quantity
        
        let expectationAskFirstPrice = "1"
        let expectationAskFirstQuantity = "1"
        let expectationAskSecondPrice = "10000"
        let expectationAskSecondQuantity = "10"
    
        XCTAssertEqual(resultAskFirstPrice, expectationAskFirstPrice)
        XCTAssertEqual(resultAskFirstQuantity, expectationAskFirstQuantity)
        XCTAssertEqual(resultAskSecondPrice, expectationAskSecondPrice)
        XCTAssertEqual(resultAskSecondQuantity, expectationAskSecondQuantity)
    }
    
    func test_네트워크정상_같은가격_매도_호가데이터_quantity_0인경우() throws {
        let receiveOrderbook = ReceiveOrderbook(content: ReceiveOrderList(list: [ReceiveOrder(orderType: "ask",
                                                                                                     price: "1",
                                                                                                     quantity: "0",
                                                                                                     total: "0")]))
        socket = MockOrderbookSocketService(receiveOrderbook: receiveOrderbook)
        orderbookViewModel = OrderbookViewModel(service: service, socket: socket, symbol: "")
        
        orderbookViewModel.fetchOrderbook()
        
        XCTAssertTrue(orderbookViewModel.orderbook.value.asks.isEmpty)
    }
    
    func test_네트워크정상_같은가격_매도_호가데이터_quantity_다른경우() throws {
        let receiveOrderbook = ReceiveOrderbook(content: ReceiveOrderList(list: [ReceiveOrder(orderType: "ask",
                                                                                                     price: "1",
                                                                                                     quantity: "50",
                                                                                                     total: "0")]))
        socket = MockOrderbookSocketService(receiveOrderbook: receiveOrderbook)
        orderbookViewModel = OrderbookViewModel(service: service, socket: socket, symbol: "")
        
        orderbookViewModel.fetchOrderbook()
        
        let resultAskPrice = orderbookViewModel.orderbook.value.asks[0].price
        let resultAskQuantity = orderbookViewModel.orderbook.value.asks[0].quantity
        
        let expectationAskPrice = "1"
        let expectationAskQuantity = "50"
        
        XCTAssertEqual(resultAskPrice, expectationAskPrice)
        XCTAssertEqual(resultAskQuantity, expectationAskQuantity)
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
    
    func test_API네트워크정상_Socket네트워크_요청실패() throws {
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
