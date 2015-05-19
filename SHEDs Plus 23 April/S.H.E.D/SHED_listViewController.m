//
//  SHED_listViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/3/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import "SHED_listViewController.h"
#import "SHED.h"
#import "shed_data.h"
#import "habitstatisticsViewController.h"
#import "homescreenViewController.h"
#import <QuartzCore/QuartzCore.h> 
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "FMDatabaseAdditions.h"
#import "Base64.h"
#import <CFNetwork/CFNetwork.h>
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>
#import "createahabitViewController.h"
#import "PageWebViewController.h"

#define kOFFSET_FOR_KEYBOARD 160.0

@interface SHED_listViewController ()
{
    FBSession *session;
     int indexPathInt;
}
@end

@implementation SHED_listViewController
@synthesize databasePath,shed_list,IDlbl, tickbtn, crossbtn,habitstats_list,list_table,followeddate,size,footer,header,sub_header,titlelbl,gratitudetxt,gratitudelbl,shed,habit,queryString,flag,gratitudeoc,postbtn,gratTitle,shedlist,coronological,alphabatical,sortingString,appDelegate,date_array,str,value,backlbl,indexList,data3,totaldaysSelected,shedname,workTab,lifeTab,gratType,shedType,addFlag,countFlag,activityIndicatorObject,alertTxt,backBtnOutlt,fbButton,fbInvitebtn,shedIdStrForFetch,issecondTym,fbTxt,isGratitudeAdded;

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
    
  
    if (shedType !=nil)
    {
        gratType=shedType;
        shedType=nil;
    }
    else
    {
        if (gratType==nil)
        {
            gratType=@"life";
        }
    }

    if ([gratType isEqualToString:@"life"])
    {
        [lifeTab setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
        [workTab setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [lifeTab setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
        [workTab setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];

    }
    else
    {
        [workTab setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
        [lifeTab setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [workTab setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
        [lifeTab setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
    }
   
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    
    session=[[FBSession alloc]init];
    header.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"header-bg.png"]];
    sub_header.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"sub-header.png"]];
    footer.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"footer.png"]];
    
    list_table.delegate = self;
    list_table.dataSource = self;
    
    shed_list = [[NSMutableArray alloc] init];
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (flag == 0)
    {
        titlelbl.text = @"Today's SHEDs";
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            list_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 320, 262)];
            [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
            disableImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,320 ,449)];


            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            list_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 320, 180)];
            [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
            disableImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64,320 ,369)];
            // this is iphone 4 xib
        }
        else{
            list_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 320, 768, 415)];
            [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
            disableImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 127,768 ,792)];
            // this is ipad xib
        }
    }
    else if (flag == 1)
    {
            titlelbl.text = @"Current SHEDs";
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            list_table = [[UITableView alloc] initWithFrame:CGRectMake(0,140, 320, 373)];
            [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            list_table = [[UITableView alloc] initWithFrame:CGRectMake(0,140, 320, 285)];
            [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];

            
            // this is iphone 4 xib
        }
        else{
            list_table = [[UITableView alloc] initWithFrame:CGRectMake(0, 320, 768, 600)];
            [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
            // this is ipad xib

        }
    }
    
    
    list_table.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    list_table.delegate = self;
    list_table.dataSource = self;
    list_table.separatorColor = [UIColor clearColor];
    [self.view addSubview:list_table];
    postbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fbInvitebtn = [UIButton buttonWithType:UIButtonTypeCustom];

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        gratitudetxt = [[UITextView alloc] initWithFrame:CGRectMake(5, 425, 310, 45)];
        postbtn.frame = CGRectMake(190, 476, 125, 30);
        fbInvitebtn.frame = CGRectMake(10, 479,75, 27);
        gratTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 397, 320, 28)];
        backlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 397, 320, 115)];
        [gratTitle setFont:[UIFont fontWithName:@"Lucida Sans" size:17]];

        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        gratitudetxt = [[UITextView alloc] initWithFrame:CGRectMake(5, 343, 310, 45)];
        postbtn.frame = CGRectMake(190, 393, 125, 30);
        fbInvitebtn.frame = CGRectMake(10,395, 75, 27);
        gratTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 317, 320, 27)];
        backlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 317, 320, 115)];
        [gratTitle setFont:[UIFont fontWithName:@"Lucida Sans" size:17]];

        // this is iphone 4 xib
    }
    else{
        gratitudetxt = [[UITextView alloc] initWithFrame:CGRectMake(15, 783, 730, 60)];
        postbtn.frame = CGRectMake(533, 853, 207, 45);
        gratTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 740, 758, 35)];
        backlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 740, 758, 165)];
        fbInvitebtn.frame = CGRectMake(18, 855, 140, 45);
        [gratTitle setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        // this is ipad xib
    }

    backlbl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backlbl];
    
    gratitudetxt.textAlignment = NSTextAlignmentLeft;
    [gratitudetxt setDelegate:self];
    [[gratitudetxt layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[gratitudetxt layer] setBorderWidth:2.0];
    [[gratitudetxt layer] setCornerRadius:5];
    [gratitudetxt setFont: [UIFont fontWithName:@"Helvetica Neue" size:17]];
    [self.view addSubview:gratitudetxt];

    
    [fbInvitebtn addTarget:self action:@selector(fbInviteBtn:) forControlEvents:UIControlEventTouchUpInside];
    [fbInvitebtn setBackgroundImage:[UIImage imageNamed:@"fb_invite.png"]forState:UIControlStateNormal];
    [self.view addSubview:fbInvitebtn];

    [postbtn addTarget:self action:@selector(postgratitude:) forControlEvents:UIControlEventTouchUpInside];
    [postbtn setBackgroundImage:[UIImage imageNamed:@"postGratitude-icon.png"]forState:UIControlStateNormal];
    [self.view addSubview:postbtn];
    
    gratTitle.backgroundColor = [UIColor whiteColor];
    gratTitle.text = @" Today I am grateful for....";

    [self.view addSubview:gratTitle] ;
    
    if (flag == 1){
        
        fbInvitebtn.hidden = YES;
        postbtn.hidden = YES;
        gratitudetxt.hidden = YES;
        gratTitle.hidden =YES;
        backlbl.hidden = YES;
    }
    
    
    
    [self calculatePecent];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate *date2 =[dateFormatter dateFromString:appDelegate.todaysDate];
//    
//    NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc]init];
//    [dateformatter1 setDateFormat:@"EEEE"];
//    
//    NSString *str3 = [dateformatter1 stringFromDate:date2];
//    NSString *str4 = [str3 stringByAppendingString:@"%"];
//    NSLog(@"%%%@", str4);
////    gratitudelbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 15)];
////    [gratitudelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:10]];
////    //gratitudelbl.text =  @"Please type here.....";
////    [gratitudetxt addSubview:gratitudelbl];
//    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Fetchin the Thoughts from the table ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    NSString *masteredStr = [[NSString alloc] initWithFormat:@"NO"];
//    if (flag == 1) {
//        queryString = [NSString stringWithFormat:@"Select * FROM SHED where isMastered = \"%@\" and type =\"%@\"",masteredStr, gratType];
//    }
//    else if (flag == 0)
//    {
//        queryString = [NSString stringWithFormat:@"Select * FROM SHED where isMastered = \'%@\' and alarm_days LIKE \'%%%@\' and type =\"%@\"",masteredStr, str4,gratType];
//    }
//    
//    
//    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDir = [docPaths objectAtIndex:0];
//    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
//    
//    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
//    NSLog(@"query %@", queryString);
//    NSLog(@"path : %@", dbPath);
//    [database open];
//    NSLog(@"query %@", queryString);
//    FMResultSet *results = [database executeQuery:queryString];
//    
//    while([results next]) {
//        shed	= [[SHED alloc] init];
//        shed.shed_id = [results stringForColumn:@"shed_id"];
//        shed.name = [results stringForColumn:@"name"];
//        //shed.description = [results stringForColumn:@"description"];
//        shed.alarm_time = [results stringForColumn:@"alarm_time"];
//        shed.alarm_status = [results stringForColumn:@"alarm_status"];
//        shed.start_date = [results stringForColumn:@"start_date"];
//        shed.alarm_days = [results stringForColumn:@"alarm_days"];
//        NSLog(@"alarm days.. %@",shed.alarm_days);
//        shed.type = [results stringForColumn:@"type"];
//        
//        shed.isBeingFollowedToday = NO;
//        
//        NSLog(@"alarm Days ::%@", shed.alarm_days);
//        
//        
//        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *date2 = [formatter dateFromString:appDelegate.todaysDate];
//        NSString* todaysdate = [formatter stringFromDate:date2];
//        NSLog(@"My Date %@", todaysdate);
//        
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        [format setDateFormat:@"yyyy-MM-dd"];
//        NSDate *startDate = [format dateFromString:shed.start_date];
//        
//        NSString *dateQuery = [NSString stringWithFormat:@"Select followed_date from Shed_Data where id = \"%d\"",[shed.shed_id intValue]];
//        
//        FMResultSet *dateSet = [database executeQuery:dateQuery];
//        followeddate = [[NSMutableArray alloc]init];
//        while([dateSet next]) {
//            NSString *tempStr = [dateSet stringForColumn:@"followed_date"];
//            [followeddate addObject:tempStr];
//            
//            if([todaysdate isEqualToString:tempStr])
//                shed.isBeingFollowedToday = YES;
//            
//        }
//        shed.datesArray = followeddate;
//        shed.applieddays = [followeddate count];
//        
//       
//        
//        NSDate *endDate = [format dateFromString:todaysdate];
//        
//        
//        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
//                                                           fromDate:startDate
//                                                             toDate:endDate
//                                                            options:0];
//        totaldaysSelected = [totaldays day];
//        
//        //if(shed.totaldays==0)
//            totaldaysSelected +=1;
//        int TotalDaysCounted = 0;
//        
//        NSString *daysString = [NSString stringWithFormat:@"%@",shed.alarm_days];
//        NSLog(@"Days To add %@", daysString);
//        
//        NSArray *daysstr = [shed.alarm_days componentsSeparatedByString:@","];
//        
//        NSLog(@"Selected Days Name: %@", daysstr);
//        
//        
//        data3 = [[NSMutableArray alloc]init];
//        
//        int i;
//        for (i = 0; i < [daysstr count]; i++) {
//            NSString* myArrayElement = [daysstr objectAtIndex:i];
//            int index = [self getindex:myArrayElement];
//            
//            int occurence = [self cal:totaldaysSelected :startDate :index];
//            TotalDaysCounted += occurence;
//        }
//        
//        shed.totaldays = TotalDaysCounted;
//        
//        if(shed.totaldays==0)
//            shed.percentage = 0;
//        else
//
//            shed.percentage = ((float)shed.applieddays/(float)shed.totaldays)*100;
//        
//        if(shed.totaldays == 1 && shed.applieddays == 0)
//            shed.percentage = 50;
//        
//        NSLog(@"Applied Days of the shed %d",shed.applieddays);
//        NSLog(@"Total days of the shed %d",shed.totaldays);
//        NSLog(@"percetage of the shed %f",shed.percentage);
// 
//        [shed_list addObject:shed];
//      
//    }
//    
//    if([sortingString isEqualToString:@"Cronological"])
//    {
//        [coronological setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
//        [alphabatical setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
//        [coronological setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
//        [alphabatical setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"alarm_time"
//                                                                    ascending:YES
//                                                                     selector:@selector(localizedStandardCompare:)];
//     shedlist = [self.shed_list sortedArrayUsingDescriptors:@[firstNameSort]];
//    NSLog(@"Sorted by first name: %@", shedlist);
//    }
//    else if([sortingString isEqualToString:@"Alphabatical"]){
//        [alphabatical setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
//        [alphabatical setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
//        [coronological setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [coronological setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
//
//        
//        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"name"
//                                                                        ascending:YES
//                                                                         selector:@selector(localizedStandardCompare:)];
//        shedlist = [self.shed_list sortedArrayUsingDescriptors:@[firstNameSort]];
//        NSLog(@"Sorted by first name: %@", shedlist);
//    }
//    [database close];
    //[self scheduleNotificationForDate];
//    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
//    [formatter1 setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate *date7 =[formatter1 dateFromString:appDelegate.todaysDate];
//    NSString* todaydate = [formatter1 stringFromDate:date7];
//    value = [NSUserDefaults standardUserDefaults];
//    str = [value objectForKey:@"Date"];
//    if ([str isEqualToString: todaydate])
//    {
//        [postbtn setBackgroundImage:[UIImage imageNamed:@"postGratitude-icon grey.png"]forState:UIControlStateNormal];
//         postbtn.userInteractionEnabled = NO;
//    }
//    else
//    {
//        //postbtn.userInteractionEnabled = NO;
//    }
    
//    dot =[[UIImageView alloc] initWithFrame:CGRectMake(0,44,320,300)];
//    dot.image=[UIImage imageNamed:@"disable568.png"];
//    [self.view addSubview:dot];
//    NSUserDefaults * value1 = [NSUserDefaults standardUserDefaults];
//    NSString *myString = [value1 objectForKey:@"GratitudeDate"];
//    
//    if(myString==nil)
//        myString=@"";
//    
//    if ([myString isEqualToString:appDelegate.todaysDate]) {
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    NSString *gratPopUp=[defaults valueForKey:@"GratitudePopUp"];
//
//    if ([gratPopUp isEqualToString:@"1"]) {
//        [self scheduleNotificationForDate];
//    }else{
//        
//        }
//    }else{
//        
//    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [shedlist count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){

        return 55.0;
    }else{
        return 87.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index row %ld", (long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        shedname = [[UILabel alloc] initWithFrame:CGRectMake(55, 4, 180, 50)];
        [shedname setFont:[UIFont fontWithName:@"Lucida Sans" size:15]];
        shedname.lineBreakMode = NSLineBreakByWordWrapping;
    }
    else{
        if (flag==0)
        {
             shedname = [[UILabel alloc] initWithFrame:CGRectMake(105,2,460, 80)];
        }
        else if (flag==1)
        {
             shedname = [[UILabel alloc] initWithFrame:CGRectMake(105, 2,570, 80)];
        }
        [shedname setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
    }
    shedname.numberOfLines = 2;
    shedname.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:shedname] ;
    
    shed = [shedlist objectAtIndex:indexPath.row];
    shedname.text = shed.name;
    UIImageView *gratimgup;
    UIImageView *img ;
    tickbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    crossbtn = [UIButton buttonWithType:UIButtonTypeCustom];

    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        img = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 34, 34)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(305, 18, 8, 15)];
        tickbtn.frame = CGRectMake(240, 11, 28, 28);
        crossbtn.frame = CGRectMake(270, 11, 28, 28);
        //this is iphone 5 xib
    }
    else
    {
        [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 65, 65)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(723, 30, 16, 27)];
        tickbtn.frame = CGRectMake(590, 15, 56, 50);
        crossbtn.frame = CGRectMake(650, 15, 56, 50);
        //this is ipad xib
    }

    gratimgup.image = [UIImage imageNamed:@"arrow.png"];
    gratimgup.hidden = NO;
    [cell.contentView addSubview:gratimgup];
    
    tickbtn.tag = 200+indexPath.row;
    [tickbtn addTarget:self action:@selector(addshed:)forControlEvents:UIControlEventTouchUpInside];
    
    crossbtn.tag = 400+indexPath.row;
    [crossbtn addTarget:self action:@selector(removeshed:) forControlEvents:UIControlEventTouchUpInside];
    
    if(shed.isBeingFollowedToday){
        [tickbtn setBackgroundImage:[UIImage imageNamed:@"ok_green.png"]forState:UIControlStateNormal];
        [crossbtn setBackgroundImage:[UIImage imageNamed:@"delete-gray.png"]forState:UIControlStateNormal];
    }
    else
    {
        [tickbtn setBackgroundImage:[UIImage imageNamed:@"ok_gray.png"]forState:UIControlStateNormal];
        [crossbtn setBackgroundImage:[UIImage imageNamed:@"delete-red.png"]forState:UIControlStateNormal];
    }
    NSLog(@"Percentage of SHED %f", shed.percentage);

    if (shed.percentage <= 49) {
        img.image = [UIImage imageNamed:@"sad-smiley.png"];
        [cell addSubview:img];
    }
    else if (shed.percentage > 49 && shed.percentage <=80)
    {
        img.image = [UIImage imageNamed:@"neutral-smiley.png"];
        [cell addSubview:img];
    }
    else if (shed.percentage > 80 )
    {
        img.image = [UIImage imageNamed:@"happy-smiley.png"];
        [cell addSubview:img];
    }
    
