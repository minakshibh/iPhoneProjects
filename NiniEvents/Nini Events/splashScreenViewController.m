//
//  splashScreenViewController.m
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/8/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import "splashScreenViewController.h"
#import "loginViewController.h"
#import "homeViewController.h"
#import "serviceProviderHomeViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "appHomeViewController.h"
#import "eventImagesSlideViewViewController.h"
@interface splashScreenViewController ()

@end

@implementation splashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *urlString = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"output_U78sIP" ofType:@"mp4"]];
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:urlString];
    [_moviePlayer.view setFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-20,self.view.frame.size.width,self.view.frame.size.height+40)];
    _moviePlayer.fullscreen = YES;
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    [self.view addSubview:_moviePlayer.view];
    
    [_moviePlayer setFullscreen:YES animated:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(presentnextView) userInfo:nil repeats:NO];
}
- (void)presentnextView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults valueForKey:@"isLogedOut"]);
    NSString *isLogedOut;
    if ([defaults valueForKey:@"isLogedOut"] == NULL ) {
        isLogedOut =[NSString stringWithFormat:@"YES"];
    }else{
        isLogedOut =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"isLogedOut"]];
    }
    NSLog(@"ROLE... %@",[defaults valueForKey:@"Role"]);
    if ([isLogedOut isEqualToString:@"YES"]) {
        loginViewController *loginVC = [[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        if ([[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Role"]] isEqualToString:@"ServiceProvider"]) {
            serviceProviderHomeViewController *serviceProviderHomeVC= [[serviceProviderHomeViewController alloc]initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
            [self.navigationController pushViewController:serviceProviderHomeVC animated:YES];
        }else{
        eventImagesSlideViewViewController *apphomeVC = [[eventImagesSlideViewViewController alloc]initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
        [self.navigationController pushViewController:apphomeVC animated:YES];
        }
    }
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

@end
