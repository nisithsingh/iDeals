//
//  PayPalPayment.h
//
//  Version 2.1.0
//
//  Copyright (c) 2014, PayPal
//  All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - PayPalPaymentIntent

typedef NS_ENUM(NSInteger, PayPalPaymentIntent) {
  PayPalPaymentIntentSale = 0,
  PayPalPaymentIntentAuthorize = 1,
  };


#pragma mark - PayPalPaymentDetails

/// The PayPalPaymentDetails class defines optional amount details.
/// @see https://developer.paypal.com/webapps/developer/docs/api/#details-object for more details.
@interface PayPalPaymentDetails : NSObject <NSCopying>

/// Convenience constructor.
/// See the documentation of the individual properties for more detail.
/// @param subtotal Sum of amounts for all items in this transaction.
/// @param shipping Shipping and handling amount for the overall transaction.
/// @param tax Tax amount for the overall transaction.
+ (PayPalPaymentDetails *)paymentDetailsWithSubtotal:(NSDecimalNumber *)subtotal
                                        withShipping:(NSDecimalNumber *)shipping
                                             withTax:(NSDecimalNumber *)tax;

/// Sub-total (amount) of items being paid for. 10 characters max with support for 2 decimal places.
@property(nonatomic, copy, readwrite) NSDecimalNumber *subtotal;

/// Amount charged for shipping. 10 characters max with support for 2 decimal places.
@property(nonatomic, copy, readwrite) NSDecimalNumber *shipping;

/// Amount charged for tax. 10 characters max with support for 2 decimal places.
@property(nonatomic, copy, readwrite) NSDecimalNumber *tax;

@end


#pragma mark - PayPalItem

/// The PayPalItem class defines an optional itemization for a payment.
/// @see https://developer.paypal.com/docs/api/#item-object for more details.
@interface PayPalItem : NSObject <NSCopying>

/// Convenience constructor.
/// See the documentation of the individual properties for more detail.
/// @param name Name of the item.
/// @param quantity Number of units.
/// @param price Unit price for this item.
/// @param currency ISO standard currency code.
/// @param sku The stock keeping unit for this item.
+ (PayPalItem *)itemWithName:(NSString *)name
                withQuantity:(NSUInteger)quantity
                   withPrice:(NSDecimalNumber *)price
                withCurrency:(NSString *)currency
                     withSku:(NSString *)sku;

/// Convenience utility.
/// Returns the total of (quantity * price) for all of the items.
/// @param array of PayPalItem objects.
+ (NSDecimalNumber *)totalPriceForItems:(NSArray *)items;

/// Item name. 127 characters max. Required.
@property(nonatomic, copy, readwrite) NSString *name;

/// Number of a particular item. 10 characters max. Required.
@property(nonatomic, assign, readwrite) NSUInteger quantity;

/// Item cost. 10 characters max. Required.
@property(nonatomic, copy, readwrite) NSDecimalNumber *price;

/// ISO standard currency code (http://en.wikipedia.org/wiki/ISO_4217). Required.
@property(nonatomic, copy, readwrite) NSString *currency;

/// Stock keeping unit corresponding (SKU) to item. 50 characters max.
@property(nonatomic, copy, readwrite) NSString *sku;

@end


#pragma mark - PayPalPayment

@interface PayPalPayment : NSObject <NSCopying>

/// Convenience constructor.
/// See the documentation of the individual properties for more detail.
/// @param amount The amount of the payment.
/// @param currencyCode The ISO 4217 currency for the payment.
/// @param shortDescription A short descripton of the payment.
/// @param intent PayPalPaymentIntentSale for an immediate payment;
///                PayPalPaymentIntentAuthorize for payment authorization only, to be captured separately at a later time.
+ (PayPalPayment *)paymentWithAmount:(NSDecimalNumber *)amount
                        currencyCode:(NSString *)currencyCode
                    shortDescription:(NSString *)shortDescription
                              intent:(PayPalPaymentIntent)intent;


#pragma mark Required properties

/// ISO standard currency code (http://en.wikipedia.org/wiki/ISO_4217).
@property(nonatomic, copy, readwrite) NSString *currencyCode;

/// Amount in the given currency to process. Must be positive.
@property(nonatomic, copy, readwrite) NSDecimalNumber *amount;

/// A short description of the transaction, for display to the user.
/// The description will be truncated for display, if necessary;
/// limiting it to about 20 characters should prevent truncation in most cases.
@property(nonatomic, copy, readwrite) NSString *shortDescription;

/// The intent of this payment:
/// - PayPalPaymentIntentSale for an immediate payment
/// - PayPalPaymentIntentAuthorize for payment authorization only,
///   to be captured separately at a later time.
/// Defaults to PayPalPaymentIntentSale.
@property(nonatomic, assign, readwrite) PayPalPaymentIntent intent;


#pragma mark Optional properties

/// Optional payment details @see PayPalPaymentDetails properties.
/// @note If you provide payment details, be sure that `subtotal`, `shipping`, and `tax`
/// sum exactly to the payment `amount`.
@property (nonatomic, copy, readwrite) PayPalPaymentDetails *paymentDetails;

/// Optional array of PayPalItem objects. @see PayPalItem
/// @note If you provide one or more items, be sure that the various prices correctly
/// sum to the payment `amount` or to `paymentDetails.subtotal`.
@property (nonatomic, copy, readwrite) NSArray *items;

/// Optional Build Notation code ("BN code"), obtained from partnerprogram@paypal.com,
/// for your tracking purposes.
@property(nonatomic, copy, readwrite) NSString *bnCode;


#pragma mark Convenience getters

/// Can this payment be processed?
/// A payment might not be processable if, for example:
/// - the amount is non-positive,
/// - the currency is invalid,
/// - the amount includes more decimal fraction digits than the currency allows,
/// - there's no description, or
/// - the payment has already been processed.
@property(nonatomic, assign, readonly) BOOL processable;

/// The payment amount rendered with the appropriate currency symbol.
@property(nonatomic, copy, readonly) NSString *localizedAmountForDisplay;


#pragma mark Properties available on completed purchases

/// Full payment confirmation, with lots of details including the proof
/// of payment token. You should send the entire confirmation
/// dictionary to your servers and process it there, for maximum flexibility.
/// See https://developer.paypal.com/webapps/developer/docs/integration/mobile/verify-mobile-payment/
/// and https://developer.paypal.com/webapps/developer/docs/integration/direct/capture-payment/
/// for more details.
@property(nonatomic, readonly, copy) NSDictionary *confirmation;


@end
