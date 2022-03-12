//
//  MainViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/13.
//

import XCTest

class MainViewModelTest: XCTestCase {

    var service: TickerServiceable!
    var storage: LikeStorgeType!
    var socket: SocketServiceable!
    var mainViewModel: MainViewModel!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        storage = MockLikeStorage()
        socket = MockSocketService()
        mainViewModel = MainViewModel(service: service, storage: storage, socket: socket)
    }

    override func tearDownWithError() throws {
        service = nil
        storage = nil
        socket = nil
        mainViewModel = nil
    }

    func test_네트워크정상_코인목록_요청성공_및_소켓업데이트() throws {
        mainViewModel.fetchTickers()
        
        let resultTickerSymbol = mainViewModel.tickers.value[0].symbol
        let resultTickerClosePrice = mainViewModel.tickers.value[0].market.closingPrice
        
        let expectationTickerSymbol = "Fake"
        let expectationTickerClosePrice = "1500"
        
        XCTAssertEqual(resultTickerSymbol, expectationTickerSymbol)
        XCTAssertEqual(resultTickerClosePrice, expectationTickerClosePrice)
    }
    
    func test_API네트워크실패_요청실패() throws {
        service = MockAPIService(isSuccess: false)
        mainViewModel = MainViewModel(service: service, storage: storage, socket: socket)
        
        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        mainViewModel.errorHandler = executeError
        mainViewModel.fetchTickers()
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
    }
    
    func test_API네트워크정상_Socket네트워크실패_API요청만_성공한경우() throws {
        socket = MockSocketService(isSuccess: false)
        mainViewModel = MainViewModel(service: service, storage: storage, socket: socket)
        
        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        mainViewModel.errorHandler = executeError
        mainViewModel.fetchTickers()
        
        let resultTickerClosePrice = mainViewModel.tickers.value[0].market.closingPrice
        let expectationTickerClosePrice = "12"
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
        XCTAssertEqual(resultTickerClosePrice, expectationTickerClosePrice)
    }

    func test_관심클릭시_관심심볼과_일치한_코인목록_불러오기() throws {
        var resultTickers: [Ticker]?
        let executeTickers: ([Ticker]) -> Void = { tickers in
            resultTickers = tickers
        }
        mainViewModel.updateTickersHandler = executeTickers
        mainViewModel.fetchTickers()
        mainViewModel.executeFilterTickers()
        
        let resultTickerCount = resultTickers?.count
        let resultTickerSymbol = resultTickers?[0].symbol
        
        let expectationTickerCount = 1
        let expectationTickerSymbol = "Fake"
        
        XCTAssertEqual(resultTickerCount, expectationTickerCount)
        XCTAssertEqual(resultTickerSymbol, expectationTickerSymbol)
    }
    
    func test_관심목록중_업데이트된_코인_인덱스() throws {
        var resultIndex: Int?
        let executeTickers: (Int) -> Void = { index in
            resultIndex = index
        }
        mainViewModel.changeIndexHandler = executeTickers
        mainViewModel.executeFilterTickers()
        mainViewModel.fetchTickers()
        
        let expectationIndex = 0
        
        XCTAssertEqual(resultIndex, expectationIndex)
    }
}
