//
//  DetailViewController.h
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UIView *promotionImage;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *actualPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *DiscountedPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *youSaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *EndDateLabel;


@end
