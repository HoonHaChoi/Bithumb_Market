//
//  TransactionPriceGraphView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class TransactionPriceGraphView: UIView {
    
    private let graph: Graph = Graph()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func updateGraph(_ graph: GraphData) {
        DispatchQueue.main.async {
            self.graph.closePrice = graph.closePriceList[graph.startPoint..<graph.count].map { Double($0) }
            self.graph.openPrice = graph.openPriceList[graph.startPoint..<graph.count].map { Double($0) }
            self.graph.maxPrice = graph.maxPriceList[graph.startPoint..<graph.count].map { Double($0) }
            self.graph.minPrice = graph.minPriceList[graph.startPoint..<graph.count].map { Double($0) }
            self.graph.date = graph.dateList[graph.startPoint..<graph.count].map { String($0) }
            self.graph.layer.setNeedsDisplay()
        }
    }
    
    func changeGraph(isLine: Bool) {
        graph.isLineGraph = isLine
    }
}

extension TransactionPriceGraphView {
    
    private func setupView() {
        addSubview(graph)
        graph.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            graph.topAnchor.constraint(equalTo: self.topAnchor),
            graph.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            graph.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            graph.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
