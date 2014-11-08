//
//  LoginViewController.m
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "LoginViewController.h"

#import "AppCommunication.h"
#import <CoreLocation/CoreLocation.h>
@interface LoginViewController ()
- (IBAction)isBuyer:(id)sender;
- (IBAction)isSeller:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *bizNameTextField;

@end

@implementation LoginViewController

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
    [AppCommunication sharedManager].locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
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
    

            NSString *latitude, *longitude, *state, *country;
            
            latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    [[AppCommunication sharedManager] strLocationMakerWithLat:newLocation.coordinate.latitude withLongi:newLocation.coordinate.longitude];

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
        
    }
}
-(void)serverCreateSellerAccount
{

        NSString *fixedUrl = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/seller/create/%@/%@",
                              [AppCommunication sharedManager].myFBID,
                              [self stringFix:self.bizNameTextField.text]];
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
                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                {

                                    NSLog(@"Account Made Successfully");
                                    
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
    [self performSegueWithIdentifier:@"seller" sender:self];
}
-(NSString*)stringFix:(NSString*) str
{
    NSString* temp = [str stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return temp;
}
@end
