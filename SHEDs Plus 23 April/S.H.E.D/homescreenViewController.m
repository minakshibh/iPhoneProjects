//
//  homescreenViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/20/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import "homescreenViewController.h"
#import "createahabitViewController.h"
#import "SHED_listViewController.h"
#import "AppDelegate.h"
#import "FMDatabaseAdditions.h"
#import "gratitude_listingViewController.h"
#import "Instructions_listViewController.h"
#import "mastered_shedViewController.h"
#import "setting_shedViewController.h"
#import "SHED.h"
#import "PageWebViewController.h"

@interface homescreenViewController ()

@end

@implementation homescreenViewController
@synthesize home_title,home_background,home_footer,sub_header,footer,title,addshedbtn,currentshedbtn,masteredshedbtn,gratitudebtn,instructionbtn,settingbtn,idstr,todaysShed,friendPickerController;
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    appDelegate.navigator.navigationBar.tintColor = [UIColor clearColor];

    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480))
    {
        [title setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        [addshedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:20]];
        [currentshedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:20]];
        [masteredshedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:20]];
        [gratitudebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:20]];
        [instructionbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:20]];
        [settingbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:20]];
        [todaysShed.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:20]];
    }
    else
    {
        [title setFont: [UIFont fontWithName:@"Helvetica Neue" size:85]];
        [addshedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:40]];
        [currentshedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:40]];
        [masteredshedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:40]];
        [gratitudebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:40]];
        [instructionbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:40]];
        [settingbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:40]];
        [todaysShed.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:40]];
    }
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inviteFriends:(id)sender {
    
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:[NSString stringWithFormat:@"I have been using this great App, SHEDs - Simple Habits Every Day, to get my life on track and firing. You must try it. It's awesome."]
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         }
         else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             }
             else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 }
                 else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
}

- (IBAction)likeBtn:(id)sender {
    
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
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (IBAction)createahabit:(id)sender {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    int workShedCount = [database intForQuery:[NSString stringWithFormat:@"SELECT COUNT(shed_id) FROM SHED where isMastered ='NO' and type = '%@'",@"work"]];
    int lifeShedCount = [database intForQuery:[NSString stringWithFormat:@"SELECT COUNT(shed_id) FROM SHED where isMastered ='NO' and type = '%@'",@"life"]];
    
    if (workShedCount >= 12 && lifeShedCount >= 12) {
        UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:@"Limit Reached " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [savealert show];
    }
    else
    {
        createahabitViewController *createhabit;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            createhabit = [[createahabitViewController alloc]initWithNibName:@"createahabitViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            createhabit = [[createahabitViewController alloc]initWithNibName:@"createahabitViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else{
            createhabit = [[createahabitViewController alloc]initWithNibName:@"createahabitViewController_ipad" bundle:nil];
            // this is ipad xib
        }
        createhabit.flag = 1;
        [self.navigationController pushViewController:createhabit animated:YES];
    }
}

- (IBAction)deleteahabit:(id)sender {
    SHED_listViewController *shedlist;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
         shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    shedlist.sortingString = [NSString stringWithFormat:@"Cronological"];
    shedlist.flag = 1;
    [self.navigationController pushViewController:shedlist animated:YES];
}

- (IBAction)gratitude:(id)sender {
    gratitude_listingViewController *gratvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        gratvc = [[gratitude_listingViewController alloc] initWithNibName:@"gratitude_listingViewController" bundle:Nil];      //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        gratvc = [[gratitude_listingViewController alloc] initWithNibName:@"gratitude_listingViewController_iphone4" bundle:Nil];            // this is iphone 4 xib
    }
    else{
        gratvc = [[gratitude_listingViewController alloc] initWithNibName:@"gratitude_listingViewController_ipad" bundle:Nil];            // this is ipad xib
    }

    [self.navigationController pushViewController:gratvc animated:YES];
}

- (IBAction)masteredhabit:(id)sender {
    //SHED *shed = [[SHED alloc] init];
    NSLog(@"SHED_Name %@",idstr);
    mastered_shedViewController *masteredvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        masteredvc = [[mastered_shedViewController alloc] initWithNibName:@"mastered_shedViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
        masteredvc = [[mastered_shedViewController alloc] initWithNibName:@"mastered_shedViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        masteredvc = [[mastered_shedViewController alloc] initWithNibName:@"mastered_shedViewController_ipad" bundle:Nil];
        // this is ipad xib
    }
    masteredvc.strid = idstr;
    [self.navigationController pushViewController:masteredvc animated:YES];
}

- (IBAction)settings:(id)sender {
    setting_shedViewController *settingvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        settingvc = [[setting_shedViewController alloc] initWithNibName:@"setting_shedViewController_ipad" bundle:Nil];
        // this is ipad xib
    }
    [self.navigationController pushViewController:settingvc animated:YES];
}

- (IBAction)delete:(id)sender {
}
#pragma mark -
#pragma mark Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}
- (IBAction)instruction:(id)sender {
   
    Instructions_listViewController *instructionvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        instructionvc = [[Instructions_listViewController alloc] initWithNibName:@"Instructions_listViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        instructionvc = [[Instructions_listViewController alloc] initWithNibName:@"Instructions_listViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        instructionvc = [[Instructions_listViewController alloc] initWithNibName:@"Instructions_listViewController_ipad" bundle:Nil];
        // this is ipad xib
    }
    [self.navigationController pushViewController:instructionvc animated:YES];
}

- (IBAction)todays_shed:(id)sender {
    SHED_listViewController *shedlist;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:nil];
            // this is ipad xib
    }
    
    shedlist.sortingString = [NSString stringWithFormat:@"Cronological"];
    shedlist.flag = 0;
    [self.navigationController pushViewController:shedlist animated:YES];
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
