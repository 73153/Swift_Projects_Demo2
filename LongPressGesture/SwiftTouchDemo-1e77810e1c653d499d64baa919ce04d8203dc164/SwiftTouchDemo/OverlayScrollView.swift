//
//  OverlayScrollView.swift
//  SwiftTouchDemo
//
//  Created by Michael Rockhold on 6/8/14.
//  Copyright (c) 2014 Michael Rockhold. All rights reserved.
//

import UIKit

class OverlayScrollView: UIScrollView {

    init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
        var hitView = super.hitTest(point, withEvent: event)
        if hitView == self {
            return nil
        } else {
            return hitView
        }
//        return (hitView == self) ? nil : hitView
    }
}
