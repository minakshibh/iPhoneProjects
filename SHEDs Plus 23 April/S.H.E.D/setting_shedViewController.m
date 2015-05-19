//
//  setting_shedViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 1/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "setting_shedViewController.h"
#import "homescreenViewController.h"
#import "AppDelegate.h"
#import "aboutUsViewController.h"
#import "GratitudeArchieveViewController.h"
#import "passcodeOptionViewController.h"
#import "createahabitViewController.h"
#import "AppDelegate.h"
#import "PageWebViewController.h"


@interface setting_shedViewController ()

@end

@implementation setting_shedViewController
@synthesize headertitle,aboutusbtn,passcodebtn,ratebtn,gratitudeSettings,enablePopupBtn,popUpToggle,gratToggle,gratPopUp,actionsheet,pickdate,gratNotifyTime,pickrViewIpad,datePickerIpad,gratNotifyBtn,gratNotifyTitle,dailyGratReminderTitle,is24h,appDelegate,gratClickView,downArrow,sideArrow;
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    NSLog(@"%@",(is24h ? @"YES" : @"NO"));
    
    createahabitViewController *createVC = [[createahabitViewController alloc] init];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *popUp=[defaults valueForKey:@"PopUp"];
    NSLog(@"popup value %@",popUp);
    if ([popUp isEqualToString:@"1"])
    {
        [popUpToggle setOn:YES animated:YES];
    }
    else if ([popUp isEqualToString:@"0"])
    {
         [popUpToggle setOn:NO animated:YES];
    }
   
    NSString *gratPopUpView=[defaults valueForKey:@"GratitudePopUp"];
    
    if ([gratPopUpView isEqualToString:@"1"]) {
        [gratToggle setOn:YES animated:YES];
    }else{
        [gratToggle setOn:NO animated:YES];
    }
    NSString *gratPopUpTime=[defaults valueForKey:@"GratitudeTime"];
    if (gratPopUpTime == nil) {
        if (is24h)
        {
            gratNotifyTime.text = [NSString stringWithFormat:@"05:00"];
        }
        else{
            gratNotifyTime.text = [NSString stringWithFormat:@"05:00 AM"];
        }

        
    }else{
        if (is24h)
        {
            [gratNotifyTime setText:gratPopUpTime];
            NSLog(@"Alarm Time :-------------- %@",gratPopUpTime);
        }
        else
        {
            NSString *alarmTime=[NSString stringWithFormat:@"%@",gratPopUpTime];
            NSString  *timeValue=[alarmTime  substringWithRange:NSMakeRange(0, 2)];
            if ([timeValue intValue]>12){
                int hours=[timeValue intValue] -12;
                NSString *housStr=[NSString stringWithFormat:@"%d",hours];
                NSString *minutes=[alarmTime substringWithRange:NSMakeRange(3, 2)];
                [gratNotifyTime setText:[NSString stringWithFormat:@"%@:%@ pm",housStr,minutes]];
            }
            else{
                [gratNotifyTime setText:[NSString stringWithFormat:@"%@ am",alarmTime]];
            }
        }

    }
    

    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        [aboutusbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [passcodebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [ratebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [gratitudeSettings.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [enablePopupBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [gratNotifyTitle setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [dailyGratReminderTitle.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
    }
    else{
        [headertitle setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
        [aboutusbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:37]];
        [passcodebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:37]];
        [ratebtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:37]];
        [gratitudeSettings.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:37]];
        [enablePopupBtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:37]];
        [gratNotifyTitle setFont: [UIFont fontWithName:@"Lucida Sans" size:37]];
        [dailyGratReminderTitle.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:37]];
    }
     [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

}

- (IBAction)gratitudeToggle:(id)sender {
   
    if (gratToggle.on) {
        [gratToggle setOn:YES animated:YES];
        gratPopUp = gratToggle.on;
    }
    else{
        [gratToggle setOn:NO animated:YES];
        gratPopUp = 0;
    }
    
    NSLog(@"%d",gratPopUp);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSString stringWithFormat:@"%d",gratPopUp] forKey:@"GratitudePopUp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)gratitudeReminder:(id)sender {
    if (gratClickView.hidden == YES) {
        gratClickView.hidden = NO;
        downArrow.hidden = NO;
        sideArrow.hidden = YES;
    
    }else{
        gratClickView.hidden = YES;
        downArrow.hidden = YES;
        sideArrow.hidden = NO;
    }
    
}

