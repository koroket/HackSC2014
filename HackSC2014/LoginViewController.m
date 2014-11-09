//
//  LoginViewController.m
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "LoginViewController.h"
#import <Sinch/Sinch.h>
#import "AppCommunication.h"
#import <CoreLocation/CoreLocation.h>
@interface LoginViewController ()
- (IBAction)isBuyer:(id)sender;
- (IBAction)isSeller:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *bizNameTextField;
@property (nonatomic,strong) id<SINClient> sinchClient;
@property (nonatomic,strong) id<SINMessageClient> messageClient;
@end

@implementation LoginViewController
{
    bool gettingSellerAccount;
    bool gotLocations;
    bool gotFacebook;
}
-(void)clientDidFail:(id<SINClient>)client error:(NSError *)error
{
    NSLog(@"fail");
}
-(void)clientDidStart:(id<SINClient>)client
{
    NSLog(@"start");
}
-(void)createClient
{
    // Instantiate a Sinch client object
    self.sinchClient = [Sinch clientWithApplicationKey:@"a35750b5-c354-4264-b504-e3212d46d11f"
                                     applicationSecret:@"d1Zj1Sz7W0ic2zU3iZOTgg=="
                                       environmentHost:@"sandbox.sinch.com"
                                                userId:[AppCommunication sharedManager].myFBID];
    self.sinchClient.delegate = self;
    [self.sinchClient setSupportMessaging:YES];
    
    
    // Start the Sinch Client
    [self.sinchClient start];
    // Start listening for incoming events (calls and messages).
    [self.sinchClient startListeningOnActiveConnection];
    
    [self.sinchClient setSupportMessaging: YES];
    
    self.messageClient = [self.sinchClient messageClient];
    self.messageClient.delegate = self;
    
    
    
    
    
    
}
- (void) messageDeliveryFailed:(id<SINMessage>) message info:(NSArray *)messageFailureInfo {
    for (id<SINMessageFailureInfo> reason in messageFailureInfo) {
        NSLog(@"Delivering message with id %@ failed to user %@. Reason %@",
              reason.messageId, reason.recipientId, [reason.error localizedDescription]);
    }
}
-(void)sendSinchTo:(NSString*) theirId fromID:(NSString*)myid withLatitude:(double)lati withLongitude:(double)longi
{
    NSString* sendingString = [NSString stringWithFormat:@"%@/%f/%f",myid,lati,longi];
    SINOutgoingMessage *message = [SINOutgoingMessage messageWithRecipient:theirId text:sendingString];
    [self.messageClient sendMessage:message];
}
-(void)messageDelivered:(id<SINMessageDeliveryInfo>)info
{
    NSLog(@"Message Delivered");
}
-(void)messageFailed:(id<SINMessage>)message info:(id<SINMessageFailureInfo>)messageFailureInfo
{
    NSLog(@"Message Failed");
}
-(void)messageClient:(id<SINMessageClient>)messageClient didReceiveIncomingMessage:(id<SINMessage>)message
{
    [self breakSinch:message.text];
}
-(void)messageSent:(id<SINMessage>)message recipientId:(NSString *)recipientId
{
    NSLog(@"Message Sent");
}
-(void)breakSinch:(NSString*)yourString
{
    NSArray* temparray = [yourString componentsSeparatedByString:@"/"];
    if([AppCommunication sharedManager].buyerMapViewController!=nil)
    {
        if([(NSString*)temparray[0] isEqualToString:[AppCommunication sharedManager].currentMapSellerFBID])
        {
            [[AppCommunication sharedManager].buyerMapViewController updateMapWithLatitude:((NSString*)temparray[1]).doubleValue andWithLongitude:((NSString*)temparray[2]).doubleValue];
        }
    }
}
- (void)startStandardUpdates
{
    
    // Create the location manager if this object does not
    // already have one.
    if (nil == [AppCommunication sharedManager].locationManager)
    {
        [AppCommunication sharedManager].locationManager = [[CLLocationManager alloc] init];
        [[AppCommunication sharedManager].locationManager requestAlwaysAuthorization];
    }

    
    [AppCommunication sharedManager].locationManager.delegate = self;
    [AppCommunication sharedManager].locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    // Set a movement threshold for new events.
    [AppCommunication sharedManager].locationManager.distanceFilter = 500; // meters
    
    [[AppCommunication sharedManager].locationManager startUpdatingLocation];
}


