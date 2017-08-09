//
//  PowerViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 4/15/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import ChameleonFramework

class PowerViewController: UIViewController {
    
    @IBOutlet weak var xPosLbl: UILabel!
    @IBOutlet weak var xNegLbl: UILabel!
    @IBOutlet weak var yPosLbl: UILabel!
    @IBOutlet weak var yNegLbl: UILabel!
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var chargeView: UIView!
    
    func didTapTempPanel(tap: UILongPressGestureRecognizer) {
        
        switch tap.state {
        case .began:
            
            if let label = tap.view as? UILabel {
                
                // Tap Color Feedback
                if label.backgroundColor == UIColor.white {
                    label.backgroundColor = FlatWhiteDark()
                } else if label.backgroundColor == FlatRed() {
                    label.backgroundColor = FlatRedDark()
                }
            } else {
                print("view is not uilabel")
            }
        case .ended:
            
            if let label = tap.view as? UILabel {
                
                // Select/Deselect tapped panel
                if label.textColor == FlatRed() {
                    select(panel: label)
                } else {
                    deselect(panel: label)
                }
                
                let location = tap.location(in: label)
                let isTouchInsideView = CGRect(origin: CGPoint.zero, size: label.bounds.size).contains(location)
                
                if isTouchInsideView {
                }
            }
            
        case .cancelled:
            
            if let view = tap.view {
                view.backgroundColor = UIColor.white
            }
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizers()
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    // MARK: Gesture Recognizers
    
    func setupGestureRecognizers() {
        let xPosTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let xNegTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let yPosTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let yNegTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        
        xPosTouch.minimumPressDuration = 0.001
        xNegTouch.minimumPressDuration = 0.001
        yPosTouch.minimumPressDuration = 0.001
        yNegTouch.minimumPressDuration = 0.001
        
        xPosLbl.addGestureRecognizer(xPosTouch)
        xNegLbl.addGestureRecognizer(xNegTouch)
        yPosLbl.addGestureRecognizer(yPosTouch)
        yNegLbl.addGestureRecognizer(yNegTouch)
    }
    
    
    // MARK: Graphics Setup
    
    func setupUI() {
        
        // Corner Radius
        xPosLbl.layer.masksToBounds = true
        xPosLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        xPosLbl.textColor = FlatRed()
        xPosLbl.backgroundColor = UIColor.white
        
        xNegLbl.layer.masksToBounds = true
        xNegLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        xNegLbl.textColor = FlatRed()
        xNegLbl.backgroundColor = UIColor.white
        
        yPosLbl.layer.masksToBounds = true
        yPosLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        yPosLbl.textColor = FlatRed()
        yPosLbl.backgroundColor = UIColor.white
        
        yNegLbl.layer.masksToBounds = true
        yNegLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        yNegLbl.textColor = FlatRed()
        yNegLbl.backgroundColor = UIColor.white
        
        currentView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        chargeView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        
    }
    
    // MARK: Panel Controls
    
    func select(panel: UILabel) {
        panel.backgroundColor = FlatRed()
        panel.textColor = FlatWhite()
        

    }
    
    func deselect(panel: UILabel) {
        panel.backgroundColor = UIColor.white
        panel.textColor = FlatRed()

    }

}
