//
//  BacksplashView.swift
//  UNITE
//
//  Created by Zack Snyder on 5/18/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import AppKit

class BacksplashView: NSView {
    
    override func draw(_ dirtyRect: NSRect) {
        let tiledImage = NSImage(named: "Backsplash")
        let tileFill = NSColor(patternImage: tiledImage!)
        tileFill.set()
        NSRectFill(dirtyRect)
    }
}
