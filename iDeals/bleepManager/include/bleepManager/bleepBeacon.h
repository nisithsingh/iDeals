//
//  bleepBeacon.h
//  bleepManager
//
//  Created by hawshy on 27/12/13.
//  Copyright (c) 2013 Rainmaker Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLRegion.h>
#import <CoreLocation/CLAvailability.h>

@class bleepBeacon;

@interface bleepBeacon : NSObject 

/*
 *  proximityUUID
 *
 *  Discussion:
 *    Proximity identifier associated with the beacon.
 *
 */
@property (strong, nonatomic) NSUUID *proximityUUID;

/*
 *  major
 *
 *  Discussion:
 *    Most significant value associated with the beacon.
 *
 */
@property (strong, nonatomic) NSNumber *major;

@property (strong, nonatomic) NSNumber *batteryPower;

/*
 *  minor
 *
 *  Discussion:
 *    Least significant value associated with the beacon.
 *
 */
@property (strong, nonatomic) NSNumber *minor;

/*
 *  proximity
 *
 *  Discussion:
 *    Proximity of the beacon from the device.
 *
 */
@property (assign, nonatomic) CLProximity proximity;

/*
 *  accuracy
 *
 *  Discussion:
 *    Represents an one sigma horizontal accuracy in meters where the measuring device's location is
 *    referenced at the beaconing device. This value is heavily subject to variations in an RF environment.
 *    A negative accuracy value indicates the proximity is unknown.
 *
 */
@property (assign, nonatomic) CLLocationAccuracy accuracy;

/*
 *  rssi
 *
 *  Discussion:
 *    Received signal strength in decibels of the specified beacon.
 *    This value is an average of the RSSI samples collected since this beacon was last reported.
 *
 */
@property (assign, nonatomic) NSInteger rssi;


@end
