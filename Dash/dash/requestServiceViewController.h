//
//  requestServiceViewController.h
//  dash
//
//  Created by Krishna_Mac_1 on 4/27/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
@interface requestServiceViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
    IBOutlet UITextField *specialRequirmentTxt;
    IBOutlet UITextField *modeltxt;
    IBOutlet UITextField *maketxt;
    IBOutlet UITextField *vehicleNumberTxt;
    IBOutlet UITextField *colorTxt;
    IBOutlet UIImageView *uploadImage;
    IBOutlet UITextField *locationTxt;
    NSMutableArray *locationArray, *serviceTpeArray, *serviceTimeArray;
    IBOutlet UIView *serviceTypeView;
    IBOutlet UIView *selectServiceLocationView;
    BOOL isOtherLocationSelected;
    IBOutlet UITableView *serviceLocationTableView;
    IBOutlet UIButton *selectLocationBtn;
    IBOutlet UIButton *selectServiceTimeBtn;
    IBOutlet UIButton *selectDateBtn;
    IBOutlet UIButton *selectTimeBtn;
    IBOutlet UIView *serviceTimeView;
    IBOutlet UITableView *selectTypeTableView;
    IBOutlet UITableView *selectTimeTableView;
    IBOutlet UIButton *selectServiceTypeBtn;
    IBOutlet UIButton *getMapLocationBtn;
    IBOutlet UIButton *submitBtn;
    IBOutlet UIImageView *clockImg;
    IBOutlet UIImageView *calenderImg;
    IBOutlet UILabel *selectServiceTimeLbl;
    IBOutlet UILabel *selectServiceTypeLbl;
    IBOutlet UILabel *selectServiceLocationLbl;
    IBOutlet UIView *pickerBackView;
    IBOutlet UIDatePicker *dateTimePickr;
    NSString *timeSelectionType, *dateSelected;
}
- (IBAction)uploadImageBtnAction:(id)sender;
- (IBAction)getMapLocationBtnAction:(id)sender;
- (IBAction)selectLocationBtnAction:(id)sender;
- (IBAction)selectServiceTimeBtnAction:(id)sender;
- (IBAction)selectDateBtnAction:(id)sender;
- (IBAction)selectTimeBtnAction:(id)sender;
- (IBAction)selectserviceTypeBtnAction:(id)sender;
- (IBAction)submitBtnAction:(id)sender;
- (IBAction)doneDateSelectionBttn:(id)sender;
- (IBAction)cancelDateSelectionBttn:(id)sender;
- (IBAction)backBttn:(id)sender;
@end
