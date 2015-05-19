//
//  PageWebViewController.m
//  SHEDs Plus
//
//  Created by Br@R on 08/08/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "PageWebViewController.h"

@interface PageWebViewController ()

@end

@implementation PageWebViewController
@synthesize  webView,activityIndicatorObject,disableImg;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    disableImg.hidden=NO;

    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   // activityIndicatorObject.backgroundColor =[UIColor blackColor];
     //activityIndicatorObject.color = [UIColor whiteColor];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 260);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 200);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 312);
    }
   // activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];
    [activityIndicatorObject startAnimating];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: @"https://www.facebook.com/pages/SHEDs/1469787619936379"] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    
    [self.webView loadRequest: request];
    
    //[activityIndicatorObject stopAnimating];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    disableImg.hidden=YES;

    [activityIndicatorObject stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Operation failed due to a connection problem, retry later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
    
    NSLog(@"Error:-%@",error);
    disableImg.hidden=YES;
    
    [activityIndicatorObject stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtn:(id)sender {
    
   [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
