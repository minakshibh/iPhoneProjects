//
//  habitstatisticsViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/28/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import "habitstatisticsViewController.h"
#import "FMResultSet.h"
#import "SHED_listViewController.h"
#import "createahabitViewController.h"


static int calendarShadowOffset = (int)-25;

@interface habitstatisticsViewController ()

@end

@implementation habitstatisticsViewController
@synthesize datelbl,shed,databasePath,habitstatslist,longrunlbl,currentrunlbl,rowData,calendar,deleteshedbtn,editshedbtn,masteredbtn,titlelbl,habitstotaldays,habitpercentdays,daysappliedbtn,backbtn,daysappliednamelbl,startdatenamelbl,totaldaysnamelbl,percentdaysnamelbl,currentrunnamelbl,longestrunnamelbl,habit_view,date1,data1,marks,comp,masteredstr,flag,tabstring,appDelegate,totaldaysSelected,data3,shed_Data,indexList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        calendar = 	[[TKCalendarMonthView alloc] init];
        calendar.delegate = self;
        calendar.dataSource = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    daysappliedbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn = [UIButton buttonWithType:UIButtonTypeCustom];

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        habitpercentdays = [[UILabel alloc] initWithFrame:CGRectMake(207, 400, 93, 26)];
        habitstotaldays = [[UILabel alloc] initWithFrame:CGRectMake(207, 275, 93, 26)];
        daysappliedbtn.frame = CGRectMake(0, 335, 303, 40);
        backbtn.frame = CGRectMake(5, 19, 60, 40);
        [habitpercentdays setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [habitstotaldays setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [daysappliedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [startdatenamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [daysappliednamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [percentdaysnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [totaldaysnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [currentrunnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [longestrunnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [datelbl setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        [longrunlbl setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [currentrunlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:19]];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480){
        habitpercentdays = [[UILabel alloc] initWithFrame:CGRectMake(207, 345, 93, 26)];
        habitstotaldays = [[UILabel alloc] initWithFrame:CGRectMake(207, 245, 93, 26)];
        daysappliedbtn.frame = CGRectMake(0, 285, 303, 40);
        backbtn.frame = CGRectMake(5, 19, 60, 40);
        [habitstotaldays setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [daysappliedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [habitpercentdays setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [startdatenamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [daysappliednamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [percentdaysnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [totaldaysnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [currentrunnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [longestrunnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [datelbl setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        [longrunlbl setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
        [currentrunlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:19]];
        // this is iphone 4 xib
    }
    else
    {
        habitpercentdays = [[UILabel alloc] initWithFrame:CGRectMake(573, 595, 170, 35)];
        habitstotaldays = [[UILabel alloc] initWithFrame:CGRectMake(573, 418, 170, 35)];
        daysappliedbtn.frame = CGRectMake(427, 495, 303, 40);
        backbtn.frame = CGRectMake(15, 22, 128, 95);
        [habitpercentdays setFont: [UIFont fontWithName:@"Lucida Sans" size:30]];
        [habitstotaldays setFont: [UIFont fontWithName:@"Lucida Sans" size:30]];
        [daysappliedbtn.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:30]];
        [startdatenamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [daysappliednamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [percentdaysnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [totaldaysnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [currentrunnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [longestrunnamelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [datelbl setFont: [UIFont fontWithName:@"Lucida Sans" size:30]];
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:48]];
        [longrunlbl setFont: [UIFont fontWithName:@"Lucida Sans" size:30]];
        [currentrunlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        // this is ipad xib
    }
    
    habitpercentdays.textAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:habitpercentdays];
    
    habitstotaldays.textAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:habitstotaldays];
    
    [daysappliedbtn addTarget:self action:@selector(daysapplied:) forControlEvents:UIControlEventTouchUpInside];
    [daysappliedbtn setTitleColor:[UIColor colorWithRed:50/255.0f green:121/255.0f blue:25/255.0f alpha:1] forState:UIControlStateNormal];
    
    daysappliedbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:daysappliedbtn];
 
    [backbtn addTarget:self action:@selector(moveback:) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    backbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:backbtn];
    
     NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *changedDate = [formatter1 dateFromString:shed.start_date];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"MM-dd-yyyy"];

    NSString* todaydate = [df stringFromDate:changedDate];
    NSLog(@"My Date %@", todaydate);

    self.datelbl.text =[NSString stringWithFormat:@"%@",todaydate];
    UIImage *deleteimg = [UIImage imageNamed:@"deleteShed-icon.png"];
    [deleteshedbtn setBackgroundImage:deleteimg forState:UIControlStateNormal];
    
    UIImage *editimg = [UIImage imageNamed:@"editShed-icon.png"];
    [editshedbtn setBackgroundImage:editimg forState:UIControlStateNormal];
    
    UIImage *masterimg = [UIImage imageNamed:@"masteredShed-icon.png"];
    [masteredbtn setBackgroundImage:masterimg forState:UIControlStateNormal];
    titlelbl.text = shed.name;
   
    NSLog(@"SHED DATE: %@", shed.start_date);
    NSLog(@"SHED DAYS: %@", shed.alarm_days);
    NSLog(@"ROW DATA :: %@", shed.alarm_days);
//    NSString *queryString = [NSString stringWithFormat:@"Select current_run, longest_run FROM Shed_Data Group By id Having followed_date = Max(followed_date) And id = \"%@\"",shed.shed_id];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
//    
//    FMResultSet *results = [database executeQuery:queryString];
    rowData = [[NSMutableArray alloc] init];
//    NSLog(@"I AM HERE");
//    while([results next]) {
//
//        shed.current_run = [results intForColumn:@"current_run"];
//        shed.longest_run = [results intForColumn:@"longest_run"];
//        
//        }
    NSString *dateQuery = [NSString stringWithFormat:@"Select * from Shed_Data where id = \"%@\" order by followed_date ASC ",shed.shed_id];
    FMResultSet *dateSet = [database executeQuery:dateQuery];
    shed_Data.current_run = 0;
    shed_Data.longest_run = 0;
    
    while([dateSet next]) {
        NSString *followedDate = [dateSet stringForColumn:@"followed_date"];
        
        [rowData addObject:followedDate];
        shed_Data = [[shed_data alloc]init];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *followed_date = [formatter dateFromString:followedDate];
        
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        NSDate *current_date = [formatter1 dateFromString:appDelegate.todaysDate];

//        if([followed_date compare:current_date] == NSOrderedSame){
            shed_Data.current_run = [dateSet intForColumn:@"current_run"];
//        }else{
//           // shed_Data.current_run = 0;
//        }
        
        shed_Data.longest_run = [dateSet intForColumn:@"longest_run"];
        }
    shed.datesArray = rowData;
    shed.followed_date = [dateSet stringForColumn:@"followed_date"];
    shed.applieddays = [rowData count];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *datetoday = [formatter dateFromString:appDelegate.todaysDate];
    NSString* todaysdate = [formatter stringFromDate:datetoday];
    NSLog(@"My Date %@", todaysdate);
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [format dateFromString:shed.start_date];
    
    NSDate *endDate = [format dateFromString:todaysdate];
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *totaldays1 = [gregorianCalendar components:NSDayCalendarUnit
                                                       fromDate:startDate
                                                         toDate:endDate
                                                        options:0];
    totaldaysSelected = [totaldays1 day];
    //if(shed.totaldays==0)
        totaldaysSelected+=1;
    int TotalDaysCounted = 0;
    
    NSString *daysString = [NSString stringWithFormat:@"%@",shed.alarm_days];
    NSLog(@"Days To add %@", daysString);
    
    NSArray *daysstr = [shed.alarm_days componentsSeparatedByString:@","];
    
    NSLog(@"Selected Days Name: %@", daysstr);
    
    
    data3 = [[NSMutableArray alloc]init];
    
    int i;
    for (i = 0; i < [daysstr count]; i++) {
        NSString* myArrayElement = [daysstr objectAtIndex:i];
        int index = [self getindex:myArrayElement];
        
        int occurence = [self cal:totaldaysSelected :startDate :index];
        TotalDaysCounted += occurence;
    }
    
    shed.totaldays = TotalDaysCounted;
    
    if(shed.totaldays==0)
        shed.percentage = 0;
    else
        shed.percentage = ((float)shed.applieddays/(float)shed.totaldays)*100;
    
    NSString *percentdaysstr = [NSString stringWithFormat:@"%.0f %%", shed.percentage];
    NSString *totaldaysstr = [NSString stringWithFormat:@"%d", shed.totaldays];
    NSString *applieddaysstr = [NSString stringWithFormat:@"%d", shed.applieddays];
    NSString *currentRun = [NSString stringWithFormat:@"%d", shed_Data.current_run];
    NSString *longestRun = [NSString stringWithFormat:@"%d", shed_Data.longest_run];
    habitpercentdays.text = percentdaysstr ;
    habitstotaldays.text = totaldaysstr;
    [daysappliedbtn setTitle:applieddaysstr forState:UIControlStateNormal];
    currentrunlbl.text = currentRun;
    longrunlbl.text = longestRun;
    NSLog(@"start date %@", shed.start_date);
    NSLog(@"Applied Days %d", shed.applieddays);
    NSLog(@"Total Days %d", shed.totaldays);
    NSLog(@"Percentage %f", shed.percentage);
    NSLog(@"current run %d", shed_Data.current_run);
    NSLog(@"longest run %d", shed_Data.longest_run);
    
    
//    if(shed.applieddays==0){
//        NSLog(@"array empty");
//    }else{
//        NSLog(@"array not empty");
//    }
//
//    int crun;
//    int lrun;
//    bool isInLoop = false;
//    
//    if([rowData count]>0){
//        crun = 1;
//        lrun = 1;
//    }else{
//        crun = 0;
//        lrun = 0;
//    }
// //   NSLog(@"rowdata size %lu",(unsigned long)[rowData count]);
//    
//    for (int i = 0; i<[rowData count] ; i++) {
//        
//        if(i<([rowData count]-1)){
//            NSLog(@"Date is :: %@",[rowData objectAtIndex:i]);
//            NSDateFormatter *format = [[NSDateFormatter alloc] init];
//            [format setDateFormat:@"yyyy-MM-dd"];
//            NSDate *startDate = [format dateFromString:[rowData objectAtIndex:i]];
//            NSDate *endDate = [format dateFromString:[rowData objectAtIndex:i+1]];
//            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
//                                                               fromDate:startDate
//                                                                 toDate:endDate
//                                                                options:0];
//            NSLog(@"Days Difference %@",totaldays);
//            if ([totaldays day] <= 1) {
//                isInLoop = true;
//                
//                crun++;
//                if (crun > lrun) {
//                    lrun = crun;
//                }
//            }else
//            {
//                isInLoop = false;
//                crun = 1;
//            }
//        }else{
//            NSLog(@"date %@",appDelegate.todaysDate);
//            NSDateFormatter *format = [[NSDateFormatter alloc] init];
//            [format setDateFormat:@"yyyy-MM-dd"];
//            
//            
//            NSDate *startDate = [format dateFromString:[rowData objectAtIndex:i]];
//           
//            NSDate *date2 = [format dateFromString:appDelegate.todaysDate];
//            NSString *cDate = [format stringFromDate:date2];
//            NSDate *tDate = [format dateFromString:cDate];
//            if([startDate isEqualToDate:tDate]){
//                if([rowData count]>1){
//                    if(!isInLoop){
//                        crun = 1;
//                    }
//                }else{
//                    crun = 1;
//                    lrun = 1;
//                }
//            }else{
//                crun = 0;
//            }
//        }
//        
////        NSLog(@"CURRENT RUN ::::%d",crun);
////        NSString *currentrunstr = [NSString stringWithFormat:@"%d", crun];
////        currentrunlbl.text = currentrunstr;
////        NSString *longestrunstr = [NSString stringWithFormat:@"%d", lrun];
////        NSLog(@"LONGEST RUN ::::%d",lrun);
////        longrunlbl.text = longestrunstr;
//    }
//    
////    if ([longestrunstr isEqualToString:@""]) {
////        longrunlbl.text = @"0";
////    }
////    else
////    {
////        longrunlbl.text = longestrunstr;
////    }
////    [currentrunlbl setFont: [UIFont fontWithName:@"Lucida Sans" size:19]];
////    if ([currentrunstr isEqualToString:@""]) {
////        currentrunlbl.text = @"0";
////    }
////    else{
////        currentrunlbl.text = currentrunstr;
////    }
//    
    [database close];
//    
//    NSLog(@"CURRENT RUN ::::%d",crun);
//    NSString *currentrunstr = [NSString stringWithFormat:@"%d", crun];
//    currentrunlbl.text = currentrunstr;
//    NSString *longestrunstr = [NSString stringWithFormat:@"%d", lrun];
//    NSLog(@"LONGEST RUN ::::%d",lrun);
//    longrunlbl.text = longestrunstr;
//    
//    

    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        calendar.frame = CGRectMake(0, -calendar.frame.size.height+calendarShadowOffset, calendar.frame.size.width, calendar.frame.size.height);

        }
    else {
        calendar.frame = CGRectMake(250, -calendar.frame.size.height+calendarShadowOffset, calendar.frame.size.width, calendar.frame.size.height);
 
    }
	// Ensure this is the last "addSubview" because the calendar must be the top most view layer
	[self.view addSubview:calendar];
	[calendar reload];
        NSLog(@"Done getting calender there!");
    // Do any additional setup after loading the view from its nib.
    
    
    createahabitViewController *createshed ;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        createshed = [[createahabitViewController alloc] initWithNibName:@"createahabitViewController" bundle:nil];
        
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        
        createshed = [[createahabitViewController alloc] initWithNibName:@"createahabitViewController_iphone4" bundle:nil];
        
        // this is iphone 4 xib
    }else {
        createshed = [[createahabitViewController alloc] initWithNibName:@"createahabitViewController_ipad" bundle:nil];
        
        // this is iphone 4 xib
    }
   
    createshed.habitname.titleLabel.text = shed.name;
    [self.navigationController pushViewController:createshed animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)moveback:(id)sender
{
    SHED_listViewController *shedlist;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }else {
        shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:nil];
        // this is iphone 4 xib
    }
    shedlist.sortingString = [NSString stringWithFormat:@"Cronological"];
    shedlist.flag = flag;
    shedlist.sortingString = tabstring;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController pushViewController:shedlist animated:NO];
}
- (IBAction)daysapplied:(id)sender {
    
    if (calendar.frame.origin.y == -calendar.frame.size.height+calendarShadowOffset) {
		// Show
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){

            calendar.frame = CGRectMake(0, 12, calendar.frame.size.width, calendar.frame.size.height);
        }
        else
        {
            calendar.frame = CGRectMake(250, 15, calendar.frame.size.width, calendar.frame.size.height);

        }
		[UIView commitAnimations];
        NSLog(@"Calendar Appair");
    }
    else
    {
		// Hide
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.75];
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){

		calendar.frame = CGRectMake(0, -calendar.frame.size.height+calendarShadowOffset+12, calendar.frame.size.width, calendar.frame.size.height);
        }
        else{
            calendar.frame = CGRectMake(250, -calendar.frame.size.height+calendarShadowOffset+15, calendar.frame.size.width, calendar.frame.size.height);

        }
		[UIView commitAnimations];
        [daysappliedbtn setTitle:@"" forState:UIControlStateNormal];
        habitpercentdays.text = @"";
        currentrunlbl.text = @"";
        longrunlbl.text = @"";
        habitstotaldays.text = @"";
        [self viewDidLoad];
        NSLog(@"Calendsr Disappairs");
	}

}

- (IBAction)masteredshed:(id)sender {
    if (shed.applieddays >= 21) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well done. You have performed the SHED for 21 days" message:@"Do you wish to transfer to Mastered SHEDs?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag =1;
        [alert show];
        
    }
    
     else if (shed.applieddays < 21){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You havn't performed the SHED for 21 days" message:@"Are you sure you have mastered this SHED?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag =1;
        [alert show];
     }
   }
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 1)
    {
        
        for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if ([notify.alertBody isEqualToString:shed.name]) {
                NSLog(@"the notification this is canceld is %@", notify.alertBody);
                
                [[UIApplication sharedApplication] cancelLocalNotification:notify] ; // delete the notification from the system
                
            }
            
        }
        
        //        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString *documentsDir = [docPaths objectAtIndex:0];
        //        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        NSString *isMastered = [[NSString alloc] initWithFormat:@"YES"];
        //        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE SHED SET isMastered = \"%@\" , masteredDate = \"%@\" where shed_id = \"%@\"", isMastered, appDelegate.todaysDate, shed.shed_id];
        
        [database executeUpdate:insertSQL];
        
        [database close];
//        NSArray *docPaths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDir1 = [docPaths1 objectAtIndex:0];
//        NSString *dbPath1 = [documentsDir1   stringByAppendingPathComponent:@"shed_db.sqlite"];
//        FMDatabase *database1 = [FMDatabase databaseWithPath:dbPath1];
//        [database1 open];
//        NSString *updateMasterDate = [NSString stringWithFormat:@"UPDATE Shed_Data SET masteredDate = \"%@\" where id = \"%@\" and followed_date = (select Max(followed_date) from Shed_Data)",appDelegate.todaysDate, shed.shed_id];
//        [database1 executeUpdate:updateMasterDate];
//        [database1 close];
        
        SHED_listViewController *shedlist ;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];
            //this is iphone 5 xib
        } else if ([[UIScreen mainScreen] bounds].size.height == 480)  {
            shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else{
            shedlist = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:nil];
  
        }
        shedlist.flag=flag;
        shedlist.sortingString = [NSString stringWithFormat:@"Cronological"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
        
        
        [self.navigationController pushViewController:shedlist animated:NO];
    }
    else if (buttonIndex == 0 && alertView.tag == 2)
    {
        //        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString *docsPath = [paths objectAtIndex:0];
        //        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"shed_db.sqlite"];
        int shedid = [shed.shed_id intValue];
        NSLog(@"shed id of deleting shed is %d",shedid);
        //        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM shed WHERE  shed_id = \"%d\"",shedid] ;
        NSString *deletedataQuery = [NSString stringWithFormat:@"DELETE FROM Shed_Data WHERE id = \"%d\"",shedid] ;
        shed.isBeingFollowedToday = NO;
        
        [database executeUpdate:deletedataQuery];
        [database executeUpdate:deleteQuery];
        [database close];
        
        for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if ([notify.alertBody isEqualToString:shed.name]) {
                NSLog(@"the notification this is canceld is %@", notify.alertBody);
                
                [[UIApplication sharedApplication] cancelLocalNotification:notify] ; // delete the notification from the system
                
            }
            
        }
        
        
        NSLog(@"Clicked button index 0 of second alert");
        
        SHED_listViewController *shedList;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            shedList = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {

            shedList = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:Nil];

        }
        else {
            shedList = [[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:Nil];
            // this is iphone 4 xib
        }
    
        
        shedList.flag = flag;
        shedList.sortingString = [NSString stringWithFormat:@"Cronological"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:shedList animated:NO];
        
        NSLog(@"SHED REMOVED");
        NSLog(@"Clicked button index 0");
    }
    else
    {
        NSLog(@"Clicked button index other than 0");
        // Add another action here
    }
    
}

#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
   
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:d];
    int day = [component weekday];
    NSLog(@"Day INdex is %d",day);

    NSString *dayString = [self getDay:day];
    NSLog(@"Day Name is %@",dayString);
//    NSMutableArray *daynamearray = [[NSMutableArray alloc]init];
//    [daynamearray addObject:shed.alarm_days];
//    NSLog(@"Day Name Array is %@",daynamearray);
//    if ([daynamearray containsObject:dayString]) {
//        [self checkDate:d];
//    }else{
//        
//    }
    
    if ([shed.alarm_days rangeOfString:dayString].location == NSNotFound) {
        NSLog(@"string does not contain specified date");
    } else {
        [self checkDate:d];
    }
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
	NSLog(@"calendarMonthView monthDidChange");
}

#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {
	NSLog(@"calendarMonthView marksFromDate toDate");
	NSLog(@"Make sure to update 'data' variable to pull from CoreData, website, User Defaults, or some other source.");
	// When testing initially you will have to update the dates in this array so they are visible at the
	// time frame you are testing the code.
    
    NSLog(@"SHED ID %@",shed.shed_id);
    data1 = [[NSMutableArray alloc] init];
//	NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [docPaths objectAtIndex:0];
//    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    NSString *dateQuery = [NSString stringWithFormat:@"Select followed_date from Shed_Data where id = \"%@\"",shed.shed_id];
//    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    FMResultSet *results = [database executeQuery:dateQuery];
    while([results next]) {
        [rowData addObject:[results stringForColumn:@"followed_date"]];
    }
    shed.datesArray = rowData;
    // NSString *str = shed.datesArray;
    //NSString *str2 = [ shed.datesArray componentsJoinedByString:@","];
    for (int i =0; i < [shed.datesArray count]; i++) {
        NSString *str3 = [[NSString alloc] initWithFormat:@"%@ 00:00:00 +0000",[shed.datesArray objectAtIndex:i]];
        NSLog(@"data array %@",str3);
        [data1 addObject:str3];
        
    }
    NSLog(@"array of updated dates %@",data1);
    
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first
	// iterating date then times would go up and down based on daylight savings.
	comp = [cal components: NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit
                  fromDate:startDate];
    
	NSDate *d = [cal dateFromComponents:comp];
    //int daysToAdd = 1;
    // NSDate *newDate1 = [d dateByAddingTimeInterval:60*60*24*daysToAdd];
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
	[offsetComponents setDay:1];
	
    // for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
		// Increment day using offset components (ie, 1 day in this instance)
		
        
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		NSLog(@"d values %@",d);
        NSLog(@"d's descriptiion %@",[d description]);
		// If the date is in the data array, add it to the marks array, else don't
		if ([data1 containsObject:[d description] ])
            
        {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	//[offsetComponents release];
	[database close];
	return [NSArray arrayWithArray:marks];
}
- (IBAction)editshed:(id)sender {
    createahabitViewController *createshed;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        createshed = [[createahabitViewController alloc]initWithNibName:@"createahabitViewController" bundle:nil];            //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {

        createshed = [[createahabitViewController alloc]initWithNibName:@"createahabitViewController_iphone4" bundle:nil];            // this is iphone 4 xib
    }
    else
    {
        createshed = [[createahabitViewController alloc]initWithNibName:@"createahabitViewController_ipad" bundle:nil];            // this is ipad xib
    }

    createshed.flag= 2;
    //NSString *namestr = [[NSString alloc] initWithFormat:@"%@",shed];
    
    createshed.shedobj = shed;
    NSLog(@"SHED  :----------%@",shed.alarm_days);
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController pushViewController:createshed animated:NO];
}
- (IBAction)deleteshed:(id)sender {
    NSLog(@"SHED id On delete button %@", shed.shed_id);
    
    NSString *str1 = [NSString stringWithFormat:@"Delete \"%@",shed.name];
    NSRange stringRange = {0, MIN([str1 length], 40)};
    
    // adjust the range to include dependent chars
    stringRange = [str1 rangeOfComposedCharacterSequencesForRange:stringRange];
    
    // Now you can create the short string
    NSString *shortString = [str1 substringWithRange:stringRange];
    UIAlertView *alert;
    if (str1.length <= 40) {
       alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@\"",shortString] message:@"Are you sure?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    }else{
        alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@...\"",shortString] message:@"Are you sure?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    }
    alert.tag =2;
    [alert show];
    }

