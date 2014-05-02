//
//  MasterViewController.m
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "bleepManager.h"
#import "bleepBeacon.h"


@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *foundBeacons;
}
@end

@implementation MasterViewController
@synthesize locationManager;

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    foundBeacons = [[NSMutableArray alloc] init];
    
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(startTracking:)
    forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [[bleepManager sharedInstance] setDelegate:self];
    [self startTracking:self];
    
}
- (void)stopRefresh

{
    
    [self.refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return foundBeacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //NSString *object = foundBeacons[indexPath.row];
    //cell.textLabel.text = object;
    
    [[cell textLabel] setText:[[[foundBeacons objectAtIndex:[indexPath row]] proximityUUID] UUIDString]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

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
       // [foundBeacons addObject:beacon];
        NSLog(@"%d",[foundBeacons count]);
		NSLog(@"%@", detectedNumbers);
        [foundBeacons insertObject:beacon atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        //textView.text  = [detectedNumbers stringByAppendingString:textView.text];
        
		//UILocalNotification *notification = [[UILocalNotification alloc] init];
		//notification.alertBody = detectedNumbers;
		//[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        //[[UIApplication sharedApplication] scheduledLocalNotifications:notification];
	}
        [self stopTracking:self];
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


- (IBAction)startTracking:(id)sender{
    [foundBeacons removeAllObjects];
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
