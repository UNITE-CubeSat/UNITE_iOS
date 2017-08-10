//
//  AdminLoginViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 8/8/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ChameleonFramework

class AdminLoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var adminLoginBtn: UIButton!
    
    
    @IBAction func loginAsAdmin(_ sender: UIButton) {
    }
    // MARK: View Contorller Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizers()
    
    }
    
    // MARK: Setup UI
    
    func setupUI() {
        
        
    }
    
    // MARK: Setup Gesture Recognizers
    
    func setupGestureRecognizers() {
        
    }
}
