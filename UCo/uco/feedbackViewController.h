//
//  feedbackViewController.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "feedbackObj.h"
#import "UpparBarView.h"

@interface feedbackViewController : UIViewController{
    NSMutableArray *feedbackArray;
    feedbackObj *feedbackOC;
     UpparBarView*upparView;
    IBOutlet UILabel *readLbl;
    IBOutlet UILabel *newLbl;
    IBOutlet UILabel *testimonialsLbl;
    IBOutlet UILabel *reviews;
}
@property (strong, nonatomic) IBOutlet UILabel *commentTitle;
@property (strong, nonatomic) IBOutlet UILabel *customerTitle;
@property (strong, nonatomic) IBOutlet UILabel *dateTitle;
@property (strong, nonatomic) IBOutlet UITableView *feedbackTableView;

@end
