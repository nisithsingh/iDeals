//
//  beaconDetection.h
//  iDeals
//
//  Created by student on 5/2/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "bleepManager.h"

@interface beaconDetection : NSObject <CLLocationManagerDelegate, bleepManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;

+ (NSArray *) getExistingBeacons;


@end
