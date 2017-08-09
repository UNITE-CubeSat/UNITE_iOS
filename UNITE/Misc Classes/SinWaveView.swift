//
//  SinWaveView.swift
//  UNITE
//
//  Created by Zack Snyder on 4/18/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import BezierPathLength

@IBDesignable
class SineWaveView: UIView {
    
    @IBInspectable
    var graphWidth: CGFloat = 0.90  { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var amplitude: CGFloat = 0.20   { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var periods: CGFloat = 1.0      { didSet { setNeedsDisplay() } }
    
    // Sin Path
    private var path : UIBezierPath!
    private var previousPercentWidth: CGFloat = 0.5
    
    // Selector Points
    var point : GraphPoint!
    
    var pointRadius : CGFloat = 5.0

    override func draw(_ rect: CGRect) {
        let width = bounds.width
        let height = bounds.height
        
        let origin = CGPoint(x: width * (1 - graphWidth) / 2, y: height * 0.50)
        
        path = UIBezierPath()
        path.move(to: origin)
        path.lineWidth = 2.0
        
        for angle in stride(from: 5.0, through: 360.0 * periods, by: 5.0) {
            let x = origin.x + angle/(360.0 * periods) * width * graphWidth
            let y = origin.y - sin(angle/180.0 * .pi) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        FlatRed().setStroke()
        path.stroke()
        
        updatePoint(to: previousPercentWidth)
    }
    
    
    func movePoint(to xPos: CGFloat) {
        if point == nil {
            point = GraphPoint(radius: pointRadius)
            addSubview(point)
        }
        
        let width = frame.width
        let percent = xPos / width
        let position = path.point(at: percent)
        
        if let position = position {
            point.center = position
        }
        
        previousPercentWidth = percent
    }
    
    func getLongitude() -> String {
        if let p = point {
            let deltaX = p.center.x - center.x
            let degreeConversion = 360.0 / frame.width
            let longitude = abs(deltaX) * degreeConversion
            
            let longString = String(format: "%.6f° %@", arguments: [longitude, deltaX > 0 ? "E" : "W"]) //String(format: "\(longitude)° \(deltaX > 0 ? "E" : "W")")
            return longString
        }
        
        return "— —"
    }
    
    func getLatitude() -> String {
        if let p = point {
            let deltaY = p.center.y - center.y
            let degreeConversion = 180.0 / frame.height
            let latitude = abs(deltaY) * degreeConversion
            
            let latString = String(format: "%.6f° %@", arguments: [latitude, deltaY > 0 ? "S" : "N"]) //"\(longitude)° \(deltaY > 0 ? "N" : "S")"
            return latString
        }
        
        return "— —"
    }
    
    private func updatePoint(to percent: CGFloat) {
        if point != nil && path != nil {  point.center = path.point(at: percent)! }
       
    }
}

class GraphPoint: UIView {
    
    var color : UIColor = FlatNavyBlue()    { didSet { backgroundColor = color } }
    
    init(radius: CGFloat) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: radius * 2, height: radius * 2)))
        
        layer.cornerRadius = radius
        backgroundColor = color
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.5
        
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2).cgPath
        layer.shadowColor = FlatBlackDark().cgColor
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