- (IBAction)popUpToggle:(id)sender {
  
    if (popUpToggle.on)
    {
        [popUpToggle setOn:YES animated:YES];
    }
    else{
        [popUpToggle setOn:NO animated:YES];
    }
    NSLog(@"%hhd",popUpToggle.on);
    int popUp=popUpToggle.on;
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSString stringWithFormat:@"%d",popUp] forKey:@"PopUp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)gratitudeNotify:(id)sender {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *gratPopUpView=[defaults valueForKey:@"GratitudePopUp"];
    
    if ([gratPopUpView isEqualToString:@"1"]) {
        [self showPicker];
    }else{
        
    }
}
-(void) showPicker
{
    NSString *timestring = [[NSString alloc] initWithFormat:@"%@",gratNotifyTime.text];
    
    
    if (timestring.length>5)
    {
        NSLog(@"am pm format..");
        NSArray*temptimeArray = [timestring componentsSeparatedByString:@" "];
        NSString *isAmPm=[temptimeArray objectAtIndex:1];
        NSString  *timeValue=[timestring  substringWithRange:NSMakeRange(0, 2)];
        timestring=[timestring substringToIndex:5];
        
        if ([isAmPm isEqualToString:@"pm"]|| [isAmPm isEqualToString:@"PM"] || [isAmPm isEqualToString:@"Pm"])
        {
            int hours=[timeValue intValue] +12;
            if (hours == 24) {
                hours = 12;
            }
            NSString *housStr=[NSString stringWithFormat:@"%d",hours];
            NSString *minutes=[timestring substringWithRange:NSMakeRange(3, 2)];
            timestring =[NSString stringWithFormat:@"%@:%@",housStr,minutes];
        }
        else{
            int hours=[timeValue intValue];
            if (hours == 12) {
                hours =00;
            }
            NSString *housStr=[NSString stringWithFormat:@"%d",hours];
            NSString *minutes=[timestring substringWithRange:NSMakeRange(3, 2)];
            timestring =[NSString stringWithFormat:@"%@:%@",housStr,minutes];
        }
    }
    timestring = [[NSString alloc] initWithFormat:@"%@",timestring];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date4 = [dateFormat dateFromString:timestring];
    NSLog(@"THE TIME IS FROM THE LABEL: %@",timestring);
    NSLog(@"YOUR DATE: %@", date4);

    if (date4 ==nil)
    {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.hour = [[timestring substringToIndex:2] intValue];
        components.minute = [[timestring substringFromIndex:3] intValue];
        components.second=00;
        [components setTimeZone:[NSTimeZone systemTimeZone]];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        date4 = [calendar dateFromComponents:components];
        
        NSLog(@"YOUR DATE: %@", date4);
        NSLog(@"THE TIME IS FROM THE LABEL: %@",timestring);
        
    }
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
        [self showPicker:date4];
    }
    else{
        [[pickrViewIpad layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [[pickrViewIpad layer] setBorderWidth:1.0];
        [[pickrViewIpad layer] setCornerRadius:8];
        self.pickrViewIpad.hidden = NO;
        // HabittextfeildView.hidden=YES;
        datePickerIpad.datePickerMode = UIDatePickerModeTime;
        [datePickerIpad addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
        [datePickerIpad setDate:date4 animated: YES];
    }

}
- (IBAction)aboutusbtn:(id)sender {
    aboutUsViewController *aboutvc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        aboutvc = [[aboutUsViewController alloc] initWithNibName:@"aboutUsViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {

        aboutvc = [[aboutUsViewController alloc] initWithNibName:@"aboutUsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }else {
        aboutvc = [[aboutUsViewController alloc] initWithNibName:@"aboutUsViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    [self.navigationController pushViewController:aboutvc animated:NO];
}

- (IBAction)moveback:(id)sender {
    homescreenViewController *homevc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    } else {
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController pushViewController:homevc animated:NO];
}

- (IBAction)ratingbtn:(id)sender {
    
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id937139648"]];

    
//    if ([SKStoreProductViewController class]) {
//        SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
//        controller.delegate = self;
//        [controller loadProductWithParameters:@{ SKStoreProductParameterITunesItemIdentifier : @"937139648" }completionBlock:^(BOOL result, NSError *error)
//         {
//             if (error)
//             {
//                 NSString *errorString=[NSString stringWithFormat:@"Error %@ with User Info %@",error,[error userInfo]];
//                 NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
//                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"APP STORE" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                 [alert show];
//             }
//             else
//             {
//                 [self presentViewController:controller animated:YES completion:nil];
//             }
//         }];
//    }
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)postToFacebook:(id)sender {
//    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.facebookConnect=YES;
//    [appDelegate facebookIntegration];
//}


//- (IBAction)PostToFacebook:(id)sender {
//    
////    
//    //    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    //    appDelegate.facebookConnect=YES;
//    //    [appDelegate facebookIntegration];
//}

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


- (IBAction)GratitudeSettng:(id)sender {
    
    GratitudeArchieveViewController *gratitudeVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        gratitudeVc = [[GratitudeArchieveViewController alloc] initWithNibName:@"GratitudeArchieveViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        gratitudeVc = [[GratitudeArchieveViewController alloc] initWithNibName:@"GratitudeArchieveViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    } else {
        gratitudeVc = [[GratitudeArchieveViewController alloc] initWithNibName:@"GratitudeArchieveViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    [self.navigationController pushViewController:gratitudeVc animated:YES];
}

- (IBAction)passcodeBtn:(id)sender {
    passcodeOptionViewController *passcodeVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        passcodeVC = [[passcodeOptionViewController alloc] initWithNibName:@"passcodeOptionViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        passcodeVC = [[passcodeOptionViewController alloc] initWithNibName:@"passcodeOptionViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    } else {
        passcodeVC = [[passcodeOptionViewController alloc] initWithNibName:@"passcodeOptionViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    [self.navigationController pushViewController:passcodeVC animated:YES];
}
- (void)showPicker:(NSDate *)date
{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSLog(@"version..%@",currSysVer);
    
    
    if (([currSysVer compare:[NSString stringWithFormat:@"8.0"] options:NSNumericSearch] == NSOrderedSame) ||([currSysVer compare:[NSString stringWithFormat:@"8.0"] options:NSNumericSearch] == NSOrderedDescending) )
    {
        pickdate = [[UIDatePicker alloc] init];
        
        pickdate.hidden = NO;
        pickdate.datePickerMode = UIDatePickerModeTime;
        [pickdate addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
        //[actionsheet addSubview:pickdate];
        // [actionsheet showInView:self.view];
        // [actionsheet showFromRect:CGRectMake(0,480, 320,215) inView:self.view animated:YES];
        
        // [actionsheet setBounds:CGRectMake(0,0,320, 500)];
        
        CGRect pickerRect = pickdate.bounds;
        pickerRect.origin.y = 20;
        pickdate.bounds = pickerRect;
        NSDateFormatter*df=[[NSDateFormatter alloc]init];
        [df setDateFormat:@"HH:mm a"];
        NSString *ds=[df stringFromDate:date];
        
        
        [pickdate setDate:date animated: YES];
        
        UIView*testView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 303, 158)];
        [testView setBackgroundColor:[UIColor whiteColor]];
        [testView addSubview:pickdate];
        
        
        
       alertController = [UIAlertController
                                              alertControllerWithTitle:@"Hello"
                                              message:@"testing"
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        // [alertController.view addSubview:testView];
        
        
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"DONE" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self scheduleNotificationForDate];
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:nil];
        UIAlertAction *archiveAction =[UIAlertAction actionWithTitle:@"Archive" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [alertController addAction:archiveAction];
        
        [alertController.view insertSubview:testView atIndex:1];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"Select the Time" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"DONE" otherButtonTitles:Nil, nil];
        pickdate = [[UIDatePicker alloc] initWithFrame:[actionsheet bounds]];
        pickdate.hidden = NO;
        pickdate.datePickerMode = UIDatePickerModeTime;
        [pickdate addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
        [actionsheet addSubview:pickdate];
        [actionsheet showInView:self.view];
        [actionsheet setBounds:CGRectMake(0,0,320, 500)];
        
        CGRect pickerRect = pickdate.bounds;
        pickerRect.origin.y = -90;
        pickdate.bounds = pickerRect;
        NSDateFormatter*df=[[NSDateFormatter alloc]init];
        [df setDateFormat:@"HH:mm a"];
        NSString *ds=[df stringFromDate:date];
        
        
        [pickdate setDate:date animated: YES];
        
    }
    
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==5)
    {
        if (buttonIndex == 0)
        {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    else{
        if (buttonIndex == 0)
        {
//            NSUserDefaults * value1 = [NSUserDefaults standardUserDefaults];
//            NSString *myString = [value1 objectForKey:@"GratitudeDate"];
//            
//            if(myString==nil)
//                myString=@"";
//            
//            if ([myString isEqualToString:appDelegate.todaysDate]) {
//                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                NSString *gratPopUp=[defaults valueForKey:@"GratitudePopUp"];
//                
//                if ([gratPopUp isEqualToString:@"1"]) {
                    [self scheduleNotificationForDate];
//                }else{
//                    
//                }
//            }else{
//                
//            }

            actionsheet = Nil;
        }
    }
}



-(void) scheduleNotificationForDate {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *gratPopUpTime=[defaults valueForKey:@"GratitudeTime"];
    //     NSString *gratPopUpDate = [defaults objectForKey:@"gratitudeDate"];
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *curdate = [dateFormat dateFromString:gratPopUpDate];
    //
    //    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:curdate];
    NSArray *tempArray = [gratPopUpTime componentsSeparatedByString:@":"];
    NSDateComponents *dateParts = [[NSDateComponents alloc] init];
    //    NSLog(@"month %ld", (long)[components month]);
    //    NSLog(@"year %ld", (long)[components year]);
    //    NSLog(@"day %ld", (long)[components day]);
    NSLog(@"hour %d", [[tempArray objectAtIndex:0] intValue]);
    NSLog(@"minute %d", [[tempArray objectAtIndex:1] intValue]);
    
    [dateParts setHour:[[tempArray objectAtIndex:0] intValue]];
    [dateParts setMinute:[[tempArray objectAtIndex:1] intValue]];
    [dateParts setSecond:00];
    NSDate *sDate = [calendar dateFromComponents:dateParts];
    
    localNotif.fireDate = sDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.repeatInterval = NSWeekdayCalendarUnit;
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertBody = @"Add Your Gratitude";
    localNotif.soundName =UILocalNotificationDefaultSoundName;
    
    
    //NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"testId" forKey:@"ID"];
    // localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    NSLog(@"notification started");
}




- (IBAction)resignBtn:(id)sender {
    pickrViewIpad.hidden=YES;
    [self scheduleNotificationForDate];
    [self.view setUserInteractionEnabled:YES];
}
- (IBAction)changeDateInLabel:(NSDate*)date
{
    NSLog(@"I Am Changing the values");
    createahabitViewController *createVC = [[createahabitViewController alloc] init];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    if (is24h)
    {
        [timeFormat setDateFormat:@"HH:mm"];
    }
    else{
        [timeFormat setDateFormat:@"hh:mm a"];
    }
    [timeFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480))
    {
        NSString *theTime = [timeFormat stringFromDate:pickdate.date];
        NSLog(@"TIME IS:%@",theTime);
        gratNotifyTime.text = [NSString stringWithFormat:@"%@",[timeFormat stringFromDate:pickdate.date]];
    }
    else
    {
        NSString *theTime = [timeFormat stringFromDate:datePickerIpad.date];
        NSLog(@"TIME IS:%@",theTime);
        gratNotifyTime.text = [NSString stringWithFormat:@"%@",[timeFormat stringFromDate:datePickerIpad.date]];
    }
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *timeString = [NSString stringWithFormat:@"%@",gratNotifyTime.text];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

    if (is24h)
    {
        [defaults setValue:[NSString stringWithFormat:@"%@",timeString] forKey:@"GratitudeTime"];
    }
    else{
        NSArray*temptimeArray = [timeString componentsSeparatedByString:@" "];
        NSString *isAmPm=[temptimeArray objectAtIndex:1];
        NSString  *timeValue=[timeString  substringWithRange:NSMakeRange(0, 2)];
        timeString=[timeString substringToIndex:5];
        if ([isAmPm isEqualToString:@"pm"]|| [isAmPm isEqualToString:@"PM"] || [isAmPm isEqualToString:@"Pm"])
        {
            int hours=[timeValue intValue] +12;
            NSString *housStr;
            if (hours < 10) {
                housStr=[NSString stringWithFormat:@"0%d",hours];
            }else{
                housStr=[NSString stringWithFormat:@"%d",hours];
            }
            
            NSString *minutes=[timeString substringWithRange:NSMakeRange(3, 2)];
            timeString =[NSString stringWithFormat:@"%@:%@",housStr,minutes];
            [defaults setValue:[NSString stringWithFormat:@"%@",timeString] forKey:@"GratitudeTime"];
        }
        [defaults setValue:[NSString stringWithFormat:@"%@",timeString] forKey:@"GratitudeTime"];

    }
}




@end
