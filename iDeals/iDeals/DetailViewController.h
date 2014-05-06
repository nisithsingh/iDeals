//
//  DetailViewController.h
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromotionDetail.h"
#import "PayPalMobile.h"

@interface DetailViewController : UIViewController

@property NSInteger indexForSwipe;
@property (nonatomic,strong,readwrite) PayPalConfiguration *payPalConfiguration;

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *DiscountedPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *PayPalButton;
@property (weak, nonatomic) IBOutlet UILabel *youSaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *EndDateLabel;
@property (strong, nonatomic) PromotionDetail *promotionDetail;
@property (weak, nonatomic) IBOutlet UIImageView *promotionImageView;
@property (nonatomic) NSMutableArray *allStorePromos;
@property (weak, nonatomic) IBOutlet UILabel *swipeTypeLabel;
- (IBAction)goToLeftPromo:(UISwipeGestureRecognizer *)sender;
- (IBAction)goToRightPromo:(UISwipeGestureRecognizer *)sender;
+ (NSDateFormatter *) getDateFormatter;

- (void)setPromotionDetail:(PromotionDetail *)newPromotionDetail AlongWithAllPromos:(NSMutableArray*) allPromos;

- (IBAction)payButton:(id)sender;

@end


