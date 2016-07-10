//
//  ScoreOperator.swift
//  Score
//
//  Created by Ivy on 15/11/20.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

typealias Completion = (ScoreModel?, String) -> ()

class ScoreOperator: NSObject {
    
    
    class func queryScoreById(id: NSString, page: NSInteger, result: Completion) {
        
        let params = [
            PARAMS_ID : id,
            PARAMS_CURSOR : String(page),
            PARAMS_COUNT : String(COUNT_VALUE),
            PARAMS_ISWEB : String(1)
        ]
        
        Just.post(APIURL, params: params, timeout: 10) { response in
            
            var msg: String = ""
            var scoreModel: ScoreModel?
            print(response.error)
            if response.ok == false {
                
                msg = "连接服务器失败!"
            }else if response.json!.objectForKey("status") as! NSInteger != NSInteger(200) {
                
                msg = response.json!.objectForKey("body") as! String
            }else {
                
                scoreModel = ScoreModel(model: response.json!)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                result(scoreModel, msg)
            })
        }
    }
}
