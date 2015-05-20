//
//  SplashViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 20/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "loginViewController.h"

@interface SplashViewController : UIViewController<NSXMLParserDelegate>
{
    loginViewController *aSongsVc;
    NSString *isLogedOut;
    int flag;
    NSMutableString *tempString;
    NSString *result,*message, *creditValue;
}
@property (strong, nonatomic)  loginViewController*aSongsVc;

@end
