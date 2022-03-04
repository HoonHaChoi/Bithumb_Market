//
//  MainDataSource.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/02/28.
//

import UIKit

final class MainDataSource: NSObject, UITableViewDataSource {
    
    var items: [Ticker]
    var filterItems: [Ticker]
    var isFiltering: Bool
    
    override init() {
        items = .init()
        filterItems = .init()
        isFiltering = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterItems.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TickerCell.reuseidentifier, for: indexPath) as? TickerCell else {
            return .init()
        }
        
        if isFiltering {
            cell.configure(ticker: filterItems[indexPath.row])
        } else {
            cell.configure(ticker: items[indexPath.row])
        }
        return cell
    }

}
