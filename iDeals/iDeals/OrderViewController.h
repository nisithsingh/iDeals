//
//  MapViewController.h
//  iDeals
//
//  Created by Nisith Singh on 06/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "StoreDetail.h"
#import "PromotionDetail.h"
#import "PayPalMobile.h"

@interface OrderViewController : UIViewController<PayPalPaymentDelegate>{
    
   
    
}
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) NSString  *orderId;
@property (weak, nonatomic) PromotionDetail  *promotionDetail;
@property (weak, nonatomic) StoreDetail  *storeDetail;

@property (weak, nonatomic) IBOutlet UILabel *amountPaidLabel;
@property (nonatomic,strong,readwrite) PayPalConfiguration *payPalConfiguration;
@property  BOOL isFromDetailView;
@property  BOOL ispaymentCanceled;
@end
