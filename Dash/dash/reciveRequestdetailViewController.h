//
//  reciveRequestdetailViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 5/14/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "DetailerFirastViewController.h"
@interface reciveRequestdetailViewController : UIViewController
{
    NSMutableData*webData;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    IBOutlet UILabel *nameLbl;
    IBOutlet UIView *sideView;
    IBOutlet UIImageView *profileImg;
    IBOutlet UIButton *goOnlineBtn;
    DetailerFirastViewController *detailerFirstVC;
}
- (IBAction)goOnlineBtnAction:(id)sender;
- (IBAction)myWorkSamples:(id)sender;
- (IBAction)logOutBttn:(id)sender;
- (IBAction)viewProfileBttn:(id)sender;
- (IBAction)workSamples:(id)sender;
- (IBAction)menuBttn:(id)sender;
- (IBAction)homeBttn:(id)sender;
@end
