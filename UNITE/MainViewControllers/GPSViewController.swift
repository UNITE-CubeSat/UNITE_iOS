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
import GoogleMaps

class GPSViewController: UIViewController {
    
    @IBOutlet weak var sinGraphView: UIView!
    
    var scrollView = UIScrollView()
    var imageContainer = UIView()
    var worldMapView = UIImageView()
    var worldMapImage = UIImage(named: "world_map.JPG")
    
    var regularWidthConstraint : NSLayoutConstraint!
    var regularHeightConstraint : NSLayoutConstraint!
    var compactWidthConstraint : NSLayoutConstraint!
    var compactHeightConstraint : NSLayoutConstraint!
    
    var imageAspect : CGFloat {
        return worldMapImage!.size.width / worldMapImage!.size.height
    }
    
    var imageInverseAspect : CGFloat {
        return worldMapImage!.size.height / worldMapImage!.size.width
    }
    
    //@IBOutlet weak var mapView: MKMapView!
    
    // Google Maps Initializations
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 12.0
    
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
        setupMaps()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        setupConstraints()
        
        super.viewDidLayoutSubviews()

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
    
    func setupConstraints() {
        
        worldMapView.setNeedsUpdateConstraints()

        
        
        // World Map
        
        
    }
    
    func setupMaps() {
        configureLocationManager()
        configureScrollView()
        configureMapView()
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
//        locationManager.delegate = self
    }
    
    func configureScrollView() {
        scrollView = UIScrollView(frame: sinGraphView.frame)
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.bouncesZoom = false
        
        scrollView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        
        // Scroll View
        scrollView.leadingAnchor.constraint(equalTo: sinGraphView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: sinGraphView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: sinGraphView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: sinGraphView.bottomAnchor).isActive = true
    }
    
    func configureMapView() {
//        let camera = GMSCameraPosition.camera(withLatitude: 0.0,
//                                              longitude: 0.0,
//                                              zoom: zoomLevel)
//        mapView = GMSMapView.map(withFrame: sinGraphView.frame, camera: camera)
//        mapView.settings.myLocationButton = false
//        mapView.settings.scrollGestures = true
//        mapView.settings.zoomGestures = true
//        mapView.settings.tiltGestures = false
//        mapView.settings.rotateGestures = false
//        mapView.translatesAutoresizingMaskIntoConstraints = false

        //view.addSubview(mapView)
        
        //mapView.leadingAnchor.constraint(equalTo: sinGraphView.leadingAnchor).isActive = true
        //mapView.trailingAnchor.constraint(equalTo: sinGraphView.trailingAnchor).isActive = true
        //mapView.topAnchor.constraint(equalTo: sinGraphView.topAnchor).isActive = true
        //mapView.bottomAnchor.constraint(equalTo: sinGraphView.bottomAnchor).isActive = true
        
        
        // Pan image
        
//        imageContainer.frame = sinGraphView.frame
//        imageContainer.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
//        scrollView.addSubview(imageContainer)
        
        // ImageContainer Constraints
        
        
        worldMapView = UIImageView(frame: sinGraphView.frame)
        worldMapView.image = worldMapImage
        worldMapView.contentMode = .scaleToFill
        worldMapView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        worldMapView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(worldMapView)

        worldMapView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        worldMapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        worldMapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        //        worldMapView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        //        worldMapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        let isCompact = newCollection.verticalSizeClass == .compact

        worldMapView.heightAnchor.constraint(equalTo: sinGraphView.heightAnchor, multiplier: isCompact ? imageInverseAspect : 1 ).isActive = true
        worldMapView.widthAnchor.constraint(equalTo: sinGraphView.widthAnchor, multiplier: isCompact ? 1 : imageAspect).isActive = true
        
    }
}

extension GPSViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return worldMapView
    }
}
