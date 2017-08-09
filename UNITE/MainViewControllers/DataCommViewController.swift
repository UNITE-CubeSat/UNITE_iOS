//
//  DataCommViewController.swift
//  UNITE
//
//  Created by Zack Snyder on 5/8/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import ChameleonFramework
import RealmSwift
import Charts

class DataCommViewController: UIViewController, UNITEVCProtocol {
    
    enum CommDataDivision: Int {
        case total = 0
        case simplex
        case duplex
    }
    
    // MARK: Chart Properties
    
    var commChart = BarChartView()
    let commData = BarChartData()
    var token : NotificationToken!
    
    var commDataType : CommDataDivision {
        return CommDataDivision(rawValue: commDataSegControl.selectedSegmentIndex % 3)!
    }
    
    // MARK: Constants
    let TOTAL_DOWNLINK : Double = 46980392.0
    let SIMPLEX_DOWNLINK : Double = 862745.0
    let DUPLEX_LINK : Double = 46117647.0
    
    // MARK: Outlets
    @IBOutlet weak var lastPacketView: UIView!
    @IBOutlet weak var lastCommandView: UIView!
    
    @IBOutlet weak var lastPacketDateLbl: UILabel!
    @IBOutlet weak var lastCommandDateLbl: UILabel!
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var commDataSegControl: UISegmentedControl!
    
    // iPad Constraints
    @IBOutlet var landscapeConstraints : [NSLayoutConstraint]!
    @IBOutlet var portraitConstraints : [NSLayoutConstraint]!
    
    @IBAction func didSelectDataType(_ sender: UISegmentedControl) {
        updateChartData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizers()
        setupRefreshToken()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupCommChart()
        updateChartData()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            transitionToiPadSizeClass(landscape: view.bounds.width > view.bounds.height,
                                      transitionCoordinator: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            token.stop()
        }
    }
    
    // MARK: Setup UI
    
    func setupUI() {
        lastPacketView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        lastCommandView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
    }
    
    // MARK: Setup Gesture Recognizers
    
    func setupGestureRecognizers() {
        
    }
    
    // MARK: Chart Setup
    
    func setupCommChart() {
        commChart.delegate = self
        commChart.frame = CGRect(origin: CGPoint.zero, size: graphView.frame.size)
        commChart.highlightFullBarEnabled = false
        commChart.drawBarShadowEnabled = false
        commChart.drawValueAboveBarEnabled = true
        commChart.xAxis.drawLabelsEnabled = false
        commChart.rightAxis.drawLabelsEnabled = false
        commChart.leftAxis.drawLabelsEnabled = false
        commChart.drawGridBackgroundEnabled = false
        commChart.pinchZoomEnabled = true
        commChart.doubleTapToZoomEnabled = false
        commChart.gridBackgroundColor = .clear
        commChart.noDataText = AppConfig.Chart.NO_DATA_TEXT
        commChart.noDataFont = AppConfig.Chart.NO_DATA_FONT
        commChart.noDataTextColor = AppConfig.Chart.CHART_TEXT_COLOR
        
        commChart.chartDescription = AppConfig.Chart.chartDescription(text: "")
        
        commChart.translatesAutoresizingMaskIntoConstraints = false
        
        commData.setValueTextColor(AppConfig.Chart.CHART_TEXT_COLOR)
        
        graphView.addSubview(commChart)
        
        
        commChart.leadingAnchor.constraint(equalTo: graphView.leadingAnchor).isActive = true
        commChart.topAnchor.constraint(equalTo: graphView.topAnchor).isActive = true
        commChart.trailingAnchor.constraint(equalTo: graphView.trailingAnchor).isActive = true
        commChart.bottomAnchor.constraint(equalTo: graphView.bottomAnchor).isActive = true
    }
    
