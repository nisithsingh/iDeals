//
//  MasterViewController.h
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "bleepManager.h"
#import "ReachabilityModel.h"
#define k_UUID @"3AE96580-33DB-458B-8024-2B3C63E0E920"

static    NSMutableArray *storeDetailListStatic;
@interface MasterViewController : UITableViewController <CLLocationManagerDelegate, bleepManagerDelegate>    

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong)   NSMutableArray *storeDetailList;
@property(nonatomic,strong) ReachabilityModel *reachablity;
-(void) mapButtonClicked:(id)sender;
+(NSMutableArray *) geStoreDetailList;
@end
