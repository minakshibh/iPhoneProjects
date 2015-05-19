//
//  GratitudeArchieveViewController.h
//  SHEDs Plus
//
//  Created by Krishna_Mac_3 on 09/05/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FMDatabase.h"

@interface GratitudeArchieveViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSArray *AutoArchArray;
    NSArray *keepHistryArray;
    NSString* fileName;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
}
- (IBAction)backBtn:(id)sender;
- (IBAction)autoArchieve:(id)sender;
- (IBAction)keepArchieveHistry:(id)sender;
- (IBAction)Emailid:(id)sender;
- (IBAction)hideTableBtn:(id)sender;
- (IBAction)DoneBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *autoArchieve;
@property (strong, nonatomic) IBOutlet UIButton *keepArchieveHist;
@property (strong, nonatomic) IBOutlet UIButton *emailid;
@property (strong, nonatomic) IBOutlet UITableView *archieveTableView;
@property (strong, nonatomic) IBOutlet UILabel *autoArchLbl;
@property (strong, nonatomic) IBOutlet UILabel *keepHistLbl;
@property (strong, nonatomic) IBOutlet UITextField *emailidTxt;
@property (strong, nonatomic) IBOutlet UIImageView *autoArchArrow;
@property (strong, nonatomic) IBOutlet UIImageView *keepHistArrow;
@property (assign, nonatomic) BOOL isAutoArchieve;
@property (assign, nonatomic) BOOL iskeepHistry;

- (IBAction)PostToFacebook:(id)sender;


@end
