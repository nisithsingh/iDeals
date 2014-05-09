//
//  MapViewController.h
//  iDeals
//
//  Created by Nisith Singh on 06/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController{
    
    MKMapView *mapview;
    
}

- (IBAction)backButton:(id)sender;
@property (nonatomic,retain) IBOutlet MKMapView *mapview;

@end
