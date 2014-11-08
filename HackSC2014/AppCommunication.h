//
//  AppCommunication.h
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface AppCommunication : NSObject
+ (instancetype)sharedManager;
-(NSString*)strLocationMakerWithLat:(float)lat withLongi:(float)longi;

@property (nonatomic, strong) NSString* myFBName;
@property (nonatomic, strong) NSString* myFBID;
@property (nonatomic, strong) NSMutableArray* sellerMyItems;
@property (nonatomic, strong) NSMutableArray* buyerMySellers;
@property (nonatomic, strong) NSMutableArray* buyerMyItems;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* myLocation;
@end