- (void) locationManager:(CLLocationManager *)manager
        didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location!:(");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    

            NSString *latitude, *longitude;
            
            latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    [AppCommunication sharedManager].myLocation = newLocation;
    [[AppCommunication sharedManager] strLocationMakerWithLat:newLocation.coordinate.latitude withLongi:newLocation.coordinate.longitude];
    
    if([AppCommunication sharedManager].didGetPastInitialViewController)
    {
        if([[AppCommunication sharedManager].typeOfPerson isEqualToString:@"buyer"])
        {
            if([AppCommunication sharedManager].buyerMySellers!=nil)
            {
                for(int i = 0; i < [AppCommunication sharedManager].buyerMySellers.count;i++)
                {
                    NSDictionary* temp = [AppCommunication sharedManager].buyerMySellers[i];
                    [self sendSinchTo:temp[@"fbid"] fromID:[AppCommunication sharedManager].myFBID withLatitude:[AppCommunication sharedManager].myLocation.coordinate.latitude withLongitude:[AppCommunication sharedManager].myLocation.coordinate.longitude];
                }
            }
        }
        else
        {
        
        }
    }
    if(!gotLocations)
    {
        gotLocations=true;
        if([AppCommunication sharedManager].myFBID!=nil)
        {
            [self getSellerAccount];
            [self createClient];
        }
    }
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self startStandardUpdates];
    
    
}
-(void)createFBLoginl
{
    //For Some Reason App crashes without this
    FBLoginView *loginView = [[FBLoginView alloc] init];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{

    
    //call the singleton for string data
    [AppCommunication sharedManager].myFBID = user.objectID;
    [AppCommunication sharedManager].myFBName = user.name;
    if(!gotFacebook)
    {
        gotFacebook=true;
        if([AppCommunication sharedManager].myLocation!=nil)
        {
            [self getSellerAccount];
            [self createClient];
        }
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{

    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{

}

/**
 *  Handle possible errors that can occur during login
 *
 *  @param loginView
 *  @param error
 */
- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    /* If the user should perform an action outside of you app to recover,
     * the SDK will provide a message for the user, you just need to surface it.
     * This conveniently handles cases like Facebook password change or unverified
     * Facebook accounts.
     */
    
    if ([FBErrorUtility shouldNotifyUserForError:error])
    {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        /* This code will handle session closures that happen outside of the app
         * You can take a look at our error handling guide to know more about it
         * https://developers.facebook.com/docs/ios/errors
         */
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
    {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        /* If the user has cancelled a login, we will do nothing.
         * You can also choose to show the user a message if cancelling login will
         * result in
         * the user not being able to complete a task they had initiated in your app
         * (like accessing FB-stored information or posting to Facebook)
         */
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
    {
        NSLog(@"user cancelled login");
        
        /* For simplicity, this sample handles other errors with a generic message
         * You can checkout our error handling guide for more detailed information
         * https://developers.facebook.com/docs/ios/errors
         */
    }
    else
    {
        alertTitle = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)createSellerAccount
{
    if(![self.bizNameTextField.text isEqualToString:@""])
    {
        
        [self serverCreateSellerAccount];
    }
    
}
-(void)getSellerAccount
{
    if(!gettingSellerAccount)
    {
        gettingSellerAccount = true;
        NSString *fixedUrl = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/seller/get/%@",
                              [AppCommunication sharedManager].myFBID];
        NSURL *url = [NSURL URLWithString:fixedUrl];
        // Request
        NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        // Request type
        [request setHTTPMethod:@"GET"];
        // Session
        NSURLSession *urlSession = [NSURLSession sharedSession];
        // Data Task Block
        NSURLSessionDataTask *dataTask =
        [urlSession dataTaskWithRequest:request
                      completionHandler:^(NSData *data,
                                          NSURLResponse *response,
                                          NSError *error)
         {
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSInteger responseStatusCode = [httpResponse statusCode];
             
             if (responseStatusCode == 200 && data)
             {
                 NSArray *fetchedData = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:nil];
                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                {
                                    
                                    if(fetchedData.count==0)
                                    {
                                        NSLog(@"No results");
                                    }
                                    else
                                    {
                                        NSLog(@"%@",fetchedData);
                                    }
                                    
                                }); // Main Queue dispatch block
                 
                 // do something with this data
                 // if you want to update UI, do it on main queue
             }
             else
             {
                 NSLog(@"connection error");
             }
         }]; // Data Task Block
        [dataTask resume];
    }
    
    
}
-(void)serverCreateSellerAccount
{

        NSString *fixedUrl = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/seller/create/%@/%@/%f/%f",
                              [AppCommunication sharedManager].myFBID,
                              [self stringFix:self.bizNameTextField.text],
                              [AppCommunication sharedManager].myLocation.coordinate.latitude,
                              [AppCommunication sharedManager].myLocation.coordinate.longitude];
        NSURL *url = [NSURL URLWithString:fixedUrl];
        // Request
        NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        // Request type
        [request setHTTPMethod:@"GET"];
        // Session
        NSURLSession *urlSession = [NSURLSession sharedSession];
        // Data Task Block
        NSURLSessionDataTask *dataTask =
        [urlSession dataTaskWithRequest:request
                      completionHandler:^(NSData *data,
                                          NSURLResponse *response,
                                          NSError *error)
         {
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSInteger responseStatusCode = [httpResponse statusCode];
             
             if (responseStatusCode == 200 && data)
             {
                 NSArray *fetchedData = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:nil];
                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                {

                                    NSLog(@"%@",fetchedData);
                                        [self performSegueWithIdentifier:@"seller" sender:self];
                                }); // Main Queue dispatch block
                 
                 // do something with this data
                 // if you want to update UI, do it on main queue
             }
             else
             {
                 // error handling
             }
         }]; // Data Task Block
        [dataTask resume];
        
    
}
- (IBAction)isBuyer:(id)sender {
    [self performSegueWithIdentifier:@"buyer" sender:self];
}

- (IBAction)isSeller:(id)sender {
    [self createSellerAccount];

}
-(NSString*)stringFix:(NSString*) str
{
    NSString* temp = [str stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return temp;
}
@end
