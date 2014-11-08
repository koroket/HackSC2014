//
//  BuyerItemsTableViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "BuyerItemsTableViewController.h"
#import "AppCommunication.h"
@interface BuyerItemsTableViewController ()

@end

@implementation BuyerItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    [cell.textLabel removeFromSuperview];
    
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];
    nameLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].buyerMyItems[indexPath.row])[@"name"];
    
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:2];
    priceLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].buyerMyItems[indexPath.row])[@"price"];
    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [AppCommunication sharedManager].buyerMyItems.count;
}



@end
