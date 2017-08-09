//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


    let dateFormatter = DateFormatter()

    func getLabel(text: String) -> UILabel {
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30.0, height: 22.0)))
        label.text = text
        label.font = UIFont(name: "HelveticaNeue-Light", size: 25.0)!
        return label
    }
    
        dateFormatter.dateFormat = "mm/DD/yy"

        let loStack = UIStackView()
        loStack.axis = .vertical
        loStack.alignment = .center
        loStack.distribution = .equalSpacing
        loStack.spacing = 10.0
        
        let loDesc = "LO"
        let loDate = dateFormatter.string(from: Date(timeIntervalSinceNow: 0.0))
        let loValue = "-20.0°"
        
        loStack.addArrangedSubview(getLabel(text: loDesc))
        loStack.addArrangedSubview(getLabel(text: loValue))
        loStack.addArrangedSubview(getLabel(text: loDate))
        
        let avgStack = UIStackView()
        avgStack.axis = .vertical
        avgStack.alignment = .center
        avgStack.distribution = .equalSpacing
        avgStack.spacing = 10.0
        
        let avgDesc = "Avg"
        let avgDate = dateFormatter.string(from: Date(timeIntervalSinceNow: 0.0))
        let avgValue = "20.0°"
        
        avgStack.addArrangedSubview(getLabel(text: avgDesc))
        avgStack.addArrangedSubview(getLabel(text: avgValue))
        avgStack.addArrangedSubview(getLabel(text: avgDate))
        
        let hiStack = UIStackView()
        hiStack.axis = .vertical
        hiStack.alignment = .center
        hiStack.distribution = .equalSpacing
        hiStack.spacing = 10.0
        
        let hiDesc = "Avg"
        let hiDate = dateFormatter.string(from: Date(timeIntervalSinceNow: 0.0))
        let hiValue = "40.0°"
        
        hiStack.addArrangedSubview(getLabel(text: hiDesc))
        hiStack.addArrangedSubview(getLabel(text: hiValue))
        hiStack.addArrangedSubview(getLabel(text: hiDate))
        
        let rangeStack = UIStackView()
        rangeStack.axis = .horizontal
        rangeStack.alignment = .center
        rangeStack.distribution = .fillEqually
        rangeStack.spacing = 10.0
        
        rangeStack.addArrangedSubview(loStack)
        rangeStack.addArrangedSubview(avgStack)
        rangeStack.addArrangedSubview(hiStack)
        

PlaygroundPage.current.liveView = rangeStack
PlaygroundPage.current.needsIndefiniteExecution = true
