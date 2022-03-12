//
//  AssetsStatusViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class AssetsStatusViewModelTest: XCTestCase {

    func test_네트워크정상_입출금_불가() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, assetsState: .init(data: AssetsStatusData(depositStatus: 0,
                                                                                                            withdrawalStatus: 0)))
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        var resultStatus: AssetsState?
        let executeAssetState: ((AssetsState) -> Void)? = { state in
            resultStatus = state
        }
        
        viewmodel.assetsStateHandler = executeAssetState
        viewmodel.fetchAssetsStatus()
        
        XCTAssertEqual(resultStatus, .impossible)
    }
    
    func test_네트워크정상_입금불가_출금가능() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, assetsState: .init(data: AssetsStatusData(depositStatus: 1,
                                                                                                            withdrawalStatus: 0)))
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        var resultStatus: AssetsState?
        let executeAssetState: ((AssetsState) -> Void)? = { state in
            resultStatus = state
        }
        
        viewmodel.assetsStateHandler = executeAssetState
        viewmodel.fetchAssetsStatus()
        
        XCTAssertEqual(resultStatus, .possibleDeposit)
    }

    func test_네트워크정상_입금가능_출금불가() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, assetsState: .init(data: AssetsStatusData(depositStatus: 0,
                                                                                                            withdrawalStatus: 1)))
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        var resultStatus: AssetsState?
        let executeAssetState: ((AssetsState) -> Void)? = { state in
            resultStatus = state
        }
        
        viewmodel.assetsStateHandler = executeAssetState
        viewmodel.fetchAssetsStatus()
        
        XCTAssertEqual(resultStatus, .possibleWithdrawal)
    }
    
    func test_네트워크정상_입출금_가능() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, assetsState: .init(data: AssetsStatusData(depositStatus: 1,
                                                                                                            withdrawalStatus: 1)))
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        var resultStatus: AssetsState?
        let executeAssetState: ((AssetsState) -> Void)? = { state in
            resultStatus = state
        }
        
        viewmodel.assetsStateHandler = executeAssetState
        viewmodel.fetchAssetsStatus()
        
        XCTAssertEqual(resultStatus, .possibleAll)
    }
    
    func test_네트워크연결실패_요청실패() throws {
        let service = MockAssetsStatusAPIService(isSuccess: false, assetsState: .init(data: AssetsStatusData(depositStatus: 1,
                                                                                                            withdrawalStatus: 1)))
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        var resultError: HTTPError?
        let executeError: (HTTPError) -> Void = { error in
            resultError = error
        }
    
        viewmodel.errorHandler = executeError
        viewmodel.fetchAssetsStatus()
        
        XCTAssertEqual(resultError?.localizedDescription, "연결에 실패 하였습니다.")
    }
    
    func test_네트워크정상_비정상데이터_AssetsStatusData() throws {
        let service = MockAssetsStatusAPIService(isSuccess: true, assetsState: .init(data: AssetsStatusData(depositStatus: 123123,
                                                                                                            withdrawalStatus: 523123)))
        let viewmodel = AssetsStatusViewModel(service: service, symbol: "")
        
        var resultStatus: AssetsState?
        let executeAssetState: ((AssetsState) -> Void)? = { state in
            resultStatus = state
        }
        
        viewmodel.assetsStateHandler = executeAssetState
        viewmodel.fetchAssetsStatus()
        
        XCTAssertEqual(resultStatus, .impossible)
    }
    
}
