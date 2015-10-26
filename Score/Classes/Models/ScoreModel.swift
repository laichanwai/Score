//
//  IvyScoreModel.swift
//  Score
//
//  Created by Ivy on 15/10/19.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class ScoreModel: Reflect {

    var level: NSInteger!
    var status: NSInteger!
    var user: UserModel!
    var datas: NSMutableArray!
    
    required init() {
        
    }
    
    init(model: AnyObject) {
        
        model as! NSDictionary
        
        level = model.objectForKey("level") as! NSInteger
        status = model.objectForKey("status") as! NSInteger
        user = UserModel(model: model.objectForKey("user")!)
        datas = NSMutableArray()
        
        
        
        for data in model.objectForKey("datas") as! NSArray {
            
            data as! NSDictionary
            
            let item = ItemModel(model: data)
            
            datas!.addObject(item)
        }
        
    }
}
