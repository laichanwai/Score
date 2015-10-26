//
//  LZWProgressHUD.swift
//  LZWProgressHUD
//
//  Created by Ivy on 15/10/25.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

func DEGREES_TO_RADIUS(degrees: CGFloat) -> CGFloat {
    return 3.14159265358979323846 * degrees / 180.0
}

class LZWProgressHUD: UIView {

    /**
    - HUD 配置
    */
    // Bubble
    let bubbleCount: NSInteger = 8
    let bubbleDelay: CGFloat = 0.1
    let bubbleColor: UIColor = UIColor.whiteColor()
    let bubbleRadius: CGFloat = 3
    
    // Title Label
    let titleLabel: UILabel = UILabel()
    let title:String = "loading..."
    let titleColor:UIColor = UIColor.whiteColor()
    let titleFontSize:CGFloat = 16
    var isShowTitle:Bool = true
    
    // HUD
    let HUDduration: CGFloat = 2
    
    let logoView = UIView()
    let maskLayer = CALayer()
    var isShowMask:Bool = true
    
    private let mainScreen = UIScreen.mainScreen()
    
    /**
    - 单例
    
    - returns: 单例对象
    */
    class func shareInstance() -> LZWProgressHUD {
        
        struct Instance {
            static var oneToken: dispatch_once_t = 0
            static var instance: LZWProgressHUD?
        }
        
        dispatch_once(&Instance.oneToken) { () -> Void in
            
            Instance.instance = LZWProgressHUD(frame: UIScreen.mainScreen().bounds)
            
        }
        
        return Instance.instance!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化设置
        configureHUD()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*******************************Public Method*******************************/
    /**
    - showHUD
    */
    class func showProgressHUD() {
        
        shareInstance().show(autoHide: false, view: nil)
    }
    
    /**
    - showHUDInView
    
    - parameter view: 显示 HUD 的 view
    */
    class func showHUDToView(view: UIView) {
        
        shareInstance().show(autoHide: false, view: view)
    }
    
    /**
    - 隐藏 HUD
    */
    class func hideHUD() {
        
        shareInstance().hide()
    }
    
    /*******************************Private Method*******************************/
    
    /**
    - 初始化设置 HUD
    */
    private func configureHUD() {
        
        // self
        self.backgroundColor = UIColor.clearColor()
        
        // mask
        if isShowMask {
            
            maskLayer.frame = self.frame
            maskLayer.backgroundColor = UIColor.blackColor().CGColor
            maskLayer.opacity = 0.2
            self.layer.addSublayer(maskLayer)
        }
        
        // logoView
        logoView.center = CGPointMake(self.center.x, self.center.y + 50)
        logoView.frame.size = CGSizeMake(80, 40)
        logoView.backgroundColor = UIColor.clearColor()
        self.addSubview(logoView);
        
        // titleLabel
        if isShowTitle {
            
            titleLabel.text = title
            titleLabel.tintColor = titleColor
            titleLabel.font = UIFont.systemFontOfSize(titleFontSize)
            titleLabel.center = CGPointMake(logoView.center.x, logoView.frame.height)
            titleLabel.frame.size = CGSizeMake(logoView.frame.width, titleFontSize + 5)
            logoView.addSubview(titleLabel)
        }
        
    }
    
    /**
    - 显示 HUD
    */
    private func show(autoHide autoHide: Bool, var view: UIView?) {
        
        if view == nil {
            
            view = self.getWindow()
        }
        
        self.frame = view!.frame
        
        view?.addSubview(self)
        self.hidden = true
        UIView.transitionWithView(self, duration: 0.2, options: .CurveEaseInOut  , animations: { _ in
            
            self.hidden = false
            }) { _ in
                
        }
        // bubble
        for index in 1...bubbleCount {
            
            let appearLayer = getAnimationLayer(frame: logoView.frame, fillColor: bubbleColor, delay: CGFloat(index) * bubbleDelay)
            
            logoView.layer.addSublayer(appearLayer)
        }
        
        if autoHide {
            
            delay(HUDduration - 0.3, task: { () -> () in
                
                self.hide()
            })
        }
    }
    
