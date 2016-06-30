//
//  IvyViewController.swift
//  Score
//
//  Created by Ivy on 15/10/18.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

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
        
        let username: String? = NSUserDefaults.standardUserDefaults().valueForKey(SCORE_USERNAME) as? String
        let password: String? = NSUserDefaults.standardUserDefaults().valueForKey(SCORE_PASSWORD) as? String
        
        // TextField
        self.idTextField.leftView = UIView(frame: CGRectMake(0, 0, 44, self.idTextField.H))
        self.idTextField.leftViewMode = .Always
        self.idTextField.text = username
        self.pzwTextField.leftView = UIView(frame: CGRectMake(0, 0, 44, self.idTextField.H))
        self.pzwTextField.leftViewMode = .Always
        self.pzwTextField.text = password
        
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
        
        LZWProgressHUD.offset = CGPoint(x: 0, y: mainScreen.bounds.width >= 375 ? 260 : 200)
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
        
        NSUserDefaults.standardUserDefaults().setValue(self.idTextField.text, forKey: SCORE_USERNAME)
        NSUserDefaults.standardUserDefaults().setValue(self.pzwTextField.text, forKey: SCORE_PASSWORD)
        
        ScoreOperator.queryScoreById(self.idTextField.text!, page: 0) { scoreModel, msg -> () in
            LZWProgressHUD.hideHUD(delay: 0)
            
            if msg != "" {
                
                self.showWarning(msg)
            }else {
                
                self.performSegueWithIdentifier("showItems", sender: scoreModel)
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

