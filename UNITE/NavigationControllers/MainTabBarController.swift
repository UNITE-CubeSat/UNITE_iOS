//
//  MainTabBarController.swift
//  UNITE proto
//
//  Created by Zack Snyder on 2/6/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class MainTabBarController : UITabBarController {
    
    var originalDataSource : UITableViewDataSource!
    
    //CONSTANTS
    let kOrder = "CustomTabOrder"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moreNavigationController.navigationBar.tintColor = FlatRed()
        
        view.tintColor = FlatRed()
        
        if let tableView = moreNavigationController.topViewController?.view as? UITableView {
            originalDataSource = tableView.dataSource
            tableView.dataSource = self
        }
        
        loadCustomizedViews()
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let currentVC = selectedViewController {
            return currentVC.preferredInterfaceOrientationForPresentation
        }
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let currentVC = selectedViewController {
            return currentVC.supportedInterfaceOrientations
        }
        return .portrait
    }
    
    // Set custom order of tabBar viewControllers
    func loadCustomizedViews(){
        let defaults = UserDefaults.standard
        
        // returns 0 if not set, hence having the tabItem's tags starting at 1.
        let changed : Bool = defaults.bool(forKey: kOrder)
        
        if changed {
            var customViewControllers = [UIViewController]()
            var tagNumber: Int = 0
            
            if let vcs = viewControllers{
                for i in 0..<vcs.count {
                    // the tags are between 0-? and the
                    // viewControllers in the array are between 0-?
                    // so we swap them to match the custom order
                    tagNumber = defaults.integer(forKey: String(i))
                    
                    //print("TabBar re arrange i = \(i), tagNumber = \(tagNumber),  viewControllers.count = \(self.viewControllers?.count) ")
                    customViewControllers.append(vcs[tagNumber])
                }
            }
            
            self.viewControllers = customViewControllers
        }
    }
    
    
    // Save order of tabBar viewControllers
    override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        
        if changed {
            
            let defaults = UserDefaults.standard
            if let vcs = viewControllers {
                
                for i in 0..<vcs.count {
                    
                    defaults.set(vcs[i].tabBarItem.tag, forKey: String(i))
                }
            }
            
            defaults.set(changed, forKey: kOrder)
        }
    }
}

extension MainTabBarController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = originalDataSource.tableView(tableView, cellForRowAt: indexPath)
       
        cell.textLabel?.textColor = FlatNavyBlueDark()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return originalDataSource.tableView(tableView, numberOfRowsInSection: section)
    }
}
