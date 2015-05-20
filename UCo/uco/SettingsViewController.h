//
//  SettingsViewController.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "settingsObj.h"


@interface SettingsViewController : UIViewController
{
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    NSMutableArray * settingsListArray;
    settingsObj *settingsOC;
    IBOutlet UILabel *mrMrsLbl;
    IBOutlet UILabel *manageVenuesLbl;
    IBOutlet UILabel *paymentLbl;
    IBOutlet UILabel *specialOfferLbl;
    IBOutlet UILabel *myBookingLbl;
    IBOutlet UILabel *exportLbl;
    IBOutlet UILabel *myfeedbackLbl;
    IBOutlet UILabel *importLbl;
    IBOutlet UIButton *createUserBtn;
    IBOutlet UITextField *firstNameTxt;
    IBOutlet UITextField *lastNameTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *phoneTxt;
    IBOutlet UIView *createUserView;
    IBOutlet UITableView *settingTableView;
    IBOutlet UIButton *addUserBtn;
    IBOutlet UIButton *manageUsersBtn;
    IBOutlet UIButton *changePassword;
    IBOutlet UIButton *securityQuestionBtn;
    IBOutlet UIView *changePasswordView;
    IBOutlet UITextField *oldPasswordTxt;
    IBOutlet UITextField *newPasswordTxt;
    IBOutlet UITextField *confirmPasswordtxt;
    IBOutlet UIButton *submitBtn;
    IBOutlet UILabel *firstQuestionLbl;
    IBOutlet UITextField *firstAnswerTxt;
    IBOutlet UITextField *firstHintTxt;
    IBOutlet UILabel *secondQuestionLbl;
    IBOutlet UITextField *secondAnswerTxt;
    IBOutlet UITextField *secondHint;
    IBOutlet UIButton *securitySubmitBtn;
    IBOutlet UIView *securityQuestionview;
}
- (IBAction)createUserAction:(id)sender;
- (IBAction)changePasswordAction:(id)sender;
- (IBAction)addUserAction:(id)sender;
- (IBAction)securityQuestionAction:(id)sender;
- (IBAction)manageUsersAction:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)securitySubmitAction:(id)sender;


@end