-(int) cal:(int)totalDays :(NSDate *) startDate :(int) ds
{
    int reminder,start_Index,rem_Index;
    
    int exactMultiple = (totalDays)/7;
    reminder = (totalDays)%7;
    NSCalendar* calender = [NSCalendar currentCalendar];
    NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:startDate];
    int day = [component weekday];
    day = day - 1;
    
    if(day == 0)
        day = 7;
    
    start_Index = day;
    
    if(reminder>0){
        rem_Index = start_Index + reminder - 7;
        
        if (rem_Index <= 0) {
            rem_Index = rem_Index+7;
        
        
            if(ds==7){
                if(ds < rem_Index) {
                    exactMultiple++;
                }

            }else{
                if (ds >= start_Index && ds < rem_Index) {
                    exactMultiple++;
                }
            }
        }else{
            if (ds >= start_Index || ds < rem_Index) {
                exactMultiple++;
            }
        }
//        
//        if (ds < rem_Index) {
//            exactMultiple++;
//        }
    }
    
    NSLog(@"Exact Multiple is %d", exactMultiple);
    return exactMultiple;
}

-(int) getindex:(NSString*) mystring
{
    if ([mystring isEqualToString:@"Monday"]) {
        NSLog(@"Exact Multiple is Monday");
        return 1;
    }else if ([mystring isEqualToString:@"Tuesday"]) {
        NSLog(@"Exact Multiple is Tuesday");
        return 2;
    }else if ([mystring isEqualToString:@"Wednesday"]) {
        NSLog(@"Exact Multiple is Wednesday");
        return 3;
    }else if ([mystring isEqualToString:@"Thursday"]) {
        NSLog(@"Exact Multiple is Thursday");
        return 4;
    }else if ([mystring isEqualToString:@"Friday"]) {
        NSLog(@"Exact Multiple is Friday");
        return 5;
    }else if ([mystring isEqualToString:@"Saturday"]) {
        NSLog(@"Exact Multiple is Saturday");
        return 6;
    }else {
        NSLog(@"Exact Multiple is Sunday");
        return 7;
    }
}

