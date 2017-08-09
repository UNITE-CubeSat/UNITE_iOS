//
//  CommDataSet.swift
//  UNITE
//
//  Created by Zack Snyder on 5/9/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import Charts

class CommDataSet: BarChartDataSet {
    
    #if os (iOS)
    convenience init(name: String, color: UIColor) {
        self.init()
        
        label = name
        barBorderWidth = 0.0
        colors = [color]
        valueTextColor = AppConfig.Chart.CHART_TEXT_COLOR
        valueFont = AppConfig.Chart.VALUE_FONT!
    }
    #endif
    
    #if os (macOS)
    convenience init(name: String, color: NSColor) {
        self.init()
        
        label = name
        barBorderWidth = 0.0
        colors = [color]
        valueTextColor = .black
        valueFont = AppConfig.Chart.VALUE_FONT!
    }
    #endif
    
    required init() {
        super.init()
    }
}
