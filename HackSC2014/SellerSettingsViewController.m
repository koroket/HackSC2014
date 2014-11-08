//
//  SellerSettingsViewController.m
//  HackSC2014
//
//  Created by sloot on 11/8/14.
//  Copyright (c) 2014 sloot. All rights reserved.
//

#import "SellerSettingsViewController.h"

@interface SellerSettingsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *liveUILabel;
- (IBAction)switchLiveNonLive:(id)sender;
- (IBAction)clickedOnItems:(id)sender;

@end

@implementation SellerSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self performSegueWithIdentifier:@"items" sender:self];
}
@end