- (IBAction)backbtn:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480))
    {
        calendar.frame = CGRectMake(0, -calendar.frame.size.height+calendarShadowOffset+12, calendar.frame.size.width, calendar.frame.size.height);
    }
    else
    {
        calendar.frame = CGRectMake(250, -calendar.frame.size.height+calendarShadowOffset+15, calendar.frame.size.width, calendar.frame.size.height);
    }
    [UIView commitAnimations];
    NSLog(@"Calendsr Disappairs");
}
-(NSString*) getDay:(int) index
{
    if (index == 1) {
        return @"Sunday";
    }else if (index == 2) {
        return @"Monday";
    }else if (index == 3) {
        return @"Tuesday";
    }else if (index == 4) {
        return @"Wednesday";
    }else if (index == 5) {
        return @"Thursday";
    }else if (index == 6) {
        return @"Friday";
    }else {
        return @"Saturday";
    }
}
-(void) checkDate:(NSDate*) d
{
   
    NSDateFormatter* format1 = [[NSDateFormatter alloc] init] ;
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString* cd= [format1 stringFromDate:d];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* todaysdate = [formatter stringFromDate:d];
    NSString *appndString=[[NSString alloc]initWithFormat:@"%@ 00:00:00 +0000",todaysdate];
    NSLog(@"string SelectDate %@",appndString);
    NSLog(@"calendarMonthView didSelectDate %@",d);
    NSLog(@"shed dates.. %@",shed.datesArray);
    for (int i =0; i < [shed.datesArray count]; i++) {
        NSString *str3 = [[NSString alloc] initWithFormat:@"%@ 00:00:00 +0000",[shed.datesArray objectAtIndex:i]];
        NSLog(@"data array %@",str3);
        [data1 addObject:str3];
    }
    NSLog(@"array of updated dates %@",data1);
    NSDate *currentDate=[NSDate date];
    NSLog(@"currnt date. %@",currentDate);
    NSLog(@"selectd date.. %@",d);
    
    NSLog(@"start date.. %@",shed.start_date);
    NSDateFormatter* format = [[NSDateFormatter alloc] init] ;
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* cdate = [format dateFromString:shed.start_date];
    if ([data1 containsObject:appndString] )
    {
       // if ([cd compare:appDelegate.todaysDate] == NSOrderedSame) {
//        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *docsPath = [paths objectAtIndex:0];
//        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"shed_db.sqlite"];
        int shedid = [shed.shed_id intValue];
        NSLog(@"shed id of deleting shed is %d",shedid);
//        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM Shed_Data WHERE followed_date =\"%@\" and id = \"%d\"",todaysdate,shedid] ;
        
        shed.isBeingFollowedToday = NO;
        [database executeUpdate:deleteQuery];
        [database close];
        //[calendar reload];
        
        NSString *currentRunQueryString = [NSString stringWithFormat:@"SELECT * FROM Shed_Data where followed_date > '%@' And id = %@ order by followed_date ASC",todaysdate,shed.shed_id];
        //        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //        NSString *documentsDir = [docPaths objectAtIndex:0];
        //        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        
        //        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        FMResultSet *results = [database executeQuery:currentRunQueryString];
        
        while ([results next]) {
            shed_Data = [[shed_data alloc]init];
            shed_Data.followed_date = [results stringForColumn:@"followed_date"];
            
            NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init] ;
            [formatter2 setDateFormat:@"yyyy-MM-dd"];
            NSDate *ticked_date = [formatter2 dateFromString:shed_Data.followed_date];
            flag = 4;
            [self get_runs:ticked_date];
            
        }
        [database close];
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.0];
		
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
            calendar.frame = CGRectMake(0, -calendar.frame.size.height+calendarShadowOffset+12, calendar.frame.size.width, calendar.frame.size.height);
        }
        else{
            calendar.frame = CGRectMake(250, -calendar.frame.size.height+calendarShadowOffset+15, calendar.frame.size.width, calendar.frame.size.height);

        }
		[UIView commitAnimations];
        [daysappliedbtn setTitle:@"" forState:UIControlStateNormal];
        habitpercentdays.text = @"";
        currentrunlbl.text = @"";
        longrunlbl.text = @"";
        habitstotaldays.text = @"";
        [self viewDidLoad];
        
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.0];
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){

            calendar.frame = CGRectMake(0, 12, calendar.frame.size.width, calendar.frame.size.height);
        }
        else{
            calendar.frame = CGRectMake(250, 15, calendar.frame.size.width, calendar.frame.size.height);

        }
        [UIView commitAnimations];

        NSLog(@"SHED REMOVED");
    //}
    }
    else if((![data1 containsObject:appndString]) && ([d compare:currentDate]==NSOrderedAscending) && ([d compare:cdate]==NSOrderedDescending)){
        [self cal_Runs:d];

        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.0];
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){

		calendar.frame = CGRectMake(0, -calendar.frame.size.height+calendarShadowOffset+12, calendar.frame.size.width, calendar.frame.size.height);
        }
        else{
            calendar.frame = CGRectMake(250, -calendar.frame.size.height+calendarShadowOffset+15, calendar.frame.size.width, calendar.frame.size.height);

        }
		[UIView commitAnimations];
        [daysappliedbtn setTitle:@"" forState:UIControlStateNormal];
        habitpercentdays.text = @"";
        currentrunlbl.text = @"";
        longrunlbl.text = @"";
        habitstotaldays.text = @"";
        [self viewDidLoad];
        
        
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:.0];
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){

		calendar.frame = CGRectMake(0, 12, calendar.frame.size.width, calendar.frame.size.height);
        }
        else{
            calendar.frame = CGRectMake(250, 15, calendar.frame.size.width, calendar.frame.size.height);

        }
		[UIView commitAnimations];
