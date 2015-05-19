//
//  splashscreenViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/17/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>

@interface splashscreenViewController : UIViewController<MFMailComposeViewControllerDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource>
{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath, *fileName;
    FMDatabase *database;
    NSString *autoArchieve,*keepHistry,*autoArchieveDate,*emailid;
    NSDate *tenDaysAgo;
    NSDate *twentyDaysAgo;
    NSDate *thirtyDaysAgo;
}
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *titlelbl;
@property (strong, nonatomic) UIImageView * mainImageView;
@property (strong, nonatomic) NSMutableArray *gratArchievArray;

@end
