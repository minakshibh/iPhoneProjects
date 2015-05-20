//
//  TutorFirstViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "TutorFirstViewController.h"
#import "AddLessonViewController.h"
#import "AddStudentViewController.h"
#import "ParentListViewController.h"
#import "ConnectionListViewController.h"
#import "SplashViewController.h"
#import "LessonRequestViewController.h"
#import "MyLessonsViewController.h"
#import "TutorRegistrationViewController.h"
#import "Lessons.h"
#import "SBJson.h"

@interface TutorFirstViewController ()

@end

@implementation TutorFirstViewController



- (void)viewDidLoad {
    
  

//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://112.196.24.206/tutor_helper/gcm.php"]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
//    [request setHTTPMethod:@"POST"];
//    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [kappDelegate ShowIndicator];
//    
//    if(connection)
//    {
//        if(webData==nil)
//        {
//            webData = [NSMutableData data] ;
//            NSLog(@"data");
//        }
//        else
//        {
//            webData=nil;
//            webData = [NSMutableData data] ;
//        }
//        NSLog(@"server connection made");
//    }
//    else
//    {
//        NSLog(@"connection is NULL");
//    }

    
    
    lessonDetailArray=[[NSMutableArray alloc]init];
    Lessons *lessonObj=[[Lessons alloc]init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    for (int k=0;k<5; k++)
    {
        lessonObj.lesson_start_time=@"10:15";
        lessonObj.lesson_end_time=@"12:15";
        lessonObj.lessonDescription=@"iphone";
        lessonObj.no_of_students=@"5";
        [lessonDetailArray addObject:lessonObj];
    }
    
    if (IS_IPHONE_5)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 203, 300, 225) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }

    if (IS_IPHONE_6)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10,250, 354, 270) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }
    if (IS_IPHONE_6P)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10,280, 394, 270) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 168, 300, 210) fontName:@"Helvetica" delegate:self trigger:@"Tutor"];
    }
    
    lessondetailBcakView.hidden=YES;
    
    
    [self.view addSubview: calendarView];
    [self.view bringSubviewToFront:buttonsView];
    [calendarView bringSubviewToFront:buttonsView];
    [self.view bringSubviewToFront:lessondetailBcakView];
    [calendarView bringSubviewToFront:lessondetailBcakView];

    self.navigationController.navigationBar.hidden=YES;

//    activeStudentsLbl.text=@"111";
//    feesCollectedLbl.text=@"$100";
//    feesDueLbl.text=@"$222";
    [self getLessonDetailFromDataBase];
    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];

    getDetailView=[[GetDetailCommonView alloc]initWithFrame:CGRectMake(0, 0, 0,0) tutorId:tutorId delegate:self  webdata:webData trigger:@"lessons"];
    [self.view addSubview: getDetailView];

}
-(void) getLessonDetailFromDataBase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *tutorId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM TutorProfile where tutorID=\"%@\"",tutorId];
    
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next])
    {
        NSString*activelessonsStr=[results stringForColumn:@"activeLessons"];
        NSString*feesCollected=[results stringForColumn:@"feesCollected"];
        NSString*fees_due=[results stringForColumn:@"fees_due"];
        activeStudentsLbl.text=[NSString stringWithFormat:@"%@",activelessonsStr];
        feesCollectedLbl.text=[NSString stringWithFormat:@"$%@",feesCollected];
        feesDueLbl.text=[NSString stringWithFormat:@"$%@",fees_due];
    }
    [database close];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)menuActionBtn:(id)sender
{
    
}


- (IBAction)addLessonActionBtn:(id)sender {
    
    buttonsView.hidden=YES;
    AddLessonViewController*addLessonVc=[[AddLessonViewController alloc]initWithNibName:@"AddLessonViewController" bundle:[NSBundle mainBundle]];
    addLessonVc.trigger=@"Tutor";
    [self.navigationController pushViewController: addLessonVc animated:YES];
}

