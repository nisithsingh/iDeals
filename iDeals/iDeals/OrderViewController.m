//
//  MapViewController.m
//  iDeals
//
//  Created by Milan Ashara on 06/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

//
//  OrderViewController
//  iDeals
//
//  Created by Nisith Singh on 01/05/14.
//  Copyright (c) 2014 Team6. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController
@synthesize orderDateLabel,orderIdLabel,promoDescLabel,promotionNameLabel,storeIdLabel,orderId,storeDetail,promotionDetail,amountPaidLabel,isFromDetailView,ispaymentCanceled;
NSString* const postPaymentSuccessUrl=@"https://apex.oracle.com/pls/apex/viczsaurav/iDeals/success/";
NSString* const orderUrl=@"https://apex.oracle.com/pls/apex/viczsaurav/iDeals/getorderid/";




- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!orderId) {
      //  [self configureView];
    }
    // Create a PayPalPayment
    
   
    
    if(isFromDetailView == YES)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.hidden=YES;
            
        });
        
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        
        // Amount, currency, and description
        
        //payment.currencyCode = @"SGD";
        //payment.shortDescription = @"Happy 7/11 Day";
        
        // payment.amount = self.DiscountedPriceLabel.text ;
        float discountedPrice=([promotionDetail.promotionActualPrice floatValue] - (([promotionDetail.promotionDiscount floatValue] * [promotionDetail.promotionActualPrice floatValue])/(float)100));
        payment.currencyCode = @"SGD";
        NSString *dp=[NSString stringWithFormat:@"%.02f",discountedPrice];
        
        payment.amount = [[NSDecimalNumber alloc] initWithFloat:[dp floatValue]];
        payment.shortDescription = promotionDetail.promotionDescription;
        NSLog(@"Promotion Detail View : %@",promotionDetail.promotionDescription);
        
        // Use the intent property to indicate that this is a "sale" payment,
        // meaning combined Authorization + Capture. To perform Authorization only,
        // and defer Capture to your server, use PayPalPaymentIntentAuthorize.
        payment.intent = PayPalPaymentIntentSale;
        
        // Check whether payment is processable.
        if (!payment.processable) {
            // If, for example, the amount was negative or the shortDescription was empty, then
            // this payment would not be processable. You would want to handle that here.
        }
        
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                    configuration:self.payPalConfiguration
                                                                                                         delegate:self];
        
        // Present the PayPalPaymentViewController.
        
        [self presentViewController:paymentViewController animated:YES completion:nil];
        isFromDetailView=NO;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.hidden=NO;
            
        });
        // [self configureView];
    }
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:true];
    if (ispaymentCanceled==YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.hidden=NO;
            
        });
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UITableViewController * vc = [storyboard instantiateInitialViewController];
        ispaymentCanceled=NO;
        [self presentViewController:vc animated:YES completion:nil];
        
        return;
    }
    

}
#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    NSLog(@"PayPal Payment Success!");
    //self.resultText.text = [completedPayment description];
    
    [self verifyCompletedPayment:completedPayment];
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    
    self.ispaymentCanceled=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
    
  /*  NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UITableViewController * vc = [storyboard instantiateInitialViewController];
    ispaymentCanceled=NO;
    [self presentViewController:vc animated:YES completion:nil];
    
    return;*/

    
}




// SomeViewController.m
- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    /*
     * Saving details on Server
     */
    ///build an info object and convert to json
    NSDictionary *results = completedPayment.confirmation;
    NSDictionary* request = [NSDictionary dictionaryWithObjectsAndKeys:
                             [results[@"response"] objectForKey:@"id"],@"id",
                             [results[@"response"] objectForKey:@"intent"],@"intent",
                             [results[@"response"] objectForKey:@"state"],@"state",
                             results[@"response_type"],@"response_type",
                             nil];
    
    //convert object to data
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSLog(@"Data = %@", jsonData);
    
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:
                                       [NSURL URLWithString:postPaymentSuccessUrl]];
    [urlrequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlrequest setHTTPMethod:@"POST"];
    [urlrequest setHTTPBody:jsonData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlrequest delegate:self];
    if (connection) {
        NSLog(@"Success Payment");
        NSString *paymentId=[results[@"response"] objectForKey:@"id"];
        [self getOrderID:paymentId];
         [self configureView];
        
    }
    else{
        NSLog(@"UnSuccess Payment");
    }
}

-(void) getOrderID:(NSString *)paymentId
{
    
    NSString *url=[orderUrl stringByAppendingString:paymentId];
    NSMutableURLRequest *urlrequest = [NSMutableURLRequest requestWithURL:
                                       [NSURL URLWithString:url]];
    NSURLResponse *response;
    NSError *error;
    NSData *data=[NSURLConnection sendSynchronousRequest:urlrequest returningResponse:&response error:&error];
    if (data.length > 0 && error == nil)
    {
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSArray *orderDetails = results[@"items"] ;
        //NSString *orderId;
        for(NSDictionary *order in orderDetails)
        {
            orderId=[order objectForKey:@"orderid"];
            NSLog(@"Success Order id retrieved . Order Id :%@ ",orderId);
        }
        //go to order view controller
        
        //[self setStoreDetail:self.storeDetail];
        //[self setOrderId:orderId];
        //[self setPromotionDetail:promotionDetail];
        //[self presentViewController:self animated:YES completion:nil];
        
    }
    
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = NO;
    }
    return self;
}


- (void)configureView
{
    orderIdLabel.text=orderId;
    storeIdLabel.text=storeDetail.storeName;
    promotionNameLabel.text=promotionDetail.promotionName;
    promoDescLabel.text=promotionDetail.promotionDescription;
    promoDescLabel.numberOfLines=0;
    NSDate *date=[[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd':'HH:mm"];

    orderDateLabel.text=[dateFormatter stringFromDate:date];
    float discountedPrice=([promotionDetail.promotionActualPrice floatValue] - (([promotionDetail.promotionDiscount floatValue] * [promotionDetail.promotionActualPrice floatValue])/(float)100));
    self.amountPaidLabel.text=[[NSString stringWithFormat:@"%.02f",discountedPrice] stringByAppendingString:@" SGD"];

    
}


@end
