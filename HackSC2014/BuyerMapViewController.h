//
//  BuyerMapViewController.h
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BuyerMapViewController : UIViewController <MKMapViewDelegate>
-(void)updateMapWithLatitude:(double) lati andWithLongitude:(double) longi;

@end
