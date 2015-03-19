//
//  NSArray.swift
//  ExSwift
//
//  Created by pNre on 10/06/14.
//  Copyright (c) 2014 pNre. All rights reserved.
//

import Foundation

extension NSArray {

    /**
     *  Converts the NSArray self to a swift array of OutType objects
     */
    func cast <OutType> () -> OutType[] {
        var result = OutType[]()
        
        for item : AnyObject in self {
            //  Keep only objC objects compatible with OutType
            if let converted = bridgeFromObjectiveC(item, OutType.self) {
                result.append(converted)
            }
        }
        
        return result
    }
    
    /**
    *  Flattens the nested NSArray self to a swift array of OutType objects
    */
    func flatten <OutType> () -> OutType[] {

        var result = OutType[]()
        
        for item: AnyObject in self {
            if let converted = bridgeFromObjectiveC(item, OutType.self) {
                result.append(converted)
            } else if item is NSArray {
                result += (item as NSArray).flatten() as OutType[]
            }
        }
        
        return result
        
    }

}
