//
//  NavigationControllerDelegate.swift
//  UNITE
//
//  Created by Zack Snyder on 5/18/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import AppKit

class Subsystem: NSObject {
    var title: String
    var image: NSImage?
    
    init(name: String, imageName: String) {
        title = name
        image = NSImage(named: imageName)
    }
}

extension MainViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let item = item as? String {
            
            switch item {
            case navigationList[1] as! String: return subsystemList.count
            default: return 1
            }
            
        } else {
            return navigationList.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        if item is String {
            
            return true
            
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item is String {
            
            return subsystemList[index]
            
        } else {
            
            return navigationList[index]
        }
    }
    
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        
        if let image = item as? NSImage {
            
            let logoCell = outlineView.make(withIdentifier: "LogoView", owner: outlineView) as! NSImageView
            logoCell.image = image
            
            return logoCell
            
        } else if let text = item as? String {
            
            let headerCell = outlineView.make(withIdentifier: "HeaderView", owner: outlineView) as! NSTableCellView
            
            if let textField = headerCell.textField {
                textField.stringValue = text
            }
            return headerCell
            
        } else if let subsystem = item as? Subsystem {
            
            let dataCell = outlineView.make(withIdentifier: "DataView", owner: outlineView) as! NSTableCellView
            dataCell.imageView?.image = subsystem.image
            dataCell.textField?.stringValue = subsystem.title
            return dataCell
        }
        
        return item
    }
}


extension MainViewController: NSOutlineViewDelegate {
    
}
