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
    let bubbleColor: UIColor = UIColor.blackColor()
    let bubbleRadius: CGFloat = 3
    
    // HUD
    let HUDduration: CGFloat = 2
    
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*******************************Public Method*******************************/
    /**
    - showHUD
    */
    class func showProgressHUD() {
        
        shareInstance().configureHUD(autoHide: false, view: nil)
    }
    
    /**
    - showHUDInView
    
    - parameter view: 显示 HUD 的 view
    */
    class func showHUDToView(view: UIView) {
        
        shareInstance().configureHUD(autoHide: false, view: view)
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
    private func configureHUD(autoHide autoHide: Bool, var view: UIView?) {
        
        if view == nil {
            
            view = self.getWindow()
        }
        
        self.frame = view!.frame
        self.backgroundColor = UIColor.clearColor()
        view?.addSubview(self)
        
        self.show()
        
        if autoHide {
            
            delay(HUDduration - 0.3, task: { () -> () in
                
                self.hide()
            })
        }
    }
    
    /**
    - 显示 HUD
    */
    private func show() {
        
        let bgView = UIView()
        bgView.center = self.center
        bgView.frame.size = CGSizeMake(90, 40)
        bgView.backgroundColor = UIColor.clearColor()
        
        
        for index in 1...bubbleCount {
            
            let appearLayer = getAnimationLayer(frame: bgView.frame, fillColor: bubbleColor, delay: CGFloat(index) * bubbleDelay)
            
            bgView.layer.addSublayer(appearLayer)
        }
        
        self.addSubview(bgView);
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
        
        let alphaAnimate = CABasicAnimation(keyPath: "alpha")
        alphaAnimate.fromValue = 0
        alphaAnimate.toValue = 1
        alphaAnimate.byValue = 0.1
        alphaAnimate.removedOnCompletion = false
        alphaAnimate.fillMode = kCAFillModeRemoved
        alphaAnimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let animateGroup = CAAnimationGroup()
        animateGroup.animations = NSArray(objects: alphaAnimate, moveAnimate) as? [CAAnimation]
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
        
        // logo 参数
        let left: CGFloat = 0
        let top: CGFloat = 0
        let space: CGFloat = 10     // 间隔
        let beginPoint: CGPoint = CGPointMake(left, top)
        let radius: CGFloat = 15    // 远的半径
        
        // logo 贝赛尔曲线
        let bezierpath = UIBezierPath()
        bezierpath.moveToPoint(beginPoint)
        bezierpath.addArcWithCenter(CGPointMake(left + space + radius, radius + top), radius: radius, startAngle: DEGREES_TO_RADIUS(-90), endAngle: DEGREES_TO_RADIUS(270), clockwise: true)
        bezierpath.addLineToPoint(CGPointMake(left + 2 * space + 2 * radius, top))
        bezierpath.addArcWithCenter(CGPointMake(left + 2 * space + 3 * radius, radius + top), radius: radius, startAngle: DEGREES_TO_RADIUS(-90), endAngle: DEGREES_TO_RADIUS(270), clockwise: true)
        bezierpath.addLineToPoint(CGPointMake(left + 3 * space + 4 * radius, top))
//        bezierpath.closePath()
        
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
