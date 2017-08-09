//
//  TemperatureDataSet.swift
//  UNITE
//
//  Created by Zack Snyder on 2/27/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import Charts

#if os (iOS)
import ChameleonFramework
#endif

class TemperatureDataSet: LineChartDataSet {
    
    // CONSTANTS
    #if os (iOS)
    let DATA_COLORS = FlatNavyBlueDark()
    let VAL_COLORS = FlatNavyBlueDark()
    let HOLE_COLOR = FlatWhite()
    #endif
    
    let CIRCLE_RAD : CGFloat = 5.0
    let CIR_HOLE_RAD : CGFloat = 2.0
    
    #if os (iOS)
    convenience init(color: UIColor) {
        self.init()
        
        mode = .horizontalBezier
        
        colors = [color]
        valueColors = [AppConfig.Chart.CHART_TEXT_COLOR]
        valueFont = UIFont(descriptor: AppConfig.Chart.VALUE_FONT!.fontDescriptor, size: AppConfig.Chart.VALUE_FONT!.pointSize)
        
        
        // Drawing Data Points
        circleColors = [color]
        circleHoleColor = HOLE_COLOR
        circleRadius = CIRCLE_RAD
        circleHoleRadius = CIR_HOLE_RAD
        
        drawCirclesEnabled = false
        drawCircleHoleEnabled = false
    }
    #endif
    
    #if os (macOS)
    convenience init(color: NSColor) {
        self.init()
        
        mode = .horizontalBezier
        
        colors = [color]
        valueColors = [.blue]
        valueFont = NSFont(descriptor: AppConfig.Chart.VALUE_FONT!.fontDescriptor, size: AppConfig.Chart.VALUE_FONT!.pointSize)!
        
        
        // Drawing Data Points
        circleColors = [color]
        circleHoleColor = .white
        circleRadius = CIRCLE_RAD
        circleHoleRadius = CIR_HOLE_RAD
        
        drawCirclesEnabled = false
        drawCircleHoleEnabled = false
    }
    #endif
    
    
    required init() {
        super.init()
    }
}
