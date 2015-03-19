//
//  RSMenuViewController.swift
//  Rinasw
//
//  Created by okenProg on 2014/06/03.
//  Copyright (c) 2014年 okenProg. All rights reserved.
//

import UIKit

protocol RSMenuTrasition {
    
}

class RSMenuViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var menuViewList: UIView[]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // do not work IBOutletCollection...
        menuViewList = self.view.subviews
                                .filter {
                                    let view = $0 as UIView
                                    return view.tag >= 100
                                } as? UIView[]
        menuViewList = sort(menuViewList!, { $0.tag < $1.tag })
    }
    
    @IBAction func touchedPlayMusicButton(sender: AnyObject) {
        let viewController = RSMusicViewController()
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .Custom
        self.presentViewController(viewController, animated: true, completion: nil)
    }

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning {
        return RSMenuTransition()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning {
        return RSMenuTransition();
    }
}

class RSMenuTransition: NSObject, UIViewControllerAnimatedTransitioning {

    struct Const {
       static let transitionDurtation = 0.3
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return Const.transitionDurtation
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        // Take ViewController
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let presenting = fromVC.isKindOfClass(RSMenuViewController)
        let menuVC = (presenting ? fromVC : toVC) as RSMenuViewController
        let contentVC = (presenting ? toVC : fromVC)
    
        let containerView = transitionContext.containerView();
        let menuBaseView = menuVC.view.superview
       
        if presenting {
            menuBaseView.insertSubview(contentVC.view, belowSubview: menuVC.view)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                    delay: 0.0,
                    options: .CurveEaseIn,
                    animations: {
                        let selectMenuView = menuVC.menuViewList![0]
                        var selectMenuViewFrame = selectMenuView.frame
                        selectMenuViewFrame.origin.y = -32.0
                        selectMenuViewFrame.size.height = 96.0
                        selectMenuView.frame = selectMenuViewFrame
                        
                        
                        for i in 1..(menuVC.menuViewList!.count) {
                            let menuView = menuVC.menuViewList![i]
                                menuView.frame = CGRectOffset(menuView.frame, 0, menuVC.view.frame.size.height)
                        }
                    },
                    completion: { finished in
                        contentVC.view.removeFromSuperview()
                        containerView.addSubview(contentVC.view)
                        
                        let complete = !transitionContext.transitionWasCancelled()
                        transitionContext.completeTransition(complete)
                    })
        } else {
            containerView.addSubview(menuVC.view)

            UIView.animateWithDuration(self.transitionDuration(transitionContext),
                delay: 0.0,
                options: .CurveEaseOut,
                animations: {
                    let selectMenuView = menuVC.menuViewList![0]
                    var selectMenuViewFrame = selectMenuView.frame
                    selectMenuViewFrame.origin.y = 0
                    selectMenuViewFrame.size.height = 124.0
                    selectMenuView.frame = selectMenuViewFrame
                    
                    for i in 1..(menuVC.menuViewList!.count) {
                        let menuView = menuVC.menuViewList![i]
                        menuView.frame = CGRectOffset(menuView.frame, 0, -menuVC.view.frame.size.height)
                    }
                },
                completion: { finished in
                    contentVC.view.removeFromSuperview()
                    menuVC.view.removeFromSuperview()
                    menuBaseView.addSubview(menuVC.view)
                    let complete = !transitionContext.transitionWasCancelled()
                    transitionContext.completeTransition(complete)
                })
        }
    
    }
}

