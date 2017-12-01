//
//  TemperatureModel.swift
//  UNITE Server
//
//  Created by Zack Snyder on 3/14/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift

// One for each sensor
final class Temperature: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var value = 0.0
}
