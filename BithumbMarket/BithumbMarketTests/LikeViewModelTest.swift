//
//  LikeViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/12.
//

import XCTest

class LikeViewModelTest: XCTestCase {

    var storage: LikeStorgeType!
    var likeViewModel: LikeViewModel!
    
    override func setUpWithError() throws {
        storage = MockLikeStorage()
        likeViewModel = LikeViewModel(storage: storage)
    }

    override func tearDownWithError() throws {
        storage = nil
        likeViewModel = nil
    }

    func testExample() throws {
        
    }

}
