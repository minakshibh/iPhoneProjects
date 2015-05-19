//
//  passcodeViewController.m
//  SHEDs Plus
//
//  Created by Krishna_Mac_1 on 5/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "passcodeViewController.h"
#import <CFNetwork/CFNetwork.h>
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "passcodeOptionViewController.h"
#import "AppDelegate.h"
#import "PageWebViewController.h"


#define kOFFSET_FOR_KEYBOARD 160.0
#define ACCEPTABLE_CHARECTERS @"0123456789."

@interface passcodeViewController ()
{
    int flag;
}
@end

@implementation passcodeViewController
@synthesize enterPasscodeTxt, confirmPasscodeTxt,SetPasscode,changePasscodeView,forgotPasscodeBtn,forgtPascodeView,oldpasscodetxt,passcodeLabel,emailTxt,forgotPssBtn,forgtPasscodeLbl,passcodeBacklbl,passcodeLbl,activityIndicatorObject,donebtnOutlt,cancelBttnOutlt,backView,disableImg,headertitle;
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
    textFieldFlag = 0;
  //  isnumericKeyboard=YES;
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        
    }
    else{
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
    }

    [enterPasscodeTxt setDelegate:self];
    [oldpasscodetxt setDelegate:self];
    [confirmPasscodeTxt setDelegate:self];
 //   [self registerForKeyboardNotifications];
    forgtPasscodeLbl.hidden=YES;
    forgotPssBtn.hidden=YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults stringForKey:@"passcode"]);
    if (!([defaults stringForKey:@"passcode"] == NULL)) {
        oldpasscodetxt.hidden = NO;
        forgtPasscodeLbl.hidden=NO;
        forgotPssBtn.hidden=NO;
        
        [passcodeLabel setText:@"Change you Passcode"];
        [enterPasscodeTxt setPlaceholder:@"Enter new 4 digit Passcode"];
        [SetPasscode setTitle:@"Change Passcode" forState:UIControlStateNormal];
    }
    [[enterPasscodeTxt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[enterPasscodeTxt layer] setBorderWidth:1.0];
    [[enterPasscodeTxt layer] setCornerRadius:5];
    
    [[donebtnOutlt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[donebtnOutlt layer] setBorderWidth:1.0];
    [[donebtnOutlt layer] setCornerRadius:5];
    
    [[cancelBttnOutlt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[cancelBttnOutlt layer] setBorderWidth:1.0];
    [[cancelBttnOutlt layer] setCornerRadius:5];
    
    [[confirmPasscodeTxt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[confirmPasscodeTxt layer] setBorderWidth:1.0];
    [[confirmPasscodeTxt layer] setCornerRadius:5];
    
    [[SetPasscode layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[SetPasscode layer] setBorderWidth:1.0];
    [[SetPasscode layer] setCornerRadius:5];
    
    [[oldpasscodetxt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[oldpasscodetxt layer] setBorderWidth:1.0];
    [[oldpasscodetxt layer] setCornerRadius:5];
    
    [[emailTxt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[emailTxt layer] setBorderWidth:1.0];
    [[emailTxt layer] setCornerRadius:5];
    
    [[passcodeLbl layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[passcodeLbl layer] setBorderWidth:1.0];
    [[passcodeLbl layer] setCornerRadius:5];
    
    [[forgtPascodeView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[forgtPascodeView layer] setBorderWidth:1.0];
    [[forgtPascodeView layer] setCornerRadius:5];
    
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 260);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 160);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 312);
    }
    activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)dismissKeyboard

{
    [oldpasscodetxt resignFirstResponder];
    [enterPasscodeTxt resignFirstResponder];
    [confirmPasscodeTxt resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setPasscodeBtn:(id)sender {
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 0;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
        }
        self.backView.frame = frame;
    }];
    
    [self.view endEditing:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults valueForKey:@"passcode"]);
    
    if (!([defaults valueForKey:@"passcode"] == NULL))
    {
        //        if ([enterPasscodeTxt.text isEqualToString:confirmPasscodeTxt.text] && [oldpasscodetxt.text isEqualToString:[defaults stringForKey:@"passcode"]])
        //        {
        //            [defaults removeObjectForKey:@"passcode"];
        //            NSLog(@"%@", [defaults valueForKey:@"passcode" ]);
        //
        //
        //
        //            [defaults setObject:[NSString stringWithFormat:@"%@",enterPasscodeTxt.text]  forKey:@"passcode"];
        //            NSLog(@"%@", [defaults valueForKey:@"passcode" ]);
        //            flag = 1;
        //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Passcode changed successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //            alert.tag=3;
        //            [alert show];
        //
        //
        //        }
        if ([enterPasscodeTxt.text isEqualToString:@""] && [confirmPasscodeTxt.text isEqualToString:@""] && [oldpasscodetxt.text isEqualToString:@""])
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter values to reset the Passcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else  if ([oldpasscodetxt.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter old Passcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else  if ([enterPasscodeTxt.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter Passcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else if ([confirmPasscodeTxt.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter Passcode to Confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (enterPasscodeTxt.text.length<4) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter 4 digit Passcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else if (confirmPasscodeTxt.text.length<4) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter 4 digit Passcode to Confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else if (![enterPasscodeTxt.text isEqualToString:confirmPasscodeTxt.text])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Passcode do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }else if (![oldpasscodetxt.text isEqualToString:[defaults stringForKey:@"passcode"]]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Old Passcode is incorrect" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else if ([enterPasscodeTxt.text isEqualToString:[defaults valueForKey:@"passcode"]]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"old Passcode and new Passcode can not be same." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else{
            [defaults removeObjectForKey:@"passcode"];
            NSLog(@"%@", [defaults valueForKey:@"passcode" ]);
            
            [defaults setObject:[NSString stringWithFormat:@"%@",enterPasscodeTxt.text]  forKey:@"passcode"];
            NSLog(@"%@", [defaults valueForKey:@"passcode" ]);
            flag = 1;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Passcode changed successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=3;
            [alert show];
            
            
        }
        
    }
    else{
        if ([enterPasscodeTxt.text isEqualToString:@""] && [confirmPasscodeTxt.text isEqualToString:@""] )
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter values to set your Passcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else if ([enterPasscodeTxt.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter Passcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if ([confirmPasscodeTxt.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter Passcode to Confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (enterPasscodeTxt.text.length<4) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter 4 digit Passcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        else if (confirmPasscodeTxt.text.length<4) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter 4 digit Passcode to Confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else if (![enterPasscodeTxt.text isEqualToString:confirmPasscodeTxt.text])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Passcode do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        
        else if ([enterPasscodeTxt.text isEqualToString:confirmPasscodeTxt.text]) {
            
            NSLog(@"%@", [defaults valueForKey:@"passcode" ]);
            [defaults removeObjectForKey:@"passcode"];
            [defaults setObject:[NSString stringWithFormat:@"%@",enterPasscodeTxt.text] forKey:@"passcode"];
            NSLog(@"%@", [defaults valueForKey:@"passcode" ]);
            flag = 1;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Passcode saved successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=3;
            [alert show];
            confirmPasscodeTxt.text = @"";
            enterPasscodeTxt.text = @"";
        }
    }
    [confirmPasscodeTxt resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
   
   // isnumericKeyboard=NO;
    
    if (textField== emailTxt)
    {
        [UIView animateWithDuration:0.1f animations:^{
            
            CGRect frame = self.forgtPascodeView.frame;
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                //frame.origin.y = 145;
            }
            if ([[UIScreen mainScreen] bounds].size.height ==480) {
                frame.origin.y = 150;
                
            }
            
            self.forgtPascodeView.frame = frame;
        }];

    }
    else {
        [UIView animateWithDuration:0.1f animations:^{
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 145;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 145;
            
        }
        self.backView.frame = frame;
        }];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == enterPasscodeTxt)
    {
      //  isnumericKeyboard=YES;
        textFieldFlag = 0;
    }
    else if(textField == confirmPasscodeTxt)
    {
      //  isnumericKeyboard=YES;
        textFieldFlag = 1;
    }
    else if(textField==oldpasscodetxt)
    {
      //  isnumericKeyboard=YES;
        textFieldFlag = 2;
    }
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = -30;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = -70;
            
        }
        
        self.backView.frame = frame;
    }];

}

- (IBAction)backbtn:(id)sender {
    passcodeOptionViewController *passcodeVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        passcodeVc=[[passcodeOptionViewController alloc]initWithNibName:@"passcodeOptionViewController" bundle:nil];
    }
    else   if ([[UIScreen mainScreen] bounds].size.height == 480) {
        passcodeVc=[[passcodeOptionViewController alloc]initWithNibName:@"passcodeOptionViewController_iphone4" bundle:nil];
    }
    else{
        passcodeVc=[[passcodeOptionViewController alloc]initWithNibName:@"passcodeOptionViewController_ipad" bundle:nil];
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [self.navigationController pushViewController:passcodeVc animated:NO];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    if ([defaults stringForKey:@"passcode"] == NULL)
//    {
//        passcodeVc.changePasscodebtn.hidden=YES;
//        passcodeVc.setPasscodeBtn.hidden=NO;
//        
//    }
//    else{
//        passcodeVc.setPasscodeBtn.hidden=YES;
//        passcodeVc.changePasscodebtn.hidden=NO;
//        
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    if(textFieldFlag == 0){
        if (enterPasscodeTxt.text.length == 4  && range.length == 0)
            return NO;
        else
            return YES;
    }else if(textFieldFlag == 1){
        if (confirmPasscodeTxt.text.length == 4  && range.length == 0)
            return NO;
        else
            return YES;
    }else if(textFieldFlag==2){
        
        if (oldpasscodetxt.text.length == 4  && range.length == 0)
            return NO;
        else
            return YES;
    }else{
        return YES;
    }
}

- (IBAction)forgotPasscodeBtn:(id)sender {
    [self.view endEditing:YES];
    [self.backView endEditing:YES];
    backView.hidden=YES;
    oldpasscodetxt.text=@"";
    enterPasscodeTxt.text=@"";
    confirmPasscodeTxt.text=@"";
    //isnumericKeyboard=NO;
//    doneButton.hidden=YES;
//    [doneButton removeFromSuperview];
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 0;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
        }
        self.backView.frame = frame;
    }];
    
    [confirmPasscodeTxt resignFirstResponder];
    forgtPascodeView.hidden=NO;
}





- (void)sendMessageInBack{
	
	NSLog(@"Start Sending");
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"sample.pdf"];
	
	NSData *dataObj = [NSData dataWithContentsOfFile:writableDBPath];
	
	SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
	
	testMsg.fromEmail = @"minakshibhardwaj.kis@gmail.com";//nimit51parekh@gmail.com
	
	testMsg.toEmail = emailTxt.text;//sender mail id
	
	testMsg.relayHost = @"smtp.gmail.com";
	
	testMsg.requiresAuth = YES;
	
	testMsg.login = @"minakshibhardwaj.kis@gmail.com";//nimit51parekh@gmail.com
	
	testMsg.pass = @"mbs.kis@321";
	
	testMsg.subject = @"SHEDs Passcode";
	
	testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
	
	testMsg.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *passcodeStr=[defaults valueForKey:@"passcode"];
    NSString *str_info2=[NSString stringWithFormat:@"Hi,\n\nYour SHEDs Passcode is:%@ \n\nThanks \nSHEDs Plus Team",passcodeStr];
    NSString *sendmsg=[[NSString alloc]initWithFormat:@"%@",str_info2];
    NSLog(@"automsg=%@",sendmsg);
	
	NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,sendmsg,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
	[testMsg send];
}


-(void)messageSent:(SKPSMTPMessage *)message{
    backView.hidden=NO;
    [activityIndicatorObject stopAnimating];
    disableImg.hidden=YES;
    [self.view setUserInteractionEnabled:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Passcode sent" message:@"Your passcode has been sent to you via email.Kindly Check." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert.tag=3;
    NSLog(@"delegate - message sent");
    forgtPascodeView.hidden=YES;
    emailTxt.text=@"";
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    [activityIndicatorObject stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    disableImg.hidden=YES;
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Your passcode could not be sent. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
}


- (IBAction)doneBtn:(id)sender {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 0;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
        }
        self.backView.frame = frame;
    }];
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 0;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
        }
        self.backView.frame = frame;
    }];
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    
    
    if ([emailTxt.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter Email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (([emailTest evaluateWithObject:emailTxt.text] != YES) || [emailTxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        [activityIndicatorObject startAnimating];
        disableImg.hidden=NO;
        [self.view setUserInteractionEnabled:NO];
        
        [self sendMessageInBack];
    }
    
}
- (IBAction)cancelBtn:(id)sender {
    backView.hidden=NO;

    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 0;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
        }
        self.backView.frame = frame;
    }];
    
    [self.view endEditing:YES];
    forgtPascodeView.hidden=YES;
    emailTxt.text=@"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [confirmPasscodeTxt resignFirstResponder];
    [UIView animateWithDuration:0.3f animations:^{
        
        CGRect frame = self.backView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 0;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480) {
            frame.origin.y = 0;
        }
        self.backView.frame = frame;
    }];
    
    return YES;
}

