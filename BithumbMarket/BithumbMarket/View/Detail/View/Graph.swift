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
    
    private var date = [String]()
    private var openPrice = [Int]()
    private var closePrice = [Int]()
    private var maxPrice = [Int]()
    private var minPrice = [Int]()
    
    private var layerCount = 0
    private var offsetX = CGFloat()
    
    var boundMinX = CGFloat()
    var boundMaxX = CGFloat() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isLineGraph = false {
          didSet {
              setNeedsDisplay()
          }
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, values: [Int], date: [String], openPrice: [Int], maxPrice: [Int], minPrice: [Int], boundMinX: CGFloat, boundMaxX: CGFloat) {
        super.init(frame: frame)
        self.date = date
        self.openPrice = openPrice
        self.closePrice = values
        self.maxPrice = maxPrice
        self.minPrice = minPrice
        self.boundMinX = boundMinX
        self.boundMaxX = boundMaxX
    }
    
    override func draw(_ rect: CGRect) {
        layer.sublayers?.removeAll()
        switch isLineGraph {
        case true:
            graph(width: frame.width, height: frame.height, values: closePrice)
        case false:
            candleStick(width: frame.width, height: frame.height, boundMinX: boundMinX, boundMaxX: boundMaxX)
        }
        if let count = layer.sublayers?.count {
            layerCount = count
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        remove()
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
            stick(x: x, minY: frame.minY + 40, maxY: frame.maxY, color: UIColor.textPrimary.cgColor)
        }
    }
    
    private func remove() {
        if let count = layer.sublayers?.count {
            for _ in layerCount..<count {
                layer.sublayers?.remove(at: layerCount)
            }
        }
    }
    
    private func date(x: CGFloat, date: String) {
        drawText(x: x, y: 5, text: date,  fontSize: 11, height: 12)
    }
    
    private func price(x: CGFloat, price: Int) {
        let stringPrice = String(price).withComma()
        let text = stringPrice + "원"
        drawText(x: x, y: 20, text: text, fontSize: 16, height: 20)
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
        
        guard let min = values.min(), let max = values.max() else { return }
        let scale = CGFloat(Double(max - min) / 0.8)
        let currentY = values.map{ max - $0 }
        var currentX: CGFloat = 0
        
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
    
    private func candleStick(width: CGFloat, height: CGFloat, boundMinX: CGFloat, boundMaxX: CGFloat) {
        
        offsetX = frame.width / CGFloat(closePrice.count + 1)
        let start = checkIndex(index: Int(boundMinX / offsetX))
        let end = checkIndex(index: Int(boundMaxX / offsetX))
    
        guard let maxprice = maxPrice[start..<end].max(), let minprice = minPrice[start..<end].min() else {return}
        
        let labelSpace: CGFloat = 55
        var currentX: CGFloat = boundMinX
        let scale = CGFloat(Double((maxprice - minprice) / 2) / 0.4)
        let close = closePrice.map{ frame.height * (CGFloat(maxprice - $0) / scale) + labelSpace }
        let open = openPrice.map{ frame.height * (CGFloat(maxprice - $0) / scale) + labelSpace }
        let max = maxPrice.map{ frame.height * (CGFloat(maxprice - $0) / scale) + labelSpace }
        let min = minPrice.map{ frame.height * (CGFloat(maxprice - $0) / scale) + labelSpace }
        
        for i in start..<end{
            currentX += offsetX
            stick(x: currentX - 4, minY: min[i] , maxY: max[i], color: UIColor.textSecondary.cgColor)
            
            if close[i] > open[i] {
                rectangle(top: open[i] , bottom: close[i], color: UIColor.fallColor.cgColor, currentX: currentX)
            } else {
                rectangle(top: close[i], bottom: open[i], color: UIColor.riseColor.cgColor, currentX: currentX)
            }
        }
    }
    
    private func rectangle(top: CGFloat, bottom: CGFloat, color: CGColor, currentX: CGFloat) {
        let layers = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: currentX - (offsetX/2) - 3, y: top))
        path.addLine(to: CGPoint(x: currentX - (offsetX/2) + offsetX - 5 , y: top))
        path.addLine(to: CGPoint(x: currentX - (offsetX/2) + offsetX - 5, y: bottom))
        path.addLine(to: CGPoint(x:  currentX - (offsetX/2) - 3, y: bottom))
        layers.lineCap = .round
        layers.path = path.cgPath
        layers.fillColor = color
        self.layer.addSublayer(layers)
    }
    
    private func checkIndex(index: Int) -> Int {
        switch index {
        case ..<0:
            return 0
        case (closePrice.count)...:
            return closePrice.count
        default:
            return index
        }
    }
    
    private func checkX(x: CGFloat) -> CGFloat {
        switch x {
        case ..<(boundMinX + 55):
            return boundMinX + 55
        case (boundMaxX - 55)...:
            return boundMaxX - 55
        default:
            return x
        }
    }
    
    private func checkStick(x: CGFloat) -> CGFloat {
        switch x {
        case ..<0:
            return 0
        case frame.width...:
            return frame.width
        default:
            return x
        }
    }
    
}
