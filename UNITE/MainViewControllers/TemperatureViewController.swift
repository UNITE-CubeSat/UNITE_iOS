//
//  TemperatureViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 2/24/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import ScrollableGraphView
import RealmSwift

class TemperatureViewController: UIViewController, UNITEVCProtocol {
    
    
    // MARK: Outlets
    
    // Sensor Panels
    @IBOutlet weak var xPosLbl: UILabel!
    @IBOutlet weak var xNegLbl: UILabel!
    @IBOutlet weak var yPosLbl: UILabel!
    @IBOutlet weak var yNegLbl: UILabel!
    @IBOutlet weak var zPosLbl: UILabel!
    @IBOutlet weak var zNegLbl: UILabel!
    @IBOutlet weak var boardLbl: UILabel!
    @IBOutlet weak var langmuirLbl: UILabel!
    @IBOutlet weak var epsEmbeddedLbl: UILabel!
    @IBOutlet weak var epsLbl: UILabel!
    
    // Segment Controls
    @IBOutlet weak var sensorSelectorSegControl: UISegmentedControl!
    @IBOutlet weak var timeSelectorSegControl: UISegmentedControl!
    
    @IBOutlet weak var tempDisplayPageControl: UIPageControl!
    
    // Display Views
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var averagesView: UIView!
    
    // Average Labels
    @IBOutlet weak var loTempLbl: UILabel!
    @IBOutlet weak var avgTempLbl: UILabel!
    @IBOutlet weak var hiTempLbl: UILabel!
    
    // Constraints
    @IBOutlet var landscapeConstraints: [NSLayoutConstraint]!
    @IBOutlet var portraitConstraints: [NSLayoutConstraint]!
    
    // Selection Stacks
    @IBOutlet weak var outerStack: UIStackView!
    @IBOutlet weak var firstInnerStack: UIStackView!
    @IBOutlet weak var secondInnerStack: UIStackView!
    
    
    // MARK: Instance Variables
    
    // Sensor Selection
    var selectedSensors = [UILabel]()
    var chartColors = [FlatRed(), FlatBlue(), FlatGreen(), FlatYellow(), FlatPlum(), FlatOrange()]
    
    // Realm
    var token : NotificationToken!
    
    // MARK: CONSTANTS
    let MIN_PRESS_DUR = 0.001
    
    
    // MARK: Gesture Handlers
    
