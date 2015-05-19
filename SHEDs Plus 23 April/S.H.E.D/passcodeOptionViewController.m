//
//  passcodeOptionViewController.m
//  SHEDs Plus
//
//  Created by Krishna_Mac_1 on 5/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "passcodeOptionViewController.h"
#import "passcodeViewController.h"
#import "setting_shedViewController.h"
#import "AppDelegate.h"
#import "PageWebViewController.h"

@interface passcodeOptionViewController ()

@end

@implementation passcodeOptionViewController
@synthesize changePasscodebtn,enablePasscodeBtn,passcodeToggle,setPasscodeBtn,headertitle;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        [enablePasscodeBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [changePasscodebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [setPasscodeBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [self.passwordRecovoryBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];

    }
    else{
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
        [enablePasscodeBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        [changePasscodebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        [setPasscodeBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        [self.passwordRecovoryBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
    }
    
    
    [[self.passcodeRecoveryEmailtxt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.passcodeRecoveryEmailtxt layer] setBorderWidth:1.0];
    [[self.passcodeRecoveryEmailtxt layer] setCornerRadius:8];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults stringForKey:@"passcode"] == NULL)
    {
        changePasscodebtn.hidden=YES;
        setPasscodeBtn.hidden=NO;

    }
    else{
        setPasscodeBtn.hidden=YES;
        changePasscodebtn.hidden=NO;

    }
    NSLog(@"%@",[defaults valueForKey:@"toggleSwitch"]);
    
    if ([[defaults valueForKey:@"toggleSwitch"] isEqualToString:@"test"]) {
        [passcodeToggle setOn:YES animated:YES];
    }
    else{
        [passcodeToggle setOn:NO animated:YES];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePasscode:(id)sender {
    
    
   
    passcodeViewController *passcodeVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        passcodeVC = [[passcodeViewController alloc] initWithNibName:@"passcodeViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        
        passcodeVC = [[passcodeViewController alloc] initWithNibName:@"passcodeViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    } else {
        
        passcodeVC = [[passcodeViewController alloc] initWithNibName:@"passcodeViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    [self.navigationController pushViewController:passcodeVC animated:YES];
   
}

- (IBAction)toggleSwitch:(id)sender
{
    NSLog(@"Toggle is %u", passcodeToggle.state);
    NSString *emailStr = [NSString stringWithFormat:@"%@",self.passcodeRecoveryEmailtxt.text];
    NSUInteger  StrLength= [emailStr length];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults stringForKey:@"RecovoryEmail"]);
    NSLog(@"%@",[defaults stringForKey:@"passcode"]);
    NSLog(@"%@",[defaults stringForKey:@"toggleSwitch"]);
    
    
     if ([defaults stringForKey:@"passcode"] == NULL)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please set your passcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
        [alert show];
        [passcodeToggle setOn:NO animated:YES];
    }
    
    else
    {
    
        
        if (passcodeToggle.on)
        {
            if (([defaults valueForKey:@"RecovoryEmail"] == NULL)) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter passcode recovery email first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [passcodeToggle setOn:NO animated:YES];
                [alert show];
            }else{
            NSLog(@"%@",[defaults stringForKey:@"toggleSwitch"]);
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"toggleSwitch"];
            NSLog(@"%@",[defaults stringForKey:@"toggleSwitch"]);
            
            [defaults setObject:[NSString stringWithFormat:@"test"] forKey:@"toggleSwitch"];
            NSLog(@"%@",[defaults stringForKey:@"toggleSwitch"]);
            }
        }else
        {
            NSLog(@"%@",[defaults stringForKey:@"toggleSwitch"]);
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"toggleSwitch"];
            NSLog(@"%@",[defaults stringForKey:@"toggleSwitch"]);
            
            [defaults setObject:[NSString stringWithFormat:@"ok"] forKey:@"toggleSwitch"];
            
            NSLog(@"%@",[defaults stringForKey:@"toggleSwitch"]);
            
        }
    }
        NSLog(@"%@", [defaults valueForKey:@"toggleSwitch" ]);
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)backBtn:(id)sender {
    
    setting_shedViewController *settingVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        
        settingVc=[[setting_shedViewController alloc]initWithNibName:@"setting_shedViewController" bundle:nil];
    }
    else   if ([[UIScreen mainScreen] bounds].size.height == 480) {
        settingVc=[[setting_shedViewController alloc]initWithNibName:@"setting_shedViewController_iphone4" bundle:nil];
        
    }
    else{
        settingVc=[[setting_shedViewController alloc]initWithNibName:@"setting_shedViewController_ipad" bundle:nil];
        
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [self.navigationController pushViewController:settingVc animated:NO];
    

  //  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)PostToFacebook:(id)sender {
    
    PageWebViewController *pageVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        pageVc=[[PageWebViewController alloc]initWithNibName:@"PageWebViewController" bundle:nil];
        
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        pageVc = [[PageWebViewController alloc]initWithNibName:@"PageWebViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        pageVc = [[PageWebViewController alloc]initWithNibName:@"PageWebViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    
    
    [self.navigationController presentViewController:pageVc animated:YES completion:nil];
    
//    UIAlertView* dialog = [[UIAlertView alloc] init];
//    [dialog setDelegate:self];
//    [dialog setTitle:@"Share your views in SHEDs community..."];
//    [dialog setMessage:@" "];
//    [dialog addButtonWithTitle:@"Cancel"];
//    [dialog addButtonWithTitle:@"OK"];
//    dialog.tag = 5;
//    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [dialog textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
//    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
//    [dialog setTransform: moveUp];
//    [dialog show];
    
    //
    //    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    appDelegate.facebookConnect=YES;
    //    [appDelegate facebookIntegration];
}

- (IBAction)passwordRecovryBtn:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"RecovoryEmail"] != NULL) {
    self.passcodeRecoveryEmailtxt.text = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"RecovoryEmail"]];
    }
    if (self.emailView.hidden == YES) {
        
        self.emailView.hidden = NO;
        self.downArrow.hidden = NO;
        self.sideArrow.hidden = YES;
    }else{
        
        self.emailView.hidden = YES;
        self.downArrow.hidden = YES;
        self.sideArrow.hidden = NO;
    }
}

