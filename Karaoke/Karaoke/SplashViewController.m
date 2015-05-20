//
//  SplashViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 20/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import "AvailableSongsViewController.h"

@interface SplashViewController ()

@end


@implementation SplashViewController
@synthesize aSongsVc;
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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
}
- (void)presentnextView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults valueForKey:@"isLogedOut"]);
    if ([defaults valueForKey:@"isLogedOut"] == NULL ) {
        isLogedOut =[NSString stringWithFormat:@"YES"];
    }else{
    isLogedOut =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"isLogedOut"]];
    }
    if ([isLogedOut isEqualToString:@"YES"]) {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            aSongsVc=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            aSongsVc=[[loginViewController alloc]initWithNibName:@"loginViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else
        {
            aSongsVc=[[loginViewController alloc]initWithNibName:@"loginViewController_ipad" bundle:Nil];
        }
        [self.navigationController pushViewController:aSongsVc animated:NO];
    }else{
        AvailableSongsViewController *availableSongsVC;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            availableSongsVC=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            availableSongsVC=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else
        {
            availableSongsVC=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_ipad" bundle:Nil];
        }
        [self.navigationController pushViewController:availableSongsVC animated:NO];
        
    }
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ||[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationPortrait;
}
@end
