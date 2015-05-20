//
//  OrdersListViewController.h
//  Nini Events
//
//  Created by Br@R on 09/02/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import <QuartzCore/QuartzCore.h>
#import "pendingOrdersOC.h"


@interface OrdersListViewController : UIViewController
{
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *pendingOrderItemNameArray,*pendingOrderListArray,*pendingOrderTimeOfDeliveryArray,*processingOrderList,*itemNamesArray;
    
    IBOutlet UILabel *headrLbl;
    int webServiceCode;
    pendingOrdersOC *pendingOrderObj;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;    
    IBOutlet UILabel *startNewOrdrLbl;
    IBOutlet UIImageView *strtNewOrdrImag;
    IBOutlet UILabel *ordrHistryLbl;
    IBOutlet UIImageView *ordrhistryImag;
    IBOutlet UIImageView *requstAssistImag;
    IBOutlet UIImageView *spCornrImag;
    IBOutlet UIImageView *exitImag;
    IBOutlet UILabel *requestAssistntLbl;
    IBOutlet UILabel *spCornerLbl;
    IBOutlet UILabel *exitLbl;
    int bulbFlag;
    NSTimer *hideTimer;
}
@property (strong,nonatomic) NSString* type;
@property (weak, nonatomic) IBOutlet UITableView *pendingOrdersTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *sideScroller;
@property (assign, nonatomic) int flagValue;
- (IBAction)backBtn:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)startAnewOrdeActionBtn:(id)sender;
- (IBAction)orderHistoryActionBtn:(id)sender;
- (IBAction)requestAssistntActionBtn:(id)sender;
- (IBAction)spCornerActionBtn:(id)sender;
- (IBAction)ExitBtn:(id)sender;
- (IBAction)apphomeAction:(id)sender;
- (IBAction)menuAction:(id)sender;
- (IBAction)checkOutView:(id)sender;
- (IBAction)ophemyAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *batchLbl;
@property (strong, nonatomic) IBOutlet UIView *sideMenuWithoutReqAssistance;
@property (strong, nonatomic) IBOutlet UIView *footerWithoutEventsDetail;
@property (strong, nonatomic) IBOutlet UILabel *otherMenuBatchLbl;
@property (strong, nonatomic) IBOutlet UIImageView *batchImg;
@property (strong, nonatomic) IBOutlet UIImageView *otheMenuBatchImg;
- (IBAction)pingBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *pingBulbImg;
@property (strong, nonatomic) IBOutlet UIImageView *otherMenuPingBulbImg;
@property (strong, nonatomic) IBOutlet UIView *pingMessageView;
@property (strong, nonatomic) IBOutlet UIImageView *assisstanceNotificationBadgeImg;
@property (strong, nonatomic) IBOutlet UILabel *assisstanceNotificationBadgeLbl;
@property (strong, nonatomic) IBOutlet UIView *exitPopUpView;
- (IBAction)exitYesAction:(id)sender;
- (IBAction)exitNoAction:(id)sender;

@end
