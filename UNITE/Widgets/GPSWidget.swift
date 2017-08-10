//
//  GPSWidget.swift
//  
//
//  Created by Zack Snyder on 2/11/17.
//
//

import Foundation
import ChameleonFramework
import MapKit

class GPSWidget: WidgetView {
    
    var map : MapView!
    let zoom : Float = 5.0
    let accuracy : Double = 1000.0
    
    override var id: String { return WidgetType.gps.toString() }
    
    // CONSTANTS
    let TITLE_TEXT = "GPS"
    let ASPECT_RATIO : CGFloat = 4.0/3.0
    
    override func setupContent() {
        createWidget(widgetType: .gps)
        
//        setupMap()
//        addContentConstraints()
    }
    
    
    private func setupMap() {
        
        map = MapView(boundingView: contentView, isCompact: traitCollection.verticalSizeClass == .compact)
        map.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(map)
        map.isHidden = true
        
        askLocationPermission()

    }
    
    private func addContentConstraints() {
        
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: ASPECT_RATIO).isActive = true

        
        contentView.leadingAnchor.constraint(equalTo: map.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: map.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: map.topAnchor).isActive = true
    }
}

extension GPSWidget : CLLocationManagerDelegate {
    
    func askLocationPermission() {
        
        // Request User Location as a placeholder for satellite
        AppConfig.locManager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .denied && CLLocationManager.authorizationStatus() != .restricted {
            
            if CLLocationManager.authorizationStatus() == .notDetermined {
                AppConfig.locManager.requestWhenInUseAuthorization()
            }
            
            AppConfig.locManager.desiredAccuracy = kCLLocationAccuracyKilometer
            AppConfig.locManager.distanceFilter = accuracy
            
            AppConfig.locManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
