//
//  AppCommunication.h
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCommunication : NSObject
+ (instancetype)sharedManager;
@property (nonatomic, strong) NSString* myFBName;
@property (nonatomic, strong) NSString* myFBID;
@property (nonatomic, strong) NSMutableArray* sellerMyItems;
@end
