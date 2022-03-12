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
        storage = MockLikeStorage(isSuccess: true)
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
        
        XCTAssertEqual(resultHasLike, true)
    }
    
    func test_같은_이름의_심볼이_존재하지_않은경우() throws {
        var resultHasLike: Bool?
        let executeHasLike: ((Bool) -> Void)? = { state in
            resultHasLike = state
        }
        
        likeViewModel.hasLikeHandler = executeHasLike
        likeViewModel.hasLike(symbol: "Joke")
        
        XCTAssertEqual(resultHasLike, false)
    }

    func test_같은_이름의_심볼_존재시_삭제_성공한_경우() throws {
        var resultComplete: Bool?
        let executeComplete: (() -> Void)? = {
            resultComplete = true
        }
        
        likeViewModel.updateCompleteHandler = executeComplete
        likeViewModel.updateLike(symbol: "ASD")
        XCTAssertEqual(resultComplete, true)
    }
    
    func test_같은_이름의_심볼_없을시_저장_성공한_경우() throws {
        var resultComplete: Bool?
        let executeComplete: (() -> Void)? = {
            resultComplete = true
        }
        
        likeViewModel.updateCompleteHandler = executeComplete
        likeViewModel.updateLike(symbol: "Joke")
        XCTAssertEqual(resultComplete, true)
    }
    
    func test_같은_이름의_심볼_없을시_심볼_저장에_실패한_경우() throws {
        storage = MockLikeStorage(isSuccess: false)
        likeViewModel = LikeViewModel(storage: storage)
        
        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        likeViewModel.errorHandler = executeError
        likeViewModel.updateLike(symbol: "Joke")
        XCTAssertEqual(resultError?.localizedDescription, "저장에 실패하였습니다.")
    }
    
    func test_같은_이름의_심볼_존재시_심볼_삭제에_실패한_경우() throws {
        storage = MockLikeStorage(isSuccess: false)
        likeViewModel = LikeViewModel(storage: storage)
        
        var resultError: Error?
        let executeError: (Error) -> Void = { error in
            resultError = error
        }
        
        likeViewModel.errorHandler = executeError
        likeViewModel.updateLike(symbol: "ASD")
        XCTAssertEqual(resultError?.localizedDescription, "삭제에 실패하였습니다.")
    }
    
}