//    }
}
}
-(void)cal_Runs:(NSDate*) cd
{
//    NSArray *daysstr = [shed.alarm_days componentsSeparatedByString:@","];
//    
//    NSLog(@"Selected Days Name: %@", daysstr);
//    
//    int i;
//    for (i = 0; i < [daysstr count]; i++) {
//        NSString* myArrayElement = [daysstr objectAtIndex:i];
//        int indexValue = [self getindex:myArrayElement];
//        [indexList addObject:[NSNumber numberWithInt:indexValue]];
//    }
//    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
//    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
//    NSArray *reverseOrder=[indexList sortedArrayUsingDescriptors:descriptors];
//    NSLog(@"Sorted Array %@",reverseOrder);

    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *current_date = [formatter1 dateFromString:appDelegate.todaysDate];
    NSArray *daysstr = [shed.alarm_days componentsSeparatedByString:@","];
    NSLog(@"Selected Days Name: %@", daysstr);
    indexList = [[NSMutableArray alloc]init];
   // [indexList removeAllObjects];
    int i;
    for (i = 0; i < [daysstr count]; i++) {
        NSString* myArrayElement = [daysstr objectAtIndex:i];
        int indexValue = [self getindex:myArrayElement];
        [indexList addObject:[NSNumber numberWithInt:indexValue]];
    }
    
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *reverseOrder=[indexList sortedArrayUsingDescriptors:descriptors];
    NSLog(@"Sorted Array %@",reverseOrder);

    
    
    if ([cd compare:current_date] == NSOrderedSame) {
        [self get_runs:current_date];
        
        shed.isBeingFollowedToday = YES;
        shed.applieddays+=1;
        if (shed.applieddays >= 21) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well done. You have performed the SHED for 21 days" message:@"Do you wish to transfer to Mastered SHEDs?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            alert.tag =1;
            [alert show];
            
        }
        
    } else{
        [self get_runs:cd];
       
        NSDateFormatter* format1 = [[NSDateFormatter alloc] init] ;
        [format1 setDateFormat:@"yyyy-MM-dd"];
        NSString* stringDate= [format1 stringFromDate:cd];
        
        
        NSString *currentRunQueryString = [NSString stringWithFormat:@"SELECT * FROM Shed_Data where followed_date > '%@' And id = %@ order by followed_date ASC",stringDate,shed.shed_id];
//        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDir = [docPaths objectAtIndex:0];
//        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        
//        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        FMResultSet *results = [database executeQuery:currentRunQueryString];
       
        while ([results next]) {
            shed_Data = [[shed_data alloc]init];
            shed_Data.followed_date = [results stringForColumn:@"followed_date"];
            
            NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init] ;
            [formatter2 setDateFormat:@"yyyy-MM-dd"];
            NSDate *ticked_date = [formatter2 dateFromString:shed_Data.followed_date];
            flag = 4;
            [self get_runs:ticked_date];

           }
         [database close];
    }
    
