//
//  instructionDetailViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac_3 on 09/01/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "setting_shedViewController.h"
#import "aboutUsViewController.h"

@interface aboutUsViewController ()

@end

@implementation aboutUsViewController
@synthesize aboutUsDetailLabl, aboutUsTxtView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [aboutUsDetailLabl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];

    }
    else{
        [aboutUsDetailLabl setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
    }
   // aboutUsTxtView.font =[UIFont fontWithName:@"Lucida Sans" size:18];
   // aboutUsTxtView.textAlignment = UITextAlignmentLeft;
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BckToList:(id)sender {
    setting_shedViewController *settingvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController" bundle:nil];        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController_iphone4" bundle:nil];        // this is iphone 4 xib
    }
    else {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController_ipad" bundle:nil];        // this is iphone 4 xib
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    
    [self.navigationController pushViewController:settingvc animated:NO];
}

- (IBAction)PostToFacebook:(id)sender {
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.facebookConnect=YES;
    [appDelegate facebookIntegration];
}
@end
