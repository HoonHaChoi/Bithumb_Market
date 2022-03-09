//
//  GraphDetailViewController.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/07.
//

import UIKit

final class GraphDetailViewController: UIViewController {
    
    let viewmodel = GraphViewModel()
    var graph = Graph()
    let width: CGFloat = 30000
    
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
    
    private func drawgraph() {
        // TODO: date struct 처리 필요
        graph = Graph(
            frame: CGRect(x: 0, y: 0, width: width, height: UIScreen.main.bounds.height - 200),
            values: self.viewmodel.closePriceList,
            date: self.viewmodel.dateList,
            openPrice: self.viewmodel.openPriceList,
            maxPrice: self.viewmodel.maxPriceList,
            minPrice: self.viewmodel.minPriceList,
            boundMinX: self.scrollView.bounds.minX,
            boundMaxX: self.scrollView.bounds.maxX
        )
    }
    
    private func bind() {
        viewmodel.data.subscribe { [weak self] observer in
            DispatchQueue.main.async {
                self?.drawgraph()
                self?.setupView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewmodel.fetchGraphPrice {
            self.bind()
        }
        // TODO: scrollTOEnd() * 2 문제 해결
        scrollView.scrollToEnd()
        scrollView.scrollToEnd()
        scrollView.delegate = self
    }
    
}

extension GraphDetailViewController {
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        configureScrollView()
        scrollContentView.addSubview(graph)
        
        NSLayoutConstraint.activate([
            graph.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            graph.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
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

extension UIScrollView {
    
    func scrollToEnd() {
        let offset = CGPoint(x: 30000, y: 0)
        setContentOffset(offset, animated: true)
        self.layoutIfNeeded()
    }
}

