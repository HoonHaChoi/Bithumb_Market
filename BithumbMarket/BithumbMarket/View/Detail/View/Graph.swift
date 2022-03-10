//
//  Graph.swift
//  BithumbMarket
//
//  Created by jiinheo on 2022/03/03.
//

import UIKit

final class Graph: UIView {
    
    var offsetX = CGFloat()

    var date = [String]()
    var openPrice = [Double]()
    var closePrice = [Double]()
    var maxPrice = [Double]()
    var minPrice = [Double]()
    private var layerCount = 0
    
    var boundMinX = CGFloat()
    var boundMaxX = CGFloat() {
        didSet {
            setNeedsDisplay()
        }
    }
    var isLineGraph = UserDefaults.standard.isLine() {
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

    override func draw(_ rect: CGRect) {
        layer.sublayers?.removeAll()
        switch isLineGraph {
        case true:
            lineGraph(width: frame.width, height: frame.height, values: closePrice)
        case false:
            candleStickGraph(width: frame.width, height: frame.height, boundMinX: boundMinX, boundMaxX: boundMaxX)
            minMaxText(minList: minPrice, maxList: maxPrice)
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
        switch isLineGraph {
        case true:
            minMaxText(minList: closePrice, maxList: closePrice)
        case false:
            minMaxText(minList: minPrice, maxList: maxPrice)
        }
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
            for _ in layerCount - 2..<count {
                layer.sublayers?.remove(at: layerCount - 2)
            }
        }
    }
    
    private func minMaxText(minList: [Double], maxList: [Double]) {
        let start = checkIndex(index: Int(boundMinX / offsetX))
        let end = checkIndex(index: Int(boundMaxX / offsetX))
        if start < 0 || end < 0 { return }
        
        guard let maxprice = maxList[start...end].max(),
              let minprice = minList[start...end].min() else {return}
        
        let labelSpace: CGFloat = 55
        let scale = CGFloat(Double(maxprice - minprice) / 0.8 / frame.height)
        let max = maxList.map{(CGFloat(maxprice - $0) / scale) + labelSpace }
        let min = minList.map{(CGFloat(maxprice - $0) / scale) + labelSpace }

        guard let maxPriceIndex = maxList[start...end].firstIndex(of: maxprice),
           let minPriceIndex = minList[start...end].firstIndex(of: minprice) else { return }
        
        let boundMinPriceX = offsetX * CGFloat(minPriceIndex)
        let boundMaxPriceX = offsetX * CGFloat(maxPriceIndex)
        let maxpriceString = convertString(price: maxprice)
        let minpriceString = convertString(price: minprice)
        
        let minX = checkMinMaxX(x: boundMinPriceX + offsetX)
        let maxX = checkMinMaxX(x: boundMaxPriceX + offsetX)
 
        drawMinMaxText(x: minX, y: min[minPriceIndex] + 10, text: "최저 " + minpriceString, color: UIColor.fallColor.cgColor)
        drawMinMaxText(x: maxX, y: max[maxPriceIndex] - 25, text: "최고 " + maxpriceString, color: UIColor.riseColor.cgColor)
    }
    
    private func drawMinMaxText(x: CGFloat, y: CGFloat, text: String, color: CGColor) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x - 60 , y: y, width: 120, height: 10)
        
