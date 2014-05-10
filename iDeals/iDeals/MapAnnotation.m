//
//  MapAnnotation.m
//  iDeals
//
//  Created by Nisith Singh on 10/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
    }
    return self;
}

@end
