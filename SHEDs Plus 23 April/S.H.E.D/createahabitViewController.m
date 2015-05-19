
//  createahabitViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/21/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import "createahabitViewController.h"
#import "homescreenViewController.h"
#import "SHED.h"
#import "FMDatabaseAdditions.h"
#import "Base64.h"
#import "PageWebViewController.h"
@interface createahabitViewController ()
@end

@implementation createahabitViewController
@synthesize celltitles,habitstableview,toggleswitch,pickdate,timelbl,dscptxt,habitname,tableview,daystable,daysarray,timetitlelbl, checkedIndexPath,popoverController,SHEDlist,databasePath,header,sub_header, footer,actionsheet,model,daysString,checkmark,savebtn,titlelbl,habitnamestr,alarmstatusarray,alarmdaysstr,flag,shedobj,insertSQL,isMasteredstr,result,str,appDelegate,HabittextfeildView,habittextview,donebutton,tempStr,pickrViewIpad,datePickerIpad,pickrTittle,alerttitlelbl,worktitlelbl,lifetitlelbl,workBtn,lifeBtn,isLifeBtn,isworkBtn,shedNameStr,addRewardsDone,rewardsPopUpView,rewardImgView,rewardStreakTxt,rewarddetailLbl,rewardDetailTxt,cancelBtn,daysLbl,backBtn,removIcon,rewardTogleswitch,saveTimeStr,is24h,imagearray,bgView,ScrollViewBg;

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
    imagearray=[[NSMutableArray alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    NSLog(@"%@",(is24h ? @"YES" : @"NO"));

    [[rewardsPopUpView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[rewardsPopUpView layer] setBorderWidth:1.0];
    [[rewardsPopUpView layer] setCornerRadius:5];
    [[addRewardsDone layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[addRewardsDone layer] setBorderWidth:1.0];
    [[addRewardsDone layer] setCornerRadius:5];
    [[cancelBtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[cancelBtn layer] setBorderWidth:1.0];
    [[cancelBtn layer] setCornerRadius:5];
    [[rewardDetailTxt layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[rewardDetailTxt layer] setBorderWidth:1.0];
    [[rewardDetailTxt layer] setCornerRadius:3];
   
//    habitnamestr = [NSString stringWithFormat:@""];
//    timelblstr= [NSString stringWithFormat:@"5:00"];
//    daysstr = [NSString stringWithFormat:@""];
   
    //[habitname setText:[NSString stringWithFormat:@"PrefilledValue"]];
    
    SHEDlist = [[SHED_listViewController alloc] init];
    appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    appDelegate.navigator.navigationBar.tintColor = [UIColor clearColor];
    alarmstatusarray=[[NSMutableArray alloc]init];
    tempStr = @"";
    
    if (flag == 1) {
        //[rewrdsToggle setOn:NO animated:NO];
        titlelbl.text = @"Add SHEDs";
    }
    else if (flag == 2){
        titlelbl.text = @"Edit SHEDs";
        if (rewardStreakStr ==nil ||rewrardDetailStr ==nil)
        {
            rewardStreakStr=shedobj.rewardStreak;
            rewrardDetailStr=shedobj.rewardDetail;
            rewardImageStr=shedobj.rewardImage;
            rewardStatus=shedobj.rewardStatus;
        }
        rewarddetailLbl.hidden=YES;
        NSLog(@"rewardStatus..%d",shedobj.rewardStatus);
//        if (shedobj.rewardStatus==0)
//        {
//            [rewrdsToggle setOn:NO animated:NO];
//        }
//        else{
//            [rewrdsToggle setOn:YES animated:NO];
//        }
        rewardStreakTxt.text=shedobj.rewardStreak;
        rewardDetailTxt.text=shedobj.rewardDetail;
        NSData* data = [Base64 decode:shedobj.rewardImage ];
        rewardImgView.image = [UIImage imageWithData:data];
    }
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
    }
    else{
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
    }

    habitstableview.delegate = self;
    habitstableview.dataSource = self;
    timelbl.hidden = YES;
    //savebtn setBackgroundImage:[UIImage imageNamed:@"save-icon.png"] forState:
    celltitles =[[NSMutableArray alloc] initWithObjects:@"Name",@"",@"",@"Set Rewards",@"Days Applied",@"Select All",@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    daysarray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savedata:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [self.habitstableview reloadData];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.rewardsPopUpView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}
-(void)dismissKeyboard

{
    [rewardStreakTxt resignFirstResponder];
}
- (void)savedata:(id)sender
{
    saveTimeStr=[NSString stringWithFormat:@"%@",timelbl.text];
    if (saveTimeStr.length>5)
    {
        NSLog(@"am pm format..");
        NSArray*temptimeArray = [saveTimeStr componentsSeparatedByString:@" "];
        NSString *isAmPm=[temptimeArray objectAtIndex:1];
        NSString  *timeValue=[saveTimeStr  substringWithRange:NSMakeRange(0, 2)];
        saveTimeStr=[saveTimeStr substringToIndex:5];
        if ([isAmPm isEqualToString:@"pm"]|| [isAmPm isEqualToString:@"PM"] || [isAmPm isEqualToString:@"Pm"])
        {
            int hours=[timeValue intValue] +12;
            if (hours==24) {
                hours=12;
            }
            NSString *housStr=[NSString stringWithFormat:@"%d",hours];
            NSString *minutes=[saveTimeStr substringWithRange:NSMakeRange(3, 2)];
            saveTimeStr =[NSString stringWithFormat:@"%@:%@",housStr,minutes];
        }
        else{
            int hours=[timeValue intValue] +12;
            if (hours==24) {
                NSString *housStr=[NSString stringWithFormat:@"00"];
                NSString *minutes=[saveTimeStr substringWithRange:NSMakeRange(3, 2)];
                saveTimeStr =[NSString stringWithFormat:@"%@:%@",housStr,minutes];
            }
        }
    }
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    NSString *type;
    NSString *otherType;
    
    if ( rewardStreakStr ==NULL || rewardStreakStr ==nil)
    {
        rewardStreakStr=@"";
    }
    if ( rewrardDetailStr ==NULL || rewrardDetailStr ==nil)
    {
        rewrardDetailStr=@"";
    }
    if (flag==2)
    {
        if (isLifeBtn)
        {
            type = @"life";
            otherType=@"work";
        }
        else if(isworkBtn)
        {
            type = @"work";
            otherType=@"life";
        }
        else{
            type=shedobj.type;
        }
    }
    else
    {
        if (isworkBtn)
        {
            type = @"work";
            otherType=@"life";
        }
        else
        {
            type = @"life";
            otherType=@"work";
        }
    }

    int count = [db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(shed_id) FROM SHED where isMastered ='NO' and type = \"%@\"",type]];

    if (flag==2)
    {
        if ([shedobj.type isEqualToString:type]) {
            count=count-1;
        }
    }
    if (count == 12){
        UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:[NSString stringWithFormat:@"Limit of %@ SHEDs have been reached. Please try saving it as %@ SHED.",type,otherType] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [savealert show];
    }
    else
    {
        for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
        {
            if ([notify.alertBody isEqualToString:self.habitname.currentTitle]) {
                NSLog(@"the notification this is canceld is %@", notify.alertBody);
                [[UIApplication sharedApplication] cancelLocalNotification:notify] ;
                // delete the notification from the system
            }
        }
        //NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GTM"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        
        //NSString *dateStr = [dateFormat stringFromDate:date2];
         result = [[daysarray valueForKey:@"description"] componentsJoinedByString:@","];

       // NSDate *date = [dateFormat dateFromString:timelbl.text];
        NSLog(@"Todays Date ::::::::::::::: %@",appDelegate.todaysDate);

        daysString = [daysarray componentsJoinedByString:@","];
        NSLog(@"Days String :%@",daysString );
      
        if ([tempStr isEqualToString:@""] ){
            UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:@"Please enter SHEDs Description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                habittextview.text=@"";
            [savealert show];
        }
         
        else if ([daysString  isEqual: @""]){
            UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:@"Kindly Select at least one day." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [savealert show];
        }
        
        else if (rewardStatus==1 &&rewardStreakStr.length ==0 && rewrardDetailStr.length ==0)
        {
            UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:@"Please set rewards." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            habittextview.text=@"";
            [savealert show];
            
        }
        else if (rewardStatus==1 && rewardStreakStr.length ==0)
        {
            UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:@"Please enter rewards run." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            habittextview.text=@"";
            [savealert show];
            
        }
        else if (rewardStatus==1 && [rewardStreakStr isEqualToString:@"0"]) {
            UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"SHEDs" message:@"Please enter reward run" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
           // rewardStreakTxt.text=@"";
        }

        else if (rewardStatus==1 && rewrardDetailStr.length ==0)
            
        {
            UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@"SHEDs"  message:@"Please enter rewards Description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            habittextview.text=@"";
            [savealert show];
        }
        else
        {
            NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDir = [docPaths objectAtIndex:0];
            NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
            isMasteredstr = [[NSString alloc] initWithFormat:@"NO"];
            FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            UIAlertView *savealert;
          
           if (flag == 2 ||flag==9)
            {
                if (type ==nil)
                {
                     insertSQL = [NSString stringWithFormat:@"UPDATE SHED SET name = \"%@\" ,alarm_time = \"%@\" , alarm_status = \"%d\", alarm_days = \"%@\", type=\"%@\" ,rewardImage=\"%@\",rewardDetail=\"%@\",rewardStreak=\"%@\",rewardStatus=%d where shed_id = \"%@\"",tempStr, saveTimeStr,self.toggleswitch.on, self.daysString, shedobj.type,rewardImageStr,rewrardDetailStr,rewardStreakStr,rewardStatus, shedobj.shed_id];
                }
                else if(flag==2)
                {
                    insertSQL = [NSString stringWithFormat:@"UPDATE SHED SET name = \"%@\" ,alarm_time = \"%@\" , alarm_status = \"%d\", alarm_days = \"%@\", type=\"%@\",rewardImage=\"%@\",rewardDetail=\"%@\",rewardStreak=\"%@\",rewardStatus=%d where shed_id = \"%@\"",tempStr, saveTimeStr,self.toggleswitch.on, self.daysString,type,rewardImageStr,rewrardDetailStr,rewardStreakStr,rewardStatus,shedobj.shed_id];
                }
                
                savealert = [[UIAlertView alloc] initWithTitle:@" Congratulations!!!"  message:@"Your SHED has been updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            
            else if(flag==1)
            {
                insertSQL = [NSString stringWithFormat:@"INSERT INTO SHED ( name,alarm_time,start_date , alarm_status, alarm_days, isMastered, type,rewardImage,rewardDetail,rewardStreak,rewardStatus) VALUES (\"%@\", \"%@\", \"%@\",\"%hhd\",\"%@\",'%@', \"%@\",\"%@\",'%@', \"%@\",%d)",tempStr, saveTimeStr,appDelegate.todaysDate,self.toggleswitch.on, self.daysString,self.isMasteredstr, type,rewardImageStr,rewrardDetailStr,rewardStreakStr,rewardStatus];
            
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"addShedLastDate"];
                [defaults setValue:[NSString stringWithFormat:@"%@",appDelegate.todaysDate] forKey:@"addShedLastDate"];
                [[NSUserDefaults standardUserDefaults] synchronize];
             
                savealert = [[UIAlertView alloc] initWithTitle:@" Congratulations!!!"  message:[NSString stringWithFormat:@"Your %@ SHED has been created successfully.",type] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            [database executeUpdate:insertSQL];
            savealert.tag = 1;
            [savealert show];
            [database close];
        }
        
        if(toggleswitch.on)
        {
            NSLog(@"RESULTS :: %@",self.habitname.currentTitle);
            NSString *str22 = [NSString stringWithFormat:@"%@",self.habitname.currentTitle];
            [self scheduleNotificationForDate:result :saveTimeStr :str22];
        }
        else
        {
            for(UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
            {
                if ([notify.alertBody isEqualToString:self.habitname.currentTitle])
                {
                    NSLog(@"the notification this is canceld is %@", notify.alertBody);
                    [[UIApplication sharedApplication] cancelLocalNotification:notify] ;
                    // delete the notification from the system
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if (buttonIndex == 0 && alertView.tag == 1)
    {
        self.habitname.titleLabel.text = @"";
        self.dscptxt.text = @"";
        homescreenViewController *home;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];        //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else
        {
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
   else if(alertView.tag==5 && buttonIndex==1 && [title isEqualToString:@"OK"])
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

    else if (buttonIndex == 0 && alertView.tag == 2)
    {
        [self savedata:nil];
       // Add another action here
    }
    else if (buttonIndex == 1 && alertView.tag == 2)
    {
        homescreenViewController *home;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {

            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else
        {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_ipad" bundle:nil];
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
    else if (alertView.tag==9)
    {
        if (buttonIndex==0)
        {
            
            rewrardDetailStr = [NSString stringWithFormat:@"%@",rewardDetailTxt.text];
            rewrardDetailStr = [rewrardDetailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            rewardStreakStr = [NSString stringWithFormat:@"%@",rewardStreakTxt.text];
            rewardStreakStr = [rewardStreakStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         //   rewardStatus=self.rewrdsToggle.on;
            
            [Base64 initialize];
            
            CGSize size=[rewardImgView.image size] ;
            NSLog(@"%f",size.width);
            NSLog(@"%f",size.height);
            if (size.width >100 ||size.height>100)
            {
                CGRect rect = CGRectMake(0,0,100,100);
                UIGraphicsBeginImageContext(rect.size);
                [rewardImgView.image drawInRect:rect];
                rewardImgView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            UIImage *small = [UIImage imageWithCGImage:rewardImgView.image.CGImage scale :0.25 orientation:rewardImgView.image.imageOrientation];
            NSData* data = UIImageJPEGRepresentation(small,0.1f);
            
            NSString *strEncoded = [Base64 encode:data ];
            rewardImageStr=[[NSString alloc]initWithFormat:@"%@",strEncoded];
            NSLog(@"%@",rewardImageStr);
            NSLog(@"reward length..%lu",(unsigned long)rewardImageStr.length);
            rewardsPopUpView.hidden=YES;
            tableview.userInteractionEnabled=YES;
            savebtn.userInteractionEnabled=YES;
            backBtn.userInteractionEnabled=YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0)
    {
        return [celltitles count];
    }
    else
    {
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
        cell.textLabel.text = [celltitles objectAtIndex:indexPath.row];
            if (indexPath.row == 0)
        {
            NSLog(@"FLAG NALUE %d",flag);
          
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                habitname = [[UIButton alloc]initWithFrame:CGRectMake(100, -3, 200, 50)];
                timelbl = [[UILabel alloc] initWithFrame:CGRectMake(-20, -5, 240, 50)];
                worktitlelbl = [[UILabel alloc] initWithFrame:CGRectMake(13, -5, 115, 50)];
                lifetitlelbl=[[UILabel alloc]initWithFrame:(CGRectMake(100, -5, 240, 50))];
                timetitlelbl = [[UILabel alloc] initWithFrame:CGRectMake(-1,-5, 70, 50)];
                alerttitlelbl=[[UILabel alloc]initWithFrame:(CGRectMake(90, -5, 240, 50))];
                toggleswitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 2, 50, 60)];
                rewardTogleswitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 2, 50, 60)];
                [timetitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                [alerttitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                [worktitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                [lifetitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:18];
                [rewardDetailTxt setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                [rewardStreakTxt setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                [daysLbl setFont:[UIFont fontWithName:@"Lucida Sans" size:16]];

                [habitname.titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:18]];
                //this is iphone 5 xib
            }
            else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
                habitname = [[UIButton alloc]initWithFrame:CGRectMake(100, 1, 200, 30)];
                timelbl = [[UILabel alloc] initWithFrame:CGRectMake(-20, 0, 240, 40)];
                alerttitlelbl=[[UILabel alloc]initWithFrame:(CGRectMake(80,-4, 240, 40))];
                worktitlelbl = [[UILabel alloc] initWithFrame:CGRectMake(13,-4, 115, 40)];
                lifetitlelbl=[[UILabel alloc]initWithFrame:(CGRectMake(90, -8, 240, 40))];
                timetitlelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, 70, 40)];
                toggleswitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 1, 50, 30)];
                [timetitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:16]];
                cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:16];
                [alerttitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:16]];
                [worktitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:16]];
                [lifetitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:16]];
                [habitname.titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:16]];
                 rewardTogleswitch = [[UISwitch alloc] initWithFrame:CGRectMake(250, 1, 50, 30)];
                [rewardDetailTxt setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                [rewardStreakTxt setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
                [daysLbl setFont:[UIFont fontWithName:@"Lucida Sans" size:16]];


                // this is iphone 4 xib
            }
            else{
                habitname = [[UIButton alloc]initWithFrame:CGRectMake(150, 17, 580, 40)];
                timelbl = [[UILabel alloc] initWithFrame:CGRectMake(46, 10, 270, 50)];
                alerttitlelbl=[[UILabel alloc]initWithFrame:(CGRectMake(480, 5, 170, 50))];
                worktitlelbl = [[UILabel alloc] initWithFrame:CGRectMake(12,5, 250, 50)];
                lifetitlelbl=[[UILabel alloc]initWithFrame:(CGRectMake(490, 5, 240, 50))];
                timetitlelbl = [[UILabel alloc] initWithFrame:CGRectMake(-2, 10, 110, 50)];
                toggleswitch = [[UISwitch alloc] initWithFrame:CGRectMake(690, 15, 70, 50)];
                [timetitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
                [habitname.titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:25]];
                cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:30];
                [alerttitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
                // this is ipad xib
                [worktitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
                [lifetitlelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
                rewardTogleswitch = [[UISwitch alloc] initWithFrame:CGRectMake(690, 15, 70, 50)];
                [rewardDetailTxt setFont:[UIFont fontWithName:@"Lucida Sans" size:25]];
                [rewardStreakTxt setFont:[UIFont fontWithName:@"Lucida Sans" size:22]];
                [daysLbl setFont:[UIFont fontWithName:@"Lucida Sans" size:22]];
            }
            
         
            
//            UIEdgeInsets titleInsets =
//            UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, -8.0f);
//            
//            UIEdgeInsets contentInsets =
//            UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
//            
//            [habitname setTitleEdgeInsets:titleInsets];
//            [habitname setContentEdgeInsets:contentInsets];
           
            habitname.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [habitname setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
           
            [habitname addTarget:self
                          action:@selector(myAction:)
                forControlEvents:UIControlEventTouchUpInside];
            
            if (flag == 1){
                tempStr = @"";
                [habitname setTitle:@"SHEDs Description" forState:UIControlStateNormal];
                
            }
            else if (flag == 2){
                tempStr = [NSString stringWithFormat:@"%@",shedobj.name];
                shedNameStr=[NSString stringWithFormat:@"%@",tempStr];
                NSLog(@"shed name= %@",shedNameStr);
                NSString *edithabitName;
                
                if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
                    NSString *str1 = [NSString stringWithFormat:@"%@",shedobj.name];
                    NSRange stringRange = {0, MIN([str1 length], 20)};
                    
                    // adjust the range to include dependent chars
                    stringRange = [str1 rangeOfComposedCharacterSequencesForRange:stringRange];
                    
                    // Now you can create the short string
                    NSString *shortString = [str1 substringWithRange:stringRange];
                    
                    if (str1.length <= 20) {
                        edithabitName = [NSString stringWithFormat:@"%@",shortString];
                    }else{
                        edithabitName = [NSString stringWithFormat:@"%@...",shortString];
                    }
                }
                else{
                    NSString *str1 = [NSString stringWithFormat:@"%@",shedobj.name];
                    edithabitName = [NSString stringWithFormat:@"%@...",str1];
                    
                    NSRange stringRange = {0, MIN([str1 length], 35)};
                    
                    // adjust the range to include dependent chars
                    stringRange = [str1 rangeOfComposedCharacterSequencesForRange:stringRange];
                    
                    // Now you can create the short string
                    NSString *shortString = [str1 substringWithRange:stringRange];
                    if (str1.length <= 35) {
                        edithabitName = [NSString stringWithFormat:@"%@",shortString];
                    }
                    else{
                        edithabitName = [NSString stringWithFormat:@"%@...",shortString];
                    }
                }
                [habitname setTitle:edithabitName forState:UIControlStateNormal];
                [habitname.titleLabel setTextAlignment: NSTextAlignmentRight];
                NSLog(@"Alarm NAME :-------------- %@",shedobj.name);
            }
            
            //habitname = [[UITextField alloc] init];
            //cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:20];
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            [cell addSubview:habitname];
        }
        else if (indexPath.row == 1)
        {
            if (flag == 1){
                if (is24h)
                {
                  timelbl.text = @"05:00";
                }
                else{
                    timelbl.text = @"05:00 AM";
                }
            }
            else if (flag == 2){
                if (is24h)
                {
                    [timelbl setText:shedobj.alarm_time];
                    NSLog(@"Alarm Time :-------------- %@",shedobj.alarm_time);
                }
                else
                {
                    NSString *alarmTime=[NSString stringWithFormat:@"%@",shedobj.alarm_time];
                    NSString  *timeValue=[alarmTime  substringWithRange:NSMakeRange(0, 2)];
                        if ([timeValue intValue]>=12)
                        {
                            int hours=[timeValue intValue] -12;
                            if (hours==00) {
                                hours=12;
                            }
                            NSString *housStr=[NSString stringWithFormat:@"%d",hours];
                            NSString *minutes=[alarmTime substringWithRange:NSMakeRange(3, 2)];
                            [timelbl setText:[NSString stringWithFormat:@"%@:%@ PM",housStr,minutes]];
                        }
                
                        else
                        {
                        int hours=[timeValue intValue] ;
                            if (hours==00)
                            {
                                NSString *housStr=[NSString stringWithFormat:@"12"];
                                NSString *minutes=[alarmTime substringWithRange:NSMakeRange(3, 2)];
                                [timelbl setText:[NSString stringWithFormat:@"%@:%@ AM",housStr,minutes]];
                            }
                            else
                            {
                                [timelbl setText:[NSString stringWithFormat:@"%@ AM",alarmTime]];
                            }
                        }
                }
  
            }
            UIFont* boldFont;
            if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
                 boldFont = [UIFont boldSystemFontOfSize:18];
                cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:18];

            }
            else{
                boldFont = [UIFont boldSystemFontOfSize:30];
                cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:30];

            }
            [timelbl setFont:boldFont];
            timelbl.textColor=[UIColor blackColor];
           // timelbl.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
            timelbl.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:timelbl];
            alerttitlelbl.text=@"Alert";
            alerttitlelbl.textAlignment = NSTextAlignmentCenter;
           
            timetitlelbl.text = @"Time";
            timetitlelbl.textAlignment = NSTextAlignmentCenter;
            [cell addSubview:timetitlelbl];
            [cell addSubview:alerttitlelbl];

            if (flag == 1) {
                toggleswitch.on = NO;
            }
            else if (flag == 2){
                if ([shedobj.alarm_status isEqualToString:@"1"]){
                    toggleswitch.on = YES;
                }
                else{
                    toggleswitch.on= NO;
                }
                NSLog(@"Alarm Status :-------------- %@",shedobj.alarm_status);
                
                NSLog(@"Alarm Days :-------------- %@",alarmstatusarray);
                //NSLog(@"Alarm days :-------------- %@",daysstr);
            }
            [cell addSubview:toggleswitch];
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        }
        else if (indexPath.row == 2){
            worktitlelbl.text = @"Work Shed";
            lifetitlelbl.text=@"Life Shed";
            worktitlelbl.textAlignment = NSTextAlignmentLeft;
            lifetitlelbl.textAlignment = NSTextAlignmentCenter;
           
            [cell addSubview:worktitlelbl];
            [cell addSubview:lifetitlelbl];
            
            workBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            lifeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];

            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                workBtn.frame = CGRectMake(130, 10, 20, 20);
                lifeBtn.frame = CGRectMake(280, 10, 20, 20);

                //this is iphone 5 xib
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480) {
                workBtn.frame = CGRectMake(120, 5, 20, 20);
                lifeBtn.frame = CGRectMake(270, 5, 20, 20);

                // this is iphone 4 xib
            }
            else{
                workBtn.frame = CGRectMake(180, 10, 40, 40);
                lifeBtn.frame = CGRectMake(690, 10, 40, 40);

            }
            workBtn.tag = indexPath.row+100;
            lifeBtn.tag = indexPath.row+200;
            if (flag==1)
            {
                UIImage *buttonBackgroundImage1 = [UIImage imageNamed:@"checkbox-active.png" ];
                UIImage *buttonBackgroundImage = [UIImage imageNamed:@"checkbox.png"];
                [workBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
                [lifeBtn setBackgroundImage:buttonBackgroundImage1 forState:UIControlStateNormal];
            }
            else if(flag==2)
            {
                NSLog(@"%@",shedobj.type);
                if ([shedobj.type isEqualToString:@"work"])
                {
                    UIImage *buttonBackgroundImage1 = [UIImage imageNamed:@"checkbox-active.png" ];
                    [workBtn setBackgroundImage:buttonBackgroundImage1 forState:UIControlStateNormal];
                    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"checkbox.png"];
                    [lifeBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
                }
                else  if ([shedobj.type isEqualToString:@"life"]){
                    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"checkbox.png"];
                    UIImage *buttonBackgroundImage1 = [UIImage imageNamed:@"checkbox-active.png" ];
                    [workBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
                    [lifeBtn setBackgroundImage:buttonBackgroundImage1 forState:UIControlStateNormal];
                }
            }
            [cell.contentView addSubview:workBtn];
            [cell.contentView addSubview:lifeBtn];
            [workBtn addTarget:self action:@selector(workBtn:) forControlEvents:UIControlEventTouchUpInside];
            [lifeBtn addTarget:self action:@selector(lifeBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {

            [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:19]];
            }
            else{
                [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
            }
        }
        else if (indexPath.row == 3)
        {
            [cell addSubview:rewardTogleswitch];

            if (flag == 1) {
                  rewardStatus=0;
                rewardTogleswitch.on = NO;
            }
            else if (flag == 2){
                if (shedobj.rewardStatus==1){
                    rewardTogleswitch.on = YES;
                    
                }
                else{
                    rewardTogleswitch.on= NO;
                }
            }
            
            [rewardTogleswitch addTarget: self action: @selector(rewardTogleswitch:) forControlEvents:UIControlEventValueChanged];
            
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            if (([[UIScreen mainScreen] bounds].size.height == 568)) {
                [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:17]];
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480){
                [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:16]];
            }
            else{
                [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
            }
        }

        else if (indexPath.row == 4)
        {
            cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
                [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:17]];
            }
            else{
                [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
            }
        }

    else if (indexPath.row > 4 && indexPath.row <13)
    {
    if(flag == 1)
    {
       // [imagearray addObject:@"0"];
        //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16]];
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 20, 20)];
            cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:15];

            //this is iphone 5 xib
            
        }
        else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(280, 5, 20, 20)];
            cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:12];
            // this is iphone 4 xib
        }
        else{
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(700, 13, 39, 40)];
            cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:26];
        }
        checkmark.image = [UIImage imageNamed:@"checkbox.png"];
        [checkmark setTag:indexPath.row];
        NSLog(@"INDEX PATH:::: %ld",(long)indexPath.row);
        cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"days-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        [cell addSubview:checkmark];
    }
    else if (flag == 2){
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, 20, 20)];
             cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:15];
            //this is iphone 5 xib
        } else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(280, 5, 20, 20)];
            cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:12];
            // this is iphone 4 xib
        }
        else{
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(700, 13, 39, 40)];
            cell.textLabel.font = [UIFont fontWithName:@"Lucida Sans" size:26];
        }
        
        checkmark.image = [UIImage imageNamed:@"checkbox.png"];
        [checkmark setTag:indexPath.row];
        cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"days-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        [cell.contentView addSubview:checkmark];
        NSString *compairString= [NSString stringWithFormat:@"%@",cell.textLabel.text];
        NSLog(@"alarm days..%@",shedobj.alarm_days);
        alarmdaysstr = shedobj.alarm_days;
        alarmstatusarray = [alarmdaysstr componentsSeparatedByString:@","];
        NSLog(@"Selected Days Name: %@", alarmstatusarray);
        for (int i = 0; i < [alarmstatusarray count]; i++) {
            NSString *daysName = [alarmstatusarray objectAtIndex:i];
           
            if ([daysName isEqualToString:compairString] ) {
               checkmark.image = [UIImage imageNamed:@"checkbox-active.png"];
                NSLog(@"Day checked");
                [daysarray addObject:daysName];
            }
        }
        if (indexPath.row >= 5) {
            if ([alarmstatusarray count]== 7) {
                checkmark.image = [UIImage imageNamed:@"checkbox-active.png"];
                }
            }
        }
        
    }
    [habitname.titleLabel setTextAlignment: NSTextAlignmentRight];
    NSLog(@"img Array %@",imagearray);
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIScreen mainScreen] bounds].size.height == 568 ){
        return 34.5;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480){
        if (indexPath.row==1){
            return 34.0;
        }
        else if (indexPath.row==0 || indexPath.row==2){
            return 29.0;
        }
        else if (indexPath.row==3){
            return 34.0;
        }
        else{
            return 26.50;
        }
    }
    else{
        return 61;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self myAction:nil];
    }
    if (indexPath.row != 0) {
        [habitname resignFirstResponder];
        [habittextview resignFirstResponder];
    }
        if (indexPath.row == 1)
        {
            HabittextfeildView.hidden=YES;
            NSString *timestring;
            if (flag==2 && !is24h){
               timestring = [[NSString alloc] initWithFormat:shedobj.alarm_time];
            }
            
            else{
                saveTimeStr=[NSString stringWithFormat:@"%@",timelbl.text];
                if (saveTimeStr.length>5)
                {
                    NSLog(@"am pm format..");
                    NSArray*temptimeArray = [saveTimeStr componentsSeparatedByString:@" "];
                    NSString *isAmPm=[temptimeArray objectAtIndex:1];
                    NSString  *timeValue=[saveTimeStr  substringWithRange:NSMakeRange(0, 2)];
                    saveTimeStr=[saveTimeStr substringToIndex:5];
                   
                    if ([isAmPm isEqualToString:@"pm"]|| [isAmPm isEqualToString:@"PM"] || [isAmPm isEqualToString:@"Pm"])
                    {
                        int hours=[timeValue intValue] +12;
                        if (hours == 24) {
                            hours = 12;
                        }
                        NSString *housStr=[NSString stringWithFormat:@"%d",hours];
                        NSString *minutes=[saveTimeStr substringWithRange:NSMakeRange(3, 2)];
                        saveTimeStr =[NSString stringWithFormat:@"%@:%@",housStr,minutes];
                    }
                    else{
                        int hours=[timeValue intValue];
                        if (hours == 12) {
                            hours =00;
                        }
                        NSString *housStr=[NSString stringWithFormat:@"%d",hours];
                        NSString *minutes=[saveTimeStr substringWithRange:NSMakeRange(3, 2)];
                        saveTimeStr =[NSString stringWithFormat:@"%@:%@",housStr,minutes];
                    }
                }
                timestring = [[NSString alloc] initWithFormat:saveTimeStr];
            }
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
            //NSString *dateStr = [dateFormat stringFromDate:date2];
            
            //dateFormat setDateFormat:@"hh:mm:ss"];
            //dateFormat setDateFormat:@"HH:mm:ss"];
            //[dateFormat setDateFormat:@"hh:mm a"];
            //[dateFormat setDateFormat:@"h:mm a"];
            //[dateFormat setDateFormat:@"HH:mm a"];
             //[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            //[dateFormat setDateFormat:@"EEEE"];
            //[dateFormat setDateFormat:@"HH:mm:ss ZZZ"];
          
//            NSDateFormatter *df = [[NSDateFormatter alloc] init];
//            [df setDateFormat:@"HH:mm a"];
//            NSString *str=[df stringFromDate:date4];
//            NSLog(@"dateSr..%@",str);
                if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
                      [self showPicker:date4];
                }
                else{
                    self.pickrViewIpad.hidden = NO;
                   // HabittextfeildView.hidden=YES;
                    datePickerIpad.datePickerMode = UIDatePickerModeTime;
                    [datePickerIpad addTarget:self action:@selector(changeDateInLabel:) forControlEvents:UIControlEventValueChanged];
                    [datePickerIpad setDate:date4 animated: YES];
                }
                if (self.datePickerIsShowing)
                {
                    [habitname resignFirstResponder];
                }
                else
                {
                    [habitname resignFirstResponder];
                    [self.timelbl resignFirstResponder];
                    [self showDatePickerCell];
                }
