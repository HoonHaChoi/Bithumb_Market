//
//  TransactionPriceGraphView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class TransactionPriceGraphView: UIView {
    
    let viewmodel = GraphViewModel()
    var graph: Graph = Graph()
    var isLineGraph = false {
          didSet {
              graph.isLineGraph = !graph.isLineGraph
              setNeedsDisplay()
          }
      }
    
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
            self.graph.closePrice = graph.closePriceList
            self.graph.openPrice = graph.openPriceList
            self.graph.maxPrice = graph.maxPriceList
            self.graph.minPrice = graph.minPriceList
            self.graph.date = graph.dateList
            self.graph.layer.setNeedsDisplay()
        }
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
