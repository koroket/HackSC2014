//
//  LoginViewController.m
//  HackSC2014
//
//  Created by sloot on 11/7/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "LoginViewController.h"

#import "AppCommunication.h"

@interface LoginViewController ()
- (IBAction)isBuyer:(id)sender;
- (IBAction)isSeller:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)createFBLoginl
{
    //For Some Reason App crashes without this
    FBLoginView *loginView = [[FBLoginView alloc] init];
}
-(void)getFBInfo
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            [AppCommunication sharedManager].myFBID = [result objectForKey:@"id"];
            [AppCommunication sharedManager].myFBName = [result objectForKey:@"first_name"];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];

}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{

//    self.nameLabel.text = user.name;
//    
//    //call the singleton for string data
//    [NetworkCommunication sharedManager].stringFBUserId = user.objectID;
//    [NetworkCommunication sharedManager].stringFBUserName = user.name;
    
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

- (IBAction)isBuyer:(id)sender {
    [self performSegueWithIdentifier:@"buyer" sender:self];
}

- (IBAction)isSeller:(id)sender {
    [self performSegueWithIdentifier:@"seller" sender:self];
}
@end
