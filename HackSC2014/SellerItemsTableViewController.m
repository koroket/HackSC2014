//
//  SellerItemsTableViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "SellerItemsTableViewController.h"
#import "AppCommunication.h"
//#import "SellerItem.h"
@interface SellerItemsTableViewController ()
- (IBAction)uploadItemSet:(id)sender;
- (IBAction)addCategory:(id)sender;
@end

@implementation SellerItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppCommunication sharedManager].sellerMyItems = [NSMutableArray array];
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
    
    [cell.textLabel removeFromSuperview];
    
    UITextField *nameLabel = (UITextField *)[cell viewWithTag:1];
    nameLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"name"];
    [nameLabel addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingChanged];
    
    
    UITextField *priceLabel = (UITextField *)[cell viewWithTag:2];
    [priceLabel addTarget:self action:@selector(priceFieldDone:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIButton *cellButton = (UIButton *)[cell viewWithTag:3];
    
    if([((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"itemType"] isEqualToString:@"Category"])
    {
        priceLabel.alpha = 0.0;
        priceLabel.userInteractionEnabled = false;
        [cellButton setTitle:@"Add" forState:UIControlStateNormal];
        [cellButton addTarget:self
                     action:@selector(addItem)
           forControlEvents:UIControlEventTouchUpInside];
        nameLabel.placeholder = @"Category Name";
    }
    else
    {
        priceLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].sellerMyItems[indexPath.row])[@"price"];
        [cellButton setTitle:@"Up" forState:UIControlStateNormal];
        [cellButton addTarget:self
                       action:@selector(moveCellUp:)
             forControlEvents:UIControlEventTouchUpInside];
        nameLabel.placeholder = @"Item Name";
        priceLabel.placeholder = @"Price";
    }

    
    return cell;
}
-(void)addItem
{
    NSMutableDictionary* newItem = [NSMutableDictionary dictionary];
    newItem[@"itemType"] = @"Item";
    newItem[@"name"] = @"";
    newItem[@"price"] = @"";
    [[AppCommunication sharedManager].sellerMyItems addObject:newItem];
    [self.tableView reloadData];
}
-(void)moveCellUp:(id)sender
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSInteger responseStatusCode = [httpResponse statusCode];
             if (responseStatusCode == 200 && data)
             {
                 dispatch_async(dispatch_get_main_queue(), ^(void)
                                {

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
- (IBAction)uploadItemSet:(id)sender {
    [self updateItemSet];
}

- (IBAction)addCategory:(id)sender {
    NSMutableDictionary* newItem = [NSMutableDictionary dictionary];
    newItem[@"itemType"] = @"Category";
    newItem[@"name"] = @"";
    [[AppCommunication sharedManager].sellerMyItems addObject:newItem];
    [self.tableView reloadData];
}
@end
