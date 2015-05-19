//
//  splashscreenViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/17/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import "splashscreenViewController.h"
#import "motivational_screenViewController.h"
#import "homescreenViewController.h"
#import "WelcomeViewController.h"

@interface splashscreenViewController ()

@end
@class AppDelegate;

@implementation splashscreenViewController
@synthesize title,titlelbl,mainImageView;
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
    
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    appDelegate.navigator.navigationBarHidden = YES;
//    [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
//    
//    NSArray *animationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],nil];
//    
//    UIImageView *mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170, 320, 260)];
//    
//    //[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(crossfade) userInfo:nil repeats:YES];
//        mainImageView.animationImages = animationArray;
//    
//    
//    mainImageView.animationDuration = 1.5f; //mainImageView is instance of UIImageView
//    mainImageView.animationRepeatCount = 0;
//    
//    
//    [mainImageView startAnimating];
//    [self.view addSubview:mainImageView];
//    
//    //    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
//    //    crossFade.autoreverses = YES;
//    //    crossFade.repeatCount = 0;
//    //    crossFade.duration = 0.1;
//    
//    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
//
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    
    NSArray *animationArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"1.png"],nil];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];

        mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170, 320, 260)];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];

        mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130, 320, 260)];
        // this is iphone 4 xib
    }
    else {
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:85]];

        mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 310,638, 558)];
        // this is ipad xib

    }
    
    
    //[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(crossfade) userInfo:nil repeats:YES];
    
    mainImageView.animationImages = animationArray;
    
    
    mainImageView.animationDuration = 1.8f; //mainImageView is instance of UIImageView
    mainImageView.animationRepeatCount = 0;
    [mainImageView startAnimating];
    [self.view addSubview:mainImageView];
    
    //    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    //    crossFade.autoreverses = YES;
    //    crossFade.repeatCount = 0;
    //    crossFade.duration = 0.1;
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)presentnextView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSUserDefaults * value = [NSUserDefaults standardUserDefaults];
    NSString *myString = [value objectForKey:@"preferedDate"];
    
    if(myString==nil)
        myString=@"";
    
    if ([myString isEqualToString:appDelegate.todaysDate]) {
        SHED_listViewController *home;
   
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                home = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                home = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }
            else{
                 home = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:nil];
                // this is ipad xib
            }
        
        home.flag = 0;
        home.sortingString=[NSString stringWithFormat:@"Cronological"];
        [self.navigationController pushViewController:home animated:YES];
        
    }
    else{
        [value setObject:appDelegate.todaysDate forKey:@"preferedDate"];
         motivational_screenViewController *motivationView;
        
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                motivationView=[[motivational_screenViewController alloc] initWithNibName:@"motivational_screenViewController" bundle:nil];
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                motivationView=[[motivational_screenViewController alloc] initWithNibName:@"motivational_screenViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }
            else{
                 motivationView=[[motivational_screenViewController alloc] initWithNibName:@"motivational_screenViewController_ipad" bundle:nil];
                // this is ipad xib
            }
        [self.navigationController pushViewController:motivationView animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
