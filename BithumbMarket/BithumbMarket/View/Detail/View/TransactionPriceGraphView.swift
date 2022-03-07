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
      
        viewmodel.fetchGraphPrice()
//        {
//            DispatchQueue.main.async {
//                self.drawgraph()
//                self.setupView()
//            }
//        }
        bind()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawgraph()
        setupView()
    }
    
    private func drawgraph() {
        graph = Graph(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300),
            values: self.viewmodel.closePriceList,
            date: self.viewmodel.dateList,
            openPrice: self.viewmodel.openPriceList,
            maxPrice: self.viewmodel.maxPriceList,
            minPrice: self.viewmodel.minPriceList
        )
    }
    
    //MARK: 그래프 바인딩 작업 추가
    private func bind() {
        viewmodel.data.subscribe { [weak self] observer in
            DispatchQueue.main.async {
                self?.drawgraph()
                self?.setupView()
            }
        }
    }
}

extension TransactionPriceGraphView {
    
    private func setupView() {
        //MARK: 기존 그래프 삭제작업 추가
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
