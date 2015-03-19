// Playground - noun: a place where people can play

import UIKit
import Foundation


//Say that CGRect is this.

//let size = CGRect(x: 0, y: 0, width: 320, height: 568)
let size = UIScreen.mainScreen().bounds
var rects = CGRect[]()
//And I want to get 4 equally sized rectangles
for i in 1...4
{
    let h = floor(size.size.height / 4)
    let w = floor(size.size.width / 4)
    rects.append(CGRect(x: 0, y: 0, width: w, height: h))
}
rects

UIDevice.currentDevice().name


