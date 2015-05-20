//
//  ParentDashboardViewController.m
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "ParentDashboardViewController.h"
#import "ConnectionListViewController.h"
#import "StudentRequestViewController.h"
#import "SplashViewController.h"
#import "LessonRequestViewController.h"
#import "MyLessonsViewController.h"
#import "AddLessonViewController.h"
#import "AddStudentViewController.h"
#import "TutorRegistrationViewController.h"
#import "TutorListViewController.h"
#import "MyStudentsListViewController.h"

@interface ParentDashboardViewController ()

@end

@implementation ParentDashboardViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    
    if (IS_IPHONE_5)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 100, 300, 300) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_6)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 130, 354, 350) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_6P)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 130, 394, 350) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    if (IS_IPHONE_4_OR_LESS)
    {
        calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 100, 300, 270) fontName:@"Helvetica" delegate:self trigger:@"Parent"];
    }
    
    [self.view addSubview: calendarView];
    [self.view bringSubviewToFront:buttonsView];
    [calendarView bringSubviewToFront:buttonsView];


    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dayButtonPressed:(DayButton *)button {
    //For the sake of example, we obtain the date from the button object
    //and display the string in an alert view
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    
    UIAlertView *dateAlert = [[UIAlertView alloc]
                              initWithTitle:@"Date Pressed"
                              message:theDate
                              delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
    [dateAlert show];
}

- (void)nextButtonPressed {
    NSLog(@"Next...");
}

- (void)prevButtonPressed {
    NSLog(@"Prev...");
}

- (IBAction)myProfileBttn:(id)sender {
    buttonsView.hidden=YES;
    TutorRegistrationViewController*tutorRegVC=[[TutorRegistrationViewController alloc]initWithNibName:@"TutorRegistrationViewController" bundle:[NSBundle mainBundle]];
    tutorRegVC.trigger=@"edit";
    tutorRegVC.editView=@"Parent";
    [self.navigationController pushViewController:tutorRegVC  animated:YES];
    
}

- (IBAction)tutorListBttn:(id)sender {
    buttonsView.hidden=YES;
    TutorListViewController*tutorListVc=[[TutorListViewController alloc]initWithNibName:@"TutorListViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:tutorListVc animated:YES];
}

- (IBAction)myStudentsList:(id)sender {
    buttonsView.hidden=YES;
    
    MyStudentsListViewController*studentsVc=[[MyStudentsListViewController alloc]initWithNibName:@"MyStudentsListViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:studentsVc animated:YES];
}

- (IBAction)connectionBttn:(id)sender {
     buttonsView.hidden=YES;
    ConnectionListViewController*connctListVc=[[ConnectionListViewController alloc]initWithNibName:@"ConnectionListViewController" bundle:[NSBundle mainBundle]];
    connctListVc.trigger=@"Parent";
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
    
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"pin"];
    SplashViewController*splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:splashVc   animated:YES];
}

- (IBAction)studentRequestBttn:(id)sender
{
    buttonsView.hidden=YES;
    StudentRequestViewController*studentReqVc=[[StudentRequestViewController alloc]initWithNibName:@"StudentRequestViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:studentReqVc animated:YES];

}

- (IBAction)menuBttn:(id)sender
{
    if (buttonsView.hidden==YES)
    {
        buttonsView.hidden=NO;
    }
    else{
        buttonsView.hidden=YES;
    }
}

- (IBAction)lessonRequestBttn:(id)sender
{
    buttonsView.hidden=YES;

    LessonRequestViewController*lessonRequstVC=[[LessonRequestViewController alloc]initWithNibName:@"LessonRequestViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.trigger=@"Parent";
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}

- (IBAction)myLessons:(id)sender {
    buttonsView.hidden=YES;

    MyLessonsViewController*lessonRequstVC=[[MyLessonsViewController alloc]initWithNibName:@"MyLessonsViewController" bundle:[NSBundle mainBundle]];
    lessonRequstVC.trigger=@"Parent";
    [self.navigationController pushViewController:lessonRequstVC animated:YES];
}

- (IBAction)addLessonBttn:(id)sender {
    buttonsView.hidden=YES;

    AddLessonViewController*addLessonVc=[[AddLessonViewController alloc]initWithNibName:@"AddLessonViewController" bundle:[NSBundle mainBundle]];
    addLessonVc.trigger=@"Parent";

    [self.navigationController pushViewController: addLessonVc animated:YES];
}

- (IBAction)addNewStudentBttn:(id)sender {
    AddStudentViewController*addStdentVC=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    addStdentVC.trigger=@"Parent";
    addStdentVC.triggervalue= @"add";

    [self.navigationController pushViewController:addStdentVC animated:YES];
}
@end
