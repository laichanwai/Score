//
//  IvyDetailTableViewController.swift
//  Score
//
//  Created by Ivy on 15/10/18.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var scoreModel: ScoreModel?
    var items: NSMutableArray?
    var popupvc: DetailPopupViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置导航栏标题
        self.title = self.scoreModel?.user?.name
        self.items = NSMutableArray(array: (self.scoreModel?.datas)!)
        
        // 计算总分
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            var score = 0
            for item in self.items! {
                
                score += (item as! ItemModel).score
            }
            
            self.popupvc = DetailPopupViewController(nibName: "DetailPopupViewController", bundle: nil)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let rightItem = UIBarButtonItem(title: "总分：\(score)", style: .Plain, target: nil, action: nil)
                self.navigationItem.rightBarButtonItem = rightItem
            })
        }
        
        // 设置背景
        self.tableView.layer.contents = UIImage(named: "background")?.CGImage
    }

    override func viewWillAppear(animated: Bool) {
        
        // UINavigation
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView DataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.items?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! ItemTableViewCell

        let item = self.items?.objectAtIndex(indexPath.row) as! ItemModel
        
        cell.numberLabel.text = "\(item.number)"
        cell.nameLabel.text = item.name
        cell.scoreLabel.text = "\(item.score)"
        cell.timeLabel.text = "\(item.createTime)"
        

        return cell
    }

    // MARK: - UITableView Delagate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.popupvc?.itemModel = items!.objectAtIndex(indexPath.row) as? ItemModel
        
        self.presentpopupViewController(self.popupvc!, animationType: .TopBottom) { () -> Void in
            
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor(red: 119/255, green: 198/255, blue: 235/255, alpha: 1)
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        UIView.animateWithDuration(0.3) { () -> Void in
            
            tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = UIColor.clearColor()
        }
    }
}
