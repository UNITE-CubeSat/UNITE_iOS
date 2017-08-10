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
    @IBOutlet weak var cancelLoginBtn: UIButton!
    
    @IBAction func didBeginEnteringText(_ sender: UITextField) {
        
        sender.backgroundColor = UIColor.white
    }
    
    @IBAction func loginAsAdmin(_ sender: UIButton) {
        
        if let username = usernameField.text, !username.isEmpty {
            if let password = passwordField.text, !password.isEmpty {
                
                UNITERealm.user?.logOut()
                
                let credentials = SyncCredentials.usernamePassword(username: username, password: password)
                
                loginToRealm(with: credentials)
                
                if let user = UNITERealm.user, !user.isAdmin {
                    
                    displayEntryError(for: usernameField)
                    displayEntryError(for: passwordField)
                    
                    present(AlertController.create(title: "Login Failed", message: "Username or Password was incorrect", action: "Dismiss"), animated: true, completion: nil)
                } else {
                    present(AlertController.create(title: "Login Succesful", message: "You are now logged in as an admin user", action: "Continue"), animated: true, completion: {
                    })
                    
                    dismiss(animated: true, completion: nil)
                }
                
            } else {
                // Display password error
                passwordField.resignFirstResponder()
                passwordField.placeholder = "Please enter a password"
                displayEntryError(for: passwordField)
            }
        } else {
            // Display username error
            usernameField.resignFirstResponder()
            usernameField.placeholder = "Please enter a username"
            displayEntryError(for: usernameField)
        }
    }
    
    @IBAction func cancelAdminLogin(_ sender: UIButton) {
        
        loginToRealm(with: UNITERealm.userCredentials)
        
        dismiss(animated: true, completion: nil)
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
        cancelLoginBtn.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
    }
    
    // MARK: Setup Gesture Recognizers
    
    func setupGestureRecognizers() {
        usernameField.delegate = self
        usernameField.returnKeyType = .next
    
        passwordField.delegate = self
        passwordField.returnKeyType = .go
    }
    
    // MARK: Login Functions
    
    func displayEntryError(for textField: UITextField) {
        textField.backgroundColor = FlatRed()
    }
}

extension AdminLoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .next {
            passwordField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginAsAdmin(adminLoginBtn)
        }
        
        return false
    }
}
