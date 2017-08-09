//
//  MainViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 5/18/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import AppKit

class MainViewController: NSViewController {
    
    let navigationList : [Any] = [NSImage(named: "UNITE_white")!, "SUBSYSTEMS"]
    let subsystemList : [Subsystem] = [Subsystem(name: "Langmuir Probe", imageName: "Probe"),
                                       Subsystem(name: "Temperature", imageName: "Temperature"),
                                       Subsystem(name: "GPS", imageName: "GPS")]
    
    // MARK: Outlets
    @IBOutlet weak var sourceListView: NSOutlineView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceListView.dataSource = self
        sourceListView.delegate = self
        sourceListView.reloadData()
    }
}
