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
#import <MessageUI/MessageUI.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,MFMailComposeViewControllerDelegate>
{
    FBSession *session;
    NSArray *docPaths,*fileName;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString *autoArchieve,*keepHistry,*autoArchieveDate,*emailid;
    UIActivityIndicatorView *activityIndicatorObject;
    UIView *view;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) splashscreenViewController *splash;
@property (strong, nonatomic) UINavigationController *navigator;
@property (strong, nonatomic) FMDatabase *database;
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSString *todaysDate;
@property (assign, nonatomic) BOOL facebookConnect;
@property (strong, nonatomic) NSMutableArray *gratArchievArray;
@property (assign) int flag;

-(void)facebookIntegration:(NSString*)messageStr;
-(void) scheduleNotificationForDate: (NSString*)dateStr: (NSString*)desc;
@end