    func updateChartData() {
        
        commData.clearValues()
        
        if UNITERealm.activeRealm != nil {
            
            if let mostRecentComm = UNITERealm.activeRealm.objects(CommData.self).first {
            
                // Config values for bar chart
                let totalBarValues = [TOTAL_DOWNLINK,
                                      mostRecentComm.totalDataUsed,
                                      TOTAL_DOWNLINK - mostRecentComm.totalDataUsed]
                let simplexBarValues = [SIMPLEX_DOWNLINK,
                                        mostRecentComm.simplexDataUsed,
                                        SIMPLEX_DOWNLINK - mostRecentComm.simplexDataUsed]
                let duplexBarValues = [DUPLEX_LINK,
                                          mostRecentComm.duplexDownlinkDataUsed,
                                          mostRecentComm.duplexUplinkDataUsed,
                                          DUPLEX_LINK - mostRecentComm.duplexDownlinkDataUsed - mostRecentComm.duplexUplinkDataUsed]

                let setNames = ["Allotted", "Used", "Available"]
                let setColors = [FlatGrayDark(), FlatRed(), FlatNavyBlue()]
                
                var dataSets = [CommDataSet]()
                switch commDataType {
                case .total:
                    dataSets = commDataSets(names: setNames, colors: setColors, dataValues: totalBarValues)
                case .simplex:
                    dataSets = commDataSets(names: setNames, colors: setColors, dataValues: simplexBarValues)
                case .duplex:
                    dataSets = commDataSets(names: setNames, colors: setColors, dataValues: duplexBarValues)
                }
                
                for set in dataSets {
                    if set.entryCount > 0 { commData.addDataSet(set) }
                }
                
            }
        }
        
        if commData.dataSets.isEmpty {
            commChart.clear()
        } else {
            commChart.data = commData
        }
    }
    
    func commDataSets(names: [String], colors: [UIColor], dataValues: [Double]) -> [CommDataSet] {
        
        var dataSets = [CommDataSet]()
        var xPos : Int?

        for i in 0..<names.count {
            let dataSet = CommDataSet(name: names[i], color: colors[i])
            
            // Add data entries
            if (i != 0) && (i != names.count - 1) {
                
                // Add all data values between the first and last values to the second data set
                for j in i..<dataValues.count - 1 {
                    xPos = j + 1
                    if dataSet.addEntry(BarChartDataEntry(x: Double(xPos == nil ? j + 1 : xPos!), y: dataValues[j])) {}
                }
                
            } else {
                
                if dataSet.addEntry(BarChartDataEntry(x: Double(xPos == nil ? i + 1 : xPos! + 1), y: dataValues[xPos == nil ? i : xPos!])) {}
            }
            
            if dataSet.entryCount > 0 { dataSets.append(dataSet) }
        }
        
        return dataSets
    }
    
    // MARK: Layout Transitions
    
    func transitionToiPadSizeClass(landscape: Bool, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        
        if let constraintsToUninstall = landscape ? portraitConstraints : landscapeConstraints,
            let constraintsToInstall = landscape ? landscapeConstraints : portraitConstraints {
        
            view.layoutIfNeeded()
            
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: {
                    _ in
                    NSLayoutConstraint.deactivate(constraintsToUninstall)
                    NSLayoutConstraint.activate(constraintsToInstall)
                    
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                NSLayoutConstraint.deactivate(constraintsToUninstall)
                NSLayoutConstraint.activate(constraintsToInstall)
            }
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
            if self.graphView != nil { self.commChart.frame = CGRect(origin: CGPoint.zero, size: self.graphView.bounds.size) }
            
        }, completion: nil)
    }
}

// MARK: Realm Handlers
extension DataCommViewController : ChartViewDelegate {
    
    func setupRefreshToken() {
        DispatchQueue.main.async {
            
            if let realm = UNITERealm.activeRealm {
                self.token = realm.addNotificationBlock({ _,_ in
                    self.updateChartData()
                })
            }
        }
    }
}
