//
//  IvyViewController.swift
//  Score
//
//  Created by Ivy on 15/10/18.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pzwTextField: UITextField!
    
    @IBOutlet weak var queryButton: UIButton!
    @IBOutlet weak var queryButtonTop: NSLayoutConstraint!
    
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningMessage: UILabel!
    
    let activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    var queryButtonOrignTopConstant: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // TextField
        self.idTextField.leftView = UIView(frame: CGRectMake(0, 0, 44, self.idTextField.H))
        self.idTextField.leftViewMode = .Always
        self.pzwTextField.leftView = UIView(frame: CGRectMake(0, 0, 44, self.idTextField.H))
        self.pzwTextField.leftViewMode = .Always
        
        let profileIcon = UIImageView(image: UIImage(named: "icon_profile"))
        profileIcon.frame = CGRectMake(12, 10, 19, 20)
        let passwordIcon = UIImageView(image: UIImage(named: "icon_password"))
        passwordIcon.frame = CGRectMake(12, 9, 22, 21)
        self.idTextField.addSubview(profileIcon)
        self.pzwTextField.addSubview(passwordIcon)
        
        // 测试
//        self.idTextField.text = "20131287"
//        self.pzwTextField.text = "20131287"
//        self.queryButtonClick("")
        
        // Activity
        self.activity.hidesWhenStopped = true
        self.activity.frame = CGRectMake(25, 12, 35, 35)
        self.queryButton.addSubview(self.activity)
        
        // queryButton
        self.queryButtonOrignTopConstant = self.queryButtonTop.constant
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // UINavigation
        self.navigationController?.navigationBarHidden = true
    }

    // 查询按钮点击
    @IBAction func queryButtonClick(sender: AnyObject) {
        
        if self.activity.isAnimating() {
            
            return;
        }
        print("click")
        
        self.activity.startAnimating()
        
        self.queryButton.center.x -= 30
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: { _ in
            
            self.queryButton.center.x += 30
        
            }, completion: { _ in
                
        })
        if self.warningView.hidden == false {
            
            UIView.transitionWithView(self.warningView, duration: 0.3, options: .TransitionCrossDissolve, animations: { _ in
                
                self.warningView.hidden = true
                
                }, completion: { _ in
                    
                    UIView.animateWithDuration(0.3, animations: { _ in
                        
                        self.queryButtonTop.constant = self.queryButtonOrignTopConstant
                        self.queryButton.layoutIfNeeded()
                        
                        }, completion: { _ in
                            
                            self.queryScore()
                    })
            })
        }else {
            
            self.queryScore()
        }
    }

    // 开始查询
    func queryScore() {
        
        if self.idTextField.text?.isEmpty == true {
            
            self.showWarning("用户 id 不能为空")
            
            self.activity.stopAnimating()
            
            return
        }
        if self.idTextField.text != self.pzwTextField.text {
            
            self.showWarning("密码不正确")
            
            self.activity.stopAnimating()
            
            return
        }
        
        let params = [
            PARAMS_ID : self.idTextField.text!
        ]
        
        // APIURL      : http://10.73.41.68:8080/Json/servlet/ReturnZjp
        // ARIURL_TEST : http://10.73.40.128:3000
        Alamofire.request(.POST, APIURL_TEST, parameters: params).responseJSON { response in
            
            self.activity.stopAnimating()
            
            if response.result.error != nil {
                
                self.showWarning("获取信息出错！")
                
                return
            }else {
                
                let scoreModel = ScoreModel(model: response.result.value!)
                
                self.performSegueWithIdentifier("showItems", sender: scoreModel)
            }
        }

        
    }
    
    // 显示出错信息
    func showWarning(message: String) {
        
        
        self.warningMessage.text = message
        
        UIView.animateWithDuration(0.3, animations: { _ in
            
            
            self.queryButtonTop.constant += 80
            self.queryButton.layoutIfNeeded()
            
            }, completion: {  _ in
                
                UIView.transitionWithView(self.warningView, duration: 0.3, options: .TransitionFlipFromTop, animations: { _ in
                    
                    self.warningView.hidden = false
                    
                    }, completion: nil)
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        segue.destinationViewController.setValue(sender, forKey: "scoreModel")
    }
}

