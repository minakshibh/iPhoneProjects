//
//  AppDelegate.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 20/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "SplashViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CustomNavigationController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
      FBSession *session;
    NSString *devicetoc, *creditValue;
    UIActivityIndicatorView *activityIndicatorObject;
    UIView *view;
    int webserviceCode;
}
@property (strong, nonatomic)  SplashViewController*splashvc;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomNavigationController *navigator;
@property (nonatomic, assign) BOOL appUsageCheckEnabled;
@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) NSString* user_UDID_Str ,*registrationIDStr,*message,*result;
@property (strong, nonatomic) NSMutableString* tempString;
@property (strong, nonatomic) NSString *deviceToken, *payload, *certificate;
@property (nonatomic, assign) BOOL facebookConnect;
@property (nonatomic, strong) UIWebView * webView;
- (BOOL)connected;
- (void)facebookIntegration:(NSString*)songNameString1: (NSString *) imageString;
@end