//    if (addFlag==2)
//    {
//        
//         shed = [shedlist objectAtIndex:indexPathInt];
//        
//            if (shed.percentage >= 70 &&  shed.percentage<85) {
//                UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Good work!! you've achieved 70% but you can do even better if you try" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alerView show];
//               
//              
//            }
//            else if (shed.percentage >=85 && shed.percentage <90)
//            {
//                UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Well done!! You've achieved 85% in this SHED and are very close to mastering this" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alerView show];
//               
//            }
//            else if (shed.percentage >= 90 )
//            {
//                UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Excellent Job!!! You've achieved 90%. You are doing really great in this SHED" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alerView show];
//            }
//              addFlag=1;
//  
//    }
    
    cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    if (flag == 0) {
    [cell.contentView addSubview:tickbtn];
    NSLog(@"tickbtn tag %ld",(long)tickbtn.tag);
   
    [cell.contentView addSubview:crossbtn];
    NSLog(@"tickbtn tag %ld",(long)crossbtn.tag);
    }
    else if(flag == 1) {
    }
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    habitstatisticsViewController *habitstat;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        habitstat = [[habitstatisticsViewController alloc]initWithNibName:@"habitstatisticsViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        habitstat = [[habitstatisticsViewController alloc]initWithNibName:@"habitstatisticsViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        habitstat = [[habitstatisticsViewController alloc]initWithNibName:@"habitstatisticsViewController_ipad" bundle:Nil];
        // this is ipad xib
    }
    habitstat.sortingStr=sortingString;
    habitstat.shedType=gratType;
    habitstat.flags = flag;
    habitstat.tabstring = sortingString;
    habitstat.shed = [shedlist objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:habitstat animated:YES];
}


