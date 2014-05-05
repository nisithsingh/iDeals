//
//  DetailViewController.m
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController
@synthesize promotionDetail;
#pragma mark - Managing the detail item

- (void)setPromotionDetail:(PromotionDetail *)newPromotionDetail
{
    if (promotionDetail != newPromotionDetail) {
        promotionDetail = newPromotionDetail;
        
        NSLog(@"Promotion Detail View : %@",promotionDetail.promotionDescription);
        // Update the view.
        //[self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.promotionDetail) {
        
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: promotionDetail.promotionImageLink]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        self.promotionImageView.image =image;
        
        NSString *discountString=[@"Off %" stringByAppendingString:[promotionDetail.promotionDiscount stringValue]];
        self.discountLabel.text=discountString;
        
        NSString *priceString=[[promotionDetail.promotionActualPrice stringValue] stringByAppendingString:@" SGD"];
        self.actualPriceLabel.text=priceString;
        
        float discountedPrice=([promotionDetail.promotionActualPrice floatValue] - (([promotionDetail.promotionDiscount floatValue] * [promotionDetail.promotionActualPrice floatValue])/(float)100));
        self.DiscountedPriceLabel.text=[[NSString stringWithFormat:@"%.02f",discountedPrice] stringByAppendingString:@" SGD"];
        
        float youSave=[promotionDetail.promotionActualPrice floatValue]-discountedPrice;
        self.youSaveLabel.text=[[NSString stringWithFormat:@"%.02f",youSave] stringByAppendingString:@" SGD"];

        
        NSDateFormatter *dateFormatter=[DetailViewController getDateFormatter];
        
        self.startDateLabel.text= [dateFormatter stringFromDate:promotionDetail.promotionStartDate];
        NSLog(@"start Date :%@",[dateFormatter stringFromDate:[NSDate date]]);
        self.EndDateLabel.text= [dateFormatter stringFromDate:promotionDetail.promotionEndDate];
        self.startDateLabel.numberOfLines=0;
        self.EndDateLabel.numberOfLines=0;
        
        
    }
}

+ (NSDateFormatter *) getDateFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    return dateFormatter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
