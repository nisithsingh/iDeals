//
//  MapAnnotation.h
//  iDeals
//
//  Created by Nisith Singh on 10/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject

@property (strong, nonatomic) NSString *title;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title;



@end
