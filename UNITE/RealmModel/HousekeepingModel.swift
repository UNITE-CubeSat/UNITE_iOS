//
//  HousekeepingModel.swift
//  UNITE Server
//
//  Created by Zack Snyder on 3/14/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift

final class HKList: Object {
    dynamic var date = NSDate()
    
    let batteryList = List<Battery>()
}

final class Battery: Object {
    dynamic var id = ""
    dynamic var date = NSDate()
    dynamic var value = 0.0
}
