//
//  FirstViewController.swift
//  UNITE proto
//
//  Created by Zack Snyder on 2/6/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import UIKit
import ChameleonFramework
import SafariServices
import MapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var stackScrollView: UIScrollView!
    
    // Main Widget Stack
    @IBOutlet var widgetStack: UIStackView!
    
    var endOfStack : Int {
        return widgetStack.arrangedSubviews.count - 2
    }
    
    var widgetConfiguration : WidgetConfig {
        if let config = WidgetConfig.loadSave(key: WCDataKey) {
            return config
        } else {
            return WidgetConfig.sharedInstance
        }
    }
    
    var widgetList = [GPSWidget(), TempWidget()]
    
    // Countdown Widget
    @IBOutlet weak var countdownBackView: UIView!

    @IBOutlet weak var daysCountLbl: UILabel!
    @IBOutlet weak var hoursCountLbl: UILabel!
    @IBOutlet weak var minutesCountLbl: UILabel!
    @IBOutlet weak var secondsCountLbl: UILabel!
    
    @IBOutlet weak var launchProgressBar: UIProgressView!
    
    
    // Link Widget
    @IBOutlet weak var usiSpaceLinkView: UIView!
    @IBOutlet weak var realmServerLinkView: UIView!
    @IBOutlet weak var nslConsoleLinkView: UIView!
    
    // Temperature Widget
    
    // GPS Widget
    
    // Edit Button
    @IBOutlet weak var editButtonView: UIView!
    
    // MARK: Gesture Handling
    
    func spaceLinkIsTapped(tap: UILongPressGestureRecognizer) {
        
        // Link to usispace
        switch tap.state {
            
        case .began:
            // Highlight view
            
            usiSpaceLinkView.backgroundColor = FlatWhiteDark()
            
        case .ended:
            // Go to link
            
            usiSpaceLinkView.backgroundColor = UIColor.white
            
            if let view = tap.view {
                
                let location = tap.location(in: view)
                let touchIsInsideView = CGRect(origin: CGPoint.zero, size: view.bounds.size).contains(location)
                
                if touchIsInsideView {
                    let safari = SFSafariViewController(url: URL(string: "http://www.usispace.com")!)
                    if #available(iOS 10.0, *) {
                        safari.preferredControlTintColor = FlatWhite()
                        safari.preferredBarTintColor = FlatNavyBlueDark()
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    present(safari, animated: true, completion: {})
                }
            }
        case .cancelled:
            // Unhighlight view
            
            usiSpaceLinkView.backgroundColor = UIColor.white
            
        default:
            break
        }
    }
    
    func serverLinkIsTapped(tap: UILongPressGestureRecognizer) {
        
        // Link to usispace
        switch tap.state {
            
        case .began:
            // Highlight view
            
            realmServerLinkView.backgroundColor = FlatWhiteDark()
            
        case .ended:
            // Go to link
            
            realmServerLinkView.backgroundColor = UIColor.white
            
            if let view = tap.view {
                
                let location = tap.location(in: view)
                let touchIsInsideView = CGRect(origin: CGPoint.zero, size: view.bounds.size).contains(location)
                
                if touchIsInsideView {
                    let safari = SFSafariViewController(url: URL(string: "http://realm-server.usispace.com")!)
                    if #available(iOS 10.0, *) {
                        safari.preferredControlTintColor = FlatWhite()
                        safari.preferredBarTintColor = FlatNavyBlueDark()
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    present(safari, animated: true, completion: {})
                }
            }
        case .cancelled:
            // Unhighlight view
            
            realmServerLinkView.backgroundColor = UIColor.white
            
        default:
            break
        }
    }
    
    func nslLinkIsTapped(tap: UILongPressGestureRecognizer) {
        
        // Link to college
        switch tap.state {
            
        case .began:
            // Highlight view
            
            nslConsoleLinkView.backgroundColor = FlatWhiteDark()
            
        case .ended:
            // Go to link
            
            nslConsoleLinkView.backgroundColor = UIColor.white
            
            if let view = tap.view {
                
                let location = tap.location(in: view)
                let touchIsInsideView = CGRect(origin: CGPoint.zero, size: view.bounds.size).contains(location)
                
                if touchIsInsideView {
                    let safari = SFSafariViewController(url: URL(string: "https://data2.nsldata.com/console")!)
                    if #available(iOS 10.0, *) {
                        safari.preferredControlTintColor = FlatWhite()
                    } else {
                        // Fallback on earlier versions
                    }
                    if #available(iOS 10.0, *) {
                        safari.preferredBarTintColor = FlatNavyBlueDark()
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    present(safari, animated: true, completion: {})
                }
            }
            
        case .cancelled:
            // Unhighlight view
            
            nslConsoleLinkView.backgroundColor = UIColor.white
            
        default:
            break
        }
    
    }
    
    func editButtonIsTapped(tap: UILongPressGestureRecognizer) {
        
        switch tap.state {
        case .began:
            
            editButtonView.backgroundColor = FlatWhiteDark()
            
        case .ended:
            
            editButtonView.backgroundColor = FlatWhite()
            
            let widgetManager = storyboard?.instantiateViewController(withIdentifier: "WidgetManager") as! WidgetManagerViewController
            present(widgetManager, animated: true, completion: {
                widgetManager.parentVC = self
            })
            
        case .cancelled:
            
            editButtonView.backgroundColor = FlatWhite()
            
        default:
            break
        }
    }
    
    // MARK: ViewController Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureWidgets(for: widgetConfiguration.activeWidgetTypes)
        
        setupGraphicalElements()
        setupGestureRecognizers()
        startCountDownTimer()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // MARK: Gesture Initializers
    
    func setupGestureRecognizers() {
        let spaceLinkTap = UILongPressGestureRecognizer(target: self, action: #selector(spaceLinkIsTapped(tap:)))
        let serverLinkTap = UILongPressGestureRecognizer(target: self, action: #selector(serverLinkIsTapped(tap:)))
        let nslLinkTap = UILongPressGestureRecognizer(target: self, action: #selector(nslLinkIsTapped(tap:)))
        let editButtonTap = UILongPressGestureRecognizer(target: self, action: #selector(editButtonIsTapped(tap:)))
        
        
        spaceLinkTap.minimumPressDuration = 0.001
        serverLinkTap.minimumPressDuration = 0.001
        nslLinkTap.minimumPressDuration = 0.001
        editButtonTap.minimumPressDuration = 0.001
        
        usiSpaceLinkView.addGestureRecognizer(spaceLinkTap)
        realmServerLinkView.addGestureRecognizer(serverLinkTap)
        nslConsoleLinkView.addGestureRecognizer(nslLinkTap)
        editButtonView.addGestureRecognizer(editButtonTap)
    }
    
    // MARK: Graphics Configuration
    
    func setupGraphicalElements() {
        countdownBackView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS

        usiSpaceLinkView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        realmServerLinkView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        nslConsoleLinkView.layer.cornerRadius = AppConfig.Graphics.CORNER_RADIUS
        
        editButtonView.layer.cornerRadius = editButtonView.bounds.height / 2
    }
    
    
    
    // MARK: Countdown Timer
    
    func startCountDownTimer() {
        
        updateCountDownDisplays()
        updateProgressBar()
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            
            self.updateCountDownDisplays()
            self.updateProgressBar()
        })
    }
    
    func updateCountDownDisplays() {
        
        var now = Date(timeIntervalSinceNow: 0.0)
        
        let daysLeft = AppConfig.UNITE_END_DATE.days(from: now)
        now.addTimeInterval(Double(daysLeft) * 3600.0 * 24.0)
        
        let hoursLeft = AppConfig.UNITE_END_DATE.hours(from: now)
        now.addTimeInterval(Double(hoursLeft) * 3600.0)
        
        let minutesLeft = AppConfig.UNITE_END_DATE.minutes(from: now)
        now.addTimeInterval(Double(minutesLeft) * 60.0)
        
        let secondsLeft = AppConfig.UNITE_END_DATE.seconds(from: now)
        
        daysCountLbl.text = "\(daysLeft)"
        hoursCountLbl.text = "\(hoursLeft)"
        minutesCountLbl.text = "\(minutesLeft)"
        secondsCountLbl.text = "\(secondsLeft)"
        
    }
    
    func updateProgressBar() {
        
        let total = AppConfig.UNITE_END_DATE.days(from: AppConfig.UNITE_START_DATE)
        let uncompleted = AppConfig.UNITE_END_DATE.days(from: Date(timeIntervalSinceNow: 0.0))
        
        let progress = Float(total - uncompleted) / Float(total)
        
        launchProgressBar.setProgress(progress, animated: true)
    }
    
    
    // MARK: Setup Widgets
    
    func configureWidgets(for types: [WidgetView.WidgetType]) {
        
        for widgetType in types {
            setupWidget(widgetType.toWidget())
        }
    }
    
    func setupWidget(_ widget: WidgetView) {
        
        widget.configure()                                               // Configure widget settings

        widgetStack.insertArrangedSubview(widget, at: endOfStack)        // Insert widget at the end of the stack
        
        stackScrollView.leadingAnchor.constraint(equalTo: widget.leadingAnchor, constant: AppConfig.Widgets.Constraints.mainLeading).isActive = true     // Add leading constraint to widget
        stackScrollView.trailingAnchor.constraint(equalTo: widget.trailingAnchor, constant: AppConfig.Widgets.Constraints.mainTrailing).isActive = true  // Add trailing constraint to widget
        
        widget.setupContent()                                            // Update widget content
        
    }
    
    func updateWidgetStack() {
        
        for subview in widgetStack.arrangedSubviews {
            if subview is WidgetView {
                subview.removeFromSuperview()
            }
        }
        
        configureWidgets(for: widgetConfiguration.activeWidgetTypes)
    }
}