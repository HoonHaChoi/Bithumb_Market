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
        
        let status: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .impossible)
        }
        
        viewmodel.assetsStateHandler = status
        viewmodel.fetchAssetsStatus()
    }
    
    func test_입금불가_출금가능() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, index: 1)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let status: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .possibleWithdrawal)
        }
        
        viewmodel.assetsStateHandler = status
        viewmodel.fetchAssetsStatus()
    }

    func test_입금가능_출금불가() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, index: 2)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let status: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .possibleDeposit)
        }
        
        viewmodel.assetsStateHandler = status
        viewmodel.fetchAssetsStatus()
    }
    
    func test_입출금가능() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, index: 3)
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        let status: ((AssetsState) -> Void)? = {
            XCTAssertEqual($0, .possibleAll)
        }
        
        viewmodel.assetsStateHandler = status
        viewmodel.fetchAssetsStatus()
    }
    
}
