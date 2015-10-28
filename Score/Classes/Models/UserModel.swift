//
//  IvyUserModel.swift
//  Score
//
//  Created by Ivy on 15/10/18.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class UserModel: Reflect {

    var name: String!
    var id: NSInteger!
    var grade: NSInteger?
    var classes: NSInteger?
    var college: NSInteger?
    
    
    required init() {
    }
    
    init(model: AnyObject) {
        
        model as! NSDictionary
        
        name = model.objectForKey("name") as! String
        id = model.objectForKey("id") as! NSInteger
        grade = model.objectForKey("grade") as? NSInteger
        classes = model.objectForKey("classes") as? NSInteger
        college = model.objectForKey("college") as? NSInteger
    }

}

