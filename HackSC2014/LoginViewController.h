//
//  LoginViewController.h
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import <Sinch/Sinch.h>
@interface LoginViewController : UIViewController<FBLoginViewDelegate,CLLocationManagerDelegate,SINMessageClientDelegate,SINClientDelegate>

@end
