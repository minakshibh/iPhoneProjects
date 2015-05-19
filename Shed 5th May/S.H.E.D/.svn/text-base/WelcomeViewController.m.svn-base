//
//  WelcomeViewController.m
//  SHED's
//
//  Created by Krishna_Mac_2 on 03/02/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "WelcomeViewController.h"
#import "homescreenViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController
@synthesize headerLabel, txtWelcome;

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
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
        [headerLabel setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        txtWelcome.font = [UIFont fontWithName:@"Lucida Sans" size:17];

    }
    else{
        [headerLabel setFont: [UIFont fontWithName:@"Helvetica Neue" size:80]];
        txtWelcome.font = [UIFont fontWithName:@"Lucida Sans" size:35];

    }
    
    //[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
    
    //[motivationView setFont: [UIFont fontWithName:@"NoticiaText-Bold" size:40]];
    
    NSUserDefaults *value = [NSUserDefaults standardUserDefaults];
    [value setObject:@"used" forKey:@"usage"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotIt:(id)sender {
    
    homescreenViewController *home;
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else{
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_ipad" bundle:nil];
            // this is ipad xib
        }
    [self.navigationController pushViewController:home animated:NO];
}
@end
