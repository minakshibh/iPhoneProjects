//
//  GreetingsViewController.h
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSideBarView.h"
#import "UpparBarView.h"
#import "Greeting.h"


@interface GreetingsViewController : UIViewController
{
    LeftSideBarView *Leftsideview;
    UpparBarView*upparView;
    IBOutlet UITableView *greetingTableView;
    NSMutableArray*greetingListArray;
    Greeting*greetingListObj;
    
    IBOutlet UIButton *emailPageBttn;
    IBOutlet UIButton *printPageBttn;
}
- (IBAction)printPageBtn:(id)sender;
- (IBAction)emailPageBttn:(id)sender;


@end
