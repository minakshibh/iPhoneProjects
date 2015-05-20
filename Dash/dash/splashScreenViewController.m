//
//  splashScreenViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/15/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "splashScreenViewController.h"
#import "AppDelegate.h"
#import "loginViewController.h"
#import "RegisterVerificationViewController.h"
#import "homeViewViewController.h"
#import "DetailerFirastViewController.h"

@interface splashScreenViewController ()

@end

@implementation splashScreenViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentnextView
{
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"view" ]isEqualToString:@"verifyView"])
    {
        RegisterVerificationViewController *registrVC = [[RegisterVerificationViewController alloc]initWithNibName:@"RegisterVerificationViewController" bundle:nil];
        [self.navigationController pushViewController:registrVC animated:YES];
    }
    else{
        NSString*userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
        if ([userId isKindOfClass:[NSNull class]])

        {
            userId=@"";
        }
        if( userId.length==0)
        {
            loginViewController *loginVC = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        else{
          
            
            NSString*role= [[NSUserDefaults standardUserDefaults] valueForKey:@"role"];
            
            
            if ([role isEqualToString:@"customer"])
            {
                homeViewViewController *homeVc = [[homeViewViewController alloc]initWithNibName:@"homeViewViewController" bundle:nil];
                [self.navigationController pushViewController:homeVc animated:YES];          }
            else{
                DetailerFirastViewController *homeVC = [[DetailerFirastViewController alloc] initWithNibName:@"DetailerFirastViewController" bundle:nil];
                [self.navigationController pushViewController:homeVC animated:NO];
            }
        }
    }
}
@end
