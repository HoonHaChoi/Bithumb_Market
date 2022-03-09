//
//  TransactionPriceGraphView.swift
//  BithumbMarket
//
//  Created by HOONHA CHOI on 2022/03/02.
//

import UIKit

final class TransactionPriceGraphView: UIView {
    
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
            self.graph.boundMaxX = UIScreen.main.bounds.width
            self.graph.boundMinX = 0
            self.graph.date = graph.dateList
            self.graph.layer.setNeedsDisplay()
        }
    }

}

extension TransactionPriceGraphView {
    
    private func setupView() {
        if let viewWithTag = self.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        graph.tag = 1
        
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
