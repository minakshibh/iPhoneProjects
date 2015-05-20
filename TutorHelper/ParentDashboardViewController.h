//
//  ParentDashboardViewController.h
//  TutorHelper
//
//  Created by Br@R on 26/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCalendarView.h"

@interface ParentDashboardViewController : UIViewController<DDCalendarViewDelegate>
{
    DDCalendarView *calendarView;
    IBOutlet UIView *buttonsView;

}
- (IBAction)connectionBttn:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)studentRequestBttn:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)lessonRequestBttn:(id)sender;
- (IBAction)myLessons:(id)sender;
- (IBAction)addLessonBttn:(id)sender;
- (IBAction)addNewStudentBttn:(id)sender;
- (IBAction)myProfileBttn:(id)sender ;
- (IBAction)tutorListBttn:(id)sender;
- (IBAction)myStudentsList:(id)sender;
@end
