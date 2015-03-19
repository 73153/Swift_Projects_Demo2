//
//  FishRootController.swift
//  FishHack
//
//  Created by Edgar Aroutiounian on 6/14/14.
//  Copyright (c) 2014 Edgar Aroutiounian. All rights reserved.
//

import Foundation
import UIKit

class FishRootController : UIViewController
{
    override func loadView()
    {
        self.view = FrontIconsView(frame: UIScreen.mainScreen().bounds)
    }
    override func shouldAutorotate() -> Bool
    {
        return false
    }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
    {
        
    }
}


