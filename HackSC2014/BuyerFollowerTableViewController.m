//
//  BuyerFollowerTableViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "BuyerFollowerTableViewController.h"
#import "AppCommunication.h"
@interface BuyerFollowerTableViewController ()

@end

@implementation BuyerFollowerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppCommunication sharedManager].typeOfPerson = @"buyer";
    [AppCommunication sharedManager].didGetPastInitialViewController = true;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    [AppCommunication sharedManager].buyerMySellers = [NSMutableArray array];
    [self getMySellers];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellerListCell" forIndexPath:indexPath];
    cell.textLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].buyerMySellers[indexPath.row])[@"bizName"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [AppCommunication sharedManager].buyerMySellers.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self getMySellersList:indexPath.row];
}
-(void)getMySellers
{
    
    NSString *fixedUrl = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/buyer/mySellers/%@",
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
                                
                                NSLog(@"%@",fetchedData);
                                [AppCommunication sharedManager].buyerMySellers = [fetchedData mutableCopy];
                                NSLog(@"%@",[AppCommunication sharedManager].buyerMySellers);
                                [self.tableView reloadData];
                                
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
-(void)getMySellersList:(int)index
{
    NSString *fixedUrl = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/buyer/itemSet/%@",
                          ((NSDictionary*)[AppCommunication sharedManager].buyerMySellers[index])[@"fbid"]];
    [AppCommunication sharedManager].currentMapSellerFBID = ((NSDictionary*)[AppCommunication sharedManager].buyerMySellers[index])[@"fbid"];
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
                                
                                NSLog(@"%@",(NSDictionary*)[AppCommunication sharedManager].buyerMySellers[index]);
                                [AppCommunication sharedManager].currentLatitude=((NSDictionary*)[AppCommunication sharedManager].buyerMySellers[index])[@"latitude"];
                                [AppCommunication sharedManager].currentLongitude=((NSDictionary*)[AppCommunication sharedManager].buyerMySellers[index])[@"longitude"];
                                [AppCommunication sharedManager].buyerMyItems = [fetchedData[@"itemSet"] mutableCopy];
                                [self performSegueWithIdentifier:@"item" sender:self];
                                
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