//            }
//            else
//            {
//            timelbl.textColor = [UIColor grayColor];
//            }
        }
    if (indexPath.row == 3  && rewardStatus==1) {
       
        [self addRewardsView];
        NSLog(@"set rewrds..");
    }

    else if (indexPath.row == 5)
    {
        //HabittextfeildView.hidden=YES;
//        for (int j=0;j<8; j++)
//        {
//            if ([[imagearray objectAtIndex:j] isEqualToString: @"0"])
//            {
//                [imagearray replaceObjectAtIndex:j withObject:@"1"];
//            }
//            else{
//                [imagearray replaceObjectAtIndex:j withObject:@"0"];
//
//            }
//           
//        }
         NSLog(@"array img %@",imagearray);
        self.pickrViewIpad.hidden=YES;
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
        UIImageView *check = (UIImageView*)[cell viewWithTag:5];
        
        NSData *img1Data = UIImageJPEGRepresentation(check.image, 1.0);
        NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"checkbox.png"], 1.0);
        
        if ([img1Data isEqualToData:img2Data])
        {
            daysarray =[[NSMutableArray alloc] init];
            check.image = [UIImage imageNamed:@"checkbox-active.png"];
           
            for (int i = 6; i < 13; i++) {
                NSLog(@"I am Selectin the row %d", i);
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:path1];
                UIImageView *check1 = (UIImageView*)[cell1 viewWithTag:i];
                check1.image = [UIImage imageNamed:@"checkbox-active.png"];
                [daysarray addObject:cell1.textLabel.text];
            }
            NSLog(@"Array of days: %@", daysarray);
        }
         else
         {
            check.image = [UIImage imageNamed:@"checkbox.png"];
            NSLog(@"HELLO");
            for (int i = 6; i < 13; i++) {
                NSLog(@"I am Selectin the row %d", i);
                NSIndexPath *path1 = [NSIndexPath indexPathForRow:i inSection:0];
                UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:path1];
                UIImageView *check1 = (UIImageView*)[cell1 viewWithTag:i];
                check1.image = [UIImage imageNamed:@"checkbox.png"];
                [daysarray removeObject:cell1.textLabel.text];
            }
        }

        
    }
    else if (indexPath.row > 4 )
    {
        
//           if ([[imagearray objectAtIndex:indexPath.row-5] isEqualToString: @"0"])
//            {
//                [imagearray replaceObjectAtIndex:indexPath.row-5 withObject:@"1"];
//            }
//            else{
//                [imagearray replaceObjectAtIndex:indexPath.row-5 withObject:@"0"];
//                
//            }
        
       
        NSLog(@"array img %@",imagearray);
        HabittextfeildView.hidden=YES;
        NSLog(@"I am Selectin the row %ld", (long)indexPath.row);
        self.pickrViewIpad.hidden=YES;

        NSIndexPath *path = [NSIndexPath indexPathForRow:5 inSection:0];
        UITableViewCell *cell1 = [tableView cellForRowAtIndexPath:path];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImageView *check = (UIImageView*)[cell viewWithTag:indexPath.row];
        UIImageView *check1 = (UIImageView*)[cell1 viewWithTag:5];
        
        NSLog(@"subviews %@", check.image);
        
        NSData *img1Data = UIImageJPEGRepresentation(check.image, 1.0);
        NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"checkbox.png"], 1.0);
        
        if ([img1Data isEqualToData:img2Data])
        {
            NSLog(@"I am Checking the row");
            NSLog(@"Day Removed: %@", cell.textLabel.text);
            check.image = [UIImage imageNamed:@"checkbox-active.png"];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            UITableViewCell *cell = (UITableViewCell*)[habitstableview cellForRowAtIndexPath:indexpath];
            if (![daysarray containsObject:cell.textLabel.text]) {
                [daysarray addObject:cell.textLabel.text];
                
            }
            if ([daysarray count] == 7) {
                check1.image =[UIImage imageNamed:@"checkbox-active.png"];
            }
   
        }
         else
         {
            check1.image =[UIImage imageNamed:@"checkbox.png"];
            check.image = [UIImage imageNamed:@"checkbox.png"];
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            UITableViewCell *cell = (UITableViewCell*)[habitstableview cellForRowAtIndexPath:indexpath];
            [daysarray removeObject:cell.textLabel.text];
        }

        
    }
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Array of days: %@", daysarray);
}
-(IBAction)myAction:(id)sender
{
    tableview.userInteractionEnabled=NO;
    pickrViewIpad.hidden=YES;
    savebtn.userInteractionEnabled =NO;
    [[HabittextfeildView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[HabittextfeildView layer] setBorderWidth:1.0];
    [[HabittextfeildView layer] setCornerRadius:5];
    HabittextfeildView.hidden = NO;
    if (flag==2)
    {
        if (![[habitname currentTitle] isEqualToString:@"SHEDs Description"])
        {
            habittextview.text=shedNameStr;
        }
    }
    
    [[habittextview layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[habittextview layer] setBorderWidth:1.0];
    [[habittextview layer] setCornerRadius:5];
    
    [habittextview becomeFirstResponder];
    [habittextview setDelegate:self];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480))
    {
        [habittextview setFont:[UIFont fontWithName:@"Lucida Sans" size:19]];
    }
    else
    {
        [habittextview setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
    }
    [[donebutton layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[donebutton layer] setBorderWidth:1.0];
    [[donebutton layer] setCornerRadius:5];
}

- (void)showDatePickerCell
{
    self.datePickerIsShowing = YES;
    [habitname resignFirstResponder];
}

- (void)hideDatePickerCell
{
    self.datePickerIsShowing = NO;
    [habitname resignFirstResponder];
}
- (IBAction)rewardTogleswitch:(id)sender {
    [self.view endEditing: YES];
    
    if (rewardTogleswitch.on)
    {
        [rewardTogleswitch setOn:YES animated:YES];
        [self addRewardsView];
        rewardStatus=1;
    }
    else{
        [rewardTogleswitch setOn:NO animated:YES];
        rewardStatus=0;
    }
    NSLog(@"reward status %d",rewardStatus);
    NSLog(@"%hhd",rewardTogleswitch.on);

}

- (void)toggleSwitch
{
    if (toggleswitch.on)
    {
        [habitname resignFirstResponder];
        [self.view endEditing:YES];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *cell = (UITableViewCell*)[habitstableview cellForRowAtIndexPath:indexPath];
        
        SHED *shed	= [[SHED alloc] init];
        NSString *queryString = [NSString stringWithFormat:@"Select shed_id ,alarm_status, alarm_time FROM SHED "];
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        NSLog(@"query %@", queryString);
        [database open];
        FMResultSet *results = [database executeQuery:queryString];
        while([results next])
        {
            shed.shed_id = [results stringForColumn:@"shed_id"];
            shed.alarm_status = [results stringForColumn:@"alarm_status"];
            shed.alarm_time = [results stringForColumn:@"alarm_time"];
            NSLog(@"SHED ID IS TO BE: %@", shed.shed_id);
        }
        [database close];
        
        if ([shed.alarm_status isEqualToString:@"1"]) {
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setDateFormat:@"HH:mm a"];
            [timeFormat setTimeZone:[NSTimeZone systemTimeZone]];
            NSDate *Date = [timeFormat dateFromString:shed.alarm_time];
            NSLog(@"Time is : %@", Date);
        }
        timelbl.hidden = NO;
        timelbl.textColor = [UIColor blackColor];
        cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        [toggleswitch setOn:YES animated:YES];
    }
    else
    {
        [habitname resignFirstResponder];
        NSLog(@"Time is %@",timelbl.text);
        self.datePickerIsShowing = YES;
        timelbl.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
        timelbl.textColor = [UIColor colorWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1];
        timetitlelbl.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
        alerttitlelbl.backgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
        [toggleswitch setOn:NO animated:YES];
    }
}

- (IBAction)changeDateInLabel:(NSDate*)date
{
    NSLog(@"I Am Changing the values");
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
        timelbl.text = [NSString stringWithFormat:@"%@",[timeFormat stringFromDate:pickdate.date]];
    }
    else
    {
        NSString *theTime = [timeFormat stringFromDate:datePickerIpad.date];
        NSLog(@"TIME IS:%@",theTime);
        timelbl.text = [NSString stringWithFormat:@"%@",[timeFormat stringFromDate:datePickerIpad.date]];
    }
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
        
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Hello"
                                              message:@"testing"
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        // [alertController.view addSubview:testView];
        
        
        UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"DONE" style:UIAlertActionStyleCancel handler:nil];
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
            actionsheet = Nil;
        }
    }
}

