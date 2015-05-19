//
//  passcodeViewController.h
//  SHEDs Plus
//
//  Created by Krishna_Mac_1 on 5/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CFNetwork/CFNetwork.h>
#import "SKPSMTPMessage.h"

@interface passcodeViewController : UIViewController <UITextFieldDelegate,MFMailComposeViewControllerDelegate,SKPSMTPMessageDelegate>
{
    int textFieldFlag; // 0 for enter passcode, 1 for confirm passcode
   // BOOL isnumericKeyboard;
//      UIButton *doneButton ;
}
@property (strong, nonatomic) IBOutlet UITextField *enterPasscodeTxt;
@property (strong, nonatomic) IBOutlet UIImageView *disableImg;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasscodeTxt;
@property (strong, nonatomic) IBOutlet UITextField *oldpasscodetxt;
@property (strong, nonatomic) IBOutlet UIButton *SetPasscode;
@property (strong, nonatomic) IBOutlet UIView *changePasscodeView;
@property (strong, nonatomic) IBOutlet UILabel *passcodeLabel;

- (IBAction)backbtn:(id)sender;
- (IBAction)setPasscodeBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasscodeBtn;
- (IBAction)forgotPasscodeBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *forgtPascodeView;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;

@property (strong, nonatomic) IBOutlet UILabel *passcodeLbl;
- (IBAction)doneBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *passcodeBacklbl;
- (IBAction)cancelBtn:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *forgtPasscodeLbl;
@property (strong, nonatomic) IBOutlet UIButton *forgotPssBtn;

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UIButton *donebtnOutlt;
@property (strong, nonatomic) IBOutlet UIButton *cancelBttnOutlt;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *headertitle;


- (IBAction)PostToFacebook:(id)sender;

@end
