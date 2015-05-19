//
//  enterPasscodeViewController.h
//  SHEDs Plus
//
//  Created by Krishna_Mac_1 on 5/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CFNetwork/CFNetwork.h>
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

@interface enterPasscodeViewController : UIViewController <UITextFieldDelegate,SKPSMTPMessageDelegate>
{
    UIButton *doneButton ;
    BOOL isNumericKeyboard;
}
@property (strong, nonatomic) IBOutlet UITextField *enterPasscode;
@property (strong, nonatomic) IBOutlet UIButton *confirmOutlet;

- (IBAction)confirmBtn:(id)sender;
- (IBAction)forgotPasscode:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *forgtpacodView;
- (IBAction)doneBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailID;
- (IBAction)cancelBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *passcodeView;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UIImageView *disableImg;

@property (strong, nonatomic) IBOutlet UILabel *headertitle;

@property (strong, nonatomic) IBOutlet UIButton *donebtnOutlt;
@property (strong, nonatomic) IBOutlet UIButton *cancelBttnOutlt;

- (IBAction)PostToFacebook:(id)sender;

@end
