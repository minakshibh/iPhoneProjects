//
//  AboutUsViewController.m
//  RapidRide
//
//  Created by Br@R on 26/11/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize webView,linkUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];

    [self.headedLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:linkUrl] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    
    [self.webView loadRequest: request];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
      NSLog(@"Error:-%@",error);
    
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
