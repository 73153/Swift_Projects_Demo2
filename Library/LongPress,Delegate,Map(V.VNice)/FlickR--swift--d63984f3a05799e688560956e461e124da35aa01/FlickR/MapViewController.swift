//
//  MapViewController.swift
//  FlickR
//
//  Created by Jonathan Schmidt on 05/06/2014.
//  Copyright (c) 2014 Matelli. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet var mapView : MKMapView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addLocation(sender : UILongPressGestureRecognizer) {
        if sender.state == .Began {
            let city = City.newCity()
            let coordinates = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            city.latitude = coordinates.latitude
            city.longitude = coordinates.longitude
            city.name = "Quelque-part"
            City.appDelegate().saveContext()
            self.dismissModalViewControllerAnimated(true)
        }
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
