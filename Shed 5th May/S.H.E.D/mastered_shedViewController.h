//
//  mastered_shedViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 1/9/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHED.h"
#import "AppDelegate.h"
#import "homescreenViewController.h"
#import "SHED.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "shed_data.h"

@interface mastered_shedViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    int _tag;
    int delete_tag;
}
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) SHED *shed;
@property (strong, nonatomic) IBOutlet UILabel *header_title;
@property (strong, nonatomic) IBOutlet UITableView *mastered_tableview;
@property (strong, nonatomic) NSMutableArray *mastered_list;
@property (strong, nonatomic) UIButton *deletebtn;
@property (strong, nonatomic) UIButton *movebtn;
@property (strong, nonatomic) NSString *strid;
@property (strong, nonatomic) NSMutableArray *rowData;
@property (strong, nonatomic) NSMutableArray *followeddate ,*daysarray;
@property (strong, nonatomic) NSMutableArray *data3;
@property (strong, nonatomic) NSMutableArray *indexList;
@property (strong, nonatomic) UILabel *shedname;
@property (strong, nonatomic) UILabel *shedtotalrun;
@property (strong, nonatomic) UIImageView *seperatorimg;
@property (strong, nonatomic) UILabel *shedapplieddays;
@property (strong, nonatomic) UIImageView *seperatorimg1;
@property (strong, nonatomic) UILabel *shedlongestrun;
@property (strong, nonatomic) NSString * result;
@property (assign, nonatomic) int totaldaysSelected;
- (IBAction)moveback:(id)sender;
@end
