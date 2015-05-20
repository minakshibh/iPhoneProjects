//
//  forgotPasswordViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/3/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "forgotPasswordViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "loginViewController.h"
@interface forgotPasswordViewController ()

@end

@implementation forgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(160, 190);
    activityIndicator.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicator];
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

- (IBAction)retrivePassword:(id)sender {
    [self retrivePasswordBtn];
    [self.userEmail resignFirstResponder];
}

- (IBAction)backBtn:(id)sender {
    loginViewController *loginVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        loginVc=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        loginVc=[[loginViewController alloc]initWithNibName:@"loginViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        loginVc=[[loginViewController alloc]initWithNibName:@"loginViewController_ipad" bundle:Nil];
    }
    [self.navigationController pushViewController:loginVc animated:YES];

}



-(void)retrivePasswordBtn
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/ForgotPassword",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *userEmail;
   
    if(userEmail==nil)
        userEmail = [NSString stringWithFormat:@"%@",self.userEmail.text];
    [request setPostValue:userEmail forKey:@"email"];
    
    [activityIndicator startAnimating];
    [self.view setUserInteractionEnabled:NO];
    self.disableView.hidden = NO;
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    [activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    self.disableView.hidden = YES;
    
    NSError *error = [request error];
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Connection error..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertview show];
    NSLog(@"res error :%@",error.description);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    //    [songstabOutlet setUserInteractionEnabled:YES];
    //    [albumsTabOutlet setUserInteractionEnabled:YES];
    
    NSLog(@"response%@", responseString);
    [activityIndicator stopAnimating];
    
    NSData *responseData = [request responseData];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    
}

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI
  qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict

{
    if ([elementName isEqualToString:@"Result"]){
        tempString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"Success"]){
        tempString = [[NSMutableString alloc] init];
    }
}



//---when the text in an element is found---
- (void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    [tempString appendString:string];
}
//---when the end of element is found---
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([elementName isEqualToString:@"Success"]){
        
        message = [NSString stringWithFormat:@"%@", tempString];
    }else if ([elementName isEqualToString:@"Result"])
    {
        self.userEmail.text=@"";
        [activityIndicator stopAnimating];
        [self.view setUserInteractionEnabled:YES];
        self.disableView.hidden = YES;
        NSString *results = [NSString stringWithFormat:@"%@",tempString];
        if ([results isEqualToString:@"0"]) {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Please check your email for password." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alertview.tag = 1;
            [alertview show];
        }else{
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Invalid UserEmail" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertview show];
        }
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
    {
        loginViewController *loginVc;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            loginVc=[[loginViewController alloc]initWithNibName:@"loginViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            loginVc=[[loginViewController alloc]initWithNibName:@"loginViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else{
            loginVc=[[loginViewController alloc]initWithNibName:@"loginViewController_ipad" bundle:Nil];
        }
        [self.navigationController pushViewController:loginVc animated:YES];
        
        //  [self purchaseMyProduct:[validProducts objectAtIndex:0]];
        // [self downloadNow:nil];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ||[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
@end
