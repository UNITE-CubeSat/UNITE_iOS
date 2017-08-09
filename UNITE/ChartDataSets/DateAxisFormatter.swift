//
//  DateAxisFormatter.swift
//  UNITE
//
//  Created by Zack Snyder on 5/15/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import Charts

#if os (iOS)
class DateAxisFormatter: UIViewController, IAxisValueFormatter {
    
    let DATE_FORMAT_STRING = "MM/dd/yy"
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT_STRING
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
#endif

#if os (macOS)
    class DateAxisFormatter: NSViewController, IAxisValueFormatter {
        
        let DATE_FORMAT_STRING = "MM/dd/yy"
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DATE_FORMAT_STRING
            return dateFormatter.string(from: Date(timeIntervalSince1970: value))
        }
}
#endif
