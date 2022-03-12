//
//  AssetsStatusViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class AssetsStatusViewModelTest: XCTestCase {
    
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func test_입출금_불가() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, index: 0)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let resultStatus: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .impossible)
        }
        
        viewmodel.assetsStateHandler = resultStatus
        viewmodel.fetchAssetsStatus()
    }
    
    func test_입금불가_출금가능() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, index: 1)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let resultStatus: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .possibleWithdrawal)
        }
        
        viewmodel.assetsStateHandler = resultStatus
        viewmodel.fetchAssetsStatus()
    }

    func test_입금가능_출금불가() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, index: 2)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let resultStatus: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .possibleDeposit)
        }
        
        viewmodel.assetsStateHandler = resultStatus
        viewmodel.fetchAssetsStatus()
    }
    
    func test_입출금_가능() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, index: 3)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let resultStatus: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .possibleAll)
        }
        
        viewmodel.assetsStateHandler = resultStatus
        viewmodel.fetchAssetsStatus()
    }
    
    func test_요청실패() throws {
        let service = MockAssetsStatusAPIService(isSuccess: false, index: 0)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let resultError: (HTTPError) -> Void = { error in
            XCTAssertEqual(error.errorDescription, "연결에 실패 하였습니다.")
        }
    
        viewmodel.errorHandler = resultError
        viewmodel.fetchAssetsStatus()
    }
    
}
