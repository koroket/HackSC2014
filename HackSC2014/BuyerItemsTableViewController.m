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
- (IBAction)mapPressed:(id)sender;

@end

@implementation BuyerItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    
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
    cell.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    [cell.textLabel removeFromSuperview];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:2];
    priceLabel.backgroundColor=  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    priceLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].buyerMyItems[indexPath.row])[@"price"];
    
    
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:1];
    nameLabel.backgroundColor =  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    if(priceLabel.text.length==0)
    {
        nameLabel.text = ((NSMutableDictionary*)[AppCommunication sharedManager].buyerMyItems[indexPath.row])[@"name"];
        nameLabel.alpha = 1.0;
        priceLabel.alpha = 1.0;

    }
    else
    {
                    nameLabel.text = [NSString stringWithFormat:@"    %@",((NSMutableDictionary*)[AppCommunication sharedManager].buyerMyItems[indexPath.row])[@"name"]];
        nameLabel.alpha = 0.5;
        priceLabel.alpha = 0.5;
    }

    
    

    
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [AppCommunication sharedManager].buyerMyItems.count;
}



- (IBAction)mapPressed:(id)sender {
    [self performSegueWithIdentifier:@"map" sender:self];
}
@end
