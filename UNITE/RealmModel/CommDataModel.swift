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
    
    @objc dynamic var date = NSDate()
    @objc dynamic var isCommand = false
    
    @objc dynamic var simplexDataUsed = 0.0
    @objc dynamic var duplexDownlinkDataUsed = 0.0
    @objc dynamic var duplexUplinkDataUsed = 0.0
    
    @objc dynamic var totalDataUsed = 0.0
}
