//
//  BuyerFindSellerViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "BuyerFindSellerViewController.h"
#import "AppCommunication.h"
@interface BuyerFindSellerViewController ()
- (IBAction)foodSwitch:(id)sender;
- (IBAction)sweetswitch:(id)sender;
- (IBAction)collectibleswitch:(id)sender;
- (IBAction)garageSaleSwitch:(id)sender;
- (IBAction)clothingSwitch:(id)sender;
- (IBAction)distanceSlider:(id)sender;
- (IBAction)updateList:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UISlider *distanceSliderMine;

@end

@implementation BuyerFindSellerViewController
{
    NSMutableDictionary* tags;
    bool updating;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.distanceSliderMine.minimumValue = 1.0;
    self.distanceSliderMine.maximumValue = 20.0;
    tags = [NSMutableDictionary dictionary];
    //self.view.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

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

- (IBAction)foodSwitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        tags[@"food"] = @(true);
    } else{
        NSLog(@"Switch is OFF");
        tags[@"food"] = @(false);
    }
}

- (IBAction)sweetswitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        tags[@"sweets"] = @(true);
    } else{
        NSLog(@"Switch is OFF");
        tags[@"sweets"] = @(false);
    }
}

- (IBAction)collectibleswitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        tags[@"collectibles"] = @(true);
    } else{
        NSLog(@"Switch is OFF");
        tags[@"collectibles"] = @(false);
    }
}

- (IBAction)garageSaleSwitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        tags[@"garage"] = @(true);
    } else{
        NSLog(@"Switch is OFF");
        tags[@"garage"] = @(false);
    }
}

- (IBAction)clothingSwitch:(id)sender {
    if([sender isOn]){
        NSLog(@"Switch is ON");
        tags[@"clothing"] = @(true);
    } else{
        NSLog(@"Switch is OFF");
        tags[@"clothing"] = @(false);
    }
}

- (IBAction)distanceSlider:(id)sender {
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f", self.distanceSliderMine.value];
}

- (IBAction)updateList:(id)sender {
    if(!updating)
    {
        updating = true;
        [self updateServerWithList];
    }
}
-(void)getServer
{
    //URL
    NSString *fixedURL = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/buyer/search/%@",
                          [AppCommunication sharedManager].myFBID
                          ];
        NSURL *url = [NSURL URLWithString:fixedURL];
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

                                }
                                
                                
                            }); // Main Queue dispatch block
             
             // do something with this data
             // if you want to update UI, do it on main queue
         }
         else
         {
             NSLog(@"no internet connection");
         }
     }]; // Data Task Block
    [dataTask resume];
}
-(void)updateServerWithList
{
    //URL
    NSString *fixedURL = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/buyer/search/%@",
                          [AppCommunication sharedManager].myFBID
                          ];
    NSURL *url = [NSURL URLWithString:fixedURL];
    
    //Session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"PUT";
    
    
    tags[@"limit"] = [NSString stringWithFormat:@"%.2f", self.distanceSliderMine.value];
    
    //Error Handling
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:tags
                                                   options:kNilOptions
                                                     error:&error];
    if (!error)
    {
        //Upload
        NSURLSessionUploadTask *uploadTask =
        [session uploadTaskWithRequest:request
                              fromData:data
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
                                    updating = false;
                                });//Dispatch main queue block
             }//if
             else
             {
                 NSLog(@"Sending to individuals failed");
             }
         }];//upload task Block
        [uploadTask resume];
        NSLog(@"Connected to server");
    }
    else
    {
        NSLog(@"Cannot connect to server");
    }

}
@end
