//
//  MyprofileViewController.h
//  dash
//
//  Created by Br@R on 08/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>

@interface MyprofileViewController : UIViewController

{
    IBOutlet UIImageView *profileImg;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *contactLbl;
    IBOutlet UILabel *emailLbl;
    IBOutlet UILabel *creditCardLbl;

    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
}
- (IBAction)profileImageEditBttn:(id)sender;
- (IBAction)profileEditBttn:(id)sender;
- (IBAction)BackBttn:(id)sender;
@end
