//
//  ForgotPasswordViewController.m
//  RapidRide
//
//  Created by Br@R on 09/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "SBJson.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
 #import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#define kCountriesFileName @"countries.json"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize  emailAddressTxt,headerLbl,doneBtn,activityIndicatorObject,disableImg,headerView,mobileNumText;
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
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
     [self.backView setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:0.5]];
    
    self.backView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backView.layer.borderWidth = 1.5;
    
    // Set image corner radius
    self.backView.layer.cornerRadius = 5.0;
    
    // To enable corners to be "clipped"
    [self.backView setClipsToBounds:YES];

    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtn:(id)sender {
    
    [self.view endEditing:YES];
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    NSString* uEmailStr = [emailAddressTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSString* mobileNumStr = [mobileNumText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([uEmailStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
    else if ([emailTest evaluateWithObject:uEmailStr] != YES)
    {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Enter valid user email address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [loginalert show];
    }
//    if ([mobileNumStr isEqualToString:@""])
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter your mobile number to get password.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        
//    }
//    else {
//        emailAddressTxt.text=@"";
//        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Mail has been sent to your account. please check." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [loginalert show];
//
//    }
    
   // 7696343444
    
    
    else {
        [self.activityIndicatorObject startAnimating];
        self.view.userInteractionEnabled =NO;
        disableImg.hidden=NO;
       // mobileNumStr=[NSString stringWithFormat:@"%@%@",phoneCode,mobileNumStr];
        NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:uEmailStr,@"UserEmail",  nil];
        
        NSString *jsonRequest = [jsonDict JSONRepresentation];
        
        NSLog(@"jsonRequest is %@", jsonRequest);
        NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RecoverPassword",Kwebservices]];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
        
        NSLog(@"Request:%@",urlString);
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(connection)
        {
            if(webData==nil)
            {
                webData = [NSMutableData data] ;
                NSLog(@"data");
            }
            else
            {
                webData=nil;
                webData = [NSMutableData data] ;
            }
            
            NSLog(@"server connection made");
        }
        
        else
        {
            NSLog(@"connection is NULL");
        }

     }
}
#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    disableImg.hidden=YES;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    
    webData =nil;

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    disableImg.hidden=YES;

    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;

    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        UIAlertView *alert;
        
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result ==1)
            
        {
            alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=2;
        }
        else{
            alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=1;
           
        }
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    
    if (alertView.tag==1)
    {
        if (buttonIndex==0)
        {
             emailAddressTxt.text=@"";
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return  YES;
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
