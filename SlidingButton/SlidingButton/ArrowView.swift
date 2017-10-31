//
//  ArrowView.swift
//  SlidingButton
//
//  Created by Ivan Sapozhnik on 10/31/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class ArrowView: IconView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        
        let shadow = UIColor.black.withAlphaComponent(0.3)
        let shadowOffset = CGSize(width: 0, height: 0.5)
        let shadowBlurRadius: CGFloat = 1
        
        let path = UIBezierPath()
        path.lineJoinStyle = CGLineJoin.round
        path.lineCapStyle = .round
        path.move(to: CGPoint(x: lineWidth, y: lineWidth))
        path.addLine(to: CGPoint(x: bounds.width - lineWidth, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: lineWidth, y: bounds.height - lineWidth))
        
        if let ctx = context {
            ctx.saveGState()
            ctx.setShadow(offset: shadowOffset, blur: shadowBlurRadius,  color: (shadow as UIColor).cgColor)
        }
        
        lineColor.set()
        path.lineWidth = lineWidth
        path.stroke()
    }
}
