//
//  beaconDetection.m
//  iDeals
//
//  Created by student on 5/2/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import "beaconDetection.h"
#import "bleepManager.h"
#import "bleepBeacon.h"

#define k_UUID @"3AE96580-33DB-458B-8024-2B3C63E0E920"

@implementation beaconDetection
@synthesize locationManager;


-(void)beaconManager:(bleepManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
	NSString* proxrange;
	for (bleepBeacon *beacon in beacons) {
		switch (beacon.proximity) {
			case CLProximityUnknown:
				proxrange = @"Unknown";
				break;
			case CLProximityImmediate:
				proxrange = @"Immediate";
				break;
			case CLProximityNear:
				proxrange = @"Near";
				break;
			case CLProximityFar:
				proxrange = @"Far";
				break;
			default:
				proxrange = @"";
				break;
		}
		NSString* detectedNumbers = [NSString stringWithFormat:@"proximityUUID: %@, Major: %@, Minor: %@, Proximity range:%@, Estimated distance: %.2fm, RSSI: %i Battery Level: %@\n", beacon.proximityUUID.UUIDString, beacon.major, beacon.minor, proxrange, beacon.accuracy, beacon.rssi, beacon.batteryPower];
		NSLog(@"%@", detectedNumbers);
        //textView.text  = [detectedNumbers stringByAppendingString:textView.text];
        
		UILocalNotification *notification = [[UILocalNotification alloc] init];
		notification.alertBody = detectedNumbers;
		[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
	}
}

- (void)beaconManager:(bleepManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLBeaconRegion *)region
{
	if(state == CLRegionStateInside)
	{
		NSLog(@"bleep! In CLRegionStateInside");
        //textView.text = [@"bleep! in CLRegionStateInside\n" stringByAppendingString:textView.text];
		[manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
		UILocalNotification *notification = [[UILocalNotification alloc] init];
		notification.alertBody = @"Determined state in, started ranging";
		[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
	}
	else if(state == CLRegionStateOutside)
	{
		NSLog(@"bleep! In CLRegionStateOutside");
        //textView.text = [@"bleep! in CLRegionStateOutside\n" stringByAppendingString:textView.text];
		[manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
		UILocalNotification *notification = [[UILocalNotification alloc] init];
		notification.alertBody = @"Determined state out, stopped ranging";
		[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
	}
	else
	{
		NSLog(@"bleep! In ?");
        //textView.text = [@"bleep! in ?\n" stringByAppendingString:textView.text];
		UILocalNotification *notification = [[UILocalNotification alloc] init];
		notification.alertBody = @"State unknown";
		[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
	}
}

- (void)beaconManager:(bleepManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error{
    NSLog(@"error: %@", [error description]);
    //textView.text = [[NSString stringWithFormat:@"error: %@\n", [error description]]stringByAppendingString:textView.text];
}

- (void)didReceiveMemoryWarning
{
    //[super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTracking:(id)sender{
    //[udid setTextColor:[UIColor grayColor]];
    //[udid setEnabled:FALSE];
    [[bleepManager sharedInstance] setUUID:[k_UUID uppercaseString]];
    [[bleepManager sharedInstance] startBleepDiscoveryForRegion];
	NSLog(@"bleep! Start monitoring");
    //textView.text  = [[NSString stringWithFormat:@"bleep! Start monitoring: %@\n", udid.text] stringByAppendingString:textView.text];
}

- (IBAction)stopTracking:(id)sender{
    //[udid setTextColor:[UIColor blackColor]];
    //[udid setEnabled:TRUE];
    [[bleepManager sharedInstance] stopBleepDiscovery];
	NSLog(@"bleep! Stop monitoring");
    //textView.text  = [@"bleep! Stop monitoring\n" stringByAppendingString:textView.text];
    
}


@end
