//
//  checkWebserviceViewController.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/14/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "checkWebserviceViewController.h"
#include "JSON.h"
#include "ASIHTTPRequest.h"
#include "SBJson.h"
#include "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
@interface checkWebserviceViewController ()

@end

@implementation checkWebserviceViewController

- (void)viewDidLoad {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    [super viewDidLoad];
    [self fetchTimeStamp];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) fetchTimeStamp
{
     [activityIndicator startAnimating];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    NSString *theDate = [dateFormatter stringFromDate:currentDate];
    NSString *clientId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Client Id"]];
    NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:listDataIdStr,@"listDataId",clientId,@"clientId",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetCancellationThisWeek"];
    
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

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Internet connection seems to be down. Application might not work properly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"ERROR ...%@",error);
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
         [activityIndicator stopAnimating];
    
}
@end
