
//
//  testViewController.h
//  AccordionTableView
//
//  Created by Krishna_Mac on 12/26/13.
//  Copyright (c) 2013 Vladimir Olexa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gratitude.h"
#import <MessageUI/MessageUI.h>
#import "FMDatabase.h"
#import <QuickLook/QuickLook.h>


@interface gratitude_listingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    NSArray *topItems;
    NSMutableArray *subItems;
    NSString *ParentCellIdentifier;
    NSString *ChildCellIdentifier;
    int currentExpandedIndex;
    bool isMovingDown, shouldCollapse;
    int lastSelection, currentSelection;
    int flag;
    bool isLoadMoreRequired;
    NSString* fileName, *autoArchieve,*keepHistry,*emailid;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    int index1, index2;
    Gratitude *gratOC;
    NSString *gratString;
    NSDate *tenDaysAgo;
    NSDate *twentyDaysAgo;
    NSDate *thirtyDaysAgo;

}


@property (strong, nonatomic) NSString* fileName;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray *gratitude_list,*gratArchievArray;
@property (strong, nonatomic) NSMutableArray *gratitudeDescription, *gratitudeid;
@property (strong, nonatomic) NSMutableArray *selectedRows;
@property (strong, nonatomic) UILabel *datelbl;
@property (strong, nonatomic) UILabel *gratlbl;
@property (strong, nonatomic) UIButton *editBtn;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIImageView *gratimgup;
@property (strong, nonatomic) UIImageView *gratimgdown;
@property (strong, nonatomic) IBOutlet UITextView *gratTxtView;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIView *gratPopUp;
@property (assign, nonatomic) long int  rowIndex;
@property (assign, nonatomic) long int  selectIndex;
@property (strong, nonatomic) IBOutlet UIView *hideTxtView;
@property (strong, nonatomic) IBOutlet UIImageView *disableImgView;
@property (strong, nonatomic) Gratitude *myGrat;

-(IBAction)edittingDoneBtn:(id)sender;
-(IBAction)archieveBtn:(id)sender;
-(NSString*)getPDFFileName;
- (IBAction)PostToFacebook:(id)sender;

@end




