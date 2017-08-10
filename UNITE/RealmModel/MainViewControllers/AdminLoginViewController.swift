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
import KDLoadingView

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
                
                usernameField.resignFirstResponder()
                passwordField.resignFirstResponder()
                
                UNITERealm.user?.logOut()
                UNITERealm.user = nil
                
                let credentials = SyncCredentials.usernamePassword(username: username, password: password)
                
                loginToRealm(with: credentials)
                
                waitForLoginToComplete()
                
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
    
    func waitForLoginToComplete() {
        // Blur View
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.frame = view.bounds
        
        // Loading View Animation
        let loadingViewRect = CGRect(x: 0.0, y: 0.0, width: 75.0, height: 75.0)
        let loadingView = KDLoadingView(frame: loadingViewRect, lineWidth: 2.0, firstColor: FlatRed(), secondColor: UIColor.white, thirdColor: FlatNavyBlueDark(), duration: CGFloat(UNITERealm.serverTimeout) / 3.0)
        
        loadingView.center = view.center
        
        view.addSubview(blurView)
        view.addSubview(loadingView)
        
        loadingView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10.0) {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
            blurView.removeFromSuperview()
            
            self.testLoginSuccess()
        }
        
    }
    
    func testLoginSuccess() {
        
        if let user = UNITERealm.user, user.isAdmin {
            let loginSuccessfulAlert = UIAlertController(title: "Login Succesful", message: "You are now logged in as an admin user", preferredStyle: .actionSheet)
            let continueAction = UIAlertAction(title: "Continue", style: .default, handler: {
                action in
                loginSuccessfulAlert.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            })
            
            loginSuccessfulAlert.addAction(continueAction)
            
            present(loginSuccessfulAlert, animated: true, completion: nil)
            
        } else {
            displayEntryError(for: usernameField)
            displayEntryError(for: passwordField)
            
            present(AlertController.create(title: "Login Failed", message: "Username or Password was incorrect", action: "Dismiss"), animated: true, completion: nil)
            
            
        }
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
