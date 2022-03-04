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
    
    let divideValue: CGFloat = 85000000
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
        layer(width: frame.width, height: frame.height, color: color, values: values)
    }
    
    private func layer(width: CGFloat, height: CGFloat, color: CGColor, values: [CGFloat]) {
        
        let path = UIBezierPath()
        let layers = CAShapeLayer()
        
        var currentX: CGFloat = 0
        let offsetX: CGFloat = frame.width / CGFloat(values.count)
        
        path.move(to: CGPoint(x: 0, y: frame.height - (frame.height * (values[0] / divideValue))))
        
        for i in 1..<values.count {
            currentX += offsetX
            path.addLine(to: CGPoint(x: currentX, y: frame.height - (frame.height * (values[i] / divideValue))))
        }
        
        layers.fillColor = nil
        layers.strokeColor = color
        layers.lineWidth = 4
        layers.lineCap = .round
        layers.path = path.cgPath
        self.layer.addSublayer(layers)
    }
}