- (IBAction)cancelBtn:(id)sender {
    if ([rewrardDetailStr isEqualToString:@""] || [rewardStreakStr isEqualToString:@""]) {
         [rewardTogleswitch setOn:NO animated:YES];
        rewardStreakStr= shedobj.rewardStreak;
        rewrardDetailStr= shedobj.rewardDetail;
    }
    [self.view endEditing:YES];
    savebtn.userInteractionEnabled=YES;
    tableview.userInteractionEnabled=YES;
    backBtn.userInteractionEnabled=YES;
    rewardsPopUpView.hidden=YES;
    scrollView.hidden = YES;
   
    
    

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    //rewardsPopUpView.frame = CGRectMake(12,50,297,277);
    
}

- (IBAction)deleteImage:(id)sender {
    rewardImgView.image=nil;
    removIcon.hidden=YES;
}
- (IBAction)imageBtn:(id)sender
{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
    
//    [self.view endEditing:YES];
//    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
//    NSLog(@"version..%@",currSysVer);
//    
//    if (([currSysVer compare:[NSString stringWithFormat:@"8.0"] options:NSNumericSearch] == NSOrderedSame) ||([currSysVer compare:[NSString stringWithFormat:@"8.0"] options:NSNumericSearch] == NSOrderedDescending) )
//    {
////        NSString *deviceType = [UIDevice currentDevice].model;
////        
//    if ([[UIScreen mainScreen] bounds].size.height == 1024)
//    {
//        [[self.photoGalaryBtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
//        [[self.photoGalaryBtn layer] setBorderWidth:1.0];
//        [[self.photoGalaryBtn layer] setCornerRadius:5];
//        if (self.photoGalaryBtn.hidden == YES) {
//            self.photoGalaryBtn.hidden = NO;
//        }else{
//            self.photoGalaryBtn.hidden = YES;
//        }
//        
//    }else{
//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:nil
//                                      delegate:self
//                                      cancelButtonTitle:@"Cancel"
//                                      destructiveButtonTitle:@"Photo Library"
//                                      otherButtonTitles:nil];
//        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
//        actionSheet.tag=5;
//        [actionSheet showInView:self.view];
//    }
//    }else {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:nil
//                                  delegate:self
//                                  cancelButtonTitle:@"Cancel"
//                                  destructiveButtonTitle:@"Photo Library"
//                                  otherButtonTitles:nil];
//    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
//    actionSheet.tag=5;
//    [actionSheet showInView:self.view];
//    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.rewardImgView.image = chosenImage;
    removIcon.hidden=NO;
    self.photoGalaryBtn.hidden= YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.photoGalaryBtn.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
//- (IBAction)rewardsToggleBt:(id)sender {
//    [self.view endEditing: YES];
//    if (rewrdsToggle.on)
//    {
//        [rewrdsToggle setOn:YES animated:YES];
//    }
//    else{
//        [rewrdsToggle setOn:NO animated:YES];
//    }
//   
//    NSLog(@"%hhd",rewrdsToggle.on);
//}

- (IBAction)addRewardsBtn:(id)sender {
    [self.view endEditing:YES];
      NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    rewrardDetailStr = [NSString stringWithFormat:@"%@",rewardDetailTxt.text];
    rewrardDetailStr = [rewrardDetailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    rewardStreakStr = [NSString stringWithFormat:@"%@",rewardStreakTxt.text];
    rewardStreakStr = [rewardStreakStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

 
  
    
    if (rewardStreakStr.length==0) {
        UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"SHEDs" message:@"Please enter reward run" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        rewardStreakTxt.text=@"";
    }
    else if ([rewardStreakStr isEqualToString:@"0"]) {
        UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"SHEDs" message:@"Please enter reward run" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
      //  rewardStreakTxt.text=@"";
    }
   else if (rewrardDetailStr.length==0) {
        UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"SHEDs" message:@"Please enter reward Description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
       rewardDetailTxt.text=@"";

    }
  
   else if ([rewardStreakStr rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"SHEDs" message:@"Reward run must be in number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        rewardStreakTxt.text=@"";
    }

    
    
//    else if (self.rewrdsToggle.on ==0)
//    {
//        UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"SHEDs" message:@"your rewards alert is disable. are you sure to save ??" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
//        alert.tag=9;
//        [alert show];
//    }
    else{
        
        rewrardDetailStr = [NSString stringWithFormat:@"%@",rewardDetailTxt.text];
        rewrardDetailStr = [rewrardDetailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        rewardStreakStr = [NSString stringWithFormat:@"%@",rewardStreakTxt.text];
        rewardStreakStr = [rewardStreakStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
       // rewardStatus=self.rewrdsToggle.on;
      
        [Base64 initialize];
      
        CGSize size=[rewardImgView.image size] ;
        NSLog(@"%f",size.width);
        NSLog(@"%f",size.height);
        if (size.width >100 ||size.height>100)
        {
            CGRect rect = CGRectMake(0,0,100,100);
            UIGraphicsBeginImageContext(rect.size);
            [rewardImgView.image drawInRect:rect];
            rewardImgView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        UIImage *small = [UIImage imageWithCGImage:rewardImgView.image.CGImage scale :0.25 orientation:rewardImgView.image.imageOrientation];
        NSData* data = UIImageJPEGRepresentation(small,0.1f);
        NSString *strEncoded = [Base64 encode:data ];
        rewardImageStr=[[NSString alloc]initWithFormat:@"%@",strEncoded];
        
        NSLog(@"%@",rewardImageStr);
        NSLog(@"reward length..%lu",(unsigned long)rewardImageStr.length);
      
        rewardsPopUpView.hidden=YES;
        scrollView.hidden = YES;
        tableview.userInteractionEnabled=YES;
        savebtn.userInteractionEnabled=YES;
        backBtn.userInteractionEnabled=YES;
    }
}

- (IBAction)header_back:(id)sender {
    HabittextfeildView.hidden = YES;
    [self.view endEditing:YES];
    if ([habitname.titleLabel.text isEqualToString:@"SHEDs Description"]) {
        homescreenViewController *home;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
            //this is iphone 5 xib
        } else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
            home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        } else {
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
    else
    {
    UIAlertView *savealert = [[UIAlertView alloc] initWithTitle:@" You are about to leave this Screen"  message:@"Do you want to save the SHED??" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
    savealert.tag = 2;
    [savealert show];
    }
}

-(void) scheduleNotificationForDate: (NSString*)days: (NSString*)myDate1: (NSString*)desc{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *curdate = [dateFormat dateFromString:appDelegate.todaysDate];
    
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:curdate];
    NSArray *tempArray = [myDate1 componentsSeparatedByString:@":"];
    
    NSLog(@"month %ld", (long)[components month]);
    NSLog(@"year %ld", (long)[components year]);
    NSLog(@"day %ld", (long)[components day]);
    NSLog(@"hour %d", [[tempArray objectAtIndex:0] intValue]);
    NSLog(@"minute %d", [[tempArray objectAtIndex:1] intValue]);
    
    NSDateComponents *tempComp = [[NSDateComponents alloc] init];
    
    NSArray *daysstr = [days componentsSeparatedByString:@","];
    NSLog(@"Selected Days Name: %@", daysstr);
    int i;
    int weekDay = [components weekday];
    
    for (i = 0; i < [daysstr count]; i++) {
        NSDateComponents *dateParts = [[NSDateComponents alloc] init];
        
        [dateParts setHour:[[tempArray objectAtIndex:0] intValue]];
        [dateParts setMinute:[[tempArray objectAtIndex:1] intValue]];
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
        [database open];
        FMResultSet *results = [database executeQuery:queryString];
        
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
        localNotif.repeatInterval = NSWeekCalendarUnit;
        localNotif.alertAction = NSLocalizedString(@"View Details", nil);
        localNotif.alertBody = desc;
        localNotif.soundName =UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        NSLog(@"notification started");
    }
}

- (IBAction)addthetext:(id)sender {
    tableview.userInteractionEnabled=YES;
    HabittextfeildView.hidden = YES;
    [habittextview resignFirstResponder];
    savebtn.userInteractionEnabled = YES;
    tempStr = [NSString stringWithFormat:@"%@",habittextview.text];
    tempStr = [tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (tempStr.length == 0)
    {
        [habitname setTitle:@"SHEDs Description" forState:UIControlStateNormal];
    }
    else
    {
        shedNameStr=[NSString stringWithFormat:@"%@",habittextview.text];
        NSString *str1 = [NSString stringWithFormat:@"%@",tempStr  ];
        NSString *habitName;
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480))
        {
            NSRange stringRange = {0, MIN([str1 length], 20)};
            stringRange = [str1 rangeOfComposedCharacterSequencesForRange:stringRange];
            NSString *shortString = [str1 substringWithRange:stringRange];
            if (str1.length <= 20)
            {
                habitName = [NSString stringWithFormat:@"%@",shortString];
            }
            else
            {
                habitName = [NSString stringWithFormat:@"%@...",shortString];
            }
        }
        else
        {
            NSRange stringRange = {0, MIN([str1 length], 35)};
            stringRange = [str1 rangeOfComposedCharacterSequencesForRange:stringRange];
            NSString *shortString = [str1 substringWithRange:stringRange];
            if (str1.length <= 35)
            {
                habitName = [NSString stringWithFormat:@"%@",shortString];
            }
            else
            {
                habitName = [NSString stringWithFormat:@"%@...",shortString];
            }
        }
        [habitname setTitle:[NSString stringWithFormat:@"%@",habitName] forState:UIControlStateNormal];
    }
    
//    UIEdgeInsets titleInsets =
//    UIEdgeInsetsMake(0.0f, 8.0f, 0.0f, -8.0f);
//    
//    UIEdgeInsets contentInsets =
//    UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 15.0f);
//    
//    [habitname setTitleEdgeInsets:titleInsets];
//    [habitname setContentEdgeInsets:contentInsets];
}


- (IBAction)resignBtn:(id)sender {
    pickrViewIpad.hidden=YES;
    [self.view setUserInteractionEnabled:YES];
}


-(void)workBtn:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"workBtn");
    isworkBtn=YES;
    isLifeBtn=NO;
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"checkbox-active.png"];
    UIImage *buttonBackgroundImage1 = [UIImage imageNamed:@"checkbox.png"];
    [workBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [lifeBtn setBackgroundImage:buttonBackgroundImage1 forState:UIControlStateNormal];
}
-(void)lifeBtn:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"lifeBtn");
    isLifeBtn=YES;
    isworkBtn=NO;
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"checkbox-active.png"];
    [lifeBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    UIImage *buttonBackgroundImage1 = [UIImage imageNamed:@"checkbox.png"];
    [workBtn setBackgroundImage:buttonBackgroundImage1 forState:UIControlStateNormal];
   
 }




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==rewardStreakTxt)
    {
        
        if (range.location>=3)
        {
            return NO;
        }
        if (range.location ==0 && ([string isEqualToString:@"0"]|| [string isEqualToString:@"1"]))
        {
            daysLbl.text=@"day";
        }
        else
        {
             daysLbl.text=@"days";
        }
    }
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==rewardStreakTxt)
    {
        isnumericKeyboard=YES;
//        [UIView animateWithDuration:0.3f animations:^{
//            
//            CGRect frame = self.rewardsPopUpView.frame;
//            if ([[UIScreen mainScreen] bounds].size.height == 568) {
//                frame.origin.y = 60;
//            }
//            if ([[UIScreen mainScreen] bounds].size.height ==480) {
//                frame.origin.y = 70;
//            }
//            self.rewardsPopUpView.frame = frame;
//        }];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==rewardStreakTxt)
    {
        isnumericKeyboard=YES;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    isnumericKeyboard=NO;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    [textField resignFirstResponder];
    if (textField==rewardStreakTxt)
    {
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.1f animations:^{
            
            CGRect frame = self.rewardsPopUpView.frame;
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                frame.origin.y = 114;
            }
            if ([[UIScreen mainScreen] bounds].size.height ==480) {
                frame.origin.y = 102;
            }
            self.rewardsPopUpView.frame = frame;
        }];

        
        if ([rewardStreakTxt.text isEqualToString:@"00"] || [rewardStreakTxt.text isEqualToString:@"000"])
        {
            rewardStreakTxt.text=@"0";
        }
        
        NSMutableString *string = [NSMutableString stringWithFormat: @"%@",rewardStreakTxt.text];
        if (string.length==2)
        {
            NSString *string2 = [string substringWithRange: NSMakeRange (0, 1)];
            
            if ([string2 isEqualToString:@"0"]) {
                rewardStreakTxt.text= [string stringByReplacingCharactersInRange: NSMakeRange(0,1) withString:@""];
            }
        }
        else if(string.length==3)
        {
            NSString *string2 = [string substringWithRange: NSMakeRange (0, 1)];
            NSString *string1 = [string substringWithRange: NSMakeRange (0, 2)];
            
            if ([string1 isEqualToString:@"00"]) {
                
                rewardStreakTxt.text= [string stringByReplacingCharactersInRange: NSMakeRange (0, 2) withString:@""];
            }
            else if ([string2 isEqualToString:@"0"]) {
                
                rewardStreakTxt.text= [string stringByReplacingCharactersInRange: NSMakeRange (0, 1) withString:@""];
            }
        }
        
        
      
        rewardStreakTxt.text = [rewardStreakTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       

    }
    return YES;
}

