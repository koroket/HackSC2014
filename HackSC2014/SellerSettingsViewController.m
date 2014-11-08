//
//  SellerSettingsViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "SellerSettingsViewController.h"
#import "AppCommunication.h"
@interface SellerSettingsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *liveUILabel;
- (IBAction)switchLiveNonLive:(id)sender;
- (IBAction)clickedOnItems:(id)sender;

@end

@implementation SellerSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppCommunication sharedManager].sellerMyItems = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchLiveNonLive:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        self.liveUILabel.text = @"Turn off business";
    } else{
        NSLog(@"Switch is OFF");
        self.liveUILabel.text = @"Turn on business";
    }
}

- (IBAction)clickedOnItems:(id)sender {
    [self getMyList];
}
-(void)getMyList
{
    NSString *fixedUrl = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/buyer/itemSet/%@",
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
             NSDictionary *fetchedData = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:0
                                                                           error:nil];
             dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                
                                NSLog(@"%@",fetchedData);
                                [AppCommunication sharedManager].sellerMyItems = [fetchedData[@"itemSet"] mutableCopy];
                                [self performSegueWithIdentifier:@"items" sender:self];
                                
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
@end
