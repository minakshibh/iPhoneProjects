//
//  PageWebViewController.h
//  SHEDs Plus
//
//  Created by Br@R on 08/08/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageWebViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)cancelBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *disableImg;
@end
