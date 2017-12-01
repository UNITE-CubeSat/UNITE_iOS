//
//  HousekeepingModel.swift
//  UNITE Server
//
//  Created by Zack Snyder on 3/14/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift

final class BatteryPack: Object {
    @objc dynamic var id = ""
    
    @objc dynamic var charge = 0.0
    @objc dynamic var current = 0.0
    @objc dynamic var voltage = 0.0
    
    @objc dynamic var date = NSDate()
}
