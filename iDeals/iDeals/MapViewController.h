//
//  MapViewController.h
//  iDeals
//
//  Created by Nisith Singh on 06/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController : UIViewController{
    
    MKMapView *mapview;
    
}

- (IBAction)backButton:(id)sender;
@property (nonatomic,retain) IBOutlet MKMapView *mapview;
@property double latitude;
@property double longitude;
@property (nonatomic,strong) NSString* storeName;


- (void) setLatitude:(double) lati Longitude:(double)longi AndName:(NSString*) name;

@end
