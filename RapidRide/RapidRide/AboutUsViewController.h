//
//  AboutUsViewController.h
//  RapidRide
//
//  Created by Br@R on 26/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController

{

}
@property (strong, nonatomic) IBOutlet UILabel *headedLbl;
@property (strong, nonatomic) IBOutlet UILabel *headerView;
@property (weak, nonatomic)   IBOutlet UIWebView *webView;
@property (strong ,nonatomic) NSString *linkUrl;
- (IBAction)backBtn:(id)sender;

@end
