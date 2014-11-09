//
//  ContactsTableViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "SellerContactsTableViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "AppCommunication.h"
@interface SellerContactsTableViewController ()
- (IBAction)sendTexts:(id)sender;
@property (nonatomic, strong) NSMutableArray* myFriendNumbers;
@property (nonatomic, strong) NSMutableArray* myFriendNames;
@property (nonatomic, strong) NSMutableArray* mySelectedFriendNumbers;
@end

@implementation SellerContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myFriendNumbers = [NSMutableArray array];
    self.myFriendNames = [NSMutableArray array];
    self.mySelectedFriendNumbers = [NSMutableArray array];
    [self askForContactsPermission];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.myFriendNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeopleCell" forIndexPath:indexPath];
    cell.textLabel.text = self.myFriendNames[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    return cell;
}


-(void)askForContactsPermission
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                CFErrorRef *error = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
                CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
                CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
                
                for(int i = 0; i < numberOfPeople; i++) {
                    
                    ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                    
                    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
                    NSString *fullName =[NSString stringWithFormat:@"%@%@",firstName,lastName];
                    NSLog(@"Name:%@ %@", firstName, lastName);
                    
                    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    
                    for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                        NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                        NSLog(@"phone:%@", phoneNumber);
                        NSString *fixedNumber = [self stringFixer:phoneNumber];
                        if(![self.myFriendNumbers containsObject:fixedNumber])
                        {
                            [self.myFriendNumbers addObject:fixedNumber];
                            [self.myFriendNames addObject:fullName];
                        }
                        
                    }
                    
                    NSLog(@"=============================================");
                 [self setUpTable];
                }
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
        
        for(int i = 0; i < numberOfPeople; i++) {
            
            ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
            
            NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            NSString *fullName =[NSString stringWithFormat:@"%@ %@",firstName,lastName];
            NSLog(@"Name:%@ %@", firstName, lastName);
            
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                NSLog(@"phone:%@", phoneNumber);
                NSString *fixedNumber = [self stringFixer:phoneNumber];
                if(![self.myFriendNumbers containsObject:fixedNumber])
                {
                    [self.myFriendNumbers addObject:fixedNumber];
                    [self.myFriendNames addObject:fullName];
                }
                
            }
            [self setUpTable];
            NSLog(@"=============================================");
            
        }
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}
-(void)setUpTable
{
    [self.tableView reloadData];
}
-(NSString*)stringFixer:(NSString*)str
{
    NSString* temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"(" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@")" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return temp;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark)
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.mySelectedFriendNumbers removeObject:[self.myFriendNumbers objectAtIndex:indexPath.row]];
    }
    else
    {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.mySelectedFriendNumbers addObject:[self.myFriendNumbers objectAtIndex:indexPath.row]];
    }
    
}

-(void)sendMessageToNumber:(NSString*)number
{
    NSString *kTwilioSID = @"ACe15755bd250a2d9dc60aeb0fb25926cb";
    NSString *kTwilioSecret = @"7d5da65398ddc2e7bbb16f5d7c3d7bdc";
    NSString *kFromNumber = @"+16503895648";
    NSString *kToNumber = [NSString stringWithFormat:@"+%@",number];
    NSString *kMessage = [NSString stringWithFormat:@"You sould download DeliBird from the AppStore. The app makes it so much easier for you to buy things from me. You can add me to know where I'm at any time I'm on duty. Just search for %@",[AppCommunication sharedManager].myBizName];
    
    // Build request
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", kTwilioSID, kTwilioSecret, kTwilioSID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    // Set up the body
    NSString *bodyString = [NSString stringWithFormat:@"From=%@&To=%@&Body=%@", kFromNumber, kToNumber, kMessage];
    NSData *data = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSError *error;
    NSURLResponse *response;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Handle the received data
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"Sent");
    }
    
}
- (IBAction)sendTexts:(id)sender {
    for(int i = 0;i<self.mySelectedFriendNumbers.count;i++)
    {
        [self sendMessageToNumber:self.mySelectedFriendNumbers[i]];
    }
}
@end
