//
//  Instructions_listViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac_3 on 08/01/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "instruction_objectclass.h"
#import "sqlite3.h"

@interface Instructions_listViewController : UIViewController
{
      NSMutableArray *inst_list;
}
@property (strong, nonatomic) IBOutlet UITableView *instruction_table;
@property (strong, nonatomic) IBOutlet UILabel *instructLabel;
@property (strong, nonatomic) instruction_objectclass *instructionObj;
@property (strong, nonatomic) NSMutableArray *inst_list;

- (IBAction)backBtn:(id)sender;

- (IBAction)PostToFacebook:(id)sender;


@end
