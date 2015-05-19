//
//  mastered_shedViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 1/9/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "mastered_shedViewController.h"


@interface mastered_shedViewController ()

@end

@implementation mastered_shedViewController
@synthesize header_title,shed,mastered_list,deletebtn,strid,rowData,movebtn,appDelegate,followeddate,totaldaysSelected,data3,indexList,shedname,seperatorimg,shedtotalrun,seperatorimg1,shedapplieddays,shedlongestrun,daysarray,result;
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
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    NSLog(@"Shed ID in Masterd Shed%@",strid);
    NSString *masteredStr = [[NSString alloc] initWithFormat:@"YES"];
    NSString *queryString = [NSString stringWithFormat:@"Select * from shed where isMastered = \"%@\"",masteredStr];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    mastered_list = [[NSMutableArray alloc]init];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    shed =[[SHED alloc] init];
    rowData = [[NSMutableArray alloc] init];
    FMResultSet *results = [database executeQuery:queryString];
    [mastered_list removeAllObjects];
    
    while([results next]) {
        shed	= [[SHED alloc] init];
        shed.shed_id = [results stringForColumn:@"shed_id"];
        shed.name = [results stringForColumn:@"name"];
        shed.start_date = [results stringForColumn:@"start_date"];
        shed.alarm_days = [results stringForColumn:@"alarm_days"];
        shed.masteredDate = [results stringForColumn:@"masteredDate"];
        
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
        
        
        
        NSDate *endDate = [format dateFromString:shed.masteredDate];
        
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
                                                           fromDate:startDate
                                                             toDate:endDate
                                                            options:0];
        totaldaysSelected = [totaldays day];
        
        //if(shed.totaldays==0)
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
        
        
         NSString *queryStringlongestrun = [NSString stringWithFormat:@"Select current_run, longest_run FROM Shed_Data Group By id Having followed_date = Max(followed_date) And id = %d",[shed.shed_id intValue]];
        FMResultSet *longestrundateSet = [database executeQuery:queryStringlongestrun];
        while([longestrundateSet next]) {
            shed.longest_run = [longestrundateSet intForColumn:@"longest_run"];
        }
        
        NSLog(@"Applied Days of the shed %d",shed.applieddays);
        NSLog(@"Total days of the shed %d",shed.totaldays);
        NSLog(@"Longest Run of the shed %d",shed.longest_run);
        
        [mastered_list addObject:shed];
    }
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [header_title setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];

    }
    else{
        [header_title setFont: [UIFont fontWithName:@"Helvetica Neue" size:63]];

    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveback:(id)sender {
    homescreenViewController *home;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
        //this is iphone 5 xib
    } else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }else{
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
    
    [self.navigationController pushViewController:home animated:NO];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mastered_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index row %ld", (long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          
    for(UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    shed = [mastered_list objectAtIndex:indexPath.row];
    //cell.textLabel.text = shed.name;
      deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    movebtn = [UIButton buttonWithType:UIButtonTypeCustom];

    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        shedname = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 215, 30)];
        shedtotalrun = [[UILabel alloc] initWithFrame:CGRectMake(15, 32, 180, 30)];
        seperatorimg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 34, 5, 26)];
        shedapplieddays = [[UILabel alloc] initWithFrame:CGRectMake(50, 32, 180, 30)];
        seperatorimg1 = [[UIImageView alloc] initWithFrame:CGRectMake(70, 34, 5, 26)];
        shedlongestrun = [[UILabel alloc] initWithFrame:CGRectMake(85, 32, 180, 30)];
        deletebtn.frame = CGRectMake(220, 13, 52, 42);
        movebtn.frame = CGRectMake(265, 13, 52, 42);
        [shedname setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
        [shedtotalrun setFont:[UIFont fontWithName:@"Lucida Sans" size:15]];
        [shedapplieddays setFont:[UIFont fontWithName:@"Lucida Sans" size:15]];
        [shedlongestrun setFont:[UIFont fontWithName:@"Lucida Sans" size:15]];


    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        shedname = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 215, 30)];
        shedtotalrun = [[UILabel alloc] initWithFrame:CGRectMake(15, 32, 180, 30)];
        seperatorimg = [[UIImageView alloc] initWithFrame:CGRectMake(35, 34, 5, 26)];
        shedapplieddays = [[UILabel alloc] initWithFrame:CGRectMake(50, 32, 180, 30)];
        seperatorimg1 = [[UIImageView alloc] initWithFrame:CGRectMake(70, 34, 5, 26)];
        shedlongestrun = [[UILabel alloc] initWithFrame:CGRectMake(85, 32, 180, 30)];
        deletebtn.frame = CGRectMake(220, 13, 52, 42);
        movebtn.frame = CGRectMake(265, 13, 52, 42);
        [shedname setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
        [shedtotalrun setFont:[UIFont fontWithName:@"Lucida Sans" size:15]];
        [shedapplieddays setFont:[UIFont fontWithName:@"Lucida Sans" size:15]];
        [shedlongestrun setFont:[UIFont fontWithName:@"Lucida Sans" size:15]];
    }
    else
    {
        shedname = [[UILabel alloc] initWithFrame:CGRectMake(20, 5,500, 60)];
        shedtotalrun = [[UILabel alloc] initWithFrame:CGRectMake(25, 70, 180, 30)];
        seperatorimg = [[UIImageView alloc] initWithFrame:CGRectMake(70, 67, 5, 40)];
        seperatorimg1 = [[UIImageView alloc] initWithFrame:CGRectMake(140, 67, 5,40)];
        shedapplieddays = [[UILabel alloc] initWithFrame:CGRectMake(95, 70, 180, 30)];
        shedlongestrun = [[UILabel alloc] initWithFrame:CGRectMake(165, 70, 180, 30)];
        deletebtn.frame = CGRectMake(520, 10, 114, 93);
        movebtn.frame = CGRectMake(622, 10, 114, 93);
        [shedname setFont:[UIFont fontWithName:@"Lucida Sans" size:36]];
        [shedtotalrun setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [shedapplieddays setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        [shedlongestrun setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
    }
    
    //gratlbl.textColor = [UIColor grayColor];
    shedname.textAlignment = NSTextAlignmentLeft;
    shedname.numberOfLines = 2;
    [cell addSubview:shedname] ;
    
    //gratlbl.textColor = [UIColor grayColor];
    shedtotalrun.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:shedtotalrun] ;
    
    seperatorimg.image = [UIImage imageNamed:@"seperator.png"];
    [cell addSubview:seperatorimg];
    seperatorimg1.image = [UIImage imageNamed:@"seperator.png"];
    [cell addSubview:seperatorimg1];
    //gratlbl.textColor = [UIColor grayColor];
    shedapplieddays.textAlignment = NSTextAlignmentLeft;
    shedapplieddays.numberOfLines = 2;
    [cell addSubview:shedapplieddays] ;
    
   
    
    
    //gratlbl.textColor = [UIColor grayColor];
    shedlongestrun.textAlignment = NSTextAlignmentLeft;
    shedlongestrun.numberOfLines = 2;
    [cell addSubview:shedlongestrun] ;
    
  
    deletebtn.tag = 200+indexPath.row;
    [deletebtn addTarget:self action:@selector(removesheddata:) forControlEvents:UIControlEventTouchUpInside];
    
    movebtn.tag = 400+indexPath.row;
    [movebtn addTarget:self action:@selector(moveshed:) forControlEvents:UIControlEventTouchUpInside];
    
    [deletebtn setBackgroundImage:[UIImage imageNamed:@"delete-icon.png"]forState:UIControlStateNormal];
    [movebtn setBackgroundImage:[UIImage imageNamed:@"currentShed-icon.png"]forState:UIControlStateNormal];
    cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
    [cell.contentView addSubview:deletebtn];
    [cell.contentView addSubview:movebtn];
    

    shedname.text = shed.name;
    shedtotalrun.text = [[NSString alloc] initWithFormat:@"%d",shed.totaldays];
    shedapplieddays.text = [[NSString alloc] initWithFormat:@"%d",shed.applieddays];
    shedlongestrun.text = [[NSString alloc] initWithFormat:@"%d",shed.longest_run];
    
   
    
    
    return cell;
}
-(IBAction)moveshed:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-400 inSection:0];
    //UITableViewCell *cell = (UITableViewCell*)[list_table cellForRowAtIndexPath:indexPath];
    shed =[mastered_list objectAtIndex:indexPath.row];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    NSString *masteredStr = [[NSString alloc] initWithFormat:@"NO"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    [database open];
    int count = [database intForQuery:@"SELECT COUNT(shed_id) FROM SHED where isMastered ='NO'"];
    
    NSLog(@"path : %d", count);
    NSString *insertSQL12 = [NSString stringWithFormat:@"SELECT COUNT(shed_id) FROM SHED where isMastered = '%@'",@"NO"];
    NSLog(@"count path : %@", insertSQL12);
    if (count == 6) {
        UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@" SHEDs"  message:@"Limit Reached " delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        savealert.tag = 1;
        [savealert show];
    }
    else{
        UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@" SHEDs"  message:@" Are you sure you want to move the Shed to Current SHEDs?\n (Note:- All the data and statistics of the shed will be removed.)" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Cancel",nil];
        delete_tag = sender.tag;
        savealert.tag =2;
        [savealert show];
    }
    [database close];
    [self viewDidLoad];
    [self.mastered_tableview reloadData];
    
}

