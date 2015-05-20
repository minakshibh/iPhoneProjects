//
//  forgotPasswordViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/3/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgotPasswordViewController : UIViewController
{
    UIActivityIndicatorView *activityIndicator;
    NSMutableString *tempString;
    NSString *result,*message, *creditValue;
}
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UIImageView *disableView;
- (IBAction)retrivePassword:(id)sender;
- (IBAction)backBtn:(id)sender;

@end
