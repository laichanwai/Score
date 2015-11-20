//
//  ScoreOperator.swift
//  Score
//
//  Created by Ivy on 15/11/20.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit
import Alamofire

typealias ScoreResult = (ScoreModel, String) -> ()

class ScoreOperator: NSObject {
    
    class func queryScoreById(id: NSString, page: NSInteger, result: ScoreResult) {
        
        let params = [
            PARAMS_ID : id,
            PARAMS_CURSOR : String(page),
            PARAMS_COUNT : String(COUNT_VALUE),
            PARAMS_ISWEB : String(1)
        ]
        
        Alamofire.request(.POST, APIURL, parameters: params).responseJSON { response in
            
            var msg: String = ""
            if response.result.error != nil {
                
                msg = "获取信息出错！"
            }else if response.result.value!.objectForKey("status") as! NSInteger != NSInteger(200) {
                
                msg = response.result.value!.objectForKey("body") as! String
                
            }
            
            let scoreModel = ScoreModel(model: response.result.value!)
            
            result(scoreModel, msg)
        }
    }
}
