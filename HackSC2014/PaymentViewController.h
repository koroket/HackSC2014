//
//  PaymentViewController.h
//  HackSC2014
//
//  Created by sloot on 11/9/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"
@interface PaymentViewController : UIViewController <PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPopoverControllerDelegate>

@end