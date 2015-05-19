//
//  passcodeOptionViewController.h
//  SHEDs Plus
//
//  Created by Krishna_Mac_1 on 5/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface passcodeOptionViewController : UIViewController
{
    CGPoint svos;
    int flag;
}
@property (strong, nonatomic) IBOutlet UIButton *enablePasscodeBtn;
@property (strong, nonatomic) IBOutlet UIButton *changePasscodebtn;
@property (strong, nonatomic) IBOutlet UISwitch *passcodeToggle;
@property (strong, nonatomic) IBOutlet UIButton *setPasscodeBtn;
@property (strong, nonatomic) IBOutlet UILabel *headertitle;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIImageView *sideArrow;
@property (weak, nonatomic) IBOutlet UIImageView *downArrow;
@property (weak, nonatomic) IBOutlet UITextField *passcodeRecoveryEmailtxt;
@property (weak, nonatomic) IBOutlet UIButton *passwordRecovoryBtn;

- (IBAction)changePasscode:(id)sender;
- (IBAction)toggleSwitch:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)PostToFacebook:(id)sender;
- (IBAction)passwordRecovryBtn:(id)sender;
- (IBAction)saveEmailBtn:(id)sender;



@end
