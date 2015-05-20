//
//  StudentDetailViewController.h
//  TutorHelper
//
//  Created by Br@R on 05/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentList.h"
#import "ParentList.h"
#import <MessageUI/MessageUI.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>


@interface StudentDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

{
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    
    IBOutlet UIView *backView;
    IBOutlet UILabel *headrLbl;
    IBOutlet UILabel *studentNameLbl;
    IBOutlet UILabel *parentNameLbl;
    IBOutlet UILabel *emailAddressLbl;
    
    IBOutlet UILabel *notes;
    IBOutlet UILabel *studentIdLbl;
    IBOutlet UILabel *feesLbl;
    IBOutlet UILabel *contactNumbrLbl;
    IBOutlet UITextView *addressLbl;
    IBOutlet UITextView *notesLbl;
}
- (IBAction)editBttn:(id)sender;
- (IBAction)backBttn:(id)sender;
@property (strong, nonatomic) StudentList*StudentObj;
- (IBAction)emailBttn:(id)sender;
@property (strong, nonatomic) ParentList*parentObj;
- (IBAction)callBttn:(id)sender;

@end
