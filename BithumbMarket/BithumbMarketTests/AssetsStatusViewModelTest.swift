//
//  AssetsStatusViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class AssetsStatusViewModelTest: XCTestCase {

    var assetsStatusViewModel: AssetsStatusViewModel!
    var service: Serviceable!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        assetsStatusViewModel = AssetsStatusViewModel(service: service, symbol: "")
    }

    override func tearDownWithError() throws {
        service = nil
        assetsStatusViewModel = nil
    }

    func testExample() throws {
    }

}
