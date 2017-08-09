//
//  TemperatureModel.swift
//  UNITE Server
//
//  Created by Zack Snyder on 3/14/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift


final class TemperatureSet: Object {
    dynamic var date = NSDate()
    var sensorList = List<Temperature>()
}

// One for each sensor
final class Temperature: Object {
    dynamic var id = ""
    dynamic var date = NSDate()
    dynamic var value = 0.0
}
