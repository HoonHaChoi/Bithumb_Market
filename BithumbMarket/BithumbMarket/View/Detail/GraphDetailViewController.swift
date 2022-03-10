//
//  GraphDetailViewController.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/07.
//

import UIKit

final class GraphDetailViewController: UIViewController {
    
    private lazy var graph = Graph()
    private let graphData: GraphData
    private lazy var width: CGFloat = CGFloat(graphData.closePriceList.count * 12)
    
    init(graphData: GraphData) {
        self.graphData = graphData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.decelerationRate = .fast
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    func updateGraph() {
        DispatchQueue.main.async {
            self.graph.closePrice = self.graphData.closePriceList
            self.graph.openPrice = self.graphData.openPriceList
            self.graph.maxPrice = self.graphData.maxPriceList
            self.graph.minPrice = self.graphData.minPriceList
            self.graph.boundMaxX = self.scrollView.bounds.maxX
            self.graph.boundMinX = self.scrollView.bounds.minX
            self.graph.date = self.graphData.dateList
            self.graph.layer.setNeedsDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateGraph()
        
        // TODO: scrollTOEnd() * 2 문제 해결
        scrollView.scrollToEnd(x: width)
        scrollView.scrollToEnd(x: width)
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    deinit {
        print(#function)
    }
    
}

extension GraphDetailViewController {
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        configureScrollView()
        scrollContentView.addSubview(graph)
        graph.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            graph.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            graph.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            graph.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor),
            graph.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor)
        ])
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalToConstant: width),
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
}

extension GraphDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        graph.boundMinX = self.scrollView.bounds.minX
        graph.boundMaxX = self.scrollView.bounds.maxX
    }
    
}

