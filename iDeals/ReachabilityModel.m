//
//  ReachabilityModel.m
//  iDeals
//
//  Created by student on 5/3/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//


#import "ReachabilityModel.h"
#import "Reachability.h"

@implementation ReachabilityModel
@synthesize status;

extern NSString* const iDealsBaseURL = @"http://apex.oracle.com/pls/apex/viczsaurav/iDeals/";

/*!
 * Main method to provide the status of all Network reachability options
 */
-(BOOL) isReachable {
    status = NO;
    [self checkUrlRechability];
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    //Check Remote host.
    NSString *remoteHostName = iDealsBaseURL;
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
	[self.hostReachability startNotifier];

    //Check Internet
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];

    //Check WiFi
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
	[self.wifiReachability startNotifier];

    return status;
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

/*!
 * Provides Notification of the user if Network is lost.
 */
- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if ((reachability == self.hostReachability) ||
        (reachability == self.internetReachability) ||
        (reachability == self.wifiReachability)) {
        
    	NetworkStatus netStatus = [reachability currentReachabilityStatus];
        if ((netStatus == ReachableViaWiFi) || (netStatus== ReachableViaWWAN)) {
            status = YES;
        }
        else {
            status = NO;
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"No Network Connection Available. Please enable and try again."
                                  delegate:self cancelButtonTitle:@"ok"
                                  otherButtonTitles:nil
                                  ];
            [alert show];
        }
    }

}

/*!
 * Called to check the URL rechability.
 */
- (void) checkUrlRechability {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Alert"
                          message:@"Server not reachable. Please try again after some time."
                          delegate:self cancelButtonTitle:@"ok"
                          otherButtonTitles:nil
                          ];
    NSURLRequest *request = [NSURLRequest requestWithURL: (NSURL *)iDealsBaseURL];
    [NSURLConnection sendAsynchronousRequest:request
                                              queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                            {
                                if ([data length] > 0 && error == nil){
                                    status = YES;
                                }
                                   
                                else if (([data length] == 0 && error == nil)
                                      || (error != nil && error.code == NSURLErrorTimedOut)
                                      || (error != nil)) {
                                    status = NO;
                                    [alert show];
                                }
                                
                            }];

}

/*!
 * Removing NSNotificationCenter Observer.
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end