//
//  CanvasView.swift
//  DrawAndRec
//
//  Created by punyawee  on 20/4/61.
//  Copyright © พ.ศ. 2561 punyawee . All rights reserved.
//

import UIKit

class CanvasView: UIView {

    var lineColor: UIColor!
    var lineWidth: CGFloat!
    var path: UIBezierPath!
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    
    override func layoutSubviews() {
        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        self.lineColor = UIColor.white
        self.lineWidth = 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startingPoint = touch?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.touchPoint = touch?.location(in: self)
        self.path = UIBezierPath()
        self.path.move(to: startingPoint)
        self.path.addLine(to: touchPoint)
        self.startingPoint = touchPoint
        drawShapeLayer()
    }
    
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearCanvas() {
        self.path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

}
