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
#import "MapViewController.h"

@class ReachabilityModel;
@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *foundBeacons;
   
}
@end
// static    NSMutableArray *storeDetailList;
@implementation MasterViewController
@synthesize locationManager,reachablity,storeDetailList;
NSString* const iDealsBaseUrl=@"http://apex.oracle.com/pls/apex/viczsaurav/iDeals/getstores/";
NSString* const iDealsBaseUrlwithMajorMinor=@"http://apex.oracle.com/pls/apex/viczsaurav/iDeals/getstore/";
- (void)awakeFromNib
{
    
    [super awakeFromNib];
    foundBeacons = [[NSMutableArray alloc] init];
    if(storeDetailList==nil)
    storeDetailList = [[NSMutableArray alloc] init];
    //storeDetailList=[MasterViewController geStoreDetailList];
    reachablity=[[ReachabilityModel alloc] init];
    
    
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];
    [reachablity isReachable];
    
    [[bleepManager sharedInstance] setDelegate:self];
    [self startTracking:self];
    
    /* insert defaul test row */
   // [self fetchStoreDetail:@"3AE96580-33DB-458B-8024-2B3C63E0E920" withMinorID:[NSNumber numberWithInt:1] withMajor:[NSNumber numberWithInt:1]];
   //[self fetchStoreDetail:@"3AE96580-33DB-458B-8024-2B3C63E0E920" withMinorID:nil withMajor:nil];
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    //[storeDetailList removeAllObjects];
    //[foundBeacons removeAllObjects];
   // [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

  
    StoreDetail *storeDetail=[storeDetailList objectAtIndex:[indexPath row]];
    
    
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: storeDetail.storeLogo]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    cell.imageView.image =image;
    cell.textLabel.text=storeDetail.storeName;
    cell.detailTextLabel.text=[[[storeDetail.storePhoneNumber stringValue] stringByAppendingString:@"\n"] stringByAppendingString:storeDetail.storeAddress];
    cell.detailTextLabel.numberOfLines=0;
    cell.textLabel.numberOfLines=0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    //set the position of the button
    button.frame = CGRectMake(cell.frame.origin.x + 130, cell.frame.origin.y + 70, 100, 30);
    [button setTitle:@"Show on Map" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor= [UIColor clearColor];
    
    [cell.contentView addSubview:button];

    
    
    return cell;
}

-(void) mapButtonClicked:(id)sender{
    NSLog(@"mapButtonClicked");
   
   
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    MapViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //NSDate *object = _objects[indexPath.row];
    StoreDetail *sd=[storeDetailList objectAtIndex:indexPath.row];
    
    [vc setLatitude:sd.latitude Longitude:sd.longitude AndName:sd.storeName];
    
    [self presentViewController:vc animated:YES completion:nil];
 
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
            if([b.proximityUUID.UUIDString isEqualToString:beacon.proximityUUID.UUIDString] && b.major==beacon.major && b.minor == beacon.minor)
            {
                exist=true;
                break;
            }
        }
        if(!exist)
        {
            [foundBeacons insertObject:beacon atIndex:0];
       
            [self fetchStoreDetail:beacon.proximityUUID.UUIDString withMinorID:beacon.minor withMajor:beacon.major];
        }
    }
      //  [[bleepManager sharedInstance] stopBleepDiscovery];
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
        
        //remove row
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        if(indexPath.row!=0)    // There should be rows to delete
        {
        [storeDetailList removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
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
  }


- (IBAction)startTracking:(id)sender{
    [foundBeacons removeAllObjects];
    //[udid setTextColor:[UIColor grayColor]];
    //[udid setEnabled:FALSE];
    [[bleepManager sharedInstance] setUUID:[k_UUID uppercaseString]];
    [[bleepManager sharedInstance] startBleepDiscoveryForRegion];
    
	NSLog(@"bleep! Start monitoring");
 
   
}

- (IBAction)stopTracking:(id)sender{
  
    [[bleepManager sharedInstance] stopBleepDiscovery];
	NSLog(@"bleep! Stop monitoring");
  
}


/* Web Service Request for store details*/
- (void)fetchStoreDetail:(NSString *)beaconId withMinorID:(NSNumber *)minorID withMajor:(NSNumber *)majorID
{
   
    
    NSString *urlString = [iDealsBaseUrl stringByAppendingString:beaconId];
    
    if(majorID != nil && minorID != nil)
    {
        urlString=[iDealsBaseUrlwithMajorMinor stringByAppendingString:beaconId];
        urlString=[urlString stringByAppendingString:@","];
        urlString=[urlString stringByAppendingString:[majorID stringValue]];
        urlString=[urlString stringByAppendingString:@","];
        urlString=[urlString stringByAppendingString:[minorID stringValue]];
    }
    NSLog(@"URL : %@",urlString);
    
    NSURL *url = [NSURL URLWithString: urlString];
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
             for(NSDictionary *storeDictionay in storeDetails)
             {
                 
                 StoreDetail *storeDetail=[[StoreDetail alloc] init];
                 storeDetail.storeName=[storeDictionay objectForKey:@"store_name"];
                 storeDetail.storeAddress=[storeDictionay objectForKey:@"store_address"];
                 storeDetail.storeId=[storeDictionay objectForKey:@"store_id"];
                 storeDetail.storePhoneNumber=[storeDictionay objectForKey:@"store_phone"];
                 storeDetail.storeLogo=[storeDictionay objectForKey:@"store_logo"];
                 storeDetail.latitude= [[storeDictionay objectForKey:@"latitude"] floatValue];
                 storeDetail.longitude=[[storeDictionay objectForKey:@"longitude"] floatValue];
                 NSLog(@"Store Name : %@",storeDetail.storeName);
                 
                 BOOL exist=false;
                 for(StoreDetail *sd in storeDetailList)
                 {
                     if(sd.storeId == storeDetail.storeId)
                     {
                         exist=true;
                         break;
                     }
                 }
                 if(!exist)
                 {
                     [storeDetailList insertObject:storeDetail atIndex:0];
             
             
                     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                     [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                 }
             }
         }
     }];
}
-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:true];
     [[bleepManager sharedInstance] stopBleepDiscovery];
}
-(NSMutableArray*) storeDetailStaticArray
{
    static NSMutableArray* theArray = nil;
    if (theArray == nil)
    {
        theArray = [[NSMutableArray alloc] init];
    }
    
    return theArray;
}
+(NSMutableArray *) geStoreDetailList{
    if(storeDetailListStatic==nil)
    {
        storeDetailListStatic=[[NSMutableArray alloc]init];
    }
    return storeDetailListStatic;
}
@end
