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
        
        if let username = usernameField.text {
            if let password = passwordField.text {
                
                UNITERealm.user?.logOut()
                
                let credentials = SyncCredentials.usernamePassword(username: username, password: password)
                
                logInToRealm(with: credentials)
                
                
                
            } else {
                // Display password error
            }
        } else {
            // Display username error
        }
    }
    // MARK: View Contorller Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizers()
    
    }
    
    // White status bar text
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Don't show in landscape for iPhone
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone { return .portrait }
        return .landscape
    }
    
    // Prefer portrait
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // MARK: Setup UI
    
    func setupUI() {
        
        // Round view corners
        adminLoginBtn.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
    }
    
    // MARK: Setup Gesture Recognizers
    
    func setupGestureRecognizers() {
        
    }
}
