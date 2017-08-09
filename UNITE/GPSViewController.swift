//
//  GPSViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 3/8/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import ChameleonFramework

class GPSViewController: UIViewController {
    
    @IBOutlet weak var sinGraphView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    // Statellite Time
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var hourLbl: UILabel!
    @IBOutlet weak var minLbl: UILabel!
    @IBOutlet weak var secLbl: UILabel!
    
    // Background Views
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var latView: UIView!
    @IBOutlet weak var longView: UIView!
    @IBOutlet weak var velocityView: UIView!
    @IBOutlet weak var altitudeView: UIView!
    
    // Placement
    @IBOutlet weak var latValueLbl: UILabel!
    @IBOutlet weak var longValueLbl: UILabel!
    @IBOutlet weak var velocityValueLbl: UILabel!
    @IBOutlet weak var altitudeValueLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGraphicalElements()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Graphics Setup
    
    func setupGraphicalElements() {
        
        // Corner Radius
        sinGraphView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        mapView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        timeView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        latView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        longView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        velocityView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        altitudeView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
    }

}
