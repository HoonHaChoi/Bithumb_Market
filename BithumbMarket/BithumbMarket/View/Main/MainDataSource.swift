//
//  MainDataSource.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import UIKit

final class MainDataSource: NSObject, UITableViewDataSource {
    
    var items: [Ticker]
    
    override init() {
        items = .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TickerCell.reuseidentifier, for: indexPath) as? TickerCell else {
            return .init()
        }
        cell.configure(ticker: items[indexPath.row])
        return cell
    }
    
}
