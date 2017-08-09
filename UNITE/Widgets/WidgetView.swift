//
//  WidgetView.swift
//  UNITE proto
//
//  Created by Zack Snyder on 2/11/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit

class WidgetView: UIView {
    
    enum WidgetType {
        case temperature
        case gps
        case none
        
        func toString() -> String {
            switch self {
            case .temperature:
                return "Temperature"
            case .gps:
                return "GPS"
            default:
                return ""
            }
        }
        
        func toImage() -> UIImage {
            switch self {
            case .temperature:
                return #imageLiteral(resourceName: "Temperature")
            case .gps:
                return #imageLiteral(resourceName: "GPS")
            default:
                return UIImage()
            }
        }
        
        func toWidget() -> WidgetView {
            switch self {
            case .temperature:
                return TempWidget()
            case .gps:
                return GPSWidget()
            default:
                return WidgetView()
            }
        }
        
        static func type(from id: String) -> WidgetType {
            switch id {
            case "Temperature":
                return .temperature
            case "GPS":
                return .gps
            default:
                return .none
            }
        }
    }
    
    var title = UILabel()
    var contentView = UIView()
    
    // Must override in subclasses
    var id : String { return "" }
    
    
    // CONSTANTS
    let CONTENT_SPACING : CGFloat = 14.0
    
    // Must call before adding to superview
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        backgroundColor = UIColor.white
    }
    
    // Must call before setting up any custom content on the widget
    func createWidget(widgetType: WidgetType) {
        setupTitle(text: widgetType.toString())
        setupContentView()
    }
    
    func setupContent() {
        // Override implementation
    }
    
    private func setupTitle(text: String) {
        title = AppConfig.Widgets().titleLabel()
        title.text = text
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        leadingAnchor.constraint(equalTo: title.leadingAnchor, constant: AppConfig.Widgets.Constraints.contentLeading).isActive = true
        topAnchor.constraint(equalTo: title.topAnchor, constant: AppConfig.Widgets.Constraints.contentTop).isActive = true
        trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: AppConfig.Widgets.Constraints.contentTrailing).isActive = true
    }
    
    private func setupContentView() {
        contentView.backgroundColor = UIColor.clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: AppConfig.Widgets.Constraints.contentLeading).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: AppConfig.Widgets.Constraints.contentBottom).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: AppConfig.Widgets.Constraints.contentTrailing).isActive = true
        
        contentView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: CONTENT_SPACING).isActive = true
    }
    
}
