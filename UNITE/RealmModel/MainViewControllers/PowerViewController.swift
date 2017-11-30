//
//  PowerViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 4/15/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import RealmSwift
import ScrollableGraphView
import ChameleonFramework

class PowerViewController: UIViewController, UNITEVCProtocol {
    
    // MARK: Outlets
    @IBOutlet weak var xPosLbl: UILabel!
    @IBOutlet weak var xNegLbl: UILabel!
    @IBOutlet weak var yPosLbl: UILabel!
    @IBOutlet weak var yNegLbl: UILabel!
    
    @IBOutlet weak var loPowerLbl: UILabel!
    @IBOutlet weak var avgPowerLbl: UILabel!
    @IBOutlet weak var hiPowerLbl: UILabel!
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var chargeView: UIView!
    
    @IBOutlet weak var graphView: ScrollableGraphView!
    
    @IBOutlet weak var powerPageControl: UIPageControl!
    
    // Constraints
    @IBOutlet var landscapeConstraints: [NSLayoutConstraint]!
    @IBOutlet var portraitConstraints: [NSLayoutConstraint]!
    
    // Stacks
    @IBOutlet weak var outerStack: UIStackView!
    @IBOutlet weak var firstInnerStack: UIStackView!
    @IBOutlet weak var secondInnerStack: UIStackView!
    
    // Sensor Selection
    var selectedPanels = [UILabel]()
    var chartColors = [FlatRed(), FlatBlue(), FlatGreen(), FlatYellow(), FlatPlum(), FlatOrange()]
    
    // Realm
    var token : NotificationToken!
    
    // MARK: IBActions
    
    func didTapPowerPanel(tap: UILongPressGestureRecognizer) {
        
        switch tap.state {
        case .began:
            
            if let label = tap.view as? UILabel {
                
                // Tap Color Feedback
                if label.backgroundColor == UIColor.white {
                    label.backgroundColor = FlatWhiteDark()
                } else if label.backgroundColor == FlatRed() {
                    label.backgroundColor = FlatRedDark()
                }
            } else {
                print("view is not uilabel")
            }
        case .ended:
            
            if let label = tap.view as? UILabel {
                
                // Select/Deselect tapped panel
                if label.textColor == FlatRed() {
                    select(panel: label)
                } else {
                    deselect(panel: label)
                }
                
                let location = tap.location(in: label)
                let isTouchInsideView = CGRect(origin: CGPoint.zero, size: label.bounds.size).contains(location)
                
                if isTouchInsideView {
                }
            }
            
        case .cancelled:
            
            if let view = tap.view {
                view.backgroundColor = UIColor.white
            }
            
        default:
            break
        }
    }
    
    // MARK: View Controller Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizers()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupPowerGraph()

