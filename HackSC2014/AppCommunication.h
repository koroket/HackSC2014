//
//  AppCommunication.h
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BuyerMapViewController.h"
@interface AppCommunication : NSObject
+ (instancetype)sharedManager;
-(NSString*)strLocationMakerWithLat:(float)lat withLongi:(float)longi;
@property (nonatomic, strong) NSString* myBizName;
@property (nonatomic, strong) NSString* myFBName;
@property (nonatomic, strong) NSString* myFBID;
@property (nonatomic, strong) NSMutableArray* sellerMyItems;
@property (nonatomic, strong) NSMutableArray* sellerMyFollowers;
@property (nonatomic, strong) NSMutableArray* buyerMySellers;
@property (nonatomic, strong) NSMutableArray* buyerMyItems;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* myLocation;
@property (nonatomic, strong) NSString* typeOfPerson;
@property (nonatomic, strong) NSString* currentMapSellerFBID;
@property (nonatomic, strong) NSString* currentLatitude;
@property (nonatomic, strong) NSString* currentLongitude;
@property (nonatomic, assign) bool didGetPastInitialViewController;
@property (nonatomic, weak) BuyerMapViewController* buyerMapViewController;
@end
