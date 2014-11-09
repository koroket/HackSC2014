//
//  PaymentViewController.m
//  HackSC2014
//
//  Created by sloot on 11/9/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "PaymentViewController.h"
#import <Venmo.h>
@interface PaymentViewController ()
@property (strong, nonatomic) IBOutlet UIButton *venmoButton;
@property (strong, nonatomic) IBOutlet UIButton *paypalButton;
- (IBAction)venmoPressed:(id)sender;
- (IBAction)paypalPressed:(id)sender;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)VenmoPay{
    if (![Venmo isVenmoAppInstalled]) {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    }
    else {
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
    }
    
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                 // :)
                             }
                             else {
                                 // :(
                             }
                         }];
    
    [[Venmo sharedInstance] sendPaymentTo:@"6502817692"
                                   amount:1*100 // this is in cents!
                                     note:@"PaySplit"
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"Transaction succeeded!");
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
}


- (IBAction)venmoPressed:(id)sender {
    [self VenmoPay];
}

- (IBAction)paypalPressed:(id)sender {
}
@end
