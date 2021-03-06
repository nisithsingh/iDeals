//
//  PromotionsViewController.m
//  test
//
//  Created by student1 on 5/4/14.
//  Copyright (c) 2014 student1. All rights reserved.
//

#import "PromotionsViewController.h"
#import "PromotionDetail.h"
#import "DetailViewController.h"
#import "StoreDetail.h"
@interface PromotionsViewController () {
    
}
@end

@implementation PromotionsViewController
@synthesize storeDetail;
NSString* const iDealsPromotionBaseUrl=@"https://apex.oracle.com/pls/apex/viczsaurav/iDeals/getpromotion/";

- (void)setStoreDetail:(StoreDetail *)newDetailItem
{
    if (storeDetail != newDetailItem) {
        storeDetail = newDetailItem;
        NSLog(@"Store Name in Promotion View :%@",storeDetail.storeName);
    
        if(!storeDetail.promotionDetails)
        {
            storeDetail.promotionDetails=[[NSMutableArray alloc]init];
            [self fetchPromotionDetail:storeDetail.storeId];
        }
    }
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    
    [super awakeFromNib];
    
   
}

- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];
	
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
   
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshView)
      forControlEvents:UIControlEventValueChanged];

    self.refreshControl = refresh;
    
    
    
    
}

-(void) refreshView{
    
    [self fetchPromotionDetail:storeDetail.storeId];
    [self.refreshControl endRefreshing];
   
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"Promotion count : %d",storeDetail.promotionDetails.count);
    return storeDetail.promotionDetails.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.imageView.frame = CGRectMake(0,0,32,32);
    
    PromotionDetail *promotionDetail = [storeDetail.promotionDetails objectAtIndex:[indexPath row]];
    NSString *discountString=[NSString stringWithFormat:@" - "];
    discountString=[discountString stringByAppendingString:[promotionDetail.promotionDiscount stringValue] ];
    discountString=[discountString stringByAppendingString:@"% Off"];
    [[cell textLabel] setText:[promotionDetail.promotionName stringByAppendingString:discountString]];
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: promotionDetail.promotionImageLink]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
    
    cell.imageView.image =image;
    cell.textLabel.numberOfLines = 0;
  
    //[cell.textLabel sizeToFit];
    
    cell.detailTextLabel.text=[promotionDetail  promotionDescription];
    cell.detailTextLabel.numberOfLines=0;
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [storeDetail.promotionDetails removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromotionDetail *object = promotionList[indexPath.row];
    self.detailViewController.detailItem = object;
}
*/

/* Web Service Request for promotion details*/
- (void)fetchPromotionDetail:(NSNumber *) storeId
{
    
   
    
    
    NSString *storeIdString=[storeId stringValue];
    NSLog(@"Store Id : %@",storeIdString);
    NSString *urlString = [iDealsPromotionBaseUrl stringByAppendingString:storeIdString];
    
    NSLog(@"Promotion URL : %@",urlString);

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         //clear table
         [storeDetail.promotionDetails removeAllObjects];
         [self.tableView reloadData];
         
         if (data.length > 0 && connectionError == nil)
         {
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSArray *storeDetails = results[@"items"] ;
            
             
             for(NSDictionary *promotionDictionay in storeDetails)
             {
                 
                 PromotionDetail *promotion=[[PromotionDetail alloc] init];
                 promotion.promotionId=[promotionDictionay objectForKey:@"promotion_id"] ;
                 promotion.promotionDescription=[promotionDictionay objectForKey:@"promotion_desc"];
                 promotion.promotionName=[promotionDictionay objectForKey:@"promotion_name"] ;
                 promotion.promotionActualPrice=[promotionDictionay objectForKey:@"actual_price"];
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                               [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

                 promotion.promotionStartDate=[dateFormatter dateFromString:[promotionDictionay objectForKey:@"start_date"]];
                 
                 promotion.promotionEndDate=[dateFormatter dateFromString:[promotionDictionay objectForKey:@"end_date"]] ;
                 promotion.promotionDiscount=[promotionDictionay objectForKey:@"discount"];
                 promotion.promotionImageLink=[promotionDictionay objectForKey:@"image_link"];
                 promotion.promotionDiscountCode=[promotionDictionay objectForKey:@"discount_code"];
                 
                 NSLog(@"Promotion Id : %@",[promotion.promotionId stringValue]);
                 NSLog(@"Promotion Discount: %@",[promotion.promotionDiscount stringValue]);
                 
                 [storeDetail.promotionDetails insertObject:promotion atIndex:0];
                 
                 
                 NSLog(@"Promotion count : %d",storeDetail.promotionDetails.count);
                 
                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                 [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

             }
             
             
     
         }
     
     }];
}

-(void) insertRow:(PromotionDetail *) promotion
{
    

    NSLog(@"Promotion Id: %@",promotion.promotionId);
    
    [storeDetail.promotionDetails insertObject:promotion atIndex:0];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)refreshPromotion:(id)sender {
    [self fetchPromotionDetail:storeDetail.storeId];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"promotionDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      
        PromotionDetail *promotionDetail=[storeDetail.promotionDetails objectAtIndex:indexPath.row];
       
        [[segue destinationViewController] setPromotionDetail:promotionDetail AlongWithAllPromos:storeDetail.promotionDetails];
         [[segue destinationViewController] setStoreDetail:storeDetail];
    }
}

@end