        if UIDevice.current.userInterfaceIdiom == .pad {
            transitionToiPadSizeClass(landscape: view.frame.width > view.frame.height,
                                      transitionCoordinator: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    deinit {
        if token != nil {
            token.invalidate()
        }
    }
    
    // MARK: Gesture Recognizers
    
    func setupGestureRecognizers() {
        let xPosTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapPowerPanel(tap:)))
        let xNegTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapPowerPanel(tap:)))
        let yPosTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapPowerPanel(tap:)))
        let yNegTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapPowerPanel(tap:)))
        
        xPosTouch.minimumPressDuration = 0.001
        xNegTouch.minimumPressDuration = 0.001
        yPosTouch.minimumPressDuration = 0.001
        yNegTouch.minimumPressDuration = 0.001
        
        xPosLbl.addGestureRecognizer(xPosTouch)
        xNegLbl.addGestureRecognizer(xNegTouch)
        yPosLbl.addGestureRecognizer(yPosTouch)
        yNegLbl.addGestureRecognizer(yNegTouch)
    }
    
    
    // MARK: Graphics Setup
    
    func setupUI() {
        
        // Corner Radius
        xPosLbl.layer.masksToBounds = true
        xPosLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        xPosLbl.textColor = FlatRed()
        xPosLbl.backgroundColor = UIColor.white
        
        xNegLbl.layer.masksToBounds = true
        xNegLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        xNegLbl.textColor = FlatRed()
        xNegLbl.backgroundColor = UIColor.white
        
        yPosLbl.layer.masksToBounds = true
        yPosLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        yPosLbl.textColor = FlatRed()
        yPosLbl.backgroundColor = UIColor.white
        
        yNegLbl.layer.masksToBounds = true
        yNegLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        yNegLbl.textColor = FlatRed()
        yNegLbl.backgroundColor = UIColor.white
        
        currentView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        chargeView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        
    }
    
    // MARK: Panel Controls
    
    func select(panel: UILabel) {
        panel.backgroundColor = FlatRed()
        panel.textColor = FlatWhite()
        selectedPanels.append(panel)
        
        graphView.reload()
        updateAverages()
    }
    
    func deselect(panel: UILabel) {
        panel.backgroundColor = UIColor.white
        panel.textColor = FlatRed()

        if let index = selectedPanels.index(of: panel) { selectedPanels.remove(at: index) }
        
        graphView.reload()
        updateAverages()
    }
    
    // MARK: Power Chart Setup
    
    func setupPowerGraph() {
        
    }
    
    // Updates Average Labels
    func updateAverages() {
        
        var avgLoPower = [Double]()
        var avgPower = [Double]()
        var avgHiPower = [Double]()
        
        
        if !avgLoPower.isEmpty {
            loPowerLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgLoPower))
        } else {
            loPowerLbl.text = "— —"
        }
        
        if !avgPower.isEmpty {
            avgPowerLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgPower))
        } else {
            avgPowerLbl.text = "— —"
        }
        
        if !avgHiPower.isEmpty {
            hiPowerLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgHiPower))
        } else {
            hiPowerLbl.text = "— —"
        }
    }

    // MARK: iPad Orientation Transition
    
    func transitionToiPadSizeClass(landscape: Bool, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        
        if let constraintsToUninstall = landscape ? portraitConstraints : landscapeConstraints, let constraintsToInstall = landscape ? landscapeConstraints : portraitConstraints {
            
            
            view.layoutIfNeeded()
            
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: {
                    _ in
                    NSLayoutConstraint.deactivate(constraintsToUninstall)
                    NSLayoutConstraint.activate(constraintsToInstall)
                    
                    self.configureSelectionStackView(isLandscape: landscape)
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                NSLayoutConstraint.deactivate(constraintsToUninstall)
                NSLayoutConstraint.activate(constraintsToInstall)
                
                configureSelectionStackView(isLandscape: landscape)
            }
        }
    }
    
    func configureSelectionStackView(isLandscape: Bool) {
        // Change selection stack orientation
        if isLandscape {
            outerStack.axis = .horizontal
            firstInnerStack.axis = .vertical
            secondInnerStack.axis = .vertical
        } else {
            outerStack.axis = .vertical
            firstInnerStack.axis = .horizontal
            secondInnerStack.axis = .horizontal
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            transitionToiPadSizeClass(landscape: size.width > size.height,
                                      transitionCoordinator: coordinator)
        }
        
        coordinator.animate(alongsideTransition: { _ in
            
            // Add custom layout animation code here
        }, completion: nil)
    }
}

extension PowerViewController : ScrollableGraphViewDataSource {
   
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return 0.0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
    }
    
    func numberOfPoints() -> Int {
        return 0
    }
    
}

// MARK: Realm Handler
extension PowerViewController {
    
    func setupRefreshToken() {
        DispatchQueue.main.async {
            
            if let realm = UNITERealm.activeRealm {
                self.token = realm.observe { (_,_) in

                }
            }
        }
    }
}


extension PowerViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        powerPageControl.currentPage = Int(round(scrollView.contentOffset.x/view.bounds.width))
    }
}
