//
//  FrontIconView.swift
//  FishHack
//
//  Created by Edgar Aroutiounian on 6/14/14.
//  Copyright (c) 2014 Edgar Aroutiounian. All rights reserved.
//

import Foundation
import UIKit

class FrontIconsView:UIView
{
    init(frame: CGRect)
    {
        super.init(frame: frame)
        let array = create_images(frame)
        for item in array
        {
            self.addSubview(item)
        }
        //Might add a nav bar here, but needs to be clear about it
        let a = UINavigationBar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
        self.addSubview(a)
    }
    func create_images(frame: CGRect) -> UIImageView[]
    {
        //TODO Remove magic numbers?
        var imagesArray = UIImageView[]()
        let w = frame.width / 2
        let h = frame.height / 2
        let newReportIcon     = UIImageView(image: UIImage(named: "new-report-quadrant-iphone5-01"))
        newReportIcon.frame = CGRect(x: 0, y: 0, width: w, height: h)
        newReportIcon.tag = 0
        imagesArray.append(newReportIcon)
        let templateIcon      = UIImageView(image: UIImage(named: "new-template-quadrant-iphone5"))
        templateIcon.frame = CGRect(x: w, y: 0 , width: w, height: h)
        templateIcon.tag = 1
        imagesArray.append(templateIcon)
        let viewReportIcon    = UIImageView(image: UIImage(named: "view-reports-quadrant-iphone5-01"))
        viewReportIcon.frame = CGRect(x: 0, y: frame.midY, width: w, height: h)
        viewReportIcon.tag = 2
        imagesArray.append(viewReportIcon)
        let exportReportsIcon = UIImageView(image: UIImage(named: "share-reports-quadrant-iphone5-01"))
        exportReportsIcon.frame = CGRect(x: frame.midX, y: frame.midY, width: w, height: h)
        exportReportsIcon.tag = 3
        imagesArray.append(exportReportsIcon)
        return imagesArray
    }
}

