//
//  MapView.swift
//  UNITE
//
//  Created by Zack Snyder on 4/17/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit

class MapView: UIImageView {
    
    weak var parentVC : GPSViewController!
    
    var boundingView : UIView
    var isCompact : Bool
    
    var worldMapImage = UIImage(named: "world_map.JPG")
    
    var sinWave = SineWaveView()    {
        didSet {
            sinWave.removeFromSuperview()
            addSubview(sinWave)
        }
    }
    
    var compactWidthConstraint : NSLayoutConstraint!
    var compactHeightConstraint : NSLayoutConstraint!
    var regularWidthConstraint : NSLayoutConstraint!
    var regularHeightConstraint : NSLayoutConstraint!
    
    var centerYConstraint : NSLayoutConstraint!
    
    var imageAspect : CGFloat {
        return worldMapImage!.size.width / worldMapImage!.size.height
    }
    
    var imageInverseAspect : CGFloat {
        return worldMapImage!.size.height / worldMapImage!.size.width
    }
    
    init() {
        boundingView = UIView()
        isCompact = false
        super.init(frame: CGRect.zero)
        
        self.compactWidthConstraint = widthAnchor.constraint(equalTo: boundingView.widthAnchor, multiplier: 1)
        self.compactHeightConstraint = heightAnchor.constraint(equalTo: boundingView.widthAnchor, multiplier: imageInverseAspect)
        self.regularWidthConstraint = widthAnchor.constraint(equalTo: boundingView.heightAnchor, multiplier: imageAspect)
        self.regularHeightConstraint = heightAnchor.constraint(equalTo: boundingView.heightAnchor, multiplier: 1)
    }
    
    init(boundingView: UIView, isCompact: Bool) {
        self.boundingView = boundingView
        self.isCompact = isCompact
        
        super.init(frame: CGRect.zero)

        self.compactWidthConstraint = widthAnchor.constraint(equalTo: boundingView.widthAnchor, multiplier: 1)
        self.compactHeightConstraint = heightAnchor.constraint(equalTo: boundingView.widthAnchor, multiplier: imageInverseAspect)
        self.regularWidthConstraint = widthAnchor.constraint(equalTo: boundingView.heightAnchor, multiplier: imageAspect)
        self.regularHeightConstraint = heightAnchor.constraint(equalTo: boundingView.heightAnchor, multiplier: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if isCompact {
            centerYConstraint.isActive = false
            
            regularWidthConstraint.isActive = false
            regularHeightConstraint.isActive = false
            
            compactWidthConstraint.isActive = true
            compactHeightConstraint.isActive = true
        } else {
            centerYConstraint.isActive = true
            
            compactWidthConstraint.isActive = false
            compactHeightConstraint.isActive = false
            
            regularWidthConstraint.isActive = true
            regularHeightConstraint.isActive = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count < 2 {
            sinWave.movePoint(to: touches.first!.location(in: sinWave).x)
            parentVC.updateGPSData()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sinWave.movePoint(to: touches.first!.location(in: sinWave).x)
        parentVC.updateGPSData()
    }
}