//
//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
//{
//    isnumericKeyboard=NO;
//    if (textView == rewardDetailTxt) {
//        rewarddetailLbl.hidden=YES;
//    }
//    return YES;
//}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isnumericKeyboard=NO;
    if (textView == rewardDetailTxt)
    {
        rewarddetailLbl.hidden=YES;
    
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.rewardsPopUpView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            frame.origin.y = 60;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480)
        {
           // frame.origin.y = 80;
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(keyboardFrameDidChange:)
//                                                         name:UIKeyboardDidChangeFrameNotification object:nil];
            
            

            //[self moveUpView];
            [scrollView removeFromSuperview];
            scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
            [self.view addSubview:scrollView];
//            [scrollView setBackgroundColor:[UIColor redColor]];
            [scrollView addSubview:rewardsPopUpView];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            rewardsPopUpView.frame = CGRectMake(12,-60,297,277);
            [UIView commitAnimations];

        }
        //self.rewardsPopUpView.frame = frame;
    }];
    }

}

-(void)keyboardFrameDidChange:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    
    CGRect kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [rewardsPopUpView setFrame:CGRectMake(0, kKeyBoardFrame.origin.y-rewardsPopUpView.frame.size.height, 320, rewardsPopUpView.frame.size.height)];
    
}

#pragma mark - Move Up View
-(void)moveUpView
{

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(self.view.frame.origin.y==0)
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y-140,self.view.frame.size.width,self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark - Move Down View

-(void)moveDownView
{

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.view.frame = CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}


- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    
    if (textView== rewardDetailTxt)
    {
        
        if ([rewardDetailTxt.text isEqualToString:@""])
        {
            rewarddetailLbl.hidden=NO;
        }
    
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.1f animations:^{
        
        CGRect frame = self.rewardsPopUpView.frame;
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
             frame.origin.y = 114;
        }
        if ([[UIScreen mainScreen] bounds].size.height ==480)
        {
            
           

            frame.origin.y = 102;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.25];
            rewardsPopUpView.frame = CGRectMake(12,50,297,277);
            [UIView commitAnimations];
            //[scrollView removeFromSuperview];

            //[self moveDownView];

        }
//        self.rewardsPopUpView.frame = frame;
    }];
        
        rewardDetailTxt.text = [rewardDetailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView==habittextview)
    {
        if([text isEqualToString:@"\n"]) {
            [habittextview resignFirstResponder];
            return NO;
        }
        return textView.text.length + (text.length - range.length) <= 60;
    }
    else if (textView==rewardDetailTxt)
    {
        if([text isEqualToString:@"\n"])
        {
            [textView resignFirstResponder];
            return NO;
        }
        if ([text isEqualToString:@"0"]|| [text isEqualToString:@"1"])
        {
            daysLbl.text=@"day";
        }
    }
    return YES;
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

-(void)addRewardsView
{
    rewardsPopUpView.hidden=NO;
    scrollView.hidden = NO;
    
    rewardStreakTxt.text=rewardStreakStr;
    rewardDetailTxt.text=rewrardDetailStr;
    if (rewardImgView.image==nil)
    {
        removIcon.hidden=YES;
    }
    else{
        scrollView.hidden = NO;
        //            rewardsPopUpView.hidden = NO;
    }
    
    if (rewrardDetailStr ==nil)
    {
        rewrardDetailStr =@"";
    }
    
    if ([rewrardDetailStr isEqualToString:@""]) {
        rewarddetailLbl.hidden=NO;
    }
    else{
        rewarddetailLbl.hidden=YES;
    }
    tableview.userInteractionEnabled=NO;
    savebtn.userInteractionEnabled=NO;
    backBtn.userInteractionEnabled=NO;
    NSLog(@"set rewrds..");

}

- (IBAction)photoUpload:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}
@end
