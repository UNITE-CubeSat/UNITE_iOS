//
//  AlertController.swift
//  UNITE
//
//  Created by Zack Snyder on 8/9/17.
//  Copyright © 2017 Zack Snyder. All rights reserved.
//

import Foundation
import UIKit

class AlertController: UIAlertController {
    
    static func create(title: String, message: String, action actionTitle: String) -> UIAlertController {
        
        let alert = self.init(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(action)
        
        return alert
    }
}