-(void)goToBottom
{
    NSIndexPath* ip = [NSIndexPath indexPathForRow: indexPathInt inSection:0];
    [self.list_table scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(IBAction)addshed:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-200 inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    UITableViewCell *cell = (UITableViewCell*)[list_table cellForRowAtIndexPath:indexPath];
    UIButton *check1 = (UIButton*)[cell.contentView viewWithTag:indexPath.row+200];
    UIButton *check2 = (UIButton*)[cell.contentView viewWithTag:indexPath.row+400];
    UIImageView *btnimg1 = [[UIImageView alloc] initWithImage:check1.currentBackgroundImage];

    
    NSData *img1Data = UIImageJPEGRepresentation(btnimg1.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"ok_gray.png"], 1.0);
    
    if ([img1Data isEqualToData:img2Data]){
        [check1 setBackgroundImage:[UIImage imageNamed:@"ok_green.png"]forState:UIControlStateNormal];
        [check2 setBackgroundImage:[UIImage imageNamed:@"delete-gray.png"]forState:UIControlStateNormal];
        
        [self addsheddata:sender];
        NSLog(@"tickbtn tag %ld",(long)check1.tag);
    }
    else{
        [check2 setEnabled:NO];
        NSLog(@"it is green");
    }
        
    NSLog(@"SHED LIST subviews: %@", btnimg1.image);

//    if (btnimg1.image == [UIImage imageNamed:@"ok_gray.png"]) {
//        [check1 setBackgroundImage:[UIImage imageNamed:@"ok_green.png"]forState:UIControlStateNormal];
//        [check2 setBackgroundImage:[UIImage imageNamed:@"delete-gray.png"]forState:UIControlStateNormal];
//        
//        [self addsheddata:sender];
//        NSLog(@"tickbtn tag %ld",(long)check1.tag);
//    }
//    else if (btnimg1.image == [UIImage imageNamed:@"ok_green.png"])
//    {
//        [check2 setEnabled:NO];
//        NSLog(@"it is green");
//    }
    [self calculatePecent];
    [self.list_table reloadData];
}

