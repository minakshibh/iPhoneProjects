//
//  loginViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/3/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController
{
     UIActivityIndicatorView *activityIndicator;
    NSMutableString *tempString;
    NSString *result,*message, *creditValue;
    int webserviceCode;
}
@property (weak, nonatomic) IBOutlet UITextField *userEmailtxt;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UIImageView *disableView;
- (IBAction)loginBtn:(id)sender;
- (IBAction)forgotBtn:(id)sender;

- (IBAction)registerBtn:(id)sender;

@end
