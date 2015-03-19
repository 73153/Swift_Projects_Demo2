//
//  ViewController.swift
//  LiveImpedence
//
//  Created by Craig Stanford on 13/06/2014.
//  Copyright (c) 2014 Monsterbomb. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    var array = NSMutableArray()
    
    var path:UIBezierPath {
    get {
        let bezierPath:UIBezierPath = UIBezierPath()

        bezierPath.moveToPoint(CGPointMake(22, 347))
        bezierPath.addCurveToPoint(CGPointMake(200, 347), controlPoint1: CGPointMake(22, 347), controlPoint2: CGPointMake(58.56, 349.09));
        bezierPath.addCurveToPoint(CGPointMake(283, 238.86), controlPoint1: CGPointMake(270.04, 345.96), controlPoint2: CGPointMake(284.16, 280.53));
        bezierPath.addCurveToPoint(CGPointMake(107.5, 225.35), controlPoint1: CGPointMake(279.5, 113.05), controlPoint2: CGPointMake(103.79, 139.89));
        bezierPath.addCurveToPoint(CGPointMake(200, 239), controlPoint1: CGPointMake(111.21, 310.8), controlPoint2: CGPointMake(204.42, 296.76));

        
        return bezierPath
    }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let backgrounsShapeLayer = CAShapeLayer()
        backgrounsShapeLayer.path = self.path.CGPath
        backgrounsShapeLayer.strokeColor = UIColor.grayColor().CGColor
        backgrounsShapeLayer.fillColor = nil
        backgrounsShapeLayer.lineWidth = 20.0
        backgrounsShapeLayer.lineJoin = kCALineJoinBevel
        backgrounsShapeLayer.lineCap = kCALineCapRound
        backgrounsShapeLayer.shadowColor = UIColor.magentaColor().CGColor
        backgrounsShapeLayer.shadowOpacity = 0.5
        backgrounsShapeLayer.shadowOffset = CGSizeMake(1, 1)
        backgrounsShapeLayer.shadowRadius = 5
        self.view.layer.addSublayer(backgrounsShapeLayer)
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.path.CGPath
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 20.0
        shapeLayer.lineJoin = kCALineJoinBevel
        shapeLayer.lineCap = kCALineCapRound
        self.view.layer.addSublayer(shapeLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 10.0
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shapeLayer.addAnimation(pathAnimation, forKey: "xerxes-rules")
        
        
        for index in 0..20 {
            var circle = UIButton(frame: CGRectMake(100, 100, 18, 18))
            circle.layer.cornerRadius = 9
            circle.backgroundColor = UIColor.orangeColor()
            circle.addTarget(self, action: "circleTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            array.addObject(circle)
            self.view.addSubview(circle)
//            self.view.layer.addSublayer(circle.layer)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(9 * NSEC_PER_SEC)+500000), dispatch_get_main_queue(), {
                let pausedTime = circle.layer.convertTime(CACurrentMediaTime(), fromLayer: nil);
                circle.layer.speed = 0.0;
                circle.layer.timeOffset = pausedTime;
                circle.frame = circle.layer.frame
                })
            
            let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
            keyFrameAnimation.duration = 10.0
            keyFrameAnimation.path = self.path.CGPath
            keyFrameAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(index) / 2.0
            keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            circle.layer.addAnimation(keyFrameAnimation, forKey: "circle\(index)")
        }
        
    }
    
    func circleTapped(sender:UIButton) {
        sender.backgroundColor = UIColor.greenColor()
    }
    
}

