//
//  City+CRUD.swift
//  FlickR
//
//  Created by Jonathan Schmidt on 05/06/2014.
//  Copyright (c) 2014 Matelli. All rights reserved.
//

import Foundation
import UIKit

extension City {
    class func newCity() -> City {
        let newCity = NSEntityDescription.insertNewObjectForEntityForName("City", inManagedObjectContext: self.context()) as City
        self.appDelegate().saveContext()
        return newCity
    }
    
    class func allCities() -> City[] {
        let request = NSFetchRequest(entityName:"City")
        
        var error:NSError?
        
        let cities = self.context().executeFetchRequest(request, error: &error)
        if error {
            return City[]()
        }
        
        return cities as City[]
    }
    
    func destroy() {
        self.managedObjectContext.deleteObject(self)
        City.appDelegate().saveContext()
    }
    
    class func appDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    class func context() -> NSManagedObjectContext {
        return self.appDelegate().managedObjectContext
    }
}