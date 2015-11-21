//
//  DetailPopupViewController.swift
//  Score
//
//  Created by Ivy on 15/10/23.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class DetailPopupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var detailTableViewCell: UITableViewCell!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var itemModel: ItemModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size = CGSizeMake(mainScreen.bounds.width * 0.75, mainScreen.bounds.height * 0.6)
        tableView.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.nameLabel.text = itemModel!.name
        tableView.reloadData()
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("popupCell")
            
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "popupCell")
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = .None
        }
        
        switch indexPath.row {
            
        case 0:
            cell!.textLabel!.text = "学生id"
            cell!.detailTextLabel!.text = "\(itemModel!.id)"
        case 1:
            cell!.textLabel!.text = "学生姓名"
            cell!.detailTextLabel!.text = "\(itemModel!.studentname)"
        case 2:
            cell!.textLabel!.text = "项目编号"
            cell!.detailTextLabel!.text = "\(itemModel!.number)"
        case 3:
            cell!.textLabel!.text = "学分"
            cell!.detailTextLabel!.text = "\(itemModel!.score)"
        case 4:
            cell!.textLabel!.text = "录入时间"
            cell!.detailTextLabel!.text = "\(itemModel!.createTime)"
        case 5:
            cell = detailTableViewCell
            self.titleLabel.text = "项目备注"
            self.detailTextView.text = "\(itemModel!.detail)"
        default:
            cell!.textLabel!.text = ""
            cell!.detailTextLabel!.text = ""
        }
        cell?.backgroundColor = UIColor.clearColor()
        return cell!
    }
    
    // MARK: - UItableView Delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 5 {
            
            return 120
        }else {
            
            return 60
        }
    }
}
