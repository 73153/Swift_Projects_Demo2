//
//  ViewController.swift
//  SwiftTouchDemo
//
//  Created by Michael Rockhold on 6/8/14.
//  Copyright (c) 2014 Michael Rockhold. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var canvasView:UIView?
    var scrollView:OverlayScrollView?
    var drawerView:UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bounds = self.view.bounds
        
        var canvasView = UIView(frame: bounds)
        canvasView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(canvasView)
        self.canvasView = canvasView
        
        //self.canvasView!.addGestureRecognizer(TouchDelayRecognizer.touchDelayRecognizer())

        self.addDots(25, toView: canvasView)
        DotView.arrangeDotsRandomlyInView(canvasView)
        
        var scrollView = OverlayScrollView(frame: bounds)
        self.view.addSubview(scrollView)
        self.scrollView = scrollView

        var drawerView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        drawerView.frame = CGRectMake(0, 0, bounds.size.width, 240)
        scrollView.addSubview(drawerView)
        self.drawerView = drawerView

        self.addDots(5, toView: drawerView.contentView)
        DotView.arrangeDotsNeatlyInView(drawerView.contentView)
        
        scrollView.contentSize = CGSizeMake(bounds.width, bounds.height + drawerView.frame.size.height)
        scrollView.contentOffset = CGPointMake(0, drawerView.frame.size.height)
        
        self.view.addGestureRecognizer(scrollView.panGestureRecognizer)
    }
    
    func addDots(count:UInt, toView view:UIView) {
        for var i:UInt = 0; i < count; i++ {
            var dotView = DotView.randomDotView()
            view.addSubview(dotView)
            
            var lpgr:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action:Selector.convertFromStringLiteral("handleLongPress:"))
            lpgr.delegate = self;
            dotView.addGestureRecognizer(lpgr)
        }
    }
    
    func handleLongPress(gesture:UILongPressGestureRecognizer) -> Void {
        var dot = gesture.view
        
        switch gesture.state {
        case UIGestureRecognizerState.Began:
            self.grabDot(dot, withGesture:gesture)
        case UIGestureRecognizerState.Changed:
            self.moveDot(dot, withGesture:gesture)
        case UIGestureRecognizerState.Ended, UIGestureRecognizerState.Cancelled:
            self.dropDot(dot, withGesture:gesture)
        default:
            break
        }
    }
    
    func grabDot(dot:UIView, withGesture gesture:UIGestureRecognizer) ->Void {
        dot.center = self.view.convertPoint(dot.center, fromView: dot.superview)
        self.view.addSubview(dot)
        
        UIView.animateWithDuration(0.2, animations:{(Void)->Void in
            dot.transform = CGAffineTransformMakeScale(1.2, 1.2)
            dot.alpha = 0.8
            self.moveDot(dot, withGesture:gesture)
        })
        
        self.scrollView!.panGestureRecognizer.enabled = false
        self.scrollView!.panGestureRecognizer.enabled = true

        DotView.arrangeDotsNeatlyInViewWithNiftyAnimation(self.drawerView!.contentView)
    }
    
    func moveDot(dot:UIView, withGesture gesture:UIGestureRecognizer) ->Void {
        dot.center = gesture.locationInView(self.view)
    }
    
    func dropDot(dot:UIView, withGesture gesture:UIGestureRecognizer) ->Void {
        UIView.animateWithDuration(0.2, animations:{(Void)->Void in
            dot.transform = CGAffineTransformIdentity
            dot.alpha = 1.0
        })
        
        if CGRectContainsPoint(self.drawerView!.bounds, gesture.locationInView(self.drawerView)) {
            self.drawerView!.contentView.addSubview(dot)
        } else {
            self.canvasView!.addSubview(dot)
        }
        
        dot.center = self.view.convertPoint(dot.center, toView: dot.superview)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }
}

