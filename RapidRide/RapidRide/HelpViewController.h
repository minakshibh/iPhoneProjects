//
//  HelpViewController.h
//  RapidRide
//
//  Created by Br@R on 26/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface HelpViewController : UIViewController<MFMailComposeViewControllerDelegate>

{
    NSString *phNo;
    NSString *emailStr;
}

@property (strong, nonatomic) IBOutlet UILabel *headedLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (strong, nonatomic) IBOutlet UIButton *customerService;
@property (strong, nonatomic) IBOutlet UIButton *helpCentre;
@property (strong, nonatomic) IBOutlet UIButton *termsOfPolicy;
@property (strong, nonatomic) IBOutlet UIButton *privatePolicy;
@property (strong, nonatomic) IBOutlet UIButton *becomeAdriverBtn;
@property (strong, nonatomic) IBOutlet UILabel *driverLbl;
@property (strong ,nonatomic) NSString *policyUrl;
@property (strong ,nonatomic) NSString *TermsUrl,*becomeDriverUrl;


- (IBAction)backBtn:(id)sender;
- (IBAction)becomeDriverBtn:(id)sender;
- (IBAction)customerService:(id)sender;
- (IBAction)HelpCentre:(id)sender;
- (IBAction)PrivatePolicy:(id)sender;
- (IBAction)TermsOfService:(id)sender;

@end
