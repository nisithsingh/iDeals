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
#import "StoreDetail.h"
#import "PromotionsViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *foundBeacons;
}
@end

@implementation MasterViewController
@synthesize locationManager,storeDetailList;

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    foundBeacons = [[NSMutableArray alloc] init];
    storeDetailList = [[NSMutableArray alloc] init];
    
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(startTracking:)
    forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [[bleepManager sharedInstance] setDelegate:self];
    [self startTracking:self];
    
    /* insert defaul test row */
    StoreDetail *s=[[StoreDetail alloc] init];
    s.storeName=@"store 1";
    s.address=@"store address";
    [self insertRow:s];
    
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

/*- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    
    return storeDetailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    //NSString *object = foundBeacons[indexPath.row];
    //cell.textLabel.text = object;
    StoreDetail *s=[storeDetailList objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[s.storeName stringByAppendingString:[@" - " stringByAppendingString:s.address]]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
    if ([[segue identifier] isEqualToString:@"promotionSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSDate *object = _objects[indexPath.row];
        StoreDetail *sd=[storeDetailList objectAtIndex:indexPath.row];
        [[segue destinationViewController] setStoreDetail:sd];
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
       
        BOOL exist=false;
        for(bleepBeacon *b in foundBeacons)
        {
            if([b.proximityUUID.UUIDString isEqualToString:beacon.proximityUUID.UUIDString ])
            {
                exist=true;
                break;
            }
        }
        if(!exist)
        {
            [foundBeacons insertObject:beacon atIndex:0];
          //   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
          //  [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self fetchStoreDetail];
        }
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


/* Web Service Request for store details*/
- (void)fetchStoreDetail;
{
    NSURL *url = [NSURL URLWithString:@"http://apex.oracle.com/pls/apex/viczsaurav/iDeals/store/3AE96580-33DB-458B-8024-2B3C63E0E920"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSArray *storeDetails = results[@"items"] ;
             NSDictionary *dictionary = [storeDetails objectAtIndex:0];
            
             StoreDetail *s=[[StoreDetail alloc] init];
             s.storeName=[dictionary objectForKey:@"store_name"];
             s.address=[dictionary objectForKey:@"address"];
             NSLog(@"Store Name : %@",s.storeName);
             
             [storeDetailList insertObject:s atIndex:0];
             
             
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
             [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
         }
     }];
}

-(void) insertRow:(StoreDetail *) s
{
   
    //s.storeName=[dictionary objectForKey:@"store_name"];
    //s.address=[dictionary objectForKey:@"address"];
    NSLog(@"Store Name : %@",s.storeName);
    
    [storeDetailList insertObject:s atIndex:0];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
