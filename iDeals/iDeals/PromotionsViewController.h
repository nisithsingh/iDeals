//
//  MasterViewController.h
//  test
//
//  Created by student1 on 5/4/14.
//  Copyright (c) 2014 student1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreDetail;
@class DetailViewController;

@interface PromotionsViewController : UITableViewController

- (IBAction)refreshPromotion:(id)sender;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) StoreDetail *storeDetail;
//For swipe
//@property (strong,nonatomic) NSMutableArray *allStrorePromos;
- (void)setStoreDetail:(id)newDetailItem;


@end