//
//  AppCommunication.m
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "AppCommunication.h"

@implementation AppCommunication

+ (instancetype)sharedManager
{
    static AppCommunication *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedMyManager = [[self alloc] init];
                  });
    return sharedMyManager;
}

@end

