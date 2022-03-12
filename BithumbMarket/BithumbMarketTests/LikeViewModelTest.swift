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

    func test_같은_이름의_심볼이_존재하는경우() throws {
        var resultHasLike: Bool?
        let executeHasLike: ((Bool) -> Void)? = { state in
            resultHasLike = state
        }
        
        likeViewModel.hasLikeHandler = executeHasLike
        likeViewModel.hasLike(symbol: "ASD")
        
        XCTAssertEqual(resultHasLike, true) // 옵셔널이기에 XCTAssertTrue 불가
    }
    
    func test_같은_이름의_심볼이_존재하지_않은경우() throws {
        var resultHasLike: Bool?
        let executeHasLike: ((Bool) -> Void)? = { state in
            resultHasLike = state
        }
        
        likeViewModel.hasLikeHandler = executeHasLike
        likeViewModel.hasLike(symbol: "Fake")
        
        XCTAssertEqual(resultHasLike, false)
    }

}