    @objc func didTapTempPanel(tap: UILongPressGestureRecognizer) {
        
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
    
    // MARK: Action Handlers
    
    @IBAction func tempSelectDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            deselect(panel: xPosLbl)
            deselect(panel: xNegLbl)
            deselect(panel: yPosLbl)
            deselect(panel: yNegLbl)
            deselect(panel: zPosLbl)
            deselect(panel: zNegLbl)
            deselect(panel: boardLbl)
            deselect(panel: langmuirLbl)
            deselect(panel: epsEmbeddedLbl)
            deselect(panel: epsLbl)
        case 1:
            selectedSensors.removeAll()
            deselect(panel: xPosLbl)
            deselect(panel: xNegLbl)
            deselect(panel: yPosLbl)
            deselect(panel: yNegLbl)
            deselect(panel: zPosLbl)
            deselect(panel: zNegLbl)
            select(panel: boardLbl)
            select(panel: langmuirLbl)
            select(panel: epsEmbeddedLbl)
            select(panel: epsLbl)
        case 2:
            selectedSensors.removeAll()
            select(panel: xPosLbl)
            select(panel: xNegLbl)
            select(panel: yPosLbl)
            select(panel: yNegLbl)
            select(panel: zPosLbl)
            select(panel: zNegLbl)
            deselect(panel: boardLbl)
            deselect(panel: langmuirLbl)
            deselect(panel: epsEmbeddedLbl)
            deselect(panel: epsLbl)
        default:
            break
        }
    }
    
    @IBAction func timeSelectDidChange(_ sender: UISegmentedControl) {
    }
    
    // MARK: ViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGestureRecognizers()
        setupUI()
        setupRefreshToken()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupTempGraph()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            transitionToiPadSizeClass(landscape: view.frame.width > view.frame.height,
                                      transitionCoordinator: transitionCoordinator)
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
        let xPosTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let xNegTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let yPosTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let yNegTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let zPosTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let zNegTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let boardTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let langmuirTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let epsEmbeddedTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        let epsTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        
        xPosTouch.minimumPressDuration = MIN_PRESS_DUR
        xNegTouch.minimumPressDuration = MIN_PRESS_DUR
        yPosTouch.minimumPressDuration = MIN_PRESS_DUR
        yNegTouch.minimumPressDuration = MIN_PRESS_DUR
        zPosTouch.minimumPressDuration = MIN_PRESS_DUR
        zNegTouch.minimumPressDuration = MIN_PRESS_DUR
        boardTouch.minimumPressDuration = MIN_PRESS_DUR
        langmuirTouch.minimumPressDuration = MIN_PRESS_DUR
        epsEmbeddedTouch.minimumPressDuration = MIN_PRESS_DUR
        epsTouch.minimumPressDuration = MIN_PRESS_DUR
        
        xPosLbl.addGestureRecognizer(xPosTouch)
        xNegLbl.addGestureRecognizer(xNegTouch)
        yPosLbl.addGestureRecognizer(yPosTouch)
        yNegLbl.addGestureRecognizer(yNegTouch)
        zPosLbl.addGestureRecognizer(zPosTouch)
        zNegLbl.addGestureRecognizer(zNegTouch)
        boardLbl.addGestureRecognizer(boardTouch)
        langmuirLbl.addGestureRecognizer(langmuirTouch)
        epsEmbeddedLbl.addGestureRecognizer(epsEmbeddedTouch)
        epsLbl.addGestureRecognizer(epsTouch)
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
        
        zPosLbl.layer.masksToBounds = true
        zPosLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        zPosLbl.textColor = FlatRed()
        zPosLbl.backgroundColor = UIColor.white
        
        zNegLbl.layer.masksToBounds = true
        zNegLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        zNegLbl.textColor = FlatRed()
        zNegLbl.backgroundColor = UIColor.white
        
        boardLbl.layer.masksToBounds = true
        boardLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        boardLbl.textColor = FlatRed()
        boardLbl.backgroundColor = UIColor.white
        
        langmuirLbl.layer.masksToBounds = true
        langmuirLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        langmuirLbl.textColor = FlatRed()
        langmuirLbl.backgroundColor = UIColor.white
        
        epsEmbeddedLbl.layer.masksToBounds = true
        epsEmbeddedLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        epsEmbeddedLbl.textColor = FlatRed()
        epsEmbeddedLbl.backgroundColor = UIColor.white
        
        epsLbl.layer.masksToBounds = true
        epsLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        epsLbl.textColor = FlatRed()
        epsLbl.backgroundColor = UIColor.white
        
    }
    
    // MARK: Temperature Chart Setup
    
    func setupTempGraph() {
        
        // Data Plots
        
//        tempChart.delegate = self
//        tempChart.xAxis.valueFormatter = DateAxisFormatter()
//        tempChart.frame = CGRect(origin: CGPoint.zero, size: graphView.bounds.size)
//        tempChart.noDataText = AppConfig.Chart.NO_DATA_TEXT
//        tempChart.noDataFont = AppConfig.Chart.NO_DATA_FONT
//        tempChart.noDataTextColor = AppConfig.Chart.CHART_TEXT_COLOR
//
//        tempChart.borderLineWidth = 5.0
//        tempChart.pinchZoomEnabled = false
//        tempChart.drawGridBackgroundEnabled = false
//        tempChart.highlightPerTapEnabled = false
//        tempChart.highlightPerDragEnabled = false
//
//
//        tempChart.chartDescription = AppConfig.Chart.chartDescription(text: "")
//
//        tempData.setValueTextColor(AppConfig.Chart.CHART_TEXT_COLOR)
//
//        graphView.addSubview(tempChart)
    }
    
    func updateChartData() {
        
//        tempData.clearValues()
//
//        if !selectedSensors.isEmpty && UNITERealm.activeRealm != nil {
//
//            for index in 1...selectedSensors.count {
//
//                let temperatureResults = UNITERealm.activeRealm.objects(Temperature.self).filter(NSPredicate(format: "id == %@", selectedSensors[index-1].text!))
//                let sensorDataSet = TemperatureDataSet(color: chartColors[(index-1) % chartColors.count])
//                sensorDataSet.label = selectedSensors[index-1].text!
//
//                // Generate entries for each sensor
//                for entry in temperatureResults {
//                    let newEntry = ChartDataEntry(x: entry.date.timeIntervalSince1970, y: entry.value)
//                    sensorDataSet.addEntryOrdered(newEntry)
//                }
//
//                // Add data set to LineChartData object
//                if sensorDataSet.entryCount > 0 {
//                    tempData.addDataSet(sensorDataSet)
//                }
//            }
//        }
//
//        // Clear chart if nothing is selected
//        if tempData.dataSets.isEmpty { tempChart.clear() }
//        else { tempChart.data = tempData }
    }
    
    // Updates Average Labels
    func updateAverages() {
        
//        var avgLoTemps = [Double]()
//        var avgTemps = [Double]()
//        var avgHiTemps = [Double]()
//
//
//        if !avgLoTemps.isEmpty {
//            loTempLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgLoTemps))
//        } else {
//            loTempLbl.text = "— —"
//        }
//
//        if !avgTemps.isEmpty {
//            avgTempLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgTemps))
//        } else {
//            avgTempLbl.text = "— —"
//        }
//
//        if !avgHiTemps.isEmpty {
//            hiTempLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgHiTemps))
//        } else {
//            hiTempLbl.text = "— —"
//        }
    }
    
    func select(panel: UILabel) {
        panel.backgroundColor = FlatRed()
        panel.textColor = FlatWhite()
        selectedSensors.append(panel)
        
        updateChartData()
        updateAverages()
    }
    
    func deselect(panel: UILabel) {
        panel.backgroundColor = UIColor.white
        panel.textColor = FlatRed()
        
        if let index = selectedSensors.index(of: panel) { selectedSensors.remove(at: index) }

        
        updateChartData()
        updateAverages()
    }
    
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
            
            // Add any custom transition code in this block
            
        }, completion: nil)
    }
    
    
}

extension TemperatureViewController : ScrollableGraphViewDataSource {
    
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


// MARK: Realm Handlers
extension TemperatureViewController {
    
    func setupRefreshToken() {
        DispatchQueue.main.async {
        
            if let realm = UNITERealm.activeRealm {
                self.token = realm.observe { (_,_) in
                    self.graphView.reload()
                }
            }
        }
    }
}


// MARK: Helper Functions
extension TemperatureViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tempDisplayPageControl.currentPage = Int(round(scrollView.contentOffset.x/view.bounds.width))
    }
}