//    int current_run,index_checked,longest_run;
//    shed_data *shed_Data;
//    
//    NSDateFormatter* format1 = [[NSDateFormatter alloc] init] ;
//    [format1 setDateFormat:@"yyyy-MM-dd"];
//    NSString* d= [format1 stringFromDate:cd];
//    
//    indexList = [[NSMutableArray alloc]init];
//    NSLog(@"SHED Alarm Days %@",shed.alarm_days);
//    NSLog(@"SHED id %@",shed.shed_id);
//    NSLog(@"SHED Date %@",d);
//    NSString *currentRunQueryString = [NSString stringWithFormat:@"Select * FROM Shed_Data Group By id Having followed_date = Max(followed_date) And id = %@",shed.shed_id];
//    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [docPaths objectAtIndex:0];
//    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
//    
//    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
//    [database open];
//    FMResultSet *results = [database executeQuery:currentRunQueryString];
//    // NSUInteger count = [database intForQuery:@"SELECT COUNT(*) FROM Shed_Data"];
//    //    if(![results hasAnotherRow]) {
//    //        current_run = 1;
//    //    }else{
//    int rowCount =0;
//    
//    
//    
//    while ([results next]) {
//        rowCount++;
//        shed_Data = [[shed_data alloc]init];
//        shed_Data.followed_date = [results stringForColumn:@"followed_date"];
//        shed_Data.current_run = [results intForColumn:@"current_run"];
//        
//        NSLog(@"Shed Followed Date %@",shed_Data.followed_date);
//        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *followed_date = [formatter dateFromString:shed_Data.followed_date];
//        
//        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
//        [formatter1 setDateFormat:@"yyyy-MM-dd"];
//        NSDate *current_date = [formatter1 dateFromString:d];
//        
//        NSCalendar* calender1 = [NSCalendar currentCalendar];
//        NSDateComponents* component1 = [calender1 components:NSWeekdayCalendarUnit fromDate:current_date];
//        int current_dayindex = [component1 weekday];
//        if (current_dayindex == 1) {
//            current_dayindex = 7;
//        }else{
//            current_dayindex = current_dayindex -1;
//        }
//        
//        NSCalendar* calender = [NSCalendar currentCalendar];
//        NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:followed_date];
//        int followed_dayindex = [component weekday];
//        
//        if (followed_dayindex == 1) {
//            followed_dayindex = 7;
//        }else{
//            followed_dayindex = followed_dayindex -1;
//        }
//        
//        NSNumber *num=[NSNumber numberWithInteger:current_dayindex];
//        NSInteger anIndex=[indexList indexOfObject:num];
//        
//        int value_to_be_checked=0;
//        
//        index_checked = anIndex - 1 ;
//        if(index_checked<0){
//            if([indexList count]==1){
//                index_checked = 0;
//            }else{
//                int count = [indexList count];
//                index_checked = count - 1;
//            }
//        }
//        NSNumber *temp = [indexList objectAtIndex:index_checked];
//        value_to_be_checked = [temp intValue];
//        
//        if (value_to_be_checked == followed_dayindex) {
//            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
//                                                               fromDate:followed_date
//                                                                 toDate:current_date
//                                                                options:0];
//            NSLog(@"Number of days %ld", (long)[totaldays day]);
//            int days_difference = [totaldays day];
//            if (days_difference <= 7) {
//                current_run =shed_Data.current_run +1 ;
//            }else{
//                current_run = 1;
//            }
//        }else{
//            current_run = 1;
//        }
//    }
//    
//    if(rowCount<1){
//        current_run = 1;
//    }
//    
//    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Shed_Data ( id, followed_date,current_run ) VALUES (\"%@\", \"%@\", \"%d\")",shed.shed_id,d,current_run];
//    
//    shed.isBeingFollowedToday = YES;
//    
//    [database executeUpdate:insertSQL];
//    NSString *currentRunQuery = [NSString stringWithFormat:@"Select current_run FROM Shed_Data Group By id Having current_run = Max(current_run) And id = \"%@\"",shed.shed_id];
//    FMResultSet *results1 = [database executeQuery:currentRunQuery];
//    
//    longest_run = 1;
//    
//    while([results1 next])  {
//        longest_run = [results1 intForColumn:@"current_run"];
//    }
//    
//    NSString *updateQuery = [NSString stringWithFormat:@"Update  Shed_Data SET longest_run = %d  where followed_date = \"%@\"  And id = %@",longest_run, d, shed.shed_id];
//    [database executeUpdate:updateQuery];
    
}

