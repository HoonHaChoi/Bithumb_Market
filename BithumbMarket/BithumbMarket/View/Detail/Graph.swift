//
//  Graph.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/03.
//

import Foundation
import UIKit
import AVFoundation

class Graph: UIView {
    
    var offsetX = CGFloat()

    var date = [String]()
    var openPrice = [Int]()
    var closePrice = [Int]()
    var maxPrice = [Int]()
    var minPrice = [Int]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, values: [Int], date: [String], openPrice: [Int], maxPrice: [Int], minPrice: [Int]) {
        // TODO: - Line or CandleStick 필요
        super.init(frame: frame)
        self.date = date
        self.openPrice = openPrice
        self.closePrice = values
        self.maxPrice = maxPrice
        self.minPrice = minPrice
    }
    
    override func draw(_ rect: CGRect) {
        graph(width: frame.width, height: frame.height, values: values)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        show(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        remove()
        show(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        remove()
    }
    
}

extension Graph {
    
    private func show(touches: Set<UITouch>) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            let x = position.x
            let index = checkIndex(index: Int(x / offsetX))
            date(x: x, date: date[index])
            price(x: x, price: closePrice[index])
            stick(x: x, minY: 300, maxY: 40, color: UIColor.textPrimary.cgColor)
        }
    }
    
    private func remove() {
        for _ in 0..<3 {
            if let count = layer.sublayers?.count {
                layer.sublayers?.remove(at: count - 1)
            }
        }
    }
    
    private func date(x: CGFloat, date: String) {
        drawText(x: x, y: 0, text: date,  fontSize: 11, height: 12)
    }
    
    private func price(x: CGFloat, price: Int) {
        let stringPrice = String(price).withComma()
        let text = stringPrice + "원"
        drawText(x: x, y: 15, text: text, fontSize: 16, height: 20)
    }
    
    private func drawText(x: CGFloat, y: CGFloat, text: String, fontSize: CGFloat, height: CGFloat) {
        let x = checkX(x: x)
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x - 60, y: y, width: 120, height: height)
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [.font: UIFont.systemFont(ofSize: fontSize ), .foregroundColor: UIColor.textPrimary]
        )
        textLayer.string = attributedString
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
    }
    
    private func stick(x: CGFloat, minY: CGFloat, maxY: CGFloat, color: CGColor) {
        let x = checkStick(x: x)
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        path.move(to: CGPoint(x: x, y: maxY))
        path.addLine(to: CGPoint(x: x, y: minY))
        layers.strokeColor = color
        layers.lineWidth = 1
        layers.path = path.cgPath
        self.layer.addSublayer(layers)
    }
    
    private func graph(width: CGFloat, height: CGFloat, values: [Int]) {
        offsetX = frame.width / CGFloat(values.count)
        
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        var currentX: CGFloat = 0
        
        guard let min = values.min(), let max = values.max() else { return }
        let scale = CGFloat(Double((max - min) / 2) / 0.4)
        let currentY = values.map{ max - $0 }

        path.move(to: CGPoint(x: 0, y: (frame.height * (CGFloat(currentY[0]) / scale)) + 55))
        currentY.forEach {
            currentX += offsetX
            path.addLine(to: CGPoint(x: currentX, y: (frame.height * (CGFloat($0) / scale)) + 55))
        }
    
        layers.fillColor = nil
        layers.strokeColor = UIColor.mainColor.cgColor
        layers.lineWidth = 3
        layers.lineCap = .round
        layers.path = path.cgPath
        layers.lineJoin = .round
        self.layer.addSublayer(layers)
    }
    
    private func checkIndex(index: Int) -> Int {
        switch index {
        case ..<0:
            return 0
        case (closePrice.count - 1)...:
            return closePrice.count - 1
        default:
            return index
        }
    }
    
    private func checkX(x: CGFloat) -> CGFloat {
        switch x {
        case ..<50:
            return 50
        case UIScreen.main.bounds.width - 80..<UIScreen.main.bounds.width:
            return UIScreen.main.bounds.width - 80
        default:
            return x
        }
    }
    
    private func checkStick(x: CGFloat) -> CGFloat {
        switch x {
        case ..<0:
            return 0
        case (UIScreen.main.bounds.width - 40)...:
            return UIScreen.main.bounds.width - 40
        default:
            return x
        }
    }
    
}