//
//  LZWProgressHUD.swift
//  LZWProgressHUD
//
//  Created by Ivy on 15/10/25.
//  Copyright © 2015年 Ivy. All rights reserved.
//

import UIKit

class LZWProgressHUD: UIView {
    
    // MARK: - 配置
    private let DEFAULT_COLOR = UIColor.whiteColor()
    private let DEFAULT_SIZE = CGSize(width: 40, height: 40)
    private let offset = CGPoint(x: 0, y: 250)
    
    
    // MARK: - show and hide 方法 -> 类方法
    class func showHUD() {
        
        shareInstance().configureHUD(autoHide: false, inView: nil)
    }
    
    class func showHUDInView(view: UIView) {
        
        shareInstance().configureHUD(autoHide: false, inView: view)
    }
    
    class func hideHUD(delay time: CGFloat) {
        
        shareInstance().delay(time) { () -> () in
            
            shareInstance().hide()
        }
    }
    
    // MARK: - 单例 life circle
    private class func shareInstance() -> LZWProgressHUD {
        
        struct Instance {
            static var oneToken: dispatch_once_t = 0
            static var instance: LZWProgressHUD?
        }
        
        dispatch_once(&Instance.oneToken) { () -> Void in
            
            Instance.instance = LZWProgressHUD(frame: UIScreen.mainScreen().bounds)
            Instance.instance?.setupView()
        }
        
        return Instance.instance!
    }
    
    // MARK: - 配置 HUD
    private func configureHUD(autoHide autoHide: Bool, var inView view: UIView?) {
        
        if view == nil {
            
            view = self.getWindow()
        }
        
        self.show(inView: view!)
        
        if autoHide {
            
            delay(1.5, task: { () -> () in
                
                self.hide()
            })
        }
    }
    
    // 显示 HUD
    private func show(inView view: UIView) {
        
        
        view.addSubview(self)
        
        self.hidden = true
        UIView.transitionWithView(self, duration: 0.2, options: .CurveEaseInOut, animations: { _ in
            
            self.hidden = false
            }, completion: nil)
    }
    
    // 隐藏 HUD
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
    
    // MARK: - -------------初始化设置 ---------------
    var animating: Bool = false
    
    // MARK: 加载 View
    private func setupView() {
        
        self.backgroundColor = UIColor.clearColor()
        self.frame = UIScreen.mainScreen().bounds
        
        self.setupLayer()
    }
    
    // MARK: 加载 layer
    private func setupLayer() {
        
        self.setupAnimateLayer(size: DEFAULT_SIZE, fillcolor: DEFAULT_COLOR)
    }
    
    // MARK: 加载 动画
    private func setupAnimateLayer(size size: CGSize, fillcolor: UIColor) {
        
        let circleSpacing: CGFloat = -2
        let circleSize = (size.width - 4 * circleSpacing) / 5
        let origin = CGPointMake((layer.bounds.size.width - size.width) / 2 + offset.x, (layer.bounds.size.height - size.height) / 2 + offset.y)
        let duration: CFTimeInterval = 1
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0, 0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84]
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.4, 1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.3, 1]
        opacityAnimaton.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimaton]
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.removedOnCompletion = false
        
        // Draw circles
        for var i = 0; i < 8; i++ {
            let circle = createCircleLayer(angle: CGFloat(M_PI_4 * Double(i)),
                origin: origin,
                circleSize: circleSize,
                color: fillcolor,
                containerSize: size)
            
            animation.beginTime = beginTime + beginTimes[i]
            circle.addAnimation(animation, forKey: "animation")
            self.layer.addSublayer(circle)
        }
    }
    
    // 创建圆球
    private func createCircleLayer(angle angle: CGFloat, origin: CGPoint, circleSize:CGFloat, color: UIColor, containerSize: CGSize) -> CALayer {
        
        let circle = CAShapeLayer()
        
        circle.path = UIBezierPath(arcCenter: CGPointMake(circleSize / 2, circleSize / 2),
            radius: circleSize / 2,
            startAngle: 0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true).CGPath
        circle.fillColor = color.CGColor
        
        let radius = containerSize.width / 2
        let frame = CGRect(x: origin.x + radius * (cos(angle) + 1) - circleSize / 2,
            y: origin.y + radius * (sin(angle) + 1) - circleSize / 2,
            width: circleSize,
            height: circleSize)
        
        circle.frame = frame
        
        return circle
    }
    
    // MARK: - 附加方法
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
