//
//  ReaderView.swift
//  FlickR
//
//  Created by Jonathan Schmidt on 05/06/2014.
//  Copyright (c) 2014 Matelli. All rights reserved.
//

import UIKit

protocol ReaderViewDelegate {
    var numberOfPages:Int { get }
    func pageAtIndex(index:Int) -> UIView
}

class ReaderView: UIView {
    
    let RVNoDisplayedPage = Int.min
    var delegate:ReaderViewDelegate?
    
    var displayedPage:Int = Int.min {
    didSet {
        if delegate {
            let numberOfPages = delegate!.numberOfPages
            switch displayedPage {
            case RVNoDisplayedPage:
                for item in self.subviews as UIView[] {
                        item.removeFromSuperview()
                }
            case 0..numberOfPages:
                let animationDuration = oldValue == RVNoDisplayedPage ? 0 : 1
                let newView = delegate?.pageAtIndex(displayedPage)
                
                UIView.transitionWithView(self,
                    duration: CDouble(animationDuration),
                    options: oldValue > displayedPage ? .TransitionFlipFromLeft : .TransitionFlipFromRight,
                    animations: {
                        for item in self.subviews as UIView[] {
                            item.removeFromSuperview()
                        }
                        self.addSubview(newView)
                    },
                    completion: nil)
                
            default:
                displayedPage = oldValue
            }
        }
    }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for item in subviews as UIView[] {
            item.frame = self.bounds
        }
        if !self.gestureRecognizers || self.gestureRecognizers.isEmpty {
            let nextPage = UISwipeGestureRecognizer(target: self, action: "nextPage")
            nextPage.direction = .Left
            self.addGestureRecognizer(nextPage)
            
            let previousPage = UISwipeGestureRecognizer(target: self, action: "previousPage")
            previousPage.direction = .Right
            self.addGestureRecognizer(previousPage)
            
            self.userInteractionEnabled = true
        }
    }
    
    func nextPage() {
        displayedPage++
    }
    
    func previousPage() {
        displayedPage--
    }
}
