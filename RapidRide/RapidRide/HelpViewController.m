//
//  HelpViewController.m
//  RapidRide
//
//  Created by Br@R on 26/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "HelpViewController.h"
#import "AboutUsViewController.h"
@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize customerService,helpCentre,termsOfPolicy,privatePolicy,TermsUrl,policyUrl,becomeAdriverBtn,driverLbl,becomeDriverUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    
    [self.headedLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [customerService.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [helpCentre.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [termsOfPolicy.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [privatePolicy.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [becomeAdriverBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];

   policyUrl=@"http://www.riderapid.com/app/privacy/";
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"DriverSide" ])
    {
        driverLbl.hidden=YES;
        becomeAdriverBtn.hidden=YES;
        
        TermsUrl=@"http://www.riderapid.com/app/terms-driver/";
        phNo = @"7608886421";
        emailStr=@"driverhelp@riderapid.com";
    }
    else
    {
        driverLbl.hidden=NO;
        becomeAdriverBtn.hidden=NO;
        TermsUrl=@"http://www.riderapid.com/app/terms/";
        phNo = @"8666526420";
        emailStr=@"help@riderapid.com";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)HelpCentre:(id)sender
{
    MFMailComposeViewController *comp=[[MFMailComposeViewController alloc]init];
    [comp setMailComposeDelegate:self];
    if([MFMailComposeViewController canSendMail])
    {
        [comp setToRecipients:[NSArray arrayWithObjects:emailStr, nil]];
        [comp setSubject:@"Help"];
        [comp setMessageBody:@"" isHTML:NO];
        [comp setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:comp animated:YES completion:nil];
    }
    else {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alrt show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if(error)
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alrt show];
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self dismissModalViewControllerAnimated:YES];
    }
}



- (IBAction)TermsOfService:(id)sender
{
    
    
    AboutUsViewController *aboutus;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }

    aboutus.linkUrl=TermsUrl;
    [self.navigationController pushViewController:aboutus  animated:YES];
}

- (IBAction)PrivatePolicy:(id)sender
{
    
    AboutUsViewController *aboutus;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    aboutus.linkUrl=policyUrl;
    [self.navigationController pushViewController:aboutus  animated:YES];
}

- (IBAction)customerService:(id)sender
{
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
   
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)becomeDriverBtn:(id)sender {
    becomeDriverUrl=[NSString stringWithFormat:@"http://appba.riderapid.com/mds/?riderid=%@",[[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"]];

    
    AboutUsViewController *aboutus;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        aboutus = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    aboutus.linkUrl=becomeDriverUrl;
    [self.navigationController pushViewController:aboutus  animated:YES];
    
}
@end
