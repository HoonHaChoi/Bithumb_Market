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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        viewmodel.fetchGraphPrice() {
            DispatchQueue.main.async {
                self.drawgraph()
                self.setupView()
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawgraph()
        setupView()
    }
    
    private func drawgraph() {
        graph = Graph(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300),
            values: self.viewmodel.price
        )
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
