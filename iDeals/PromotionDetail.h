//
//  PromotionDetail.h
//  iDeals
//
//  Created by student1 on 5/3/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionDetail : NSObject
{
    
}

@property (nonatomic,strong) NSNumber *promotionId;
@property (nonatomic,strong) NSString *promotionName;
@property (nonatomic,strong) NSNumber *promotionDiscount;
@property (nonatomic,strong) NSString *promotionDescription;
@property (nonatomic,strong) NSNumber *promotionActualPrice;
@property (nonatomic,strong) NSDate *promotionStartDate;
@property (nonatomic,strong) NSDate *promotionEndDate;
@property (nonatomic,strong) NSString *promotionDiscountCode;
@property (nonatomic,strong) NSString *promotionImageLink;

@end
