//
//  WelcomeViewController.h
//  SHED's
//
//  Created by Krishna_Mac_2 on 03/02/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextView *txtWelcome;
- (IBAction)gotIt:(id)sender;

@end