-(IBAction)removeshed:(UIControl*)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-400 inSection:0];
    NSLog(@"remove indexrow %ld", (long)indexPath.row);
    indexPathInt=indexPath.row;
    
    UITableViewCell *cell = (UITableViewCell*)[list_table cellForRowAtIndexPath:indexPath];
    UIButton *check1 = (UIButton*)[cell.contentView viewWithTag:indexPath.row+200];
    UIButton *check2 = (UIButton*)[cell.contentView viewWithTag:indexPath.row+400];
    UIImageView *btnimg2 = [[UIImageView alloc] initWithImage:check2.currentBackgroundImage];
    
    NSData *img1Data = UIImageJPEGRepresentation(btnimg2.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"delete-gray.png"], 1.0);
    
    if ([img1Data isEqualToData:img2Data])
    { [check1 setBackgroundImage:[UIImage imageNamed:@"ok_gray.png"]forState:UIControlStateNormal];
        [check2 setBackgroundImage:[UIImage imageNamed:@"delete-red.png"]forState:UIControlStateNormal];
        [self removesheddata:sender];
        NSLog(@"tickbtn tag %ld",(long)check2.tag);}
    else{
        [check2 setEnabled:NO];
        NSLog(@"it is red");
    }

//     if (btnimg2.image == [UIImage imageNamed:@"delete-gray.png"]) {
//        [check1 setBackgroundImage:[UIImage imageNamed:@"ok_gray.png"]forState:UIControlStateNormal];
//        [check2 setBackgroundImage:[UIImage imageNamed:@"delete-red.png"]forState:UIControlStateNormal];
//        [self removesheddata:sender];
//        NSLog(@"tickbtn tag %ld",(long)check2.tag);
//    }
//    else if (btnimg2.image == [UIImage imageNamed:@"delete-red.png"])
//    {
//        [check2 setEnabled:NO];
//        NSLog(@"it is red");
//    }
    [self calculatePecent];
    [self.list_table reloadData];
}