- (IBAction)addStudentACtionBtn:(id)sender {
    buttonsView.hidden=YES;
    AddStudentViewController*addStudentVc=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    addStudentVc.triggervalue= @"add";
    addStudentVc.trigger=@"Tutor";
    [self.navigationController pushViewController: addStudentVc animated:YES];
}

- (IBAction)activeStudentsActionBtn:(id)sender {
    buttonsView.hidden=YES;
    ParentListViewController*parentListVc=[[ParentListViewController alloc]initWithNibName:@"ParentListViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController: parentListVc animated:YES];
}

- (IBAction)MenuBtn:(id)sender {
    if (buttonsView.hidden==YES)
    {
        buttonsView.hidden=NO;
    }
    else{
        buttonsView.hidden=YES;
    }
}


- (IBAction)requestBttn:(id)sender {
    buttonsView.hidden=YES;

    ConnectionListViewController*connctListVc=[[ConnectionListViewController alloc]initWithNibName:@"ConnectionListViewController" bundle:[NSBundle mainBundle]];
    connctListVc.trigger=@"Tutor";
    [self.navigationController pushViewController:connctListVc animated:YES];
}


- (IBAction)logOutBttn:(id)sender {
    buttonsView.hidden=YES;
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"tutor_id"];
    SplashViewController*splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:splashVc animated:YES];
}


