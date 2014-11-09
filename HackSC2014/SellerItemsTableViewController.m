//
//  SellerItemsTableViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "SellerItemsTableViewController.h"
#import "AppCommunication.h"
#import "MBProgressHUD.h"
//#import "SellerItem.h"
@interface SellerItemsTableViewController ()
@property (nonatomic, strong) NSMutableArray* trying;
- (IBAction)uploadItemSet:(id)sender;
- (IBAction)addCategory:(id)sender;
@end


@implementation SellerItemsTableViewController
{
    bool clickedUpdate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.trying = [AppCommunication sharedManager].sellerMyItems;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.

    return [AppCommunication sharedManager].sellerMyItems.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [cell.textLabel removeFromSuperview];
    
    UITextField *nameLabel = (UITextField *)[cell viewWithTag:1];
    nameLabel.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    nameLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"name"];
    [nameLabel addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingChanged];
    
    
    UITextField *priceLabel = (UITextField *)[cell viewWithTag:2];
    [priceLabel addTarget:self action:@selector(priceFieldDone:) forControlEvents:UIControlEventEditingChanged];
    
    priceLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIButton *cellButton = (UIButton *)[cell viewWithTag:3];
    cellButton.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    if([((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"itemType"] isEqualToString:@"Category"])
    {
        priceLabel.alpha = 0.0;
        priceLabel.userInteractionEnabled = false;
        [cellButton setTitle:@"Add" forState:UIControlStateNormal];
        [cellButton addTarget:self
                       action:@selector(cellButton:)
           forControlEvents:UIControlEventTouchUpInside];
        nameLabel.placeholder = @"Category Name";
    }
    else
    {
        priceLabel.alpha = 1.0;
        priceLabel.userInteractionEnabled = true;
        priceLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"price"];
        [cellButton setTitle:@"Up" forState:UIControlStateNormal];
        [cellButton addTarget:self
                       action:@selector(cellButton:)
             forControlEvents:UIControlEventTouchUpInside];
        nameLabel.placeholder = @"Item Name";
        priceLabel.placeholder = @"Price";
    }

    
    return cell;
}
-(void)cellButton:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    if([senderButton.titleLabel.text isEqualToString:@"Add"])
    {
        UITableViewCell* cell = (UITableViewCell*)senderButton.superview.superview;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        
        NSMutableDictionary* newItem = [NSMutableDictionary dictionary];
        newItem[@"itemType"] = @"Item";
        newItem[@"name"] = @"";
        newItem[@"price"] = @"";
        [[AppCommunication sharedManager].sellerMyItems insertObject:newItem atIndex:indexPath.row+1];
        [self.tableView reloadData];
    }
    else if([senderButton.titleLabel.text isEqualToString:@"Up"])
    {
        UIButton *senderButton = (UIButton *)sender;
        
        UITableViewCell* cell = (UITableViewCell*)senderButton.superview.superview;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        
        if([((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row-1])[@"itemType"] isEqualToString:@"Item"])
        {
            
            [[AppCommunication sharedManager].sellerMyItems exchangeObjectAtIndex:indexPath.row-1 withObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }

}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[AppCommunication sharedManager].sellerMyItems removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)textFieldDone:(id)sender {
    UITextField *field = sender;

    UITableViewCell* cell = (UITableViewCell*)field.superview.superview;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    
    if (field != nil) {

           ((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"name"]  = field.text;

    }
}
- (void)priceFieldDone:(id)sender {
    UITextField *field = sender;
    
    UITableViewCell* cell = (UITableViewCell*)field.superview.superview;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    
    if (field != nil) {
        
        ((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"price"]  = field.text;
        
    }
}
- (IBAction)uploadItemSet:(id)sender {
    if(!clickedUpdate)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Updating Server";
        [self updateItemSet];
    }
}

- (IBAction)addCategory:(id)sender {
    NSMutableDictionary* newItem = [NSMutableDictionary dictionary];
    newItem[@"itemType"] = @"Category";
    newItem[@"name"] = @"";
    [self.trying addObject:newItem];
        NSLog(@"%d",self.trying.count);

    [AppCommunication sharedManager].sellerMyItems = self.trying;
    [self.tableView reloadData];
    NSLog(@"%d",self.trying.count);
    
}

- (void)updateItemSet
{
    //URL
    NSString *fixedURL = [NSString stringWithFormat:@"https://powerful-waters-4317.herokuapp.com/seller/itemSet/%@",
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
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[AppCommunication sharedManager].sellerMyItems forKey:@"itemSet"];
    
    //Error Handling
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
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
             dispatch_async(dispatch_get_main_queue(), ^(void)
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                clickedUpdate = false;
                            });

             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSInteger responseStatusCode = [httpResponse statusCode];
             if (responseStatusCode == 200 && data)
             {
                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                {
                                    [self performSegueWithIdentifier:@"unwind" sender:self];
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
