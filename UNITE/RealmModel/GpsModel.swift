//
//  GpsModel.swift
//  UNITE Server
//
//  Created by Zack Snyder on 3/14/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

final class GPS: Object {
    @objc dynamic var date = NSDate()
    
    @objc dynamic var latitude = ""
    @objc dynamic var longtitude = ""
    @objc dynamic var altitude = 0.0
    
    @objc dynamic var linearVelocity = 0.0
    
    // Position
    @objc dynamic var xPosition: Double = 0.0
    @objc dynamic var yPosition: Double = 0.0
    @objc dynamic var zPosition: Double = 0.0
    
    // Velocity
    @objc dynamic var xVelocity: Float = 0.0
    @objc dynamic var yVelocity: Float = 0.0
    @objc dynamic var zVelocity: Float = 0.0
}