        let attributedString = NSAttributedString(
            string: text,
            attributes: [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: color]
        )
        textLayer.string = attributedString
        textLayer.alignmentMode = .center
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
    }
    
    private func date(x: CGFloat, date: String) {
        drawText(x: x, y: 5, text: date,  fontSize: 11, height: 12)
    }
    
    private func price(x: CGFloat, price: Double) {
        let stringPrice = price < 1 ? String(format: "%.4f", price) : String(price).withComma()
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
    
    private func lineGraph(width: CGFloat, height: CGFloat) {
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        var currentX: CGFloat = 0
        
        let start = checkIndex(index: Int(boundMinX / offsetX))
        let end = checkIndex(index: Int(boundMaxX / offsetX))
        if start < 0 || end < 0 { return }
        
        guard let maxprice = closePrice[start...end].max(),
              let minprice = closePrice[start...end].min() else {return}
        
        let labelSpace: CGFloat = 55
        let scale = CGFloat(Double(maxprice - minprice) / 0.8 / frame.height)
        let currentY = closePrice.map{((CGFloat(maxprice - $0) / scale)) + labelSpace}
        
        path.move(to: CGPoint(x: 0, y: currentY[0]))
        currentY.forEach {
            currentX += offsetX
            path.addLine(to: CGPoint(x: currentX, y: $0))
        }
        layers.fillColor = nil
        layers.strokeColor = UIColor.mainColor.cgColor
        layers.lineWidth = 3
        layers.lineCap = .round
        layers.path = path.cgPath
        layers.lineJoin = .round
        self.layer.addSublayer(layers)
        
        currnetText(x: frame.width + 2, y: currentY[currentY.count - 1] - 8 , color: UIColor.mainColor.cgColor )
        currentPriceBar(open: currentY[currentY.count - 1], close: currentY[currentY.count - 1])
    }
    
    private func candleStickGraph(width: CGFloat, height: CGFloat, boundMinX: CGFloat, boundMaxX: CGFloat) {
        let start = checkIndex(index: Int(boundMinX / offsetX))
        let end = checkIndex(index: Int(boundMaxX / offsetX))
        if start < 0 || end < 0 { return }
        
        guard let maxprice = maxPrice[start...end].max(),
              let minprice = minPrice[start...end].min() else {return}

        let labelSpace: CGFloat = 55
        var currentX: CGFloat = boundMinX
        let scale = CGFloat(Double(maxprice - minprice) / 0.8 / frame.height)
        let close = closePrice.map{(CGFloat(maxprice - $0) / scale) + labelSpace }
        let open = openPrice.map{(CGFloat(maxprice - $0) / scale) + labelSpace }
        let max = maxPrice.map{(CGFloat(maxprice - $0) / scale) + labelSpace }
        let min = minPrice.map{(CGFloat(maxprice - $0) / scale) + labelSpace }

        for i in start...end{
            currentX += offsetX
            stick(x: currentX - 4, minY: min[i] , maxY: max[i], color: UIColor.textSecondary.cgColor)

            close[i] > open[i]
            ? rectangle(top: open[i] , bottom: close[i], color: UIColor.fallColor.cgColor, currentX: currentX)
            : rectangle(top: close[i], bottom: open[i], color: UIColor.riseColor.cgColor, currentX: currentX)
        }
  
        close[close.count - 1] > open[open.count - 1]
        ? currnetText(x: frame.width + 2, y: close[close.count - 1] - 8, color: UIColor.fallColor.cgColor )
        : currnetText(x: frame.width + 2, y: close[close.count - 1] - 8, color: UIColor.riseColor.cgColor)
        
        currentPriceBar(open: open[open.count - 1], close: close[close.count - 1])
    }
    
    private func currnetText(x: CGFloat, y: CGFloat, color: CGColor ) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x , y: y, width: 30, height: 16)
        
        let attributedString = NSAttributedString(
            string: "현재",
            attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: color]
        )
        textLayer.cornerRadius = 5
        textLayer.string = attributedString
        textLayer.alignmentMode = .center
        textLayer.borderWidth = 1
        textLayer.borderColor = color
        textLayer.contentsScale = UIScreen.main.scale
        self.layer.addSublayer(textLayer)
    }
 
    private func currentPriceBar(open: CGFloat, close: CGFloat) {
        let layers = CAShapeLayer()
        let path = UIBezierPath()
        let color: CGColor = close < open ? UIColor.riseColor.cgColor : UIColor.fallColor.cgColor
      
        path.move(to: CGPoint(x: 0, y: close))
        path.addLine(to: CGPoint(x: frame.width, y: close))
        layers.fillColor = nil
        layers.strokeColor = color
        layers.lineWidth = 1
        layers.lineCap = .round
        layers.path = path.cgPath
        layers.lineDashPattern = [3, 3]
        self.layer.addSublayer(layers)
    }
    
    private func rectangle(top: CGFloat, bottom: CGFloat, color: CGColor, currentX: CGFloat) {
        let layers = CAShapeLayer()
        let path = UIBezierPath(
            roundedRect: CGRect(x: currentX - (offsetX/2) - 3, y: top, width: offsetX - 2, height: bottom - top),
            cornerRadius: 2)
        layers.lineCap = .round
        layers.path = path.cgPath
        layers.fillColor = color
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
        case (boundMaxX - 55)...:
            return boundMaxX - 55
        case ..<(boundMinX + 55):
            return boundMinX + 55
        default:
            return x
        }
    }
    
    private func checkMinMaxX(x: CGFloat) -> CGFloat {
        switch x {
        case (boundMaxX - 55)...:
            if frame.width < UIScreen.main.bounds.width {
                return boundMaxX - 30
            }
            return boundMaxX - 55
        case ..<(boundMinX + 55):
            if frame.width < UIScreen.main.bounds.width {
                return boundMinX + 30
            }
            return boundMinX + 55
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
