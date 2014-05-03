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
    NSMutableArray *promotionList;
}
@end

@implementation PromotionsViewController
@synthesize storeDetail;

- (void)setStoreDetail:(StoreDetail *)newDetailItem
{
    if (storeDetail != newDetailItem) {
        storeDetail = newDetailItem;
        NSLog(@"Store Name in Promotion View :%@",storeDetail.storeName);
        // Update the view.
      //  [self configureView];
        
    }
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    promotionList=[[NSMutableArray alloc]init];
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];
    
   
    
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:true];
    [self fetchPromotionDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)insertNewObject:(id)sender
{
    if (!promotionList) {
        promotionList = [[NSMutableArray alloc] init];
    }
    
   
    
    [promotionList insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSLog(@"Promotion count : %d",promotionList.count);
    return promotionList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    PromotionDetail *object = [promotionList objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%d",[object promoId]]];
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
        [promotionList removeObjectAtIndex:indexPath.row];
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
- (void)fetchPromotionDetail;
{
    
    
    /*PromotionDetail *s=[[PromotionDetail alloc] init];
    s.promoId=@"12";
    s.discValue=@"23";
    [self insertRow:s];*/
    
    NSURL *url = [NSURL URLWithString:@"https://apex.oracle.com/pls/apex/viczsaurav/iDeals/promotion/1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response;
    NSError *error;
    //[NSURLConnection sendSynchronousRequest:request returningResponse:(NSURLResponse *__autoreleasing *) error:(NSError *__autoreleasing *)]
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (data.length > 0 && error == nil)
    {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
                                                                options:0
                                                                  error:NULL];
        NSArray *storeDetails = results[@"items"] ;
        NSDictionary *dictionary = [storeDetails objectAtIndex:0];
        
        PromotionDetail *pro=[[PromotionDetail alloc] init];
        pro.promoId=[dictionary objectForKey:@"promotion_id"] ;
       // NSLog(@"%@",NSStringFromClass([pro.promoId class]));
        pro.discValue=[dictionary objectForKey:@"discount"];
        
        NSLog(@"Promotion Name : %d",pro.promoId);
        NSLog(@"Promotion Discount: %d",pro.discValue);
        [promotionList insertObject:pro atIndex:0];
        NSLog(@"Promotion count : %d",promotionList.count);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //[self.tableView reloadData];
        
    }

    /*[NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         
         
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:NULL];
             NSArray *storeDetails = results[@"items"] ;
             NSDictionary *dictionary = [storeDetails objectAtIndex:0];
             
             PromotionDetail *s=[[PromotionDetail alloc] init];
             s.promoId=[dictionary objectForKey:@"promotion_id"];
             s.discValue=[dictionary objectForKey:@"discount"];
             NSLog(@"Promotion Name : %@",s.promoId);
             
             [promotionList insertObject:s atIndex:0];
             NSLog(@"Promotion count : %d",promotionList.count);
             
             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
             [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             //[self.tableView reloadData];
             
         }
         
     }];*/
}

-(void) insertRow:(PromotionDetail *) p
{
    
    //s.storeName=[dictionary objectForKey:@"store_name"];
    //s.address=[dictionary objectForKey:@"address"];
    NSLog(@"Store Name : %@",p.promoId);
    
    [promotionList insertObject:p atIndex:0];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
