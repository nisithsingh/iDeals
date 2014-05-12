//
//  DetailViewController.m
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import "DetailViewController.h"
#import "OrderViewController.h"
@interface DetailViewController ()
- (void)configureView;

@end

@implementation DetailViewController
@synthesize promotionDetail,allStorePromos,swipeTypeLabel,indexForSwipe,paymentViewController,orderViewController,storeDetail;
#pragma mark - Managing the detail item

- (void)setPromotionDetail:(PromotionDetail *)newPromotionDetail AlongWithAllPromos:(NSMutableArray*) allPromos
{
    if (promotionDetail != newPromotionDetail) {
        promotionDetail = newPromotionDetail;
        allStorePromos= allPromos;
        indexForSwipe= [allStorePromos indexOfObject:promotionDetail];
        NSLog(@"Promotion Detail View : %@",promotionDetail.promotionDescription);
       
        NSLog(@"Selected promo index :%d",indexForSwipe);
     
    }
}
- (void)setPromotionDetail:(StoreDetail *)newStoreDetail{
    self.storeDetail=newStoreDetail;
}


- (IBAction)payButton:(id)sender {
    
    


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



//Swipe Methods

- (IBAction)goToLeftPromo:(UISwipeGestureRecognizer *)sender {
    if(indexForSwipe==[allStorePromos count]-1){
        
        indexForSwipe=[allStorePromos count]-1;
        swipeTypeLabel.text=@"No more on the right";
    }
    else{
        indexForSwipe+=1;
        //swipeTypeLabel.text=@"Left Swipe";
        //NSLog(@"%@",[NSString stringWithFormat:@"%d",indexForSwipe]);
        promotionDetail=[allStorePromos objectAtIndex:indexForSwipe];
        [self configureView];
        swipeTypeLabel.text=@"<-       Swipe For More       ->";
    }
    
}

- (IBAction)goToRightPromo:(UISwipeGestureRecognizer *)sender {
    
    if(indexForSwipe==0){
        swipeTypeLabel.text=@"No more on the left";
        indexForSwipe=0;
    }
    else{
        indexForSwipe-=1;
        promotionDetail=[allStorePromos objectAtIndex:indexForSwipe];
        [self configureView];
        swipeTypeLabel.text=@"<-       Swipe For More       ->";
    }
}

+ (NSDateFormatter *) getDateFormatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd':'HH:mm"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"orderDetailSegue"]) {
        [[segue destinationViewController] setPromotionDetail:promotionDetail];
        [[segue destinationViewController] setStoreDetail:storeDetail];
        [[segue destinationViewController] setIsFromDetailView:YES];
        
    }
}


- (IBAction)homeButtonClicked:(id)sender {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UITableViewController * vc = [storyboard instantiateInitialViewController];
    
    [self presentViewController:vc animated:YES completion:nil];

}
@end
