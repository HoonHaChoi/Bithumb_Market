//
//  OrderbookViewModel.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/02/25.
//

import Foundation

//TODO: ViewModel 타입 불필요시 제거
protocol OrderbookViewModelType {
    var binding: () -> Void { get set}
    
    var asksPrice: [String]? { get }
    var asksQuanity: [String]? { get }
    var bidsPrice: [String]? { get }
    var bidsQuanity: [String]? { get }
}

class OrderbookViewModel: OrderbookViewModelType {

    //TODO: 뷰와 의존 관계에 따라 변경 및 추가
    var binding: () -> Void = { }
    
    private var orderbookData: OrderbookData? {
        didSet {
            binding()
        }
    }
    
    //TODO: TableViewDataSource에 따라 필요없는 프로퍼티 제거 및 추가
    var asksPrice: [String]?
    var asksQuanity: [String]?
    var bidsPrice: [String]?
    var bidsQuanity: [String]?
    
    //TODO: Quanity 연산 작업
    
    private let url = EndPoint().makeURL(of: .orderBook, param: "BTC_KRW")
    
    init(service: APIService) {
        service.request(url: url) { [weak self] (result: Result<Orderbook, HTTPError>) in
            switch result {
            case .success(let success):
                self?.orderbookData = success.data
                self?.asksPrice = self?.orderbookData?.asks.map{ $0.quantity }
                self?.bidsPrice = self?.orderbookData?.asks.map{ $0.quantity }
                self?.bidsQuanity = self?.orderbookData?.bids.map{ $0.price }
            case .failure(let failure):
                //TODO: fail 처리
                print(failure)
            }
        }
    }
    
}
