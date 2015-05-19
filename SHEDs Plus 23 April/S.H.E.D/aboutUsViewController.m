//
//  instructionDetailViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac_3 on 09/01/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "setting_shedViewController.h"
#import "aboutUsViewController.h"
#import "PageWebViewController.h"

@interface aboutUsViewController ()

@end

@implementation aboutUsViewController
@synthesize aboutUsDetailLabl, aboutUsTxtView;

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
        [aboutUsDetailLabl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];

    }
    else{
        [aboutUsDetailLabl setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
    }
   // aboutUsTxtView.font =[UIFont fontWithName:@"Lucida Sans" size:18];
   // aboutUsTxtView.textAlignment = UITextAlignmentLeft;
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BckToList:(id)sender {
    setting_shedViewController *settingvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController" bundle:nil];        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController_iphone4" bundle:nil];        // this is iphone 4 xib
    }
    else {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController_ipad" bundle:nil];        // this is iphone 4 xib
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    
    [self.navigationController pushViewController:settingvc animated:NO];
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
