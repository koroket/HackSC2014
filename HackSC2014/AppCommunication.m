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

-(NSString*)strLocationMakerWithLat:(float)lat withLongi:(float)longi
{
    
    float fixedLat = lat+.05;
    NSString* strFixedLat = [NSString stringWithFormat:@"%.1f",fixedLat];
    float fixedLongi = longi+.05;
    NSString* strFixedLongi = [NSString stringWithFormat:@"%.1f",fixedLongi];
    NSLog(strFixedLat);
    NSLog(strFixedLongi);
    return strFixedLat;
}
@end