- (IBAction)lessonRequestBtn:(id)sender
{
    buttonsView.hidden=YES;
    LessonRequestViewController*lessonRequstVC=[[LessonRequestViewController alloc]initWithNibName:@"LessonRequestViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.trigger=@"Tutor";
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}

- (IBAction)myLessonsBttn:(id)sender {
    buttonsView.hidden=YES;
    MyLessonsViewController*lessonRequstVC=[[MyLessonsViewController alloc]initWithNibName:@"MyLessonsViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.trigger=@"Tutor";
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}

- (IBAction)myProfileBttn:(id)sender {
    buttonsView.hidden=YES;
    TutorRegistrationViewController*tutorRegVC=[[TutorRegistrationViewController alloc]initWithNibName:@"TutorRegistrationViewController" bundle:[NSBundle mainBundle]];
    tutorRegVC.trigger=@"edit";
    tutorRegVC.editView=@"Tutor";
    [self.navigationController pushViewController:tutorRegVC  animated:YES];
}

- (IBAction)cancelLessonDetailBttn:(id)sender {
    lessondetailBcakView.hidden=YES;
}


- (void)dayButtonPressed:(DayButton *)button {
    //    if(lessonDetailArray.count!=0)
    //    {
    //        lessondetailBcakView.hidden=NO;
    //        [lessonDetailTableView reloadData];
    //    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];;
    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    dateLbl.text=theDate;
    [self getLeassonDetails:theDate];
    
}

- (void)nextButtonPressed {
    NSLog(@"Next...");
}

- (void)prevButtonPressed {
    NSLog(@"Prev...");
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lessonDetailArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    UILabel*backLbl= [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 300,40)];
    backLbl.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:backLbl ];
    
    UILabel*timingLbl= [[UILabel alloc] initWithFrame:CGRectMake(7, 4, 70,30)];
    timingLbl.backgroundColor = [UIColor clearColor];
    timingLbl.numberOfLines=1;
    timingLbl.font =  [UIFont boldSystemFontOfSize:11];
    [cell.contentView addSubview:timingLbl ];
    
    UILabel*topicDetailLbl= [[UILabel alloc] initWithFrame:CGRectMake(83, 4, 145,30)];
    topicDetailLbl.backgroundColor = [UIColor clearColor];
    topicDetailLbl.numberOfLines=1;
    topicDetailLbl.font = [UIFont boldSystemFontOfSize:12];
    [cell.contentView addSubview:topicDetailLbl ];
    
    UILabel*studentsLbl= [[UILabel alloc] initWithFrame:CGRectMake(230, 4, 80,30)];
    studentsLbl.backgroundColor = [UIColor clearColor];
    studentsLbl.font = [UIFont boldSystemFontOfSize:12];
    studentsLbl.numberOfLines=1;
    [cell.contentView addSubview:studentsLbl ];
    
    if ( IS_IPHONE_6P || IS_IPHONE_6)
    {
        timingLbl.frame= CGRectMake(7, 2, 80,30);
        topicDetailLbl.frame= CGRectMake(100, 25, 250,30);
        studentsLbl.frame= CGRectMake(340, 2, 80,30);
        backLbl.frame= CGRectMake(5, 1, 400,100);
    }
    
    topicDetailLbl.textColor=[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    Lessons*lessonObj=[[Lessons alloc]init];
    
    lessonObj = [lessonDetailArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    timingLbl.text=[NSString stringWithFormat:@"%@-%@",lessonObj.lesson_start_time,lessonObj.lesson_end_time];
    topicDetailLbl.text=[NSString stringWithFormat:@"%@",lessonObj.lessonDescription];
    studentsLbl.text=[NSString stringWithFormat:@"%@ students",lessonObj.no_of_students];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)ReceivedResponse
{
    [self getLessonDetailFromDataBase];
}


- (void)getLeassonDetails:(NSString*)lessonDate {
    
    NSString*_postData = [NSString stringWithFormat:@"lesson_date=%@&tutor_id=%@&parent_id=",lessonDate,[[NSUserDefaults standardUserDefaults]valueForKey:@"tutor_id"] ];
    NSLog(@"data post >>> %@",_postData);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/get-lesson-detail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [kappDelegate ShowIndicator];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [kappDelegate HideIndicator];
    
    self.view.userInteractionEnabled=YES;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    
    if ([webData length]==0)
        return;
    
    
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    NSMutableArray*lessnsArray=[[NSMutableArray alloc]init];
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"Dictionary Data .... %@",userDetailDict);
    NSArray*requestArray=[userDetailDict valueForKey:@"lesson_data"];
    if (requestArray.count>0)
    {
        
        for (int k=0; k<requestArray.count; k++)
        {
            LessonListObj=[[Lessons alloc]init];
            LessonListObj.LessonId=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_id" ]];
            LessonListObj.LessonDate=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ]  valueForKey:@"lesson_date"]];
            LessonListObj.ParentName=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"parent_name"]];
            LessonListObj.ParentEmail=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"parent_email"]];
            LessonListObj.ParentId=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ]  valueForKey:@"parent_id"]];
            LessonListObj.maximumValueOfLastUpdated=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ]  valueForKey:@"greatest_last_updated"]];
            LessonListObj.lesson_days=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_days"]];
            LessonListObj.lessonDescription=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_description"]];
            LessonListObj.lesson_duration=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_duration"]];
            LessonListObj.lesson_end_time=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_end_time"]];
            LessonListObj.isActive=[NSString stringWithFormat:@"%@",[[requestArray objectAtIndex:k ] valueForKey:@"lesson_is_active"]];
            LessonListObj.lesson_is_recurring=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_is_recurring"]];
            LessonListObj.lesson_start_time=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_start_time"]];
            LessonListObj.lessonTopic=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_topic"]];
            LessonListObj.TutorId=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"lesson_tutor_id"]];
            LessonListObj.studentListArray=[[requestArray  objectAtIndex:k ] valueForKey:@"student_info"];
            LessonListObj.no_of_students=[NSString stringWithFormat:@"%lu",(unsigned long)LessonListObj.studentListArray.count];
            LessonListObj.tutorName=[NSString stringWithFormat:@"%@",[[requestArray  objectAtIndex:k ] valueForKey:@"tutor_name"]];
            [lessnsArray addObject:LessonListObj];
            
        }
        buttonsView.hidden=YES;
        MyLessonsViewController*lessonRequstVC=[[MyLessonsViewController alloc]initWithNibName:@"MyLessonsViewController" bundle:[NSBundle mainBundle]];
        lessonRequstVC.trigger=@"Tutor";
        lessonRequstVC.lessonsListArray = lessnsArray;
        lessonRequstVC.dateDetail=@"YES";
        [self.navigationController pushViewController:lessonRequstVC animated:YES];
        
    }
}



@end
