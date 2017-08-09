//
//  TempWidget.swift
//  UNITE proto
//
//  Created by Zack Snyder on 2/11/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework
import NGSPopoverView

class TempWidget: WidgetView {
    
    // Satellite temperatures
    let tempValueKeyOrder = ["Board", "X +", "X -", "Y +", "Y -", "EPS", "Z +", "Z -", "PIC", "LP", "EPS*"]
    
    let tempValueDict : [String: Double] = ["Board": 22.1, "X +": 23.4, "X -": 25.6, "Y +": 22.8, "Y -": 21.5, "Z +": 26.1, "Z -": 22.3, "EPS": 26.4, "PIC": 20.0, "LP": 15.6, "EPS*": 24.1]
    
    let mainTempStack = UIStackView()
    
    override var id: String { return WidgetType.temperature.toString() }
    
    // CONSTANTS
    let TITLE_TEXT = "Temperature"
    let TEMP_FONT = UIFont(name: "HelveticaNeue-Light", size: 25.0)
    let TEMP_COLOR = FlatRedDark()
    let DESC_FONT = UIFont(name: "HelveticaNeue-Light", size: 15.0)
    let DESC_COLOR = FlatNavyBlueDark()
    let STACK_SPACING : CGFloat = 10.0
    
    override func setupContent() {
        createWidget(widgetType: .temperature)
        
        setupMainStack()
        addContentConstraints()
    }
    
    
    private func setupMainStack() {
        mainTempStack.translatesAutoresizingMaskIntoConstraints = false
        mainTempStack.alignment = .fill
        mainTempStack.distribution = .fillEqually
        mainTempStack.axis = .vertical
        mainTempStack.spacing = STACK_SPACING
        
        let midPoint = tempValueKeyOrder.count / 2
        let topStackKeys = tempValueKeyOrder.prefix(midPoint)
        let bottomStackKeys = tempValueKeyOrder.suffix(midPoint)
        
        mainTempStack.addArrangedSubview(getHorzTempStack(tempKeys: topStackKeys))
        mainTempStack.addArrangedSubview(getHorzTempStack(tempKeys: bottomStackKeys))
        
        contentView.addSubview(mainTempStack)
    }
    
    private func addContentConstraints() {
        
        widthAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 3/1.5).isActive = true
        
        contentView.leadingAnchor.constraint(equalTo: mainTempStack.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: mainTempStack.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: mainTempStack.trailingAnchor).isActive = true
        contentView.topAnchor.constraint(lessThanOrEqualTo: mainTempStack.topAnchor).isActive = true
    }
    
    private func getHorzTempStack(tempKeys: ArraySlice<String>) -> UIStackView {
        
        let horzStack = UIStackView()
        horzStack.axis = .horizontal
        horzStack.alignment = .center
        horzStack.distribution = .fillEqually
        
        for key in tempKeys {
            horzStack.addArrangedSubview(getVertTempDescStack(temp: tempValueDict[key]!, description: key))
        }
        
        return horzStack
    }
    
    private func getVertTempDescStack(temp: Double, description: String) -> UIStackView {
        
        let vertStack = UIStackView()
        vertStack.axis = .vertical
        vertStack.alignment = .center
        vertStack.distribution = .fillProportionally
        vertStack.spacing = STACK_SPACING
        
        vertStack.addArrangedSubview(getTempLabel(text: "\(temp)°"))
        vertStack.addArrangedSubview(getDescLabel(text: description))
        
        return vertStack
    }
    
    private func getTempLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = TEMP_FONT
        label.textColor = TEMP_COLOR
        
        return label
    }
    
    private func getDescLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = DESC_FONT
        label.textColor = DESC_COLOR
        
        return label
    }
    
    // MARK: Popup View
    func getPopUpContent(description: String) -> UIStackView {
        let rangeStack = UIStackView()
        rangeStack.axis = .horizontal
        rangeStack.alignment = .center
        rangeStack.distribution = .fillEqually
        rangeStack.spacing = STACK_SPACING
        
        return rangeStack
    }
    
    func getVertTempStack(for type: AppConfig.DataManagement.ValueType, description: String) -> UIStackView {
        let vertStack = UIStackView()
        vertStack.axis = .vertical
        vertStack.alignment = .center
        vertStack.distribution = .fillProportionally
        vertStack.spacing = STACK_SPACING
        
        return vertStack
    }
}
