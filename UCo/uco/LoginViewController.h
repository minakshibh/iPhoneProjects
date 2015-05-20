//
//  LoginViewController.h
//  uco
//
//  Created by Br@R on 17/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
{
    NSMutableData *webData;
    NSString*emailStr;
    NSString*passordStr;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *passwordTxt;
    IBOutlet UIImageView *KeepLogedInImageView;
    IBOutlet UIButton *signBtn;
    IBOutlet UIButton *signUpbtn;
    IBOutlet UIButton *keepMeLoginBtn;
    UIActivityIndicatorView *activityIndicator;
}
- (IBAction)loginActionBtn:(id)sender;
- (IBAction)keepMeLogInActionBtn:(id)sender;
- (IBAction)signUpActionBtn:(id)sender;

@end
