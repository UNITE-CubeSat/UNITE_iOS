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
import Charts

class TemperatureViewController: UIViewController {
    
    
    // MARK: Outlets
    
    // Sensor Panels
    @IBOutlet weak var xPosLbl: UILabel!
    @IBOutlet weak var xNegLbl: UILabel!
    @IBOutlet weak var yPosLbl: UILabel!
    @IBOutlet weak var yNegLbl: UILabel!
    @IBOutlet weak var zPosLbl: UILabel!
    @IBOutlet weak var zNegLbl: UILabel!
    @IBOutlet weak var boardLbl: UILabel!
    @IBOutlet weak var epsLbl: UILabel!
    
    // Segment Controls
    @IBOutlet weak var sensorSelectorSegControl: UISegmentedControl!
    @IBOutlet weak var timeSelectorSegControl: UISegmentedControl!
    
    @IBOutlet weak var tempDisplayPageControl: UIPageControl!
    
    // Display Views
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var averagesView: UIView!
    
    // Chart View and Data
    var lineChart = LineChartView()
    var tempData = LineChartData()
    
    // Sensor Selection
    var selectedSensors = [UILabel]()
    var chartColors = [FlatRed(), FlatBlue(), FlatGreen(), FlatYellow(), FlatPlum(), FlatOrange()]
    
    @IBOutlet weak var loTempLbl: UILabel!
    @IBOutlet weak var avgTempLbl: UILabel!
    @IBOutlet weak var hiTempLbl: UILabel!
    
    // MARK: CONSTANTS
    let MIN_PRESS_DUR = 0.001
    let NO_DATA_TEXT = "Please Select A Sensor"
    let NO_DATA_FONT = UIFont(name: "HelveticaNeue-Light", size: 25.0)
    let CHART_TEXT_COLOR = FlatNavyBlueDark()
    
    
    // MARK: Gesture Handlers
    
    func didTapTempPanel(tap: UILongPressGestureRecognizer) {
        
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
        setupGraphicalElements()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupLineChart()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        let epsTouch = UILongPressGestureRecognizer(target: self, action: #selector(didTapTempPanel(tap:)))
        
        xPosTouch.minimumPressDuration = MIN_PRESS_DUR
        xNegTouch.minimumPressDuration = MIN_PRESS_DUR
        yPosTouch.minimumPressDuration = MIN_PRESS_DUR
        yNegTouch.minimumPressDuration = MIN_PRESS_DUR
        zPosTouch.minimumPressDuration = MIN_PRESS_DUR
        zNegTouch.minimumPressDuration = MIN_PRESS_DUR
        boardTouch.minimumPressDuration = MIN_PRESS_DUR
        epsTouch.minimumPressDuration = MIN_PRESS_DUR
        
        xPosLbl.addGestureRecognizer(xPosTouch)
        xNegLbl.addGestureRecognizer(xNegTouch)
        yPosLbl.addGestureRecognizer(yPosTouch)
        yNegLbl.addGestureRecognizer(yNegTouch)
        zPosLbl.addGestureRecognizer(zPosTouch)
        zNegLbl.addGestureRecognizer(zNegTouch)
        boardLbl.addGestureRecognizer(boardTouch)
        epsLbl.addGestureRecognizer(epsTouch)
    }
    
    
    // MARK: Graphics Setup
    
    func setupGraphicalElements() {
        
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
        
        epsLbl.layer.masksToBounds = true
        epsLbl.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        epsLbl.textColor = FlatRed()
        epsLbl.backgroundColor = UIColor.white
        
    }
    
    // MARK: Temp Panel Functions
    
    func setupLineChart() {
        lineChart.delegate = self
        lineChart.frame = CGRect(origin: CGPoint.zero, size: graphView.bounds.size)
        lineChart.noDataText = NO_DATA_TEXT
        lineChart.noDataFont = NO_DATA_FONT
        lineChart.noDataTextColor = CHART_TEXT_COLOR
        
        lineChart.borderLineWidth = 5.0
        lineChart.pinchZoomEnabled = false
        lineChart.drawGridBackgroundEnabled = false
        lineChart.highlightPerTapEnabled = false
        lineChart.highlightPerDragEnabled = false

        let chartDesc = Description()
        chartDesc.font = NO_DATA_FONT!
        chartDesc.textColor = CHART_TEXT_COLOR
        chartDesc.text = ""
        lineChart.chartDescription = chartDesc
        
        tempData.setValueTextColor(FlatNavyBlueDark())
        
        graphView.addSubview(lineChart)
    }
    
    func updateChartData() {
        
        tempData.clearValues()
        
        if !selectedSensors.isEmpty {
            for index in 1...selectedSensors.count {
                
                let sensorDataSet = TemperatureDataSet(color: chartColors[(index-1) % chartColors.count])
                sensorDataSet.label = selectedSensors[index-1].text
                
                // Generate entries for each sensor
                for entry in 1...10 {
                    let rnd = Double(arc4random_uniform(100)) / 3.0
                    let newEntry = ChartDataEntry(x: Double(entry), y: rnd)
                    sensorDataSet.addEntryOrdered(newEntry)
                }
                
                // Add data set to LineChartData object
                tempData.addDataSet(sensorDataSet)
            }
        }
        
        // Clear chart if nothing is selected
        if tempData.dataSets.isEmpty {
            lineChart.clear()
        } else {
            lineChart.data = tempData
        }
    }
    
    // Updates Average Labels
    func updateAverages() {
        
        var avgLoTemps = [Double]()
        var avgTemps = [Double]()
        var avgHiTemps = [Double]()
        
        for dataSet in tempData.dataSets {
            var temps = [Double]()
            
            // Gets temp data from each data set and stores in temps
            for i in 0..<dataSet.entryCount {
                let entry = dataSet.entryForIndex(i)!
                temps.append(entry.y)
            }
            
            avgLoTemps.append(temps.min()!)
            avgTemps.append(AppConfig.DataManagement().average(array: temps))
            avgHiTemps.append(temps.max()!)
        }
        
        if !avgLoTemps.isEmpty {
            loTempLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgLoTemps))
        } else {
            loTempLbl.text = "— —"
        }
        
        if !avgTemps.isEmpty {
            avgTempLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgTemps))
        } else {
            avgTempLbl.text = "— —"
        }
        
        if !avgHiTemps.isEmpty {
            hiTempLbl.text = String(format: "%.1f°", AppConfig.DataManagement().average(array: avgHiTemps))
        } else {
            hiTempLbl.text = "— —"
        }
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
        
        if selectedSensors.contains(panel) {
            selectedSensors.remove(at: selectedSensors.index(of: panel)!)
        }
        
        updateChartData()
        updateAverages()
    }
}


// MARK: Helper Functions
extension TemperatureViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tempDisplayPageControl.currentPage = Int(round(scrollView.contentOffset.x/view.bounds.width))
    }
}

extension TemperatureViewController : ChartViewDelegate {
    
    
}
