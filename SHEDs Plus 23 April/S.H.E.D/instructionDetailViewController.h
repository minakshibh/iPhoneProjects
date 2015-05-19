//
//  instructionDetailViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac_3 on 09/01/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "instruction_objectclass.h"

@interface instructionDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *instructionDetailTxtView;
@property (strong, nonatomic) IBOutlet UILabel *instDetailLabl;
@property (strong, nonatomic) instruction_objectclass *insObjClass;

- (IBAction)BckToList:(id)sender;
- (IBAction)PostToFacebook:(id)sender;

@end
