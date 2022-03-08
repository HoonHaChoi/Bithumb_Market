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
      
        viewmodel.fetchGraph(symbol: "BTC", interval: .day, completion: { graph in
        
            DispatchQueue.main.async {
                self.graph = Graph(
                    frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300),
                    values: graph.closePriceList,
                    date: graph.dateList,
                    openPrice: graph.openPriceList,
                    maxPrice: graph.maxPriceList,
                    minPrice: graph.minPriceList
                )
                
                self.setupView()
            }
        })
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
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
