//
//  MainDiffableDataSource.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/06.
//

import UIKit

enum Section: Hashable {
    case main
}

final class MainDiffableDataSource: UITableViewDiffableDataSource<Section, Ticker> {
    
    private var items: [Ticker] = []
    
    func updateItems(tickers: [Ticker]) {
        items = tickers
    }
    
    func appendSnapshot(tickers: [Ticker]) {
        self.items = tickers
        var snapshot = NSDiffableDataSourceSnapshot<Section, Ticker>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        apply(snapshot: snapshot)
    }
    
    func reloadSnapshot(ticker: Ticker, completion: (() -> Void)? = nil) {
        var currentSnapshot = self.snapshot()
        currentSnapshot.reloadItems([ticker])
        apply(snapshot: currentSnapshot, completion: completion)
    }
    
    private func apply(snapshot: NSDiffableDataSourceSnapshot<Section, Ticker>, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }
    
    func reloadIndexPath(rows: [IndexPath]?) {
        rows?.forEach({ indexPath in
            guard let ticker = self.itemIdentifier(for: indexPath) else {
                return
            }
            self.reloadSnapshot(ticker: ticker)
        })
    }
    
    func findTicker(index: Int) -> Ticker? {
        return self.itemIdentifier(for: IndexPath(row: index, section: 0))
    }
    
    func isEmptyItems() -> Bool {
        items.isEmpty
    }
    
}
