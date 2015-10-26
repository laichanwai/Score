//
//  BaseNavigationController.swift
//  Score
//
//  Created by Ivy on 15/10/23.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    
}

extension UINavigationController {
    
    internal func setTransparentBar() -> Void {
        
        self.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: .Default)
        self.navigationBar.shadowImage = UIImage.init()
    }
    
}