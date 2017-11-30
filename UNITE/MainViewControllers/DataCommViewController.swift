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
import ScrollableGraphView

class DataCommViewController: UIViewController, UNITEVCProtocol {
    
    var token : NotificationToken!
    
    // MARK: Constants
    let TOTAL_DOWNLINK : Double = 46980392.0
    let SIMPLEX_DOWNLINK : Double = 862745.0
    let DUPLEX_LINK : Double = 46117647.0
    
    let allowedLinkID = "Allowed"
    let usedLinkID = "Used"
    let availableLinkID = "Duplex"
    
    // MARK: Outlets
    @IBOutlet weak var lastPacketView: UIView!
    @IBOutlet weak var lastCommandView: UIView!
    
    @IBOutlet weak var lastPacketDateLbl: UILabel!
    @IBOutlet weak var lastCommandDateLbl: UILabel!
    
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var commDataSegControl: UISegmentedControl!
    
    // iPad Constraints
    @IBOutlet var landscapeConstraints : [NSLayoutConstraint]!
    @IBOutlet var portraitConstraints : [NSLayoutConstraint]!
    
    @IBAction func didSelectDataType(_ sender: UISegmentedControl) {
        graphView.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizers()
        setupRefreshToken()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupCommGraphView()
        
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
            token.invalidate()
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
    
    func setupCommGraphView() {
        
        // Bar Plots
        let allowedBarPlot = BarPlot(identifier: allowedLinkID)
        allowedBarPlot.barColor = UIColor.flatNavyBlueColorDark()
        allowedBarPlot.barLineColor = UIColor.flatNavyBlue()
        allowedBarPlot.barWidth = 30.0
        allowedBarPlot.barLineWidth = 1.0
        
        let usedBarPlot = BarPlot(identifier: usedLinkID)
        usedBarPlot.barColor = UIColor.flatRed()
        usedBarPlot.barLineColor = UIColor.flatRedColorDark()
        usedBarPlot.barWidth = 28.0
        usedBarPlot.barLineWidth = 1.0
        
        let availableBarPlot = BarPlot(identifier: availableLinkID)
        availableBarPlot.barColor = UIColor.flatGray()
        availableBarPlot.barLineColor = UIColor.flatWhite()
        availableBarPlot.barWidth = 26.0
        availableBarPlot.barLineWidth = 1.0
        
        
        // Reference Lines
        let refLines = ReferenceLines()
        refLines.positionType = .relative
        refLines.relativePositions = [0.25, 0.5, 0.75, 1.0]
        refLines.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10.0)
        refLines.dataPointLabelColor = UIColor.flatNavyBlueColorDark()
        
        // Graph View
        graphView.dataSource = self
        graphView.addPlot(plot: allowedBarPlot)
        graphView.addPlot(plot: usedBarPlot)
        graphView.addPlot(plot: availableBarPlot)
        graphView.addReferenceLines(referenceLines: refLines)
    }
        
//        commChart.frame = CGRect(origin: CGPoint.zero, size: graphView.frame.size)
//        commChart.highlightFullBarEnabled = false
//        commChart.drawBarShadowEnabled = false
//        commChart.drawValueAboveBarEnabled = true
//        commChart.xAxis.drawLabelsEnabled = false
//        commChart.rightAxis.drawLabelsEnabled = false
//        commChart.leftAxis.drawLabelsEnabled = false
//        commChart.drawGridBackgroundEnabled = false
//        commChart.pinchZoomEnabled = true
//        commChart.doubleTapToZoomEnabled = false
//        commChart.gridBackgroundColor = .clear
//        commChart.noDataText = AppConfig.Chart.NO_DATA_TEXT
//        commChart.noDataFont = AppConfig.Chart.NO_DATA_FONT
//        commChart.noDataTextColor = AppConfig.Chart.CHART_TEXT_COLOR
//
//        commChart.chartDescription = AppConfig.Chart.chartDescription(text: "")
//
//        commChart.translatesAutoresizingMaskIntoConstraints = false
//
//        commData.setValueTextColor(AppConfig.Chart.CHART_TEXT_COLOR)
//
//        graphView.addSubview(commChart)
//
//
//        commChart.leadingAnchor.constraint(equalTo: graphView.leadingAnchor).isActive = true
//        commChart.topAnchor.constraint(equalTo: graphView.topAnchor).isActive = true
//        commChart.trailingAnchor.constraint(equalTo: graphView.trailingAnchor).isActive = true
//        commChart.bottomAnchor.constraint(equalTo: graphView.bottomAnchor).isActive = true
//  }
    
//    func updateChartData() {
//
//        commData.clearValues()
//
//        if UNITERealm.activeRealm != nil {
//
//            if let mostRecentComm = UNITERealm.activeRealm.objects(CommData.self).first {
//
//                // Config values for bar chart
//                let totalBarValues = [TOTAL_DOWNLINK,
//                                      mostRecentComm.totalDataUsed,
//                                      TOTAL_DOWNLINK - mostRecentComm.totalDataUsed]
//                let simplexBarValues = [SIMPLEX_DOWNLINK,
//                                        mostRecentComm.simplexDataUsed,
//                                        SIMPLEX_DOWNLINK - mostRecentComm.simplexDataUsed]
//                let duplexBarValues = [DUPLEX_LINK,
//                                          mostRecentComm.duplexDownlinkDataUsed,
//                                          mostRecentComm.duplexUplinkDataUsed,
//                                          DUPLEX_LINK - mostRecentComm.duplexDownlinkDataUsed - mostRecentComm.duplexUplinkDataUsed]
//
//                let setNames = ["Allotted", "Used", "Available"]
//                let setColors = [FlatGrayDark(), FlatRed(), FlatNavyBlue()]
//
//                var dataSets = [CommDataSet]()
//                switch commDataType {
//                case .total:
//                    dataSets = commDataSets(names: setNames, colors: setColors, dataValues: totalBarValues)
//                case .simplex:
//                    dataSets = commDataSets(names: setNames, colors: setColors, dataValues: simplexBarValues)
//                case .duplex:
//                    dataSets = commDataSets(names: setNames, colors: setColors, dataValues: duplexBarValues)
//                }
//
//                for set in dataSets {
//                    if set.entryCount > 0 { commData.addDataSet(set) }
//                }
//
//            }
//        }
//
//        if commData.dataSets.isEmpty {
//            commChart.clear()
//        } else {
//            commChart.data = commData
//        }
//    }
//
//    func commDataSets(names: [String], colors: [UIColor], dataValues: [Double]) -> [CommDataSet] {
//
//        var dataSets = [CommDataSet]()
//        var xPos : Int?
//
//        for i in 0..<names.count {
//            let dataSet = CommDataSet(name: names[i], color: colors[i])
//
//            // Add data entries
//            if (i != 0) && (i != names.count - 1) {
//
//                // Add all data values between the first and last values to the second data set
//                for j in i..<dataValues.count - 1 {
//                    xPos = j + 1
//                    if dataSet.addEntry(BarChartDataEntry(x: Double(xPos == nil ? j + 1 : xPos!), y: dataValues[j])) {}
//                }
//
//            } else {
//
//                if dataSet.addEntry(BarChartDataEntry(x: Double(xPos == nil ? i + 1 : xPos! + 1), y: dataValues[xPos == nil ? i : xPos!])) {}
//            }
//
//            if dataSet.entryCount > 0 { dataSets.append(dataSet) }
//        }
//
//        return dataSets
//    }
    
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
//            if self.graphView != nil { self.commChart.frame = CGRect(origin: CGPoint.zero, size: self.graphView.bounds.size) }
            
        }, completion: nil)
    }
}

