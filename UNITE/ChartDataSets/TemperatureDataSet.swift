//
//  TemperatureDataSet.swift
//  UNITE
//
//  Created by Zack Snyder on 2/27/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import Charts
import ChameleonFramework

class TemperatureDataSet: LineChartDataSet {
    
    // CONSTANTS
    let DATA_COLORS = FlatNavyBlueDark()
    let VAL_COLORS = FlatNavyBlueDark()
    let HOLE_COLOR = FlatWhite()
    let VALUE_FONT = UIFont(name: "AvenirNext-Light", size: 30.0)
    let CIRCLE_RAD : CGFloat = 5.0
    let CIR_HOLE_RAD : CGFloat = 2.0
    
    convenience init(color: UIColor) {
        self.init()
        
        mode = .horizontalBezier
        
        colors = [color]
        valueColors = [color]
        valueFont = valueFont
        
        // Drawing Data Points
        circleColors = [color]
        circleHoleColor = HOLE_COLOR
        circleRadius = CIRCLE_RAD
        circleHoleRadius = CIR_HOLE_RAD
        
        drawCirclesEnabled = false
        drawCircleHoleEnabled = false
    }
    
    required init() {
        super.init()
    }
}
