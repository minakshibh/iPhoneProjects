//
//  detailerViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/22/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mapDetailsObj.h"
#import "workSampleObj.h"

#import <QuartzCore/QuartzCore.h>
#import "FMDatabase.h"


@interface detailerViewController : UIViewController
{
    IBOutlet UILabel *nameLbl;
    IBOutlet UIImageView *profileImage;
    IBOutlet UITableView *workSampleTableView;
    NSMutableArray *beforeImagesArray;
    NSMutableArray *afterImageArrays,* worksampleDetails;
    workSampleObj *workSampleOC;
}
- (IBAction)backAction:(id)sender;
@property(strong,nonatomic)    NSString*fromView;

- (IBAction)profileBttn:(id)sender;
@property (strong, nonatomic) mapDetailsObj *mapDetailsOC;
@end
