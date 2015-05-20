//
//  MyLessonsViewController.m
//  TutorHelper
//
//  Created by Br@R on 14/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//
#import "MyLessonsViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "MyLessonsTableViewCell.h"

@interface MyLessonsViewController ()

@end

@implementation MyLessonsViewController
@synthesize trigger,lessonObj,dateDetail,lessonsListArray;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if ([dateDetail isEqualToString:@"YES"])
    {
        [lessonsTableView reloadData];
    }
    else{
        [self FetchLessonRequestsList];
 
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FetchLessonRequestsList
{
    
    NSString*tutor_id;
    NSString*parentId;
    if ([trigger isEqualToString:@"Tutor"])
    {
        tutor_id=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tutor_id"];
        parentId=@"";
    }
    else
    {
        parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        tutor_id=@"";
    }
    NSString*last_updated_date= @"";
    
    _postData = [NSString stringWithFormat:@"parent_id=%@&tutor_id=%@&trigger=%@&last_updated_date=%@", parentId,tutor_id,trigger,last_updated_date];
    
    webservice=1;
    NSLog(@"data post >>> %@",_postData);
    [kappDelegate ShowIndicator];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/fetch-my-lessons.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
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

#pragma mark - Delegate

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
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    NSLog(@"userDetailDict:%@",userDetailDict);
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            if (webservice==1)
            {
                
                lessonsListArray =[[NSMutableArray alloc]init];
                //  NSArray*requestArray1=[userDetailDict valueForKey:@"lesson_data"];
                
                
                NSArray*requestArray=[userDetailDict valueForKey:@"lesson_data"];
                if (requestArray.count>0)
                {
                    
                    for (int k=0; k<requestArray.count; k++)
                    {
                        self.lessonObj=[[Lessons alloc]init];
                        
                        
                        Lessons*LessonListObj=[[Lessons alloc]init];
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
                        
                        // [[NSUserDefaults standardUserDefaults]setValue:LessonListObj.maximumValueOfLastUpdated forKey:@"Lessons_greatest_last_updated"];
                        [lessonsListArray addObject:LessonListObj];
                    }
                    
                }
                [lessonsTableView reloadData];
                webservice=0;
                
            }
            else {
                
            }
        }
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [lessonsListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    MyLessonsTableViewCell *cell = (MyLessonsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyLessonsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    self.lessonObj=[[Lessons alloc]init];
    
    self.lessonObj = [lessonsListArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    
    NSString*lessonTime=[NSString stringWithFormat:@"%@ - %@",self.lessonObj.lesson_start_time,self.lessonObj.lesson_end_time];
    
    
    [cell setLabelText:self.lessonObj.lessonDescription :lessonTime :self.lessonObj.lesson_days :self.lessonObj.no_of_students];
    
    return  cell;
    
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