-(void)addsheddata:(UIControl *)sender{
    
    addFlag=2;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-200 inSection:0];
    // UITableViewCell *cell = (UITableViewCell*)[list_table cellForRowAtIndexPath:indexPath];
    indexPathInt=indexPath.row;
    shed =[shedlist objectAtIndex:indexPath.row];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
     NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    //SHEDLIST *info = [shed_list objectAtIndex:path.row];
  
    NSLog(@"SHED DATA in SHED_LIST %@", shed.shed_id);
    NSString *ShedID = [[NSString alloc] initWithFormat:shed.shed_id];
    NSLog(@"SHED ID %@", ShedID );
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString1 = [NSString stringWithFormat:@"select id,followed_date, current_run from Shed_Data Group By id Having followed_date = Max(followed_date) And id = \"%@\"",ShedID];
    FMResultSet *results = [database executeQuery:queryString1];
    NSLog(@"FOLLOWED DATE %@", results);
    [self calRuns];
    [self.list_table reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 0 && alertView.tag == 1)
    {
        for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if ([notify.alertBody isEqualToString:shed.name])
            {
                NSLog(@"the notification this is canceld is %@", notify.alertBody);
                [[UIApplication sharedApplication] cancelLocalNotification:notify] ;
            }
        }
        
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        NSString *isMastered = [[NSString alloc] initWithFormat:@"YES"];
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE SHED SET isMastered = \"%@\" , masteredDate = \"%@\" where shed_id = \"%@\"", isMastered, appDelegate.todaysDate, shedIdStrForFetch];
        
        
    //    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE SHED SET isMastered = \"%@\" where shed_id = \"%@\"", isMastered,shedIdStrForFetch];
        [database executeUpdate:insertSQL];
        [database close];
        
      

        [self viewDidLoad];
        [self ShowAlert];

    }
    
  
    
   else if(alertView.tag==5 && buttonIndex==1 && [title isEqualToString:@"OK"])
    {
        
        
        UITextField *messageTxt = [alertView textFieldAtIndex:0];
        
        NSString *msgTxt=[NSString stringWithFormat:@"%@", messageTxt.text];
        
        if ([msgTxt isEqualToString:@""]) {
            UIAlertView *alrt =[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter your views.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alrt show];
        }else{
            
            appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.facebookConnect=YES;
            [appDelegate facebookIntegration:msgTxt  ];
        }
    }
    
    else if (buttonIndex == 0 && alertView.tag == 2){
        [self.gratitudetxt resignFirstResponder];
    }
    else if (alertView.tag==100)
    {
        if (buttonIndex==1)
        {
            [[NSUserDefaults standardUserDefaults ] setValue:@"Done" forKey:@"Review" ];

            [[UIApplication sharedApplication]
             openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id937139648"]];
//            if ([SKStoreProductViewController class]) {
//                SKStoreProductViewController *controller = [[SKStoreProductViewController alloc] init];
//                controller.delegate = self;
//                [controller loadProductWithParameters:@{ SKStoreProductParameterITunesItemIdentifier : @"937139648" }completionBlock:^(BOOL result, NSError *error)
//                 {
//                     if (error)
//                     {
//                         NSString *errorString=[NSString stringWithFormat:@"Error %@ with User Info %@",error,[error userInfo]];
//                         NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
//                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"APP STORE" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                         [alert show];
//                     }
//                     else
//                     {
//                         [self presentViewController:controller animated:YES completion:nil];
//                     }
//                 }];
//            }
        }
        else{
            NSDate *reviewDate=[NSDate date];
            [[NSUserDefaults standardUserDefaults ] setValue:@"Later" forKey:@"Review" ];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString* date = [formatter stringFromDate:reviewDate];
            [[NSUserDefaults standardUserDefaults] setValue:date forKey:@"ReviewDate"];
        }
    }
    else if (alertView.tag==12)
    {
        if (buttonIndex==1)
        {
            alertTxt=1;
           
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"addShedLastDate"];
            [defaults setValue:[NSString stringWithFormat:@"%@",appDelegate.todaysDate] forKey:@"addShedLastDate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        else if (buttonIndex==0)
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
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"addShedLastDate"];
            [defaults setValue:[NSString stringWithFormat:@"%@",appDelegate.todaysDate] forKey:@"addShedLastDate"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    

    else if(alertView.tag==55)
    {
        if ([[[NSUserDefaults standardUserDefaults ] valueForKey:@"Review"] isEqualToString:@"Done"])
        {
            return;
        }
        
        if ([[[NSUserDefaults standardUserDefaults ] valueForKey:@"Review"] isEqualToString:@""])
        {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Looks like you enjoy using this app. Could you spare a moment of time to review it in app store? "delegate:self cancelButtonTitle:@"No,Thanks" otherButtonTitles:@"Rate It Now", nil];
            alert.tag=100;
            [alert show];
        }
        else if ([[[NSUserDefaults standardUserDefaults ] valueForKey:@"Review"] isEqualToString:@"Later"])
        {
            NSString*reviewDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"ReviewDate"];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSDate* dateReview = [formatter dateFromString:reviewDate];
            NSDate*currentDate=[NSDate date];
            
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *difference = [gregorianCalendar components:NSDayCalendarUnit
                                                                fromDate:dateReview
                                                                  toDate:currentDate
                                                                 options:0];
            int diffr = [difference day];
            
            if (diffr>5)
            {
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Looks like you enjoy using this app. Could you spare a moment of time to review it in app store? "delegate:self cancelButtonTitle:@"No,Thanks" otherButtonTitles:@"Rate It Now", nil];
                alert.tag=100;
                [alert show];
            }
        }
    }
}

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void )ShowAlert
{
    UIAlertView *alertds = [[UIAlertView alloc] initWithTitle:@"Congrats!!!" message:@"Your SHED has been transferred to Mastered SHEDs successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertds.tag=55;
    [alertds show];
}
//-(void)sendBtn :(UIControl *)sender
//{
//    [self disable];
//    [self.view endEditing:YES];
//     issueStr= [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (issueStr.length==0 )
//    {
//        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter your feedback." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
//    else{
//        [self sendMessageInBack];
//    }
//}
//
//-(void)cancelBtn :(UIControl *)sender
//{
//    [self enable];
//    [self.view endEditing:YES];
//
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:@"addShedLastDate"];
//    [defaults setValue:[NSString stringWithFormat:@"%@",appDelegate.todaysDate] forKey:@"addShedLastDate"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    myView.hidden=YES;
//    alertTxt=0;
//}
//
//- (void)sendMessageInBack{
//    [self.view setUserInteractionEnabled:NO];
//    [activityIndicatorObject startAnimating];
//    disableImg.hidden=NO;
//    NSLog(@"Start Sending");
//    
////    
////    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    
////    NSString *documentsDirectory = [paths objectAtIndex:0];
////    
////    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"sample.pdf"];
////    NSData *dataObj = [NSData dataWithContentsOfFile:writableDBPath];
//    
//    SKPSMTPMessage *testMsg = [[SKPSMTPMessage alloc] init];
//    
//    testMsg.fromEmail = @"minakshibhardwaj.kis@gmail.com";//nimit51parekh@gmail.com
//    
//    testMsg.toEmail = @"peter@ingenius.com.au";//sender mail id
//    
//    testMsg.relayHost = @"smtp.gmail.com";
//    
//    testMsg.requiresAuth = YES;
//    
//    testMsg.login = @"minakshibhardwaj.kis@gmail.com";//nimit51parekh@gmail.com
//    
//    testMsg.pass = @"mbs.kis@321";
//    
//    testMsg.subject = @"SHEDs Plus Feedback";
//    
//    testMsg.wantsSecure = YES; // smtp.gmail.com doesn't work without TLS!
//    
//    testMsg.delegate = self;
//    
//    NSString *str_info2=[NSString stringWithFormat:@"%@",issueStr];
//    
//    NSString *sendmsg=[[NSString alloc]initWithFormat:@"%@",str_info2];
//    NSLog(@"automsg=%@",sendmsg);
//    
//    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,sendmsg,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
//    
//    testMsg.parts = [NSArray arrayWithObjects:plainPart,nil];
//    [testMsg send];
//}
//
//-(void)messageSent:(SKPSMTPMessage *)message{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thank you for the feedback" message:@"Your email has been sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
//    NSLog(@"delegate - message sent");
//    [self.view setUserInteractionEnabled:YES];
//    [activityIndicatorObject stopAnimating];
//    disableImg.hidden=YES;
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:@"addShedLastDate"];
//    [defaults setValue:[NSString stringWithFormat:@"%@",appDelegate.todaysDate] forKey:@"addShedLastDate"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    alertTxt=0;
//    [self enable];
//    myView.hidden=YES;
//}
//
//-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Your email could not be delivered.Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
//    [self.view setUserInteractionEnabled:YES];
//    [activityIndicatorObject stopAnimating];
//    disableImg.hidden=YES;
//   //  [self enable];
//    NSLog(@"delegate - error(%ld): %@", (long)[error code], [error localizedDescription]);
//}
//
-(void)removesheddata:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-400 inSection:0];
    addFlag=5;
    shed =[shedlist objectAtIndex:indexPath.row];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"shed_db.sqlite"];
    int shedid = [shed.shed_id intValue];
    NSLog(@"shed id of deleting shed is %d",shedid);
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM Shed_Data WHERE followed_date = \"%@\" and id = \"%d\"",appDelegate.todaysDate,shedid] ;
    shed.isBeingFollowedToday = NO;
    shed.applieddays -=1;
    [database executeUpdate:deleteQuery];
    [database close];
    NSLog(@"SHED REMOVED");
    [self.list_table reloadData];
}


- (IBAction)header_back:(id)sender {
    homescreenViewController *home;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    home.idstr = shed.shed_id;
    [self.navigationController pushViewController:home animated:NO];
}

