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
    
    var priceOfAsks: [String]? { get }
    var quantityOfAsks: [String]? { get }
    var priceOfBids: [String]? { get }
    var quantityOfBids: [String]? { get }
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
    var priceOfAsks: [String]?
    var quantityOfAsks: [String]?
    var priceOfBids: [String]?
    var quantityOfBids: [String]?
    
    //TODO: 수정
    private func calculateRateOfQuintity(quantities: [String], quantity: String) -> Float {
        let quantities = quantities.map { Float($0) ?? 0 }
        let sumOfQuantities = quantities.reduce(0){ $0 + $1}
        return Float(quantity) ?? 0 / sumOfQuantities * 5
    }
    
    private let url = EndPoint().makeURL(of: .orderBook, param: "BTC_KRW")
    
    init(service: APIService) {
        service.request(url: url) { [weak self] (result: Result<OrderbookEntity, HTTPError>) in
            switch result {
            case .success(let success):
                self?.orderbookData = success.data
                self?.priceOfAsks = self?.orderbookData?.asks.map{ $0.price }
                self?.quantityOfAsks = self?.orderbookData?.asks.map{ $0.quantity }
                self?.priceOfBids = self?.orderbookData?.bids.map{ $0.price }
                self?.quantityOfBids = self?.orderbookData?.asks.map{ $0.quantity }
            case .failure(let failure):
                //TODO: fail 처리
                print(failure)
            }
        }
    }
    
}
