//
//  registerViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/3/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface registerViewController : UIViewController<UIScrollViewDelegate>
{
    CGPoint svos;
    UIActivityIndicatorView *activityIndicator;
    NSMutableString *tempString;
    NSString *result,*message, *creditValue;
  
}
@property (weak, nonatomic) IBOutlet UIImageView *disableView;
@property (weak, nonatomic) IBOutlet UITextField *userFirstName;
@property (weak, nonatomic) IBOutlet UITextField *userLastName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UITextField *userConfirmPassword;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
- (IBAction)loginBtn:(id)sender;
- (IBAction)registerBtn:(id)sender;
- (IBAction)backBtn:(id)sender;



@end
