//
//  BuyerMapViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "BuyerMapViewController.h"
#import "AppCommunication.h"
@interface BuyerMapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation BuyerMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppCommunication sharedManager].buyerMapViewController = self;
    [_mapView setDelegate:self];
    _mapView.showsUserLocation = YES;
    
    [self didUpdateUserLocation:[AppCommunication sharedManager].currentLatitude.doubleValue andWithLongitude:[AppCommunication sharedManager].currentLongitude.doubleValue];
}
-(void)updateMapWithLatitude:(double)lati andWithLongitude:(double)longi
{
    [self didUpdateUserLocation:lati andWithLongitude:longi];
}
-(void)didUpdateUserLocation:(double)lati andWithLongitude:(double)longi
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.005, 0.005);
    MKCoordinateRegion region = MKCoordinateRegionMake([AppCommunication sharedManager].myLocation.coordinate, span);
    
    [_mapView setRegion:region];
    
    [_mapView setCenterCoordinate:[AppCommunication sharedManager].myLocation.coordinate animated:YES];
    
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", [AppCommunication sharedManager].myLocation.coordinate.latitude,  [AppCommunication sharedManager].myLocation.coordinate.longitude,lati
                         ,longi];
    
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        NSArray *routes = [result objectForKey:@"routes"];
        if(routes.count>0)
        {
            
            NSDictionary *firstRoute = [routes objectAtIndex:0];
            
            NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
            
            NSDictionary *end_location = [leg objectForKey:@"end_location"];
            
            double latitude = [[end_location objectForKey:@"lat"] doubleValue];
            double longitude = [[end_location objectForKey:@"lng"] doubleValue];
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = coordinate;
            point.title =  [leg objectForKey:@"end_address"];
            point.subtitle = @"I'm here!!!";
            
            [self.mapView addAnnotation:point];
            
            NSArray *steps = [leg objectForKey:@"steps"];
            
            int stepIndex = 0;
            
            CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
            
            stepCoordinates[stepIndex] = [AppCommunication sharedManager].myLocation.coordinate;
            
            for (NSDictionary *step in steps) {
                
                NSDictionary *start_location = [step objectForKey:@"start_location"];
                stepCoordinates[++stepIndex] = [self coordinateWithLocation:start_location];
                
                if ([steps count] == stepIndex){
                    NSDictionary *end_location = [step objectForKey:@"end_location"];
                    stepCoordinates[++stepIndex] = [self coordinateWithLocation:end_location];
                }
            }
            if(_mapView.overlays.count>0)
            {
                [self.mapView removeOverlays:self.mapView.overlays];
            }
            MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:stepCoordinates count:1 + stepIndex];
            [_mapView addOverlay:polyLine];
            
            
            //        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(([AppCommunication sharedManager].myLocation.coordinate.latitude + coordinate.latitude)/2, ([AppCommunication sharedManager].myLocation.coordinate.longitude + coordinate.longitude)/2);
            double minLatitude,minLongitude,maxLatitude,maxLongitude = 0.0;
            
            if(latitude<[AppCommunication sharedManager].myLocation.coordinate.latitude)
            {
                minLatitude = latitude;
                maxLatitude = [AppCommunication sharedManager].myLocation.coordinate.latitude;
            }
            else
            {
                maxLatitude = latitude;
                minLatitude = [AppCommunication sharedManager].myLocation.coordinate.latitude;
            }
            
            if(longitude<[AppCommunication sharedManager].myLocation.coordinate.longitude)
            {
                minLongitude = longitude;
                maxLongitude = [AppCommunication sharedManager].myLocation.coordinate.longitude;
            }
            else
            {
                maxLongitude = longitude;
                minLongitude = [AppCommunication sharedManager].myLocation.coordinate.longitude;
            }
            
            MKCoordinateRegion region;
            region.center.latitude = (minLatitude + maxLatitude) / 2;
            region.center.longitude = (minLongitude + maxLongitude) / 2;
            
            region.span.latitudeDelta = (maxLatitude - minLatitude) * 2.1;
            
            region.span.latitudeDelta = (region.span.latitudeDelta < 0.01)
            ? 0.01
            : region.span.latitudeDelta;
            
            region.span.longitudeDelta = (maxLongitude - minLongitude) * 2.1;
            
            MKCoordinateRegion scaledRegion = [self.mapView regionThatFits:region];
            [self.mapView setRegion:scaledRegion animated:YES];

        }
    }];
}

- (CLLocationCoordinate2D)coordinateWithLocation:(NSDictionary*)location
{
    double latitude = [[location objectForKey:@"lat"] doubleValue];
    double longitude = [[location objectForKey:@"lng"] doubleValue];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:204/255. green:45/255. blue:70/255. alpha:1.0];
    polylineView.lineWidth = 10.0;
    
    return polylineView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
