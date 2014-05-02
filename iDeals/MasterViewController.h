//
//  MasterViewController.h
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>
@class beaconDetection;

@interface MasterViewController : UITableViewController {
    NSArray *beacons;
}
    

@property (nonatomic, assign) NSArray *beacons;
@end
