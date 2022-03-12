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
    var socketService: SocketServiceable!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        socketService = MockSocketService()
        transactionViewModel = TransactionViewModel(service: service, socket: socketService , symbol: "")
    }

    override func tearDownWithError() throws {
        service = nil
        socketService = nil
        transactionViewModel = nil
    }

    func test_네트워크정상_체결내역_요청성공() throws {
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
        
        let resultSocketTransactionDataType = transactionViewModel.transactionData.value[2].type
        let resultSocketTransactionDataPrice = transactionViewModel.transactionData.value[2].price
        let resultSocketTransactionDataTotal = transactionViewModel.transactionData.value[2].total
        let resultSocketTransactionDataCount = transactionViewModel.transactionData.value.count
        
        let expectationSocketTransactionType = "1"
        let expectationSocketTransactionPrice = "1"
        let expectationSocketTransactionTotal = "100.0"
        let expectationSocketTransactionCount = 3
        
        XCTAssertEqual(resultSocketTransactionDataType, expectationSocketTransactionType)
        XCTAssertEqual(resultSocketTransactionDataPrice, expectationSocketTransactionPrice)
        XCTAssertEqual(resultSocketTransactionDataTotal, expectationSocketTransactionTotal)
        XCTAssertEqual(resultSocketTransactionDataCount, expectationSocketTransactionCount)
        
    }
    
    func test_API네트워크_요청실패() throws {
        service = MockAPIService(isSuccess: false)
        socketService = MockSocketService(isSuccess: true)
        transactionViewModel = TransactionViewModel(service: service, socket: socketService , symbol: "")

        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        transactionViewModel.errorHandler = executeError
        transactionViewModel.fetchTransaction()
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
        XCTAssertTrue(transactionViewModel.transactionData.value.isEmpty)
    }
    
    func test_Socket네트워크_요청실패() throws {
        service = MockAPIService(isSuccess: true)
        socketService = MockSocketService(isSuccess: false)
        transactionViewModel = TransactionViewModel(service: service, socket: socketService , symbol: "")

        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        transactionViewModel.errorHandler = executeError
        transactionViewModel.fetchTransaction()
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
        XCTAssertFalse(transactionViewModel.transactionData.value.isEmpty)
    }

}