// MARK: Scrollable Graph View Data Source

extension DataCommViewController : ScrollableGraphViewDataSource {
    
    // Provide data points for plot
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        guard let recentDataComm = UNITERealm.activeRealm.objects(CommData.self).first else { return 0.0 }

        switch plot.identifier {
            
        case allowedLinkID:
            if pointIndex == 0 { return TOTAL_DOWNLINK }
            else if pointIndex == 1 { return SIMPLEX_DOWNLINK }
            else if pointIndex == 2 { return DUPLEX_LINK }
        case usedLinkID:
            if pointIndex == 0 { return recentDataComm.totalDataUsed }
            else if pointIndex == 1 { return recentDataComm.simplexDataUsed }
            else if pointIndex == 2 { return recentDataComm.duplexUplinkDataUsed + recentDataComm.duplexDownlinkDataUsed }
        case availableLinkID:
            if pointIndex == 0 { return TOTAL_DOWNLINK - recentDataComm.totalDataUsed }
            else if pointIndex == 1 { return SIMPLEX_DOWNLINK - recentDataComm.simplexDataUsed }
            else if pointIndex == 2 { return DUPLEX_LINK - recentDataComm.duplexDownlinkDataUsed - recentDataComm.duplexUplinkDataUsed }
            
        default: break
            
        }
        
        return 0.0
    }
    
    // Labels for data plots
    func label(atIndex pointIndex: Int) -> String {
        
        switch pointIndex {
        case 0: return "Total"
        case 1: return "Simplex"
        case 2: return "Duplex"
        default: return ""
        }
    }
    
    // Number of data points per plot
    func numberOfPoints() -> Int {
        
        return 3
    }
}


// MARK: Realm Handlers
extension DataCommViewController {
    
    func setupRefreshToken() {
        DispatchQueue.main.async {
            
            if let realm = UNITERealm.activeRealm {
                
                self.token = realm.observe({ (notification, realm) in
                    self.graphView.reload()
                })
            }
        }
    }
}


