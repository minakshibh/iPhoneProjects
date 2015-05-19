//
//  setting_shedViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 1/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "setting_shedViewController.h"
#import "homescreenViewController.h"
#import "AppDelegate.h"
#import "aboutUsViewController.h"

@interface setting_shedViewController ()

@end

@implementation setting_shedViewController
@synthesize headertitle,aboutusbtn,passcodebtn,ratebtn;
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
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        [aboutusbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [passcodebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [ratebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
    }
    else{
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
        [aboutusbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        [passcodebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        [ratebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
    }
 
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)aboutusbtn:(id)sender {
    aboutUsViewController *aboutvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutvc = [[aboutUsViewController alloc] initWithNibName:@"aboutUsViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {

        aboutvc = [[aboutUsViewController alloc] initWithNibName:@"aboutUsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }else {
        aboutvc = [[aboutUsViewController alloc] initWithNibName:@"aboutUsViewController_ipad" bundle:nil];
        // this is ipad xib
    }

    
    [self.navigationController pushViewController:aboutvc animated:NO];
}

- (IBAction)moveback:(id)sender {
    homescreenViewController *homevc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {

        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    } else {
        
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_ipad" bundle:nil];
        // this is ipad xib
    }

    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    
    [self.navigationController pushViewController:homevc animated:NO];
}

- (IBAction)ratingbtn:(id)sender {
    if ([SKStoreProductViewController class]) {
        SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
        controller.delegate = self;
        [controller loadProductWithParameters:@{ SKStoreProductParameterITunesItemIdentifier : @"838069848" }completionBlock:^(BOOL result, NSError *error)
         {
             if (error)
             {
                 NSString *errorString=[NSString stringWithFormat:@"Error %@ with User Info %@",error,[error userInfo]];
                 NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                 
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"APP STORE" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
             }
             else
             {
                 [self presentViewController:controller animated:YES completion:nil];
             }
         }];
    }
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postToFacebook:(id)sender {
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.facebookConnect=YES;
    [appDelegate facebookIntegration];
}

@end
