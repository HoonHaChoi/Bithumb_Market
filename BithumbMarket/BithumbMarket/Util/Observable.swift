//
//  Observable.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import Foundation

final class Observable<T> {
    
    var bind: ((T) -> Void)?
    
    var value :T {
        didSet {
            bind?(value)
        }
    }
    
    init(_ v :T) {
        value = v
    }
    
    func subscribe(bind: @escaping (T) -> Void) {
        bind(value)
        self.bind = bind
    }
}
