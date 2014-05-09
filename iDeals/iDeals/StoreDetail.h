//
//  StoreDetail.h
//  iDeals
//
//  Created by student on 5/3/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreDetail : NSObject
{
    
}
@property(nonatomic,retain) NSNumber *storeId;
@property(nonatomic,retain) NSString *storeName;
@property(nonatomic,retain) NSString *storeAddress;
@property(nonatomic,retain) NSMutableArray *promotionDetails;
@property(nonatomic,retain) NSNumber *storePhoneNumber;
@property (nonatomic,strong) NSString *storeLogo;
@property (nonatomic,strong) NSNumber *minorId;
@property (nonatomic,strong) NSNumber *majorId;
@end
