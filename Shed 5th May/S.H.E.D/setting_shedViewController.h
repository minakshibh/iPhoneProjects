//
//  setting_shedViewController.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 1/14/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/SKStoreProductViewController.h>

@interface setting_shedViewController : UIViewController<SKStoreProductViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *headertitle;
@property (strong, nonatomic) IBOutlet UIButton *aboutusbtn;
@property (strong, nonatomic) IBOutlet UIButton *passcodebtn;
@property (strong, nonatomic) IBOutlet UIButton *ratebtn;
- (IBAction)aboutusbtn:(id)sender;
- (IBAction)moveback:(id)sender;
- (IBAction)ratingbtn:(id)sender;
- (IBAction)postToFacebook:(id)sender;


@end