- (IBAction)saveEmailBtn:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    NSString *emailStr = [NSString stringWithFormat:@"%@",self.passcodeRecoveryEmailtxt.text];
    [defaults setObject:emailStr forKey:@"RecovoryEmail"];
    if ([self.passcodeRecoveryEmailtxt.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter passcode recovery email first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([emailTest evaluateWithObject:self.passcodeRecoveryEmailtxt.text] != YES)
    {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"SHEDs" message:@"Please enter valid user email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
    }else{
    
    [self.passcodeRecoveryEmailtxt resignFirstResponder];
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.view.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            //frame.origin.y = 145;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
            
        }
        
        self.view.frame = frame;
    }];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(alertView.tag==5 && buttonIndex==1 && [title isEqualToString:@"OK"])
    {
        
        
        UITextField *messageTxt = [alertView textFieldAtIndex:0];
        
        NSString *msgTxt=[NSString stringWithFormat:@"%@", messageTxt.text];
        
        if ([msgTxt isEqualToString:@""]) {
            UIAlertView *alrt =[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter your views.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alrt show];
        }else{
            
            AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.facebookConnect=YES;
            [appDelegate facebookIntegration:msgTxt  ];
            
        }
    }
    else   if (alertView.tag==5 && buttonIndex==0 )
    {
    }
    
    else   if (buttonIndex == 0)
    {
        passcodeViewController *passcodeVC;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            passcodeVC = [[passcodeViewController alloc] initWithNibName:@"passcodeViewController" bundle:nil];
            //this is iphone 5 xib
        } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            
            passcodeVC = [[passcodeViewController alloc] initWithNibName:@"passcodeViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        } else {
            
            passcodeVC = [[passcodeViewController alloc] initWithNibName:@"passcodeViewController_ipad" bundle:nil];
            // this is ipad xib
        }
        [self.navigationController pushViewController:passcodeVC animated:YES];    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.view.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            //frame.origin.y = 145;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
            
        }
        
        self.view.frame = frame;
    }];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.view.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            //frame.origin.y = 145;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = -70;
            
        }
        
        self.view.frame = frame;
    }];
}


@end
