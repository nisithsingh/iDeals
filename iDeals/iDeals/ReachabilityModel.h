//
//  ReachabilityModel.h
//  iDeals
//
//  Created by student on 5/3/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Reachability.h"


@interface ReachabilityModel : NSObject <CBCentralManagerDelegate>{
    
}

@property (nonatomic) BOOL status;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (nonatomic, strong) CBCentralManager* bluetoothManager;

-(BOOL) isReachable;

@end
