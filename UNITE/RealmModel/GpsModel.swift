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
    dynamic var date = NSDate()
    
    dynamic var latitude = ""
    dynamic var longtitude = ""
    dynamic var altitude = 0.0
    dynamic var velocity = 0.0
}
