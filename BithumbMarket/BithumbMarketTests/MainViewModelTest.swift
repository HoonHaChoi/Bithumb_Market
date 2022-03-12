//
//  MainViewModelTest.swift
//  BithumbMarketTests
//
//  Created by HOONHA CHOI on 2022/03/13.
//

import XCTest

class MainViewModelTest: XCTestCase {

    var service: TickerServiceable!
    var storage: LikeStorgeType!
    var socket: SocketServiceable!
    var mainViewModel: MainViewModel!
    
    override func setUpWithError() throws {
        service = MockAPIService()
        storage = MockLikeStorage(isSuccess: true)
        socket = MockSocketService()
        mainViewModel = MainViewModel(service: service, storage: storage, socket: socket)
    }

    override func tearDownWithError() throws {
        service = nil
        storage = nil
        socket = nil
        mainViewModel = nil
    }

    func testExample() throws {
    }

}