//
//-(void)keyboardWasShown:(NSNotification *)note {
//    
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
//        
//    }
//    else {
//        
//        isnumericKeyboard=NO;
//        // this is ipad xib
//    }
//    
//   
//    if ( isnumericKeyboard)
//    {
//       
//
//        // create custom button
//        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        // exactly of image size
//        doneButton.frame = CGRectMake(0, 163, 106, 53);
//        
//        doneButton.adjustsImageWhenHighlighted = NO;
//        
//        [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
//        
//        [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
//        
//        [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//        
//        // locate keyboard view
//        
//        UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//        
//        UIView* keyboard;
//        
//        for(int i=0; i<[tempWindow.subviews count]; i++) {
//            
//            keyboard = [tempWindow.subviews objectAtIndex:i];
//        }
//        
//        // keyboard view found; add the custom button to it
//        
//        [keyboard addSubview:doneButton];
//    }
//    else{
//        doneButton.hidden=YES;
//    }
//    
//}
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    if(doneButton)
//    {
//        [doneButton removeFromSuperview];
//        doneButton = nil;
//    }
//    // [UIView setAnimationDuration:0.2];
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    // view.contentInset = contentInsets;
//    //    scrollView.scrollIndicatorInsets = contentInsets;
//}
//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//}
//
//
//-(IBAction) doneButton:(id) sender
//{
//    [UIView animateWithDuration:0.1f animations:^{
//        
//        CGRect frame = self.backView.frame;
//        if ([[UIScreen mainScreen] bounds].size.height == 568) {
//            frame.origin.y = 145;
//        }
//        if ([[UIScreen mainScreen] bounds].size.height ==480) {
//            frame.origin.y = 145;
//            
//        }
//        
//        self.backView.frame = frame;
//    }];
//
//    [enterPasscodeTxt resignFirstResponder];
//    [confirmPasscodeTxt resignFirstResponder];
//    [oldpasscodetxt resignFirstResponder];
//    
//}



- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

   else if ( alertView.tag == 3)
    {
        oldpasscodetxt.text=@"";
        enterPasscodeTxt.text=@"";
        confirmPasscodeTxt.text=@"";
        emailTxt.text=@"";
        passcodeOptionViewController *passcodeVc;
      
        if ([[UIScreen mainScreen] bounds].size.height == 568){
            passcodeVc=[[passcodeOptionViewController alloc]initWithNibName:@"passcodeOptionViewController" bundle:nil];
        }else   if ([[UIScreen mainScreen] bounds].size.height == 480) {
            passcodeVc=[[passcodeOptionViewController alloc]initWithNibName:@"passcodeOptionViewController_iphone4" bundle:nil];
        }else{
            passcodeVc=[[passcodeOptionViewController alloc]initWithNibName:@"passcodeOptionViewController_ipad" bundle:nil];
        }
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
        [self.navigationController pushViewController:passcodeVc animated:NO];
    }
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




@end
