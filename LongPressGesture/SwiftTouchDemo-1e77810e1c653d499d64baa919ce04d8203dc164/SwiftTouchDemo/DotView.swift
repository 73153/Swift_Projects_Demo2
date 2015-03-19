//
//  DotView.swift
//  SwiftTouchDemo
//
//  Created by Michael Rockhold on 6/8/14.
//  Copyright (c) 2014 Michael Rockhold. All rights reserved.
//

import UIKit

class DotView: UIView {
    
    init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.width/2
    }
    
    class func randomColor() -> UIColor {
        var colors = [
            UIColor.redColor(),
            UIColor.orangeColor(),
            UIColor.yellowColor(),
            UIColor.greenColor(),
            UIColor.blueColor(),
            UIColor.purpleColor(),
            UIColor.cyanColor(),
            UIColor.magentaColor()]
        
        var r = Int(rand()) % colors.count
        return colors[r]
    }
    
    class func randomFloat(#min:CGFloat, max:CGFloat) -> CGFloat {
        return CGFloat(drand48()) * (max - min) + min
    }
    
    class func randomDotView() -> DotView {
        var randomWidth = self.randomFloat(min: 10, max: 60)
        var randomFrame = CGRect(x:0, y:0, width:randomWidth, height:randomWidth)
        var dotView = DotView(frame: randomFrame);
        dotView.backgroundColor = self.randomColor()
        return dotView
    }
    
    class func arrangeDotsRandomlyInView(view:UIView) {
        for sv:UIView! in view.subviews {
            var bounds = view.bounds
            var minX = CGRectGetMinX(bounds) + sv.frame.size.width/2
            var maxX = CGRectGetMaxX(bounds) - sv.frame.size.width/2

            var minY = CGRectGetMinY(bounds) + sv.frame.size.height/2
            var maxY = CGRectGetMaxY(bounds) - sv.frame.size.height/2

            sv.center = CGPointMake(self.randomFloat(min:minX, max:maxX), self.randomFloat(min:minY, max:maxY))
        }
    }
    
    class func arrangeDotsNeatlyInView(view:UIView) {
        var x:CGFloat = 30
        var y:CGFloat = 30
        for sv:UIView! in view.subviews {
            if x > view.bounds.width - 30 {
                x = 30
                y += 60
            }
            sv.center = CGPointMake(x, y)
            x += 60
        }
    }
    
    class func arrangeDotsNeatlyInViewWithNiftyAnimation(view:UIView) {
        var x:CGFloat = 30
        var y:CGFloat = 30
        for sv:AnyObject in view.subviews {
            if x > view.bounds.width - 30 {
                x = 30
                y += 60
            }
            UIView.animateWithDuration(0.2, animations:{ (sv as UIView).center = CGPointMake(x, y) })
            x += 60
        }
    }
}
