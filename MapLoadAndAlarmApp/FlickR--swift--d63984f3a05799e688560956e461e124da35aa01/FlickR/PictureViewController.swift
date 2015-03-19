//
//  PictureViewController.swift
//  FlickR
//
//  Created by Jonathan Schmidt on 04/06/2014.
//  Copyright (c) 2014 Matelli. All rights reserved.
//

import UIKit

class PictureViewController: UIViewController, ReaderViewDelegate {

    @IBOutlet var readerView : ReaderView
    @IBOutlet var spinner : UIActivityIndicatorView

    var location = FlickRPicture.Location(latitude: 35, longitude: 135)
    var pictures = FlickRPicture[]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            self.pictures = FlickRPicture.aroundLocation(self.location)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.readerView.delegate = self
                self.readerView.displayedPage = 0
                })
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var numberOfPages:Int {
        return pictures.count
    }

    func pageAtIndex(index: Int) -> UIView {
        let view = UIImageView(frame: readerView.bounds)
        view.contentMode = .ScaleAspectFit
        
        spinner.startAnimating()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            let picture = self.pictures[index]
            let data = NSData(contentsOfURL: picture.url)
            
            dispatch_async(dispatch_get_main_queue(), {
                view.image = UIImage(data: data)
                self.title = picture.title
                self.spinner.stopAnimating()
                view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "sharePicture:"))
                view.userInteractionEnabled = true
                })
            })
        
        return view
    }
    
    func sharePicture(sender:UILongPressGestureRecognizer) {
        if sender.state == .Began {
            if let imageView = sender.view as? UIImageView {
                let shareViewController = UIActivityViewController(activityItems:[imageView.image], applicationActivities:nil)
                
                self.presentModalViewController(shareViewController, animated: true)
            }
            
        }
        
    }
}
