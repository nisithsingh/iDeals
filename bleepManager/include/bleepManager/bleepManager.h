//
//  bleepManager.h
//  bleepManager
//
//  Created by hawshy on 12/11/13.
//  Copyright (c) 2013 Rainmaker Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class bleepManager;

@protocol bleepManagerDelegate <NSObject>

@optional

- (void)beaconManager:(bleepManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

-(void)beaconManager:(bleepManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
           withError:(NSError *)error;

/* Method not available
- (void)beaconManager:(bleepManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

- (void)beaconManager:(bleepManager *)manager didFailDiscoveryInRegion:(CLBeaconRegion *)region;
*/
- (void)beaconManager:(bleepManager *)manager didStartMonitoringForRegion:(CLRegion *)region;

-(void)beaconManager:(bleepManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error;


-(void)beaconManager:(bleepManager *)manager didEnterRegion:(CLRegion *)region;

-(void)beaconManager:(bleepManager *)manager didExitRegion:(CLRegion *)region;

-(void)beaconManager:(bleepManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;


@end

@interface bleepManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id <bleepManagerDelegate> delegate;

@property (nonatomic) BOOL avoidUnknownStateBeacons;
@property (nonatomic, strong) NSString *beaconUUID;

@property (nonatomic, strong) CLBeaconRegion *virtualBeaconRegion;
@property (nonatomic, strong) CLLocationManager *manager;

-(void)startRangingBeaconsInRegion:(CLBeaconRegion*)region;
-(void)stopRangingBeaconsInRegion:(CLBeaconRegion*)region;

-(void)requestStateForRegion:(CLBeaconRegion *)region;

-(void)startBleepDiscoveryForRegion;
-(void)stopBleepDiscovery;

+(bleepManager *)sharedInstance;
- (id) init;
- (void)setUUID:(NSString *)UUID;

@end