    private func hide() {
        
        if self.superview != nil {
            UIView.transitionWithView(self, duration: 0.3, options: .CurveEaseOut, animations: { _ in
                
                self.alpha = 0
                }, completion: { _ in
                    
                    self.removeFromSuperview()
                    self.alpha = 1
            })
        }
    }
    
    /**
    - bubble layer 设置
    
    - parameter frame:       bubble Frame
    - parameter fillColor:   bubble 填充颜色
    - parameter delay:       延时
    
    - returns: bubble layer
    */
    func getAnimationLayer(frame frame: CGRect, fillColor: UIColor, delay: CGFloat) -> CAShapeLayer {
        
        let layer = CAShapeLayer()
        layer.frame = frame
        layer.path = UIBezierPath(arcCenter: CGPointMake(0, 0), radius: bubbleRadius, startAngle: DEGREES_TO_RADIUS(-90), endAngle: DEGREES_TO_RADIUS(270), clockwise: true).CGPath
        layer.fillColor = fillColor.CGColor
        
        let moveAnimate = CAKeyframeAnimation(keyPath: "position")
        moveAnimate.path = shapeMoveBezierpath().CGPath
        moveAnimate.removedOnCompletion = false
        moveAnimate.fillMode = kCAFillModeRemoved
        moveAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let alphaAnimate = CAKeyframeAnimation(keyPath: "opacity")
        alphaAnimate.values = NSArray(objects: 0.7, 1, 0.7) as [AnyObject]
        alphaAnimate.removedOnCompletion = false
        alphaAnimate.fillMode = kCAFillModeRemoved
        alphaAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let scaleAnimate = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimate.values = NSArray(objects: 1, 1.5, 2, 2.5, 2, 1.5, 1) as [AnyObject]
        scaleAnimate.removedOnCompletion = false
        scaleAnimate.fillMode = kCAFillModeRemoved
        scaleAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let animateGroup = CAAnimationGroup()
        animateGroup.animations = NSArray(objects: alphaAnimate, moveAnimate, scaleAnimate) as? [CAAnimation]
        animateGroup.duration = Double(HUDduration)
        animateGroup.repeatCount = FLT_MAX
        
        self.delay(delay) { () -> () in
            
            layer.addAnimation(animateGroup, forKey: "layerAnimate")
        }
        
        return layer
    }
    
    /**
    - bubble 运动路径
    
    - returns: bubble 运动路径
    */
    private func shapeMoveBezierpath() -> UIBezierPath {
        
        // bubble 参数
        let left: CGFloat = 0
        let top: CGFloat = 0
        let space: CGFloat = 10     // 间隔
        let beginPoint: CGPoint = CGPointMake(left, top)
        let radius: CGFloat = 15    // 远的半径
        
        // bubble 贝赛尔曲线
        let bezierpath = UIBezierPath()
        bezierpath.moveToPoint(beginPoint)
//        bezierpath.addArcWithCenter(CGPointMake(left + space + radius, radius + top), radius: radius, startAngle: DEGREES_TO_RADIUS(-90), endAngle: DEGREES_TO_RADIUS(270), clockwise: true)
//        bezierpath.addLineToPoint(CGPointMake(left + 2 * space + 2 * radius, top))
        bezierpath.addArcWithCenter(CGPointMake(left + 2 * space + 3 * radius, radius + top), radius: radius, startAngle: DEGREES_TO_RADIUS(-90), endAngle: DEGREES_TO_RADIUS(270), clockwise: true)
        bezierpath.addLineToPoint(CGPointMake(left + 4 * space + 5 * radius, top))
        bezierpath.closePath()
        
        return bezierpath
    }
    
    /**
    - 获得主窗口
    
    - returns: 当前的windows
    */
    private func getWindow() -> UIWindow {
        
        if let delegate: UIApplicationDelegate = UIApplication.sharedApplication().delegate {
            if let window = delegate.window {
                return window!
            }
        }
        
        return UIApplication.sharedApplication().keyWindow!
    }
    
    /**
    - GCD 延时函数
    
    - parameter second: 延迟时间
    - parameter task:   结束回调函数
    */
    func delay(second: CGFloat, task:()->()) -> Void {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSTimeInterval(second) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            task()
        }
    }
}
