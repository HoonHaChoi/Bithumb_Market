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
            let graphData = graph.previewGraphData
            self.graph.closePrice = graphData.closePriceList
            self.graph.openPrice = graphData.openPriceList
            self.graph.maxPrice = graphData.maxPriceList
            self.graph.minPrice = graphData.minPriceList
            self.graph.date = graphData.dateList
            self.graph.boundMinX = 0
            self.graph.boundMaxX = self.frame.width
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
