//
//  WidgetManagerViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 2/13/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class WidgetManagerViewController: UIViewController {
    
    var activeWidgets : [WidgetView.WidgetType] = []
    var inactiveWidgets : [WidgetView.WidgetType] = []
    
    var parentVC : HomeViewController!
    
    var widgetConfiguration : WidgetConfig {
        if let config = WidgetConfig.loadSave(key: WCDataKey) {
            return config
        } else {
            return WidgetConfig.sharedInstance
        }
    }
    
    // CONSTANTS
    let STANDARD_SECTION_INDEX = 0
    let ACTIVE_SECTION_INDEX = 1
    let INACTIVE_SECTION_INDEX = 2
    
    // Standard Section
    let numberOfStandardRows = 2
    let firstRowName = "Time Clock"
    let secondRowName = "Links"
    
    let STANDARD_REUSE_STRING = "Standard"
    let ACTIVE_REUSE_STRING = "Active"
    let INACTIVE_REUSE_STRING = "Inactive"
    let REMOVE_TEXT = "Remove"
    let INSERT_TEXT = "Insert"
    
    let RETURN_VC_ID = "MainTabBarVC"
    
    let HEADER_HEIGHT : CGFloat = 20.0
    
    @IBOutlet weak var WidgetNavBar: UIToolbar!
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: {
        })
    }
    
    
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        
        widgetConfiguration.activeWidgetTypes = activeWidgets
        widgetConfiguration.inactiveWidgetTypes = inactiveWidgets
                
        dismiss(animated: true, completion: {
            self.parentVC.updateWidgetStack()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WidgetNavBar.isTranslucent = false
        WidgetNavBar.barTintColor = FlatRedDark()
        WidgetNavBar.tintColor = .white
        WidgetNavBar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        WidgetNavBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        let statusBarColorView = UIView(frame: CGRect.zero)
        statusBarColorView.frame.size.width = view.bounds.width
        statusBarColorView.frame.size.height = 20.0
        statusBarColorView.backgroundColor = FlatRedDark()
        view.addSubview(statusBarColorView)
        view.sendSubview(toBack: statusBarColorView)
        
        activeWidgets = widgetConfiguration.activeWidgetTypes
        inactiveWidgets = widgetConfiguration.inactiveWidgetTypes
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension WidgetManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == STANDARD_SECTION_INDEX{
            return numberOfStandardRows
        } else if section == ACTIVE_SECTION_INDEX {
            return activeWidgets.count
        } else if section == INACTIVE_SECTION_INDEX {
            return inactiveWidgets.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == STANDARD_SECTION_INDEX{
            let cell = tableView.dequeueReusableCell(withIdentifier: STANDARD_REUSE_STRING)!
            cell.textLabel?.text = indexPath.row == 0 ? firstRowName : secondRowName
            cell.textLabel?.textColor = FlatGrayDark()
            return cell
        
        } else if indexPath.section == ACTIVE_SECTION_INDEX {
            let cell = tableView.dequeueReusableCell(withIdentifier: ACTIVE_REUSE_STRING) as! ActiveWidgetCell
            cell.widgetTitleLbl.text = activeWidgets[indexPath.row].toString()
            cell.widgetIcon.image = activeWidgets[indexPath.row].toImage().withRenderingMode(.alwaysTemplate)
            cell.widgetIcon.tintColor = FlatNavyBlueDark()
            return cell

        } else if indexPath.section == INACTIVE_SECTION_INDEX {
            let cell = tableView.dequeueReusableCell(withIdentifier: INACTIVE_REUSE_STRING) as! InactiveWidgetCell
            cell.widgetTitleLbl.text = inactiveWidgets[indexPath.row].toString()
            cell.widgetTitleLbl.textColor = FlatRedDark()
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == STANDARD_SECTION_INDEX{
            return STANDARD_REUSE_STRING
        } else if section == ACTIVE_SECTION_INDEX {
            return ACTIVE_REUSE_STRING
        } else if section == INACTIVE_SECTION_INDEX {
            return INACTIVE_REUSE_STRING
        }
        
        return ""
    }
    
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section != STANDARD_SECTION_INDEX {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    // Allow swipe to delete a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.section == ACTIVE_SECTION_INDEX {
            let delete = UITableViewRowAction(style: .normal, title: REMOVE_TEXT, handler: { (action, indexPath) in
                
                // Hold removed widget type
                let removedWidget = self.activeWidgets[indexPath.row]
                
                // Remove widget from active list
                self.activeWidgets.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                // Insert widget in inactive list
                self.inactiveWidgets.append(removedWidget)
                let insertIndexPath = IndexPath(row: tableView.numberOfRows(inSection: self.INACTIVE_SECTION_INDEX), section: self.INACTIVE_SECTION_INDEX)
                tableView.insertRows(at: [insertIndexPath], with: .fade)
                
            })
            delete.backgroundColor = FlatRed()
            return [delete]
            
        } else if indexPath.section == INACTIVE_SECTION_INDEX {
            
            let insert = UITableViewRowAction(style: .normal, title: INSERT_TEXT, handler: { (action, indexPath) in
                
                let removedWidget = self.inactiveWidgets[indexPath.row]
                
                self.inactiveWidgets.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                self.activeWidgets.append(removedWidget)
                let insertIndexPath = IndexPath(row: tableView.numberOfRows(inSection: self.ACTIVE_SECTION_INDEX), section: self.ACTIVE_SECTION_INDEX)
                tableView.insertRows(at: [insertIndexPath], with: .fade)
            })
            insert.backgroundColor = FlatGreen()
            return [insert]
        }
        
        return nil
    }
}

class ActiveWidgetCell: UITableViewCell {
    
    @IBOutlet weak var widgetTitleLbl: UILabel!
    @IBOutlet weak var widgetIcon: UIImageView!

}

class InactiveWidgetCell: UITableViewCell {
    
    @IBOutlet weak var widgetTitleLbl: UILabel!

}
