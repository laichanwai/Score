//
//  IvyViewController.swift
//  Score
//
//  Created by Ivy on 15/10/18.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var pzwTextField: UITextField!
    
    @IBOutlet weak var queryButton: UIButton!
    @IBOutlet weak var queryButtonTop: NSLayoutConstraint!
    
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningMessage: UILabel!
    
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
        
        // queryButton
        self.queryButtonOrignTopConstant = self.queryButtonTop.constant
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // UINavigation
        self.navigationController?.navigationBarHidden = true
    }

    // MARK: UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == idTextField {
            
            pzwTextField.becomeFirstResponder()
        }else {
            
            queryButtonClick("");
        }
        
        return true
    }
    
    // 查询按钮点击
    @IBAction func queryButtonClick(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        LZWProgressHUD.offset = CGPoint(x: 0, y: 250)
        LZWProgressHUD.showHUD()
        
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
            
            LZWProgressHUD.hideHUD(delay: 0)
            
            return
        }
        if self.idTextField.text != self.pzwTextField.text {
            
            self.showWarning("密码不正确")
            
            LZWProgressHUD.hideHUD(delay: 0)
            
            return
        }
        
        
        let params = [
            PARAMS_ID : self.idTextField.text!,
            PARAMS_CURSOR : String(CURSOR_VALUE),
            PARAMS_COUNT : String(COUNT_VALUE)
        ]
        
        // APIURL      : http://10.73.41.68:8080/Json/servlet/ReturnZjp
        // ARIURL_TEST : http://10.73.2.47:3000
        Alamofire.request(.POST, APIURL, parameters: params).responseJSON { response in
            
            LZWProgressHUD.hideHUD(delay: 0)
            
            print(response)
            
            if response.result.error != nil {
                
                self.showWarning("获取信息出错！")
                
                return
            }else if response.result.value?.objectForKey("status") as! NSInteger == NSInteger(200) {
                
                let scoreModel = ScoreModel(model: response.result.value!)
                
                self.performSegueWithIdentifier("showItems", sender: scoreModel)
                
            }else {
                
                self.showWarning((response.result.value?.objectForKey("body"))! as! String)
            }
        }

        
    }
    
    // 显示出错信息
    func showWarning(message: String) {
        
        LZWProgressHUD.hideHUD(delay: 0)
        
        self.warningMessage.text = message
        self.queryButton.center.x -= 30
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: { _ in
            
            self.queryButton.center.x += 30
            
            }, completion: { _ in
                
                UIView.animateWithDuration(0.3, animations: { _ in
                    
                    
                    self.queryButtonTop.constant = 80 + self.queryButtonOrignTopConstant;
                    self.queryButton.layoutIfNeeded()
                    
                    }, completion: {  _ in
                        
                        UIView.transitionWithView(self.warningView, duration: 0.3, options: .TransitionFlipFromTop, animations: { _ in
                            
                            self.warningView.hidden = false
                            
                            }, completion: nil)
                })
        })
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        segue.destinationViewController.setValue(sender, forKey: "scoreModel")
    }
}

