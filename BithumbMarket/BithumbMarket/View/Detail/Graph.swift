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
    var values = [CGFloat]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, values: [CGFloat]) {
        super.init(frame: frame)
        self.values = values
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
            price(x: x, price: values[index])
            stick(x: x)
        }
    }
    
    private func remove() {
        if let count = layer.sublayers?.count {
            for _ in 1..<count {
                layer.sublayers?.remove(at: 1)
            }
        }
    }
    
    private func price(x: CGFloat, price: CGFloat) {
        let x = checkX(x: x)
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x - 50, y: 10, width: 100, height: 30)
        
        let stringPrice = (String(Int(price))).withComma()
        let text = stringPrice + "원"
        let attributedString = NSAttributedString(
            string: text,
            attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.textPrimary]
        )
        textLayer.string = attributedString
        textLayer.alignmentMode = .center
        self.layer.addSublayer(textLayer)
    }
    
    private func stick(x: CGFloat) {
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        
        path.move(to: CGPoint(x: x, y: 40))
        path.addLine(to: CGPoint(x: x, y: 300))
        layers.strokeColor = UIColor.typoColor.cgColor
        layers.lineWidth = 1
        layers.path = path.cgPath
        self.layer.addSublayer(layers)
    }
    
    private func graph(width: CGFloat, height: CGFloat, values: [CGFloat]) {
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        var currentX: CGFloat = 0
        var scale: CGFloat = 0

        if let first = values.first, let last = values.last {
            scale = ((first + last) / 2) / 0.5
        }
        
        offsetX = frame.width / CGFloat(values.count)
        path.move(to: CGPoint(x: 0, y: frame.height - (frame.height * (values[0] / scale))))
        values.forEach {
            currentX += offsetX
            path.addLine(to: CGPoint(x: currentX, y: frame.height - (frame.height * ($0 / scale))))
        }
        
        layers.fillColor = nil
        layers.strokeColor = UIColor.mainColor.cgColor
        layers.lineWidth = 4
        layers.lineCap = .round
        layers.path = path.cgPath
        self.layer.addSublayer(layers)
    }
    
    private func checkIndex(index: Int) -> Int {
        switch index {
        case ..<0:
            return 0
        case (values.count - 1)...:
            return values.count - 1
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
    
}
