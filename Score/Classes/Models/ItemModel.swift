//
//  IvyItemModel.swift
//  Score
//
//  Created by Ivy on 15/10/18.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class ItemModel: Reflect {
    
    var id: NSInteger!
    var name: String!
    var number: NSInteger!
    var studentname: String!
    var score: NSInteger!
    var detail: String!
    var createTime: String!
    
    required init(){ }
    
    init(model: AnyObject) {
        
        model as! NSDictionary
        
        id = model.objectForKey("id") as! NSInteger
        number = model.objectForKey("number") as! NSInteger
        name = model.objectForKey("name") as! String
        studentname = model.objectForKey("sname") as! String
        score = model.objectForKey("score") as! NSInteger
        detail = model.objectForKey("detail") as! String
        createTime = model.objectForKey("meta") as? String
        createTime = createTime != nil ? createTime : "未查询到录入时间"
    }
}