- (IBAction)workTab:(id)sender {
    [workTab setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
    [lifeTab setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [workTab setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
    [lifeTab setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
    gratType=@"work";
    [self viewDidLoad];

}

- (IBAction)lifeTab:(id)sender {
    [lifeTab setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
    [workTab setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [lifeTab setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
    [workTab setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
    gratType=@"life";

    [self viewDidLoad];


}
//#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow
{
    if (self.view.frame.origin.y >= 0)
    {
        if (alertTxt==1 ||alertTxt ==3 ||fbTxt==88)
        {
            [self setViewMovedUp:NO];

        }
        else{
            [self setViewMovedUp:YES];

        }
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        if (alertTxt==1 || alertTxt==3 || fbTxt==88)
        {
           
            [self setViewMovedUp:NO];
            fbTxt=0;
        }
        else{
            [self setViewMovedUp:YES];

        }
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    self.gratitudelbl.hidden = YES;
    if ([sender isEqual:backlbl])
    {
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
 }

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        if (alertTxt==1 || alertTxt==3 ||fbTxt==88)
        {
            //fbTxt=0;
        }
        else{
            // revert back to the normal state.
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
            rect.size.height -= kOFFSET_FOR_KEYBOARD;
        }
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)postgratitude:(id)sender
{
    [self.gratitudetxt resignFirstResponder];
    NSString *tempStr = [gratitudetxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    int textLength = [tempStr length];
    if(textLength<1 )
    {
        UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:@"Please enter the gratitude's description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        gratitudetxt.text=@"";
        [savealert show];
    }
    else
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSString stringWithFormat:@"%@",appDelegate.todaysDate] forKey:@"GratitudeDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self gratPopup];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"user editing");
    if([text isEqualToString:@"\n"])
    {
        [gratitudetxt resignFirstResponder];
        [txtView resignFirstResponder];
        return NO;
    }

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSUserDefaults * value1 = [NSUserDefaults standardUserDefaults];
    NSString *myString = [value1 objectForKey:@"gratitudeDate"];
    
    if(myString==nil)
        myString=@"";
    
//    if ([myString isEqualToString:appDelegate.todaysDate]) {
//        int textLength = [gratitudetxt.text length];
//        if(textLength>=0){
//            [gratitudetxt resignFirstResponder];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SHEDs" message:@"You've already entered the gratitude for the day." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            alert.tag =2;
//            [alert show];
//        }
 //   }
    return YES;
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


- (IBAction)posttoFacebook:(id)sender {
    //fbTxt=88;
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
    
    
//    UIView *messageView=[[UIView alloc]initWithFrame:CGRectMake(30,70, 240, 100)];
//    UITextView*msgtxtview=[[UITextView alloc]initWithFrame:CGRectMake(2,2,236,96)];
//    [messageView addSubview:msgtxtview];
//    [self.view addSubview:messageView];
    

    
    
    //    appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.facebookConnect=YES;
//    [appDelegate facebookIntegration];
  
  }

- (IBAction)coronological:(id)sender {
    [coronological setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
    [alphabatical setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
   
    [coronological setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
    [alphabatical setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];

    sortingString=[NSString stringWithFormat:@"Cronological"];
    [self viewDidLoad];
}


- (IBAction)alphabatical:(id)sender {
    [alphabatical setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
    [coronological setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [coronological setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
    [alphabatical setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
    sortingString=[NSString stringWithFormat:@"Alphabatical"];
    [self viewDidLoad];
}

-(void)disablePost
{
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date7 =[formatter1 dateFromString:appDelegate.todaysDate];
    NSString* todaydate = [formatter1 stringFromDate:date7];
    if ([date_array containsObject:todaydate]){
        postbtn.userInteractionEnabled = NO;
        [postbtn setBackgroundImage:[UIImage imageNamed:@"postGratitude-icon grey.png"]forState:UIControlStateNormal];
    }
    else{
        postbtn.userInteractionEnabled = YES;
        [postbtn setBackgroundImage:[UIImage imageNamed:@"postGratitude-icon.png"]forState:UIControlStateNormal];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView==gratitudetxt)
    {
     alertTxt=0;
    }
}


-(void) gratPopup
{
    NSString *tempStr = [gratitudetxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSLog(@"temp grattitude.. %@",tempStr);
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Gratitude ( gratitude , gratitude_date) VALUES (\"%@\", \"%@\")",tempStr,appDelegate.todaysDate];
    
    [database executeUpdate:insertSQL];
  
    self.gratitudetxt.text= @"";

    
    [database close];
    NSUserDefaults * value1 = [NSUserDefaults standardUserDefaults];
    [value1 setValue:[NSString stringWithFormat:@"%@",appDelegate.todaysDate]
              forKey:@"gratitudeDate"];
    
}
-(void)calRuns
{
    int current_run,index_checked,longest_run;
    shed_data *shed_Data;

    indexList = [[NSMutableArray alloc]init];
    NSLog(@"SHED Alarm Days %@",shed.alarm_days);
    NSLog(@"SHED id %@",shed.shed_id);
    NSString *currentRunQueryString = [NSString stringWithFormat:@"Select * FROM Shed_Data Group By id Having followed_date = Max(followed_date) And id = %@",shed.shed_id];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *results = [database executeQuery:currentRunQueryString];
   
    int rowCount =0;
    
    while ([results next]) {
        rowCount++;
        NSArray *daysstr = [shed.alarm_days componentsSeparatedByString:@","];
        
        NSLog(@"Selected Days Name: %@", daysstr);
        
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
        shed_Data = [[shed_data alloc]init];
        shed_Data.followed_date = [results stringForColumn:@"followed_date"];
        shed_Data.current_run = [results intForColumn:@"current_run"];
       
        NSLog(@"Shed Followed Date %@",shed_Data.followed_date);
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *followed_date = [formatter dateFromString:shed_Data.followed_date];

        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        NSDate *current_date = [formatter1 dateFromString:appDelegate.todaysDate];
        
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
        }
        else{
            current_run = 1;
        }
    }
    
    if(rowCount<1){
        current_run = 1;
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Shed_Data ( id, followed_date,current_run ) VALUES (\"%@\", \"%@\", \"%d\")",shed.shed_id,appDelegate.todaysDate,current_run];
        
    shed.isBeingFollowedToday = YES;
        
    [database executeUpdate:insertSQL];
    NSString *currentRunQuery = [NSString stringWithFormat:@"Select current_run FROM Shed_Data Group By id Having current_run = Max(current_run) And id = \"%@\"",shed.shed_id];
    FMResultSet *results1 = [database executeQuery:currentRunQuery];
        
    longest_run = 1;
        
    while([results1 next])  {
        longest_run = [results1 intForColumn:@"current_run"];
    }
    NSString *updateQuery = [NSString stringWithFormat:@"Update  Shed_Data SET longest_run = %d  where followed_date = \"%@\"  And id = %@",longest_run, appDelegate.todaysDate, shed.shed_id];
    [database executeUpdate:updateQuery];
        
    shed.applieddays+=1;
   
   BOOL isMultipleOf21 = !(shed.applieddays % 21);
    
    if (isMultipleOf21 && shed.applieddays!=0) {
        
        shedIdStrForFetch=shed.shed_id;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well done. You have performed the SHED for 21 days" message:@"Do you wish to transfer to Mastered SHEDs?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag =1;
        [alert show];
    }
    NSUserDefaults *popUpdefaults =[NSUserDefaults standardUserDefaults];
    int popUpValue= [[popUpdefaults valueForKey:@"PopUp"]intValue];
    if (current_run==5 && popUpValue==1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well Done" message:@"You have followed this shed for 5 days in a row." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (current_run==10 && popUpValue==1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well Done" message:@"You have followed this shed for 10 days in a row" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if (current_run==15 && popUpValue==1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well Done" message:@"You have followed this shed for 15 days in a row, only 6 days to Mastery" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    int streak=[[NSString stringWithFormat:@"%@",shed.rewardStreak ]intValue];
    NSLog(@"rewardStatus..%d",shed.rewardStatus);
    if (current_run==streak && shed.rewardStatus==1)
    {
        [self launchDialog ];
    }
}

-(int) getindex:(NSString*) mystring
{
    if ([mystring isEqualToString:@"Monday"]) {
        NSLog(@"Exact Multiple is Monday");
        return 1;
    }else if ([mystring isEqualToString:@"Tuesday"]) {
        NSLog(@"Exact Multiple is Tuesday");
        
        return 2;
    }
    else if ([mystring isEqualToString:@"Wednesday"]) {
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
    }

    NSLog(@"Exact Multiple is %d", exactMultiple);
    return exactMultiple;
    
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
    }else{
        return @"Saturday";
    }
}
-(void)calculatePecent
{
    shed_list =[[NSMutableArray alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date2 =[dateFormatter dateFromString:appDelegate.todaysDate];
    
    NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc]init];
    [dateformatter1 setDateFormat:@"EEEE"];
    
    NSString *str3 = [dateformatter1 stringFromDate:date2];
    NSString *str4 = [str3 stringByAppendingString:@"%"];
    NSLog(@"%%%@", str4);
 
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Fetchin the Thoughts from the table ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    NSString *masteredStr = [[NSString alloc] initWithFormat:@"NO"];
    if (flag == 1) {
        queryString = [NSString stringWithFormat:@"Select * FROM SHED where isMastered = \"%@\" and type =\"%@\"",masteredStr, gratType];
    }
    else if (flag == 0)
    {
        queryString = [NSString stringWithFormat:@"Select * FROM SHED where isMastered = \'%@\' and alarm_days LIKE \'%%%@\' and type =\"%@\"",masteredStr, str4,gratType];
    }
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"query %@", queryString);
    NSLog(@"path : %@", dbPath);
    NSLog(@"query %@", queryString);

    [database open];
    if (countFlag==1)
    {
        NSLog(@"todaysDate..%@",appDelegate.todaysDate);
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSLog(@"last add shed created date.. %@",[defaults valueForKey:@"addShedLastDate"]);

        NSString*addShedDate=[NSString stringWithFormat:@"%@",[defaults stringForKey:@"addShedLastDate"]];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *addShed_date = [formatter dateFromString:addShedDate];
        NSDate *current_date = [formatter dateFromString:appDelegate.todaysDate];
        int numberDays;
        if (addShed_date !=nil)
        {
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
                                                               fromDate:addShed_date
                                                                 toDate:current_date
                                                                options:0];
            NSLog(@"Number of work shed days %ld", (long)[totaldays day]);
            numberDays=[totaldays day];
        }
      
        int lifeShedCount = [database intForQuery:[NSString stringWithFormat:@"SELECT COUNT(shed_id) FROM SHED where isMastered ='NO' and type = \"life\""]];
        NSLog(@"life shed count..%d",lifeShedCount);
        int workShedCount = [database intForQuery:[NSString stringWithFormat:@"SELECT COUNT(shed_id) FROM SHED where isMastered ='NO' and type = \"work\""]];
        NSLog(@"work shed count..%d",workShedCount);
        
        NSUserDefaults *popUpdefaults =[NSUserDefaults standardUserDefaults];
       int popUpValue= [[popUpdefaults valueForKey:@"PopUp"]intValue];
        
        if (popUpValue==1 && numberDays >=7)
        {
            if (lifeShedCount==12 && workShedCount<12 )
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Have you considered adding a new work simple habit?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [alert show];
                alert.tag=12;
            }
            else if (workShedCount==12 && lifeShedCount<12)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Have you considered adding a new life simple habit?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [alert show];
                alert.tag=12;
            }
        }
         countFlag=0;
    }
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next]) {
        shed	= [[SHED alloc] init];
        shed.shed_id = [results stringForColumn:@"shed_id"];
        shed.name = [results stringForColumn:@"name"];
        shed.alarm_time = [results stringForColumn:@"alarm_time"];
        shed.alarm_status = [results stringForColumn:@"alarm_status"];
        shed.start_date = [results stringForColumn:@"start_date"];
        shed.alarm_days = [results stringForColumn:@"alarm_days"];
        NSLog(@"alarm days.. %@",shed.alarm_days);
        shed.type = [results stringForColumn:@"type"];
        shed.rewardStreak=[results stringForColumn:@"rewardStreak"];
        shed.rewardStatus=[results intForColumn:@"rewardStatus"];
        shed.rewardImage=[results stringForColumn:@"rewardImage"];
        shed.rewardDetail=[results stringForColumn:@"rewardDetail"];
        shed.isBeingFollowedToday = NO;
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date2 = [formatter dateFromString:appDelegate.todaysDate];
        NSString* todaysdate = [formatter stringFromDate:date2];
        NSLog(@"My Date %@", todaysdate);
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [format dateFromString:shed.start_date];
        
        NSString *dateQuery = [NSString stringWithFormat:@"Select followed_date from Shed_Data where id = \"%d\"",[shed.shed_id intValue]];
        
        FMResultSet *dateSet = [database executeQuery:dateQuery];
        followeddate = [[NSMutableArray alloc]init];
        while([dateSet next]) {
            NSString *tempStr = [dateSet stringForColumn:@"followed_date"];
            [followeddate addObject:tempStr];
            if([todaysdate isEqualToString:tempStr])
                shed.isBeingFollowedToday = YES;
        }
        shed.datesArray = followeddate;
        shed.applieddays = [followeddate count];
        NSDate *endDate = [format dateFromString:todaysdate];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
                                                           fromDate:startDate
                                                             toDate:endDate
                                                            options:0];
        totaldaysSelected = [totaldays day];
        totaldaysSelected +=1;
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
        
        if(shed.totaldays == 1 && shed.applieddays == 0)
            shed.percentage = 50;
        
        NSLog(@"Applied Days of the shed %d",shed.applieddays);
        NSLog(@"Total days of the shed %d",shed.totaldays);
        NSLog(@"percetage of the shed %f",shed.percentage);
        [shed_list addObject:shed];
    }
    
    if([sortingString isEqualToString:@"Cronological"])
    {
        [coronological setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
        [alphabatical setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
        [coronological setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
        [alphabatical setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"alarm_time"
                                                                        ascending:YES
                                                                         selector:@selector(localizedStandardCompare:)];
        shedlist = [self.shed_list sortedArrayUsingDescriptors:@[firstNameSort]];
        NSLog(@"Sorted by first name: %@", shedlist);
    }
    else if([sortingString isEqualToString:@"Alphabatical"])
    {
        [alphabatical setBackgroundImage:[UIImage imageNamed:@"tab-1.png"] forState:UIControlStateNormal];
        [alphabatical setTitleColor: [UIColor colorWithRed:153/255.0f green:50/255.0f blue:204/255.0f alpha:1] forState:UIControlStateNormal];
        [coronological setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [coronological setBackgroundImage:[UIImage imageNamed:@"tab-2.png"] forState:UIControlStateNormal];
        NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                        ascending:YES
                                                                         selector:@selector(localizedStandardCompare:)];
        shedlist = [self.shed_list sortedArrayUsingDescriptors:@[firstNameSort]];
        NSLog(@"Sorted by first name: %@", shedlist);
    }
    [database close];
}


- (void)launchDialog
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:[self createDemoView]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK ", nil]];
    [alertView setDelegate:self];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %ld.", buttonIndex, (long)[alertView tag]);
    [alertView close];
    }];
    [alertView setUseMotionEffects:true];
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %ld is clicked on alertView %ld.", (long)buttonIndex, (long)[alertView tag]);
    [alertView close];
    

    if ([[[NSUserDefaults standardUserDefaults ] valueForKey:@"Review"] isEqualToString:@"Done"])
    {
        return;
    }

    
     if ([[[NSUserDefaults standardUserDefaults ] valueForKey:@"Review"] isEqualToString:@""])
     {
         UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Looks like you enjoy using this app. Could you spare a moment of time to review it in app store? "delegate:self cancelButtonTitle:@"No,Thanks" otherButtonTitles:@"Rate It Now", nil];
         alert.tag=100;
         [alert show];
     }
     else if ([[[NSUserDefaults standardUserDefaults ] valueForKey:@"Review"] isEqualToString:@"Later"])
     {
         NSString*reviewDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"ReviewDate"];

         NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
         [formatter setDateFormat:@"yyyy-MM-dd"];
         NSDate* dateReview = [formatter dateFromString:reviewDate];
         NSDate*currentDate=[NSDate date];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
         NSDateComponents *difference = [gregorianCalendar components:NSDayCalendarUnit
                                                             fromDate:dateReview
                                                               toDate:currentDate
                                                              options:0];
         int diffr = [difference day];
         if (diffr>5)
         {
             UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Looks like you enjoy using this app. Could you spare a moment of time to review it in app store? "delegate:self cancelButtonTitle:@"No,Thanks" otherButtonTitles:@"Rate It Now", nil];
             alert.tag=100;
             [alert show];
         }
     }
}

- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280,100)];
    UITextView *textLbl;
    
    if (![shed.rewardImage isEqualToString:@""])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 70, 70)];
        NSData* data = [Base64 decode:shed.rewardImage ];
        imageView.image = [UIImage imageWithData:data];
        [demoView addSubview:imageView];
        textLbl=[[UITextView alloc]initWithFrame:CGRectMake(85, 13, 190, 80)];
    }
    else{
        textLbl=[[UITextView alloc]initWithFrame:CGRectMake(10, 13, 260, 80)];
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [textLbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:15]];
       //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        [textLbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:15]];
   // this is iphone 4 xib
    }
    else
    {
        [textLbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:17]];
        // this is ipad xib
    }
    
    textLbl.text=[NSString stringWithFormat:@"Congratulations, it is time to reward yourself with \"%@\".",shed.rewardDetail];
    textLbl.editable=NO;
    
    textLbl.backgroundColor=[UIColor clearColor];
    [demoView addSubview:textLbl];
    return demoView;
}

-(void)disable{
    list_table.userInteractionEnabled=NO;
    lifeTab.userInteractionEnabled=NO;
    workTab.userInteractionEnabled=NO;
    alphabatical.userInteractionEnabled=NO;
    coronological.userInteractionEnabled=NO;
    backBtnOutlt.userInteractionEnabled=NO;
    gratitudetxt.userInteractionEnabled=NO;
    postbtn.userInteractionEnabled=NO;
    fbButton.userInteractionEnabled=NO;
    fbInvitebtn.userInteractionEnabled=NO;
}
-(void)enable{
    list_table.userInteractionEnabled=YES;
    lifeTab.userInteractionEnabled=YES;
    workTab.userInteractionEnabled=YES;
    alphabatical.userInteractionEnabled=YES;
    coronological.userInteractionEnabled=YES;
    backBtnOutlt.userInteractionEnabled=YES;
    gratitudetxt.userInteractionEnabled=YES;
    postbtn.userInteractionEnabled=YES;
    fbButton.userInteractionEnabled=YES;
    fbInvitebtn.userInteractionEnabled=YES;
}

- (IBAction)fbInviteBtn:(id)sender
{
    [self.view endEditing:YES];
     alertTxt=3;
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:[NSString stringWithFormat:@"I have been using this great App, SHEDs - Simple Habits Every Day, to get my life on track and firing. You must try it. It's awesome."]
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         alertTxt=0;
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





@end
