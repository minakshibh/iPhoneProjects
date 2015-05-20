//
//  LessonRequestViewController.h
//  TutorHelper
//
//  Created by Br@R on 13/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lessons.h"

@interface LessonRequestViewController : UIViewController
{
    NSMutableData*webData;
    int webservice;
    NSString*_postData;

    NSMutableArray *byMeRequestListArray,*forMeRequestListArray;
    Lessons*lessonsObj;
    IBOutlet UITableView *RequestsTableView;
    NSString*type;
    BOOL FirstTime;
}
@property (strong ,nonatomic) NSString*trigger;
- (IBAction)byMeBttn:(id)sender;
- (IBAction)forMebttn:(id)sender;
- (IBAction)BackBttn:(id)sender;

@end
