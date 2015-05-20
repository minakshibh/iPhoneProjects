//
//  registerViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/26/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@interface registerViewController : UIViewController<UIScrollViewDelegate>
{
    
    IBOutlet UIButton *backBttn;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSString*imageUrlStr ,*creditCardNumbrStr;
    IBOutlet UIImageView *logoImg;

    CGPoint svos;
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *phoneNumberTxt;
    IBOutlet UILabel *alreadyAccountBtn;
    IBOutlet UIButton *loginHereBttn;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UITextField *confirmPasswordTxt;
    IBOutlet UILabel *lineLbl;
    NSMutableData*webData;
    int webservice;

    IBOutlet UILabel *registerBgLbl;
    IBOutlet UIScrollView *registerScroller;
    IBOutlet UIButton *registerBttn;
}
- (IBAction)registerBtnAction:(id)sender;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)loginHereBtnAction:(id)sender;
@property(strong,nonatomic)NSString*role,*trigger;
@end
