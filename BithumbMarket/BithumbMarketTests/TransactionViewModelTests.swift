//
//  BithumbMarketTests.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class TransactionViewModelTests: XCTestCase {
    
    var transactionViewModel: TransactionViewModel!
    var service: Serviceable!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        transactionViewModel = TransactionViewModel(service: service, symbol: "")
    }

    override func tearDownWithError() throws {
        service = nil
        transactionViewModel = nil
    }

    func test_체결내역_요청성공() throws {
        transactionViewModel.fetchTransaction()
        
        let resultTransactionDataType = transactionViewModel.transactionData.value[0].type
        let resultTransactionDataPrice = transactionViewModel.transactionData.value[0].price
        let resultTransactionDataTotal = transactionViewModel.transactionData.value[1].total
        
        let expectationTransactionType = "ask"
        let expectationTransactionPrice = "1"
        let expectationTransactionTotal = "1"
        
        XCTAssertEqual(resultTransactionDataType, expectationTransactionType)
        XCTAssertEqual(resultTransactionDataPrice, expectationTransactionPrice)
        XCTAssertEqual(resultTransactionDataTotal, expectationTransactionTotal)
    }
    
    func test_채결내역_요청실패() throws {
        service = MockAPIService(isSuccess: false)
        transactionViewModel = TransactionViewModel(service: service, symbol: "")

        let error: (Error) -> Void = { error in
            XCTAssertEqual(error.localizedDescription, "연결에 실패 하였습니다.")
        }
        
        transactionViewModel.errorHandler = error
        transactionViewModel.fetchTransaction()
        
        XCTAssertTrue(transactionViewModel.transactionData.value.isEmpty)
    }
    
}
