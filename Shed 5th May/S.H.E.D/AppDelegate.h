//
//  AppDelegate.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/20/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "splashscreenViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FMDatabase.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    FBSession *session;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) splashscreenViewController *splash;
@property (strong, nonatomic) UINavigationController *navigator;
@property (strong, nonatomic) FMDatabase *database;
@property(strong,nonatomic) FBSession *session;
@property (strong, nonatomic) NSString *todaysDate;
@property ( assign) int flag;
@property (nonatomic, assign) BOOL facebookConnect;

-(void)facebookIntegration;
@end