-(void) get_runs:(NSDate*)date
{
    int current_run,index_checked,longest_run;
    
    
    NSDateFormatter* format1 = [[NSDateFormatter alloc] init] ;
    [format1 setDateFormat:@"yyyy-MM-dd"];
    NSString* date_accepted = [format1 stringFromDate:date];
    
    
    NSLog(@"SHED Alarm Days %@",shed.alarm_days);
    NSLog(@"SHED id %@",shed.shed_id);
    NSLog(@"SHED Date %@",date_accepted);
    NSString *currentRunQueryString;
    
    
    currentRunQueryString= [NSString stringWithFormat:@"SELECT * FROM Shed_Data WHERE followed_date = (SELECT MAX(followed_date) FROM Shed_Data where followed_date < '%@' And id = %@ ) ",date_accepted,shed.shed_id];
    
//    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [docPaths objectAtIndex:0];
//    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
//    
//    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if(flag!=4){
        [database open];
    }

    FMResultSet *results = [database executeQuery:currentRunQueryString];
    // NSUInteger count = [database intForQuery:@"SELECT COUNT(*) FROM Shed_Data"];
    //    if(![results hasAnotherRow]) {
    //        current_run = 1;
    //    }else{
    int rowCount =0;
    
        while ([results next]) {
        rowCount++;
        shed_Data = [[shed_data alloc]init];
        shed_Data.followed_date = [results stringForColumn:@"followed_date"];
        shed_Data.current_run = [results intForColumn:@"current_run"];
        
        NSLog(@"Shed Followed Date %@",shed_Data.followed_date);
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *followed_date = [formatter dateFromString:shed_Data.followed_date];
        
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        NSDate *current_date = [formatter1 dateFromString:date_accepted];
        
        NSCalendar* calender1 = [NSCalendar currentCalendar];
        NSDateComponents* component1 = [calender1 components:NSWeekdayCalendarUnit fromDate:current_date];
        int current_dayindex = [component1 weekday];
        if (current_dayindex == 1) {
            current_dayindex = 7;
        }else{
            current_dayindex = current_dayindex -1;
        }
        
        NSCalendar* calender = [NSCalendar currentCalendar];
        NSDateComponents* component = [calender components:NSWeekdayCalendarUnit fromDate:followed_date];
        int followed_dayindex = [component weekday];
        
        if (followed_dayindex == 1) {
            followed_dayindex = 7;
        }else{
            followed_dayindex = followed_dayindex -1;
        }
        
        NSNumber *num=[NSNumber numberWithInteger:current_dayindex];
        NSInteger anIndex=[indexList indexOfObject:num];
        
        int value_to_be_checked=0;
        
        index_checked = anIndex - 1 ;
        if(index_checked<0){
            if([indexList count]==1){
                index_checked = 0;
            }else{
                int count = [indexList count];
                index_checked = count - 1;
            }
        }
        NSNumber *temp = [indexList objectAtIndex:index_checked];
        value_to_be_checked = [temp intValue];
        
        if (value_to_be_checked == followed_dayindex) {
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
                                                               fromDate:followed_date
                                                                 toDate:current_date
                                                                options:0];
            NSLog(@"Number of days %ld", (long)[totaldays day]);
            int days_difference = [totaldays day];
            if (days_difference <= 7) {
                current_run =shed_Data.current_run +1 ;
            }else{
                current_run = 1;
            }
        }else{
            current_run = 1;
        }
    }
    
    if(rowCount<1){
        current_run = 1;
    }
    if (flag == 4) {
        NSString *updateSQL = [NSString stringWithFormat:@"Delete from Shed_Data where followed_date = \"%@\" And id = '%@'",date_accepted,shed.shed_id];
       // shed.isBeingFollowedToday = YES;
        
        [database executeUpdate:updateSQL];
    }
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Shed_Data ( id, followed_date,current_run ) VALUES (\"%@\", \"%@\", \"%d\")",shed.shed_id,date_accepted,current_run];
    
        [database executeUpdate:insertSQL];
    
    NSString *currentRunQuery = [NSString stringWithFormat:@"SELECT current_run FROM Shed_Data WHERE current_run = (SELECT MAX(current_run) FROM Shed_Data where followed_date <= '%@' And id = %@ )",date_accepted, shed.shed_id];
    FMResultSet *resultset1 = [database executeQuery:currentRunQuery];
    
    longest_run = 1;
    
    while([resultset1 next])  {
        longest_run = [resultset1 intForColumn:@"current_run"];
    }
    
    NSString *updateQuery = [NSString stringWithFormat:@"Update Shed_Data SET longest_run = %d  where followed_date = \"%@\"  And id = %@",longest_run, date_accepted, shed.shed_id];
    [database executeUpdate:updateQuery];
    
    if(flag!=4){
    [database close];
    }
    
    flag = 0;
   }
@end
