//
//  motivational_screenViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/19/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homescreenViewController.h"
#import "sqlite3.h"
#import "createahabitViewController.h"
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>


@interface motivational_screenViewController : UIViewController<UIGestureRecognizerDelegate,MFMailComposeViewControllerDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource,UIActionSheetDelegate>
{
    
    NSString *docsDir;
    NSArray *dirPath;
    sqlite3 *contactDB;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
     FMDatabase *database;
    NSString *autoArchieve,*keepHistry,*autoArchieveDate,*emailid,*fileName;
    NSDate *tenDaysAgo;
    NSDate *twentyDaysAgo;
    NSDate *thirtyDaysAgo;
    NSDate *tenDaysLater;
    NSDate *twentyDaysLater;
    NSDate *thirtyDaysLater;
    UITapGestureRecognizer *tap;
}
@property (strong, nonatomic) createahabitViewController *createhabit;
@property (strong, nonatomic) homescreenViewController *home;
@property (strong, nonatomic) IBOutlet UITextView *motivationTxtView;
@property (strong, nonatomic) IBOutlet UITextView *authorview;
@property (strong, nonatomic) IBOutlet UILabel *titlelbl;
@property (strong, nonatomic) IBOutlet UILabel *continuebtn;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSMutableArray *gratArchievArray;

-(int)getRandomNumberBetween:(int)from to:(int)to;
//-(IBAction)continuebtn:(id)sender;
@end
