//
//  City.h
//  FlickR
//
//  Created by Jonathan Schmidt on 05/06/2014.
//  Copyright (c) 2014 Matelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
