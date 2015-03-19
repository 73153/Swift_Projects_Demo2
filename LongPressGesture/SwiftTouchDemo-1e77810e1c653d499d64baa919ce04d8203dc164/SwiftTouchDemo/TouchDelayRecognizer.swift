//
//  TouchDelayRecognizer.swift
//  SwiftTouchDemo
//
//  Created by Michael Rockhold on 6/10/14.
//  Copyright (c) 2014 Michael Rockhold. All rights reserved.
//

import UIKit
//import UIKit.UIGestureRecognizerSubclass

class TouchDelayRecognizer: UIGestureRecognizer {
   
    var timer:NSTimer?
    
    class func touchDelayRecognizer() -> TouchDelayRecognizer {
        return TouchDelayRecognizer(target: nil, action: nil)
    }
    
    init(target: AnyObject!, action: Selector) {
        super.init(target: target, action: action)
        self.delaysTouchesBegan = true
    }
    
//    func fail() {
//        self.state = UIGestureRecognizerState.Failed
//    }
//    
//    override func touchesBegan(touches:NSSet!, withEvent:UIEvent!) {
//        var s:Selector = Selector.convertFromStringLiteral("fail")
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.15, target:self, selector:s, userInfo:nil, repeats:false)
//    }
//    
//    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
//        self.fail()
//    }
//    
//    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
//        self.fail()
//    }
//    
//    override func reset() {
//        self.timer!.invalidate()
//        self.timer = nil
//    }
}
