//
//  enterPasscodeViewController.m
//  SHEDs Plus
//
//  Created by Krishna_Mac_1 on 5/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "enterPasscodeViewController.h"
#import "splashscreenViewController.h"
#import <CFNetwork/CFNetwork.h>
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "AppDelegate.h"
#import "PageWebViewController.h"
@interface enterPasscodeViewController ()

@end

@implementation enterPasscodeViewController
@synthesize enterPasscode,confirmOutlet,forgtpacodView,emailID,passcodeView,donebtnOutlt,headertitle,cancelBttnOutlt,activityIndicatorObject,disableImg;

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
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
    }
    else{
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:70]];
    }
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    isNumericKeyboard=YES;
    [enterPasscode setDelegate:self];
    [super viewDidLoad];
    
    [[enterPasscode layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[enterPasscode layer] setBorderWidth:1.0];
    [[enterPasscode layer] setCornerRadius:5];
    
    [[confirmOutlet layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[confirmOutlet layer] setBorderWidth:1.0];
    [[confirmOutlet layer] setCornerRadius:5];
    
    [[forgtpacodView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[forgtpacodView layer] setBorderWidth:1.0];
    [[forgtpacodView layer] setCornerRadius:5];
    
    [[emailID layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[emailID layer] setBorderWidth:1.0];
    [[emailID layer] setCornerRadius:5];
    
    [[passcodeView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[passcodeView layer] setBorderWidth:1.0];
    [[passcodeView layer] setCornerRadius:5];
    
    [[donebtnOutlt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[donebtnOutlt layer] setBorderWidth:1.0];
    [[donebtnOutlt layer] setCornerRadius:5];
    
    [[cancelBttnOutlt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[cancelBttnOutlt layer] setBorderWidth:1.0];
    [[cancelBttnOutlt layer] setCornerRadius:5];
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 260);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 200);
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
}

-(void)dismissKeyboard
{
    [enterPasscode resignFirstResponder];
}

//- (void)keyboardWillShow:(NSNotification *)note {
//    // create custom button
//    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    doneButton.frame = CGRectMake(0, 163, 106, 53);
//    doneButton.adjustsImageWhenHighlighted = NO;
//    [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
//    [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
//    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//
//    // locate keyboard view
//    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    UIView* keyboard;
//    for(int i=0; i<[tempWindow.subviews count]; i++) {
//        keyboard = [tempWindow.subviews objectAtIndex:i];
//        // keyboard view found; add the custom button to it
//        if([[keyboard description] hasPrefix:@"UIKeyboard"] == YES)
//            [keyboard addSubview:doneButton];
//    }
//}
//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)confirmBtn:(id)sender {
    [self.view endEditing:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults valueForKey:@"passcode"]);
    NSString *passcodeStr = [NSString stringWithFormat:@"%@",enterPasscode.text];
    if ([passcodeStr isEqualToString:[defaults valueForKey:@"passcode"]]) {
        splashscreenViewController *splash;
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            splash = [[splashscreenViewController alloc] initWithNibName:@"splashscreenViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            splash = [[splashscreenViewController alloc] initWithNibName:@"splashscreenViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else
        {
            splash = [[splashscreenViewController alloc] initWithNibName:@"splashscreenViewController_ipad" bundle:Nil];
             // this is ipad xib
        }
        [self.navigationController pushViewController:splash animated:NO];
        //
        //        navigator = [[UINavigationController alloc] initWithRootViewController:splash];
        //        // }
        //        self.window.rootViewController = navigator;
        //
        //        self.window.backgroundColor = [UIColor whiteColor];
        //        [self.window makeKeyAndVisible];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Invalid passcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    [UIView animateWithDuration:0.1f animations:^{
//        CGRect frame = self.view.frame;
//        if ([[UIScreen mainScreen] bounds].size.height == 568) {
//            frame.origin.y += 60;
//        }
//        if ([[UIScreen mainScreen] bounds].size.height ==480) {
//            frame.origin.y += 60;
//        }
//        self.view.frame = frame;
//    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==emailID)
    {
        isNumericKeyboard=NO;
        doneButton.hidden=YES;
    }
    else {
        isNumericKeyboard=YES;
        doneButton.hidden=NO;
    }
//    [UIView animateWithDuration:0.3f animations:^{
//        
//        CGRect frame = self.view.frame;
//        if ([[UIScreen mainScreen] bounds].size.height == 568) {
//            frame.origin.y -= 60;
//        }
//        if ([[UIScreen mainScreen] bounds].size.height ==480) {
//            frame.origin.y -= 60;
//        }
//        self.view.frame = frame;
//    }];
}
- (IBAction)forgotPasscode:(id)sender {
    isNumericKeyboard=NO;
    enterPasscode.text=@"";
    [self.view endEditing:YES];
    forgtpacodView.hidden=NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (enterPasscode.text.length >= 4 && range.length == 0){
    	return NO; // return NO to not change text
    }else{
        return YES;
    }
}


- (IBAction)doneBtn:(id)sender {
    [self.view endEditing:YES];
    [self.forgtpacodView endEditing:YES];
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([emailID.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter Email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (!([emailID.text isEqualToString:[NSString stringWithFormat:@"%@",[defaults valueForKey:@"RecovoryEmail"]]])){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter valid Email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (([emailTest evaluateWithObject:emailID.text] != YES) || [emailID.text isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else{
        [self.view setUserInteractionEnabled:NO];
        [activityIndicatorObject startAnimating];
        disableImg.hidden=NO;
        [self sendMessageInBack];
    }
}

- (IBAction)cancelBtn:(id)sender {
    [self.view endEditing:YES];
    [self.forgtpacodView endEditing:YES];
    forgtpacodView.hidden=YES;
    emailID.text=@"";
    isNumericKeyboard=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)sendMessageInBack{
	
	NSLog(@"Start Sending");
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"sample.pdf"];
	
	NSData *dataObj = [NSData dataWithContentsOfFile:writableDBPath];
	
   
	SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
	testMsg.fromEmail = @"peter@ingenius.com.au";
	testMsg.toEmail = emailID.text;
	testMsg.relayHost = @"hyperion.instanthosting.com.au";
	testMsg.requiresAuth = YES;
	testMsg.login = @"peter@ingenius.com.au";
	testMsg.pass = @"Metaman1";
	testMsg.subject = @"SHEDs Passcode";
    testMsg.validateSSLChain = NO;
	testMsg.wantsSecure = NO; // smtp.gmail.com doesn't work without TLS!
	testMsg.delegate = self;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *passcodeStr=[defaults valueForKey:@"passcode"];
    NSString *str_info2=[NSString stringWithFormat:@"Hi,\n\nYour SHEDs Passcode is:%@ \n\nThanks \nSHEDs Plus Team.",passcodeStr];    NSString *sendmsg=[[NSString alloc]initWithFormat:@"%@",str_info2];
    NSLog(@"automsg=%@",sendmsg);
	NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,sendmsg,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
	[testMsg send];
}

-(void)messageSent:(SKPSMTPMessage *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Passcode sent" message:@"Your passcode has been sent to you via email.Kindly Check." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"delegate - message sent");
    emailID.text=@"";
    forgtpacodView.hidden=YES;
    [self.view setUserInteractionEnabled:YES];
    [activityIndicatorObject stopAnimating];
    disableImg.hidden=YES;
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    
    NSLog(@"error msg- %@",error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Your passcode could not be sent. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
    [self.view setUserInteractionEnabled:YES];
    [activityIndicatorObject stopAnimating];
    disableImg.hidden=YES;
	NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
}


//-(void)keyboardWasShown:(NSNotification *)note {
//    
//    // create custom button
//    
//    
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
//        
//    } else {
//        
//        isNumericKeyboard=NO;
//        // this is ipad xib
//    }
//    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    // exactly of image size
//    doneButton.frame = CGRectMake(0, 163, 106, 53);
//    
//    doneButton.adjustsImageWhenHighlighted = NO;
//    
//    [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
//    
//    [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
//    
//    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//    // locate keyboard view
//    
//    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
//    
//    UIView* keyboard;
//    
//    for(int i=0; i<[tempWindow.subviews count]; i++) {
//        
//        keyboard = [tempWindow.subviews objectAtIndex:i];
//    }
//    
//    // keyboard view found; add the custom button to it
//    if (isNumericKeyboard)
//    {
//        [keyboard addSubview:doneButton];
//    }
//    else if(!isNumericKeyboard)
//    {
//        doneButton.hidden=YES;
//    }
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
//    [enterPasscode resignFirstResponder];
//}
//


- (void)viewDidUnload
{
  //  [[NSNotificationCenter defaultCenter] removeObserver:self];
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
}


@end
