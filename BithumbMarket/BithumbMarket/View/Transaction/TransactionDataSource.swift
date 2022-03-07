//
//  TransactionDataSource.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/01.
//

import UIKit

final class TransactionDataSource: NSObject, UITableViewDataSource {
    
    var items: [TransactionData]
    
    override init() {
        items = .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionNameSpace.cellReuseIdentifier, for: indexPath) as? TransactionTableViewCell else { return .init()}
        cell.configure(transaction: items[items.count - indexPath.row - 1])
        cell.selectionStyle = .none
        return cell
    }
    
}
