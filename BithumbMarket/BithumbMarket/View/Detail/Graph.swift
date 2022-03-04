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
    
    var offsetX: CGFloat = 0
    
    var color = UIColor.mainColor.cgColor
    var values: [CGFloat] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, values: [CGFloat], color: CGColor) {
        super.init(frame: frame)
        self.values = values
        self.color = color
    }
    
    override func draw(_ rect: CGRect) {
        graph(width: frame.width, height: frame.height, color: color, values: values)
    }
    
    private func show(touches: Set<UITouch>) {
         if let touch = touches.first {
             let position = touch.location(in: self)
             let x = position.x
             let index = Int(Float(x / offsetX))
             
             price(x: x, price: values[index])
             stick(x: x)
         }
     }
    
    private func price(x: CGFloat, price: CGFloat) {
        let text = "\(price)원"
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: x - 50, y: 10, width: 100, height: 30)

        let attributedString = NSAttributedString(
            string: text,
            attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.textPrimary]
        )
        textLayer.string = attributedString
        self.layer.addSublayer(textLayer)
    }
    
    private func stick(x: CGFloat) {
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        
        path.move(to: CGPoint(x: x, y: 40))
        path.addLine(to: CGPoint(x: x, y: 270))
        
        layers.fillColor = nil
        layers.strokeColor = UIColor.typoColor.cgColor
        layers.lineWidth = 1
        layers.lineCap = .round
        layers.path = path.cgPath
        self.layer.addSublayer(layers)
    }
    
    private func graph(width: CGFloat, height: CGFloat, color: CGColor, values: [CGFloat]) {
        
        var currentX: CGFloat = 0
        var scale: CGFloat = 0
        
        if let first = values.first,
           let last = values.last {
            scale = ((first + last) / 2) / 0.5
        }
        
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        offsetX = frame.width / CGFloat(values.count)
        
        path.move(to: CGPoint(x: 0, y: frame.height - (frame.height * (values[0] / scale))))
        
        for i in 1..<values.count {
            currentX += offsetX
            path.addLine(to: CGPoint(x: currentX, y: frame.height - (frame.height * (values[i] / scale))))
        }
        
        layers.fillColor = nil
        layers.strokeColor = color
        layers.lineWidth = 4
        layers.lineCap = .round
        layers.path = path.cgPath
        self.layer.addSublayer(layers)
    }
    
}
