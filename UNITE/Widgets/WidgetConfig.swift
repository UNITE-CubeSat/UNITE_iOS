//
//  WidgetConfig.swift
//  UNITE
//
//  Created by Zack Snyder on 4/12/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation

let WCDataKey = "WidgetData"

class WidgetConfig: NSObject, NSCoding {
    
    var activeWidgetTypes : [WidgetView.WidgetType] {
        didSet (oldValues) {
            if activeWidgetTypes != oldValues {
                save()
            }
        }
    }
    var inactiveWidgetTypes : [WidgetView.WidgetType] {
        didSet (oldValues) {
            if inactiveWidgetTypes != oldValues {
                save()
            }
        }
    }
    
    let WCActiveNamesKey = "ActiveWidgetNames"
    let WCInactiveNamesKey = "InactiveWidgetNames"
    
    static let sharedInstance = WidgetConfig()
    
    static func getActiveWidgets() -> [WidgetView] {
        if let config = loadSave(key: WCDataKey) {
            
            var returnWidgets = [WidgetView]()
            
            for type in config.activeWidgetTypes {
                returnWidgets.append(type.toWidget())
            }
            
            return returnWidgets
        } else {
            var returnWidgets = [WidgetView]()
            
            for type in sharedInstance.activeWidgetTypes {
                returnWidgets.append(type.toWidget())
            }
            
            return returnWidgets
        }
    }
    
    static func getInactiveWidgets() -> [WidgetView] {
        if let config = loadSave(key: WCDataKey) {
            
            var returnWidgets = [WidgetView]()
            
            for type in config.inactiveWidgetTypes {
                returnWidgets.append(type.toWidget())
            }
            
            return returnWidgets
        } else {
            
            var returnWidgets = [WidgetView]()
            
            for type in sharedInstance.inactiveWidgetTypes {
                returnWidgets.append(type.toWidget())
            }
            
            return returnWidgets
        }
    }
    
    func widgetTypeFor(id: String) -> WidgetView.WidgetType {
        return WidgetView.WidgetType.type(from: id)
    }
    
    override init() {
        
        activeWidgetTypes = [] //[WidgetView.WidgetType.gps, WidgetView.WidgetType.temperature]
        inactiveWidgetTypes = []
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        activeWidgetTypes = [] //[WidgetView.WidgetType.gps, WidgetView.WidgetType.temperature]
        inactiveWidgetTypes = []
        
        super.init()

        let activeWidgetNames = aDecoder.decodeObject(forKey: WCActiveNamesKey) as! [String]
        let inactiveWidgetNames = aDecoder.decodeObject(forKey: WCInactiveNamesKey) as! [String]
        
        activeWidgetTypes.removeAll()
        for name in activeWidgetNames {
            activeWidgetTypes.append(widgetTypeFor(id: name))
        }
        
        inactiveWidgetTypes.removeAll()
        for name in inactiveWidgetNames {
            inactiveWidgetTypes.append(widgetTypeFor(id: name))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        
        var activeNames = [String]()
        var inactiveNames = [String]()
        
        for type in activeWidgetTypes {
            activeNames.append(type.toString())
        }
        
        for type in inactiveWidgetTypes {
            inactiveNames.append(type.toString())
        }
        aCoder.encode(activeNames, forKey: WCActiveNamesKey)
        aCoder.encode(inactiveNames, forKey: WCInactiveNamesKey)
    }
    
    func save() {
        let savedData = NSKeyedArchiver.archivedData(withRootObject: self)
        let defaults = UserDefaults.standard
        defaults.set(savedData, forKey: WCDataKey)
    }
    
    func clear() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: WCDataKey)
    }
    
    class func loadSave(key: String) -> WidgetConfig? {
        if let data = UserDefaults.standard.object(forKey: key) as? NSData {
            return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? WidgetConfig
        } else {
            return nil
        }
    }
}