-(void) scheduleNotificationForDate: (NSString*)days: (NSString*)myDate1: (NSString*)desc{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *curdate = [dateFormat dateFromString:appDelegate.todaysDate];
    
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:curdate]; // Get necessary date components
    
    NSArray *tempStr = [myDate1 componentsSeparatedByString:@":"];
    
    NSLog(@"month %ld", (long)[components month]);
    NSLog(@"year %ld", (long)[components year]);
    NSLog(@"day %ld", (long)[components day]);
    NSLog(@"hour %d", [[tempStr objectAtIndex:0] intValue]);
    NSLog(@"minute %d", [[tempStr objectAtIndex:1] intValue]);
    
    
    NSDateComponents *tempComp = [[NSDateComponents alloc] init];
    
    
    //
    NSArray *daysstr = [days componentsSeparatedByString:@","];
    NSLog(@"Selected Days Name: %@", daysstr);
    int i;
    int weekDay = [components weekday];
    
    for (i = 0; i < [daysstr count]; i++) {
        NSDateComponents *dateParts = [[NSDateComponents alloc] init];
        
        [dateParts setHour:[[tempStr objectAtIndex:0] intValue]];
        [dateParts setMinute:[[tempStr objectAtIndex:1] intValue]];
        [dateParts setSecond:00];
        
        NSString *myArrayElement = [daysstr objectAtIndex:i];
        if ([myArrayElement isEqualToString:@"Sunday"]) {
            
            tempComp.day = 1-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Monday"]) {
            
            tempComp.day = 2-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Tuesday"]) {
            
            tempComp.day = 3-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Wednesday"]) {
            tempComp.day = 4-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Thursday"]) {
            
            tempComp.day = 5-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Friday"]){
            
            tempComp.day = 6-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        else if ([myArrayElement isEqualToString:@"Saturday"]) {
            
            tempComp.day = 7-weekDay;
            NSDate *newdate = [calendar dateByAddingComponents:tempComp toDate:curdate options:0];
            NSDateComponents *newComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:newdate];
            [dateParts setYear:[newComp year]];
            [dateParts setMonth:[newComp month]];
            [dateParts setDay:[newComp day]];
        }
        NSString *queryString = [NSString stringWithFormat:@"SELECT shed_id FROM SHED WHERE shed_id = (SELECT MAX(shed_id) FROM SHED)"];
        
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        NSLog(@"query %@", queryString);
        NSLog(@"path : %@", dbPath);
        [database open];
        
        FMResultSet *results = [database executeQuery:queryString];
        NSString *str;
        
        while([results next]) {
            str = [results stringForColumn:@"shed_id"];
            NSLog(@"ID is :: %@",str);
        }
        NSString *tempString = [NSString stringWithFormat:@"%@%@", str, myArrayElement];
        NSLog(@"Habit Name :  %@", desc);
        NSDate *sDate = [calendar dateFromComponents:dateParts];
        
        NSDictionary *userDict = [NSDictionary dictionaryWithObjectsAndKeys:tempString, @"SHED_ID", nil];
        localNotif.userInfo = userDict;
        
        localNotif.fireDate = sDate;
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.repeatInterval = NSWeekdayCalendarUnit;
        localNotif.alertAction = NSLocalizedString(@"View Details", nil);
        localNotif.alertBody = desc;
        localNotif.soundName =UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        NSLog(@"notification started");
    }
    
}
-(IBAction)removesheddata:(UIControl *)sender {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete this SHEDs" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel", nil];
    _tag = sender.tag;
    
    alert.tag = 0;
    [alert show];

    }

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && alertView.tag == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_tag-200 inSection:0];
        //UITableViewCell *cell = (UITableViewCell*)[list_table cellForRowAtIndexPath:indexPath];
        shed =[mastered_list objectAtIndex:indexPath.row];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"shed_db.sqlite"];
        int shedid = [shed.shed_id intValue];
        NSLog(@"shed id of deleting shed is %d",shedid);
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM SHED WHERE shed_id = %d",shedid] ;
        [database executeUpdate:deleteQuery];
        NSLog(@"SHED REMOVED");
        [database close];
        
        [self viewDidLoad];
        [self.mastered_tableview reloadData];
    }
    else if (buttonIndex == 0 && alertView.tag == 1)
    {
        [self viewDidLoad];
    }
    else if (buttonIndex == 0 && alertView.tag == 2)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:delete_tag - 400 inSection:0];
        //UITableViewCell *cell = (UITableViewCell*)[list_table cellForRowAtIndexPath:indexPath];
        shed =[mastered_list objectAtIndex:indexPath.row];
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        NSString *masteredStr = [[NSString alloc] initWithFormat:@"NO"];
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        
        [database open];
      
            NSLog(@"shed id in moveshed %@", shed.shed_id);
            NSString *insertSQL = [NSString stringWithFormat:@"UPDATE SHED SET isMastered = '%@',start_date = \"%@\" where shed_id = %@", masteredStr, appDelegate.todaysDate,shed.shed_id];
            [database executeUpdate:insertSQL];
            
            NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM Shed_Data WHERE id = \"%@\"",shed.shed_id] ;
            [database executeUpdate:deleteQuery];
            daysarray = [[NSMutableArray alloc] initWithObjects:shed.alarm_days, nil];
            
            result = [[daysarray valueForKey:@"description"] componentsJoinedByString:@","];
            if([shed.alarm_status isEqualToString:@"1"])
                [self scheduleNotificationForDate:result :shed.alarm_time :shed.name];
        
        [database close];
        [self viewDidLoad];
        [self.mastered_tableview reloadData];

        [self viewDidLoad];
    }
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
    // NSUInteger count = [database intForQuery:@"SELECT COUNT(*) FROM Shed_Data"];
    //    if(![results hasAnotherRow]) {
    //        current_run = 1;
    //    }else{
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
        }else{
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
    if (shed.applieddays >= 21) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Well done. You have performed the SHED for 21 days" message:@"Do you wish to transfer to Mastered SHEDs?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag =1;
        [alert show];
        
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

@end
