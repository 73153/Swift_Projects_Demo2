//
//  WLTimelineImageView.swift
//  Weekend In Lviv
//
//  Created by Admin on 13.06.14.
//  Copyright (c) 2014 rnd. All rights reserved.
//

import UIKit

// Class protocol
protocol WLTimelineImageViewDelegate:NSObjectProtocol{
    
    func imageViewDidTouch(imageView:WLTimelineImageView)
}


class WLTimelineImageView: UIImageView{

    // Delegate of class instance
    var delegate:WLTimelineImageViewDelegate? = nil
    
    init(frame: CGRect)
    {
        super.init(frame: frame)
        // Initialization code
    }
    
    // Override methods for UIImageView
    override func resignFirstResponder() -> Bool
    {
        self.highlighted = false
        return super.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool
    {
        self.highlighted = true
        return super.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool
    {
        return true
    }

    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        if touches.count == 1 && self.delegate! != nil{
            if self.delegate!.respondsToSelector(Selector("imageViewDidTouch:")) {
                self.delegate!.imageViewDidTouch(self)
            }
        }
    }

}
