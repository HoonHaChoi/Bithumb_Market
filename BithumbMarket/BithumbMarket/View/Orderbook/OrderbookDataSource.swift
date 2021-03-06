//
//  OrderbookTableViewDataSource.swift
//  BithumbMarket
//
//  Created by Doyoung on 2022/03/02.
//

import UIKit

final class OrderbookDataSource: NSObject, UITableViewDataSource {
    
    var items: OrderbookData
    
    enum OrderType: CaseIterable {
        case ask
        case bid
        
        var section: Int {
            switch self {
            case .ask:
                return 0
            case .bid:
                return 1
            }
        }
    }
    
    override init() {
        items = .init(
            asks: Array(repeating: .init(quantity: "", price: ""), count: 30),
            bids: Array(repeating: .init(quantity: "", price: ""), count: 30))
    }
    
    func updateCellData(by orderbook: OrderbookData) {
        self.items = orderbook
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return OrderType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case OrderType.ask.section:
            return items.asks.count
        case OrderType.bid.section:
            return items.bids.count
        default:
            return Int.zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderbookNameSpace.cellReuseIdentifier, for: indexPath) as? OrderbookTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(items: items, section: indexPath.section, index: indexPath.row)
        return cell
    }
    
}
