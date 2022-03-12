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

    func test_네트워크정상_소켓데이터_응답시_가격변경() throws {
        let socket = MockSocketService(isSuccess: true)
        currentMarketPriceViewModel.createSocket(socket)
        
        XCTAssertTrue(self.currentMarketPriceViewModel.price.value.currentPrice.isEmpty)
        XCTAssertTrue(self.currentMarketPriceViewModel.price.value.changePrice.isEmpty)
        XCTAssertTrue(self.currentMarketPriceViewModel.price.value.changeRate.isEmpty)
        
        let expectation = XCTestExpectation(description: "sendMessage")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        
        let expectationPrice = "1500"
        let expectationChangePrice = "500"
        let expectationChangeRate = "50"
        
        XCTAssertEqual(expectationPrice, self.currentMarketPriceViewModel.price.value.currentPrice)
        XCTAssertEqual(expectationChangePrice, self.currentMarketPriceViewModel.price.value.changePrice)
        XCTAssertEqual(expectationChangeRate, self.currentMarketPriceViewModel.price.value.changeRate)
    }
    
    func test_Socket연결실패_요청실패() throws {
        let socket = MockSocketService(isSuccess: false)
        currentMarketPriceViewModel.createSocket(socket)
        
        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        currentMarketPriceViewModel.errorHandler = executeError
        
        let expectation = XCTestExpectation(description: "sendMessage")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
    }

}
