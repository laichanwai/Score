//
//  File.swift
//  Score
//
//  Created by Ivy on 15/10/21.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

extension UIView {
    
    
    var X:CGFloat {
        set {
            
            var tempFrame = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
        get {
            
            return self.frame.origin.x
        }
    }
    var Y:CGFloat {
        set {
            
            var tempFrame = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
        get {
            
            return self.frame.origin.y
        }
    }
    var W:CGFloat {
        set {
            
            var tempFrame = self.frame
            tempFrame.size.width = newValue
            self.frame = tempFrame
        }
        get {
            
            return self.frame.size.width
        }
    }
    var H:CGFloat {
        set {
            
            var tempFrame = self.frame
            tempFrame.size.height = newValue
            self.frame = tempFrame
        }
        get {
            
            return self.frame.size.height
        }
    }
}