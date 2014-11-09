//
//  BuyerSettingViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "BuyerSettingViewController.h"
#import "AppCommunication.h"
@interface BuyerSettingViewController ()
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)search:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *bizName;
@property (strong, nonatomic) NSDictionary *searchedDictionary;
- (IBAction)addSeller:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Follow;

@end

@implementation BuyerSettingViewController
{
    bool gettingSellerAccount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
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

- (IBAction)search:(id)sender {
    [self getSeller];
}
- (IBAction)addSeller:(id)sender {
    [self addFollowing];
}
-(void)getSeller
{
    if(!gettingSellerAccount)
    {
        gettingSellerAccount = true;
        NSString *fixedUrl = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/buyer/get/%@",
                              [self stringFix:self.searchTextField.text]];
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
             gettingSellerAccount = false;
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
                                        NSDictionary* tempdict = fetchedData[0];
                                        NSLog(@"%@",tempdict[@"bizName"]);
                                        self.bizName.text = tempdict[@"bizName"];
                                        self.searchedDictionary = fetchedData[0];
                                        self.Follow.alpha = 1.0;
                                        self.Follow.userInteractionEnabled = YES;
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
    
    
}

- (void)addFollowing
{
    //URL
    NSString *fixedURL = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/buyer/following/%@",
                          [AppCommunication sharedManager].myFBID
                          ];
    NSURL *url = [NSURL URLWithString:fixedURL];
    
    //Session
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPMethod = @"POST";
    
    

    
    //Error Handling
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.searchedDictionary
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
                                    
                                    NSArray *fetchedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                           options:0
                                                                                             error:nil];
                                    dispatch_async(dispatch_get_main_queue(), ^(void)
                                                   {
                                
                                                    [[AppCommunication sharedManager].buyerMySellers addObject:self.searchedDictionary];
                                                   });
                                                   
                                });//Dispatch main queue block
             }//if
             else
             {

             }
         }];//upload task Block
        [uploadTask resume];
    }
    else
    {
        NSLog(@"Cannot connect to server");
    }
}


-(NSString*)stringFix:(NSString*) str
{
    NSString* temp = [str stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return temp;
}
@end
