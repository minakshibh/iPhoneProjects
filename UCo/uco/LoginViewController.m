//
//  LoginViewController.m
//  uco
//
//  Created by Br@R on 17/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "manageVenueViewController.h"
#include "JSON.h"
#include "ASIHTTPRequest.h"
#include "SBJson.h"
#include "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    NSLog(@"%@",kWebservices);
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    self.navigationController.navigationBarHidden=YES;
    
    signBtn.layer.borderColor =[UIColor clearColor].CGColor;;
    signBtn.layer.borderWidth = 1.5;
    signBtn.layer.cornerRadius = 17.0;
    [signBtn setClipsToBounds:YES];

    signUpbtn.layer.borderColor =[UIColor clearColor].CGColor;;
    signUpbtn.layer.borderWidth = 1.5;
    signUpbtn.layer.cornerRadius =17.0;
    [signUpbtn setClipsToBounds:YES];

    signBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    signUpbtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    keepMeLoginBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    emailTxt.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    passwordTxt.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginActionBtn:(id)sender {
    
    emailStr=[NSString stringWithFormat:@"%@",emailTxt.text];
    passordStr=[NSString stringWithFormat:@"%@",passwordTxt.text];
    
    if (emailStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"U&Co" message:@"Please enter email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
//    else if (![self validateEmailWithString:emailTxt.text]==YES)
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"U&Co" message:@"Please enter valid email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    else if (passordStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"U&Co" message:@"Please enter Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }else{
        [self login:emailStr :passordStr];
    }
//    [self MoveToTutorFirstView];
    
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)keepMeLogInActionBtn:(id)sender {
}

- (IBAction)signUpActionBtn:(id)sender {
}


-(void)MoveToManageVenueView
{
//    [[NSUserDefaults standardUserDefaults]setValue:emailStr forKey:@"emailAddress"];
//    [[NSUserDefaults standardUserDefaults]setValue:passordStr forKey:@"password"];
//    
    manageVenueViewController*DashboardVC=[[manageVenueViewController alloc]initWithNibName:@"manageVenueViewController" bundle:[NSBundle mainBundle]];
    DashboardVC.flag = 1;
    [self.navigationController pushViewController:DashboardVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void) login:(NSString *)email: (NSString *)password
{
     [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:email,@"login",password,@"password", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadAuthenticate"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
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
#pragma mark -Json Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Internet connection seems to be down. Application might not work properly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
    NSString *myFirststr=[responseString substringToIndex:1];
    NSLog(@"First Character Of String:%@",myFirststr);
    NSString *myLaststr = [responseString substringFromIndex: [responseString length] - 1];
    NSLog(@"Last Character Of String:%@",myLaststr);
        NSError *error;
    if ([responseString hasPrefix:@"\""] && [responseString length] > 1) {
        responseString = [responseString substringFromIndex:1];
        responseString = [responseString substringToIndex:[responseString length] - 1];
    }
        responseString= [responseString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
         NSLog(@"responseString:%@",responseString);
        SBJsonParser *json = [[SBJsonParser alloc] init];
        NSLog(@"jsonPARSER :%@",json);
        NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
    NSLog(@"MESSAGE %@",[userDetailDict valueForKey:@"Message"]);
    NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Message"]];
    if ([messageStr isEqualToString:@"Success"]) {
        NSString *clientId = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"ClientId"]];
        [[NSUserDefaults standardUserDefaults] setValue:clientId forKey:@"Client Id"];
        if ([clientId isEqualToString:@"0"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"U&Co" message:@"Invalid Username/Password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];

        }else{
        
        NSString *userId = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Id"]];
        [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"User Id"];
        
        NSMutableArray *roleArray = [[NSMutableArray alloc] initWithArray:[userDetailDict valueForKey:@"SecurityFunc"]];

        NSString *roleStr = [NSString stringWithFormat:@"RestaurantAdmin"];
        if ([roleArray containsObject:roleStr]) {
            [self MoveToManageVenueView];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"U&Co" message:@"You are not Restaurant admin so you cannot login into this application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"U&C)" message:@"Invalid Username/Password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
        [activityIndicator stopAnimating];
       
    
}

@end
