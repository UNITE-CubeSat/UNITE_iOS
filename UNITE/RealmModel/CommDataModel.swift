//
//  CommDataModel.swift
//  UNITE
//
//  Created by Zack Snyder on 5/9/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift

class CommData: Object {
    
    dynamic var date = NSDate()
    dynamic var isCommand = false
    
    dynamic var simplexDataUsed = 0.0
    dynamic var duplexDownlinkDataUsed = 0.0
    dynamic var duplexUplinkDataUsed = 0.0
    
    dynamic var totalDataUsed = 0.0
}
