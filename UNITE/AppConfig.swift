//
//  AppConfig.swift
//  UNITE proto
//
//  Created by Zack Snyder on 2/6/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
#if os (iOS)
import UIKit
import ChameleonFramework
#endif
import MapKit
import ScrollableGraphView

struct AppConfig {
    
    static let UNITE_START_DATE = Date(fromString: "2016-08-23")
    static let UNITE_END_DATE = Date(fromString: "2018-05-03")
    
    static let locManager = CLLocationManager()

    static let GOOGLE_MAPS_KEY_IPHONE = "AIzaSyBegynjwhoSmwaLEQqbcvsq9VR4p1eJQR8"
    static let GOOGLE_MAPS_KEY_IPAD = "AIzaSyC-Hzxm0SY0lg-xKelOLx2bnLJl4XNXwto"
    
    struct Graphics {
        
        static let CORNER_RADIUS : CGFloat = 10.0
    }
    
    struct Widgets {
        
        #if os (iOS)
        func titleLabel() -> UILabel {
            let label = UILabel()
            
            label.textColor = FlatNavyBlueDark()
            label.font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
            
            return label
        }
        #endif
        
        struct Constraints {
            
            static let mainLeading : CGFloat = -10.0
            static let mainTrailing : CGFloat = 10.0
            
            static let contentLeading : CGFloat = -8.0
            static let contentTrailing : CGFloat = 8.0
            static let contentTop : CGFloat = -8.0
            static let contentBottom : CGFloat = 8.0
        }
    }
    
    struct Graph {
        #if os (iOS)
        static let headerFont = UIFont(name: "HelveticaNeue-Light", size: 25.0)
        static let textColor = FlatNavyBlueDark()
        #endif
        
        static let noDataText = "Please Select A Sensor"
        static let dataFont = UIFont(name: "HelveticaNeue-Light", size: 11.0)
        
        
    }
    
    struct DataManagement {
        
        enum ValueType {
            case low
            case average
            case high
            
            #if os (iOS)
            func descColor() -> UIColor {
                switch self {
                case .low:
                    return FlatBlue()
                case .average:
                    return FlatBlack()
                case .high:
                    return FlatRed()
                default:
                    return FlatBlack()
                }
            }
            #endif
            
            func toString() -> String {
                switch self {
                case .low:
                    return "LO"
                case .average:
                    return "Avg"
                case .high:
                    return "HI"
                default:
                    return ""
                }
            }
        }
        
        func sum(array: [Double]) -> Double {
            var sum = 0.0
            for element in array {
                sum += element
            }
            
            return sum
        }
        
        func average(array: [Double]) -> Double {
            return sum(array: array) / Double(array.count)
        }
        
    }
}

#if os (iOS)
protocol UNITEVCProtocol {
    
    func setupUI()
    
    func setupGestureRecognizers()
    
    var preferredStatusBarStyle: UIStatusBarStyle { get }
    
    var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation { get }
    
    var supportedInterfaceOrientations : UIInterfaceOrientationMask { get }
}
#endif

extension Date {
    
    init(fromString dateString: String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let date = formatter.date(from: dateString)
        
        self.init(timeInterval: 0.0, since: date!)
    }
    
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
