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

class GPSViewController: UIViewController, UNITEVCProtocol {
    
    @IBOutlet weak var sinGraphView: UIView!
    
    var scrollView = UIScrollView()
    var imageContainer = UIView()
    var worldMapView = MapView()
    var sinWaveView = SineWaveView()

    var worldMapImage = UIImage(named: "world_map.JPG")
    
    var longitude : String {
        return sinWaveView.getLongitude()
    }
    
    var latitude : String {
        return sinWaveView.getLatitude()
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
    @IBOutlet weak var compactLatValueLbl: UILabel!
    @IBOutlet weak var longValueLbl: UILabel!
    @IBOutlet weak var compactLongValueLbl: UILabel!
    @IBOutlet weak var velocityValueLbl: UILabel!
    @IBOutlet weak var altitudeValueLbl: UILabel!
    
    // Constraints
    @IBOutlet var landscapeConstraints: [NSLayoutConstraint]!
    @IBOutlet var portraitConstraints: [NSLayoutConstraint]!
    
    // Stacks
    @IBOutlet weak var firstInnerStack: UIStackView!
    @IBOutlet weak var secondInnerStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMaps()
        updateGPSData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMapOrientation(traitCollection: traitCollection)

        if UIDevice.current.userInterfaceIdiom == .pad {
            transitionToiPadSizeClass(landscape: view.bounds.width > view.bounds.height,
                                      transitionCoordinator: nil)
        }
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
    
    // MARK: Graphics Setup
    
    func setupUI() {
        
        // Corner Radius
        sinGraphView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        mapView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        timeView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        latView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        longView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        velocityView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        altitudeView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
    }
    
    // MARK: Gesture Recognizers

    func setupGestureRecognizers() {
        // Add gesture recognizers here
        
        
    }
    
    // MARK: World Map Setup
    
    func setupMaps() {
        configureLocationManager()
        configureScrollView()
        configureMapView()
        configureSinWave()
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
        
        // Scroll GPS map with two fingers
        for gestureRecognizer in scrollView.gestureRecognizers! {
            if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
                panGestureRecognizer.minimumNumberOfTouches = 2
            }
        }
        
        scrollView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        
        sinGraphView.addSubview(scrollView)
        
        // Scroll View
        scrollView.leadingAnchor.constraint(equalTo: sinGraphView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: sinGraphView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: sinGraphView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: sinGraphView.bottomAnchor).isActive = true
        
        sinGraphView.sendSubview(toBack: scrollView)
    }
    

    
    func configureMapView() {
        // Google Maps
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
        let isCompact = traitCollection.verticalSizeClass == .compact
        worldMapView = MapView(boundingView: sinGraphView, isCompact: isCompact)
        worldMapView.image = worldMapImage
        worldMapView.contentMode = .scaleToFill
        worldMapView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        worldMapView.translatesAutoresizingMaskIntoConstraints = false
        worldMapView.isUserInteractionEnabled = true
        worldMapView.parentVC = self
        
        scrollView.addSubview(worldMapView)

        worldMapView.centerYConstraint = worldMapView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        worldMapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        worldMapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        worldMapView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        worldMapView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
    }
    
    func configureSinWave() {
        sinWaveView = SineWaveView()
        sinWaveView.amplitude = 0.4
        sinWaveView.periods = 1
        sinWaveView.graphWidth = 1.0
        sinWaveView.pointRadius = 10.0
        sinWaveView.backgroundColor = .clear
        sinWaveView.translatesAutoresizingMaskIntoConstraints = false
        
        worldMapView.sinWave = sinWaveView
        
        sinWaveView.centerYAnchor.constraint(equalTo: worldMapView.centerYAnchor).isActive = true
        sinWaveView.centerXAnchor.constraint(equalTo: worldMapView.centerXAnchor).isActive = true
        sinWaveView.widthAnchor.constraint(equalTo: worldMapView.widthAnchor).isActive = true
        sinWaveView.heightAnchor.constraint(equalTo: worldMapView.heightAnchor).isActive = true
    }
    
    func updateMapOrientation(traitCollection: UITraitCollection) {
        
        sinWaveView.setNeedsDisplay()
        
        worldMapView.setNeedsUpdateConstraints()
        
        let isCompact = traitCollection.verticalSizeClass == .compact
        worldMapView.isCompact = isCompact
        
        view.layoutIfNeeded()
    }
    
    // MARK: Data Update Handlers
    
    // Gets called each time a new point is selected
    func updateGPSData() {
        latValueLbl.text = latitude
        longValueLbl.text = longitude
        compactLatValueLbl.text = latitude
        compactLongValueLbl.text = longitude
    }
    
    // MARK: Rotation Configuration
    
    func transitionToiPadSizeClass(landscape: Bool, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        
        if let constraintsToUninstall = landscape ? portraitConstraints : landscapeConstraints,
            let constraintsToInstall = landscape ? landscapeConstraints : portraitConstraints {
            
            
            view.layoutIfNeeded()
            
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: {
                    _ in
                    NSLayoutConstraint.deactivate(constraintsToUninstall)
                    NSLayoutConstraint.activate(constraintsToInstall)
                    
                    self.configureSelectionStackView(isLandscape: landscape)
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                NSLayoutConstraint.deactivate(constraintsToUninstall)
                NSLayoutConstraint.activate(constraintsToInstall)
                
                configureSelectionStackView(isLandscape: landscape)
            }
        }
    }
    
    func configureSelectionStackView(isLandscape: Bool) {
        // Change selection stack orientation
        if isLandscape {
            firstInnerStack.axis = .vertical
            secondInnerStack.axis = .vertical
        } else {
            firstInnerStack.axis = .horizontal
            secondInnerStack.axis = .horizontal
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        updateMapOrientation(traitCollection: newCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            transitionToiPadSizeClass(landscape: size.width > size.height,
                                      transitionCoordinator: coordinator)
        }
        
    }
}

extension GPSViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return worldMapView
    }
}
