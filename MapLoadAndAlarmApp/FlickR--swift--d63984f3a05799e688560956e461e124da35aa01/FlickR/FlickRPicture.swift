//
//  FlickRPicture.swift
//  FlickR
//
//  Created by Jonathan Schmidt on 05/06/2014.
//  Copyright (c) 2014 Matelli. All rights reserved.
//

import Foundation
import CoreLocation

let kFlickRAPIKey = "edd17c0c4d413be050ffdba18c74c0e1"

struct FlickRPicture
{
    let title:String
    let id:String
    let farm:Int
    let server:String
    let secret:String
    
    var url:NSURL {
    return NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
    
    struct Location {
        let latitude:Double
        let longitude:Double
    }
    
    static func aroundLocation(location:FlickRPicture.Location) -> FlickRPicture[] {
        let url = NSURL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(kFlickRAPIKey)&lat=\(location.latitude)&lon=\(location.longitude)&format=json&nojsoncallback=1")
        
        let data = NSData(contentsOfURL: url)
        
        var pictures = FlickRPicture[]()
        
        var error:NSError?
        
        let jsonAnswer:AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: nil, error:&error)
        if (!error)
        {
            if let jsonDictionary = jsonAnswer as? NSDictionary {
                if let photosDictionary = jsonDictionary["photos"] as? NSDictionary {
                    if let photoArray = photosDictionary["photo"] as? NSArray
                    
                    
                    {
                        
                        pictures.reserveCapacity(photoArray.count)
                        
                        for item:AnyObject in photoArray {
                            if let pictureDictionary = item as? NSDictionary {
                                let pictureTitle = pictureDictionary["title"] as NSString
                                let pictureID = pictureDictionary["id"] as NSString
                                let pictureFarm = pictureDictionary["farm"].integerValue
                                let pictureServer = pictureDictionary["server"] as NSString
                                let pictureSecret = pictureDictionary["secret"] as NSString
                                
                                let picture = FlickRPicture(title: pictureTitle, id: pictureID, farm: pictureFarm, server: pictureServer, secret: pictureSecret)
                                
                                pictures.append(picture)
                            }
                        }
                    }
                }
            }
        }
        return pictures
    }
}












