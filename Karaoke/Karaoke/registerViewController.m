//
//  registerViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/3/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "registerViewController.h"
#import "loginViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface registerViewController ()

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(160, 190);
    activityIndicator.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicator];
    [self.scrollerView setContentSize: CGSizeMake(320 , 485)];
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

- (IBAction)loginBtn:(id)sender {
    loginViewController *loginVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController_ipad" bundle:Nil];
    }
    
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)registerBtn:(id)sender {
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 "] invertedSet];
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    [self.view endEditing:YES];
    
    
    if([self.userFirstName.text isEqualToString:@""] || [self.userEmail.text isEqualToString:@""] || [self.userPassword.text isEqualToString:@""] || [self.userConfirmPassword.text isEqualToString:@""] || [self.userLastName.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Uteliv" message:@"Please enter all the details." delegate:nil
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([self.userFirstName.text rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Karaoke" message:@"Please enter valid First name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
    }else if ([self.userLastName.text rangeOfCharacterFromSet:set].location != NSNotFound)
    {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Karaoke" message:@"Please enter valid Last name." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
    }
    
    else if ([emailTest evaluateWithObject:self.userEmail.text] != YES)
    {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Karaoke" message:@"Please enter valid user email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
    }else if (![[NSString stringWithFormat:@"%@",self.userPassword.text] isEqualToString:[NSString stringWithFormat:@"%@",self.userConfirmPassword.text]])
    {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Karaoke" message:@"There’s a Problem! \n The passwords do not match" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
    }
    else{
        NSLog(@"Registered successfully");
        [activityIndicator stopAnimating];
        [self.view setUserInteractionEnabled:NO];
        [self userRegistration];
    }
    [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)backBtn:(id)sender {
    loginViewController *loginVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController_ipad" bundle:Nil];
    }
    
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = self.scrollerView.contentOffset;
    
    if (textField == self.userEmail || textField == self.userPassword || textField == self.userConfirmPassword || textField == self.userLastName) {
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.scrollerView];
        pt = rc.origin;
        pt.x = 0;
        pt.y -=70;
        [self.scrollerView setContentOffset:pt animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

-(void)userRegistration
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterUser",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *userName;
    NSString *userPassword;
    NSString *userEmail;
    NSString *UDID;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userNameStr = [NSString stringWithFormat:@"%@ %@",self.userFirstName.text, self.userLastName.text];
    if(UDID==nil)
        UDID = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"user_UDID_Str"]];
    [request setPostValue:UDID forKey:@"User_UDID"];
    
    if(userPassword==nil)
        userPassword = [NSString stringWithFormat:@"%@",self.userPassword.text];
    [request setPostValue:userPassword forKey:@"Password"];
    
    if (userName == nil) {
        userName = [NSString stringWithString:userNameStr];
        [request setPostValue:userName forKey:@"Username"];
    }
    if (userEmail == nil) {
        userEmail = [NSString stringWithFormat:@"%@",self.userEmail.text];
        [request setPostValue:userEmail forKey:@"Email"];
    }

    [activityIndicator stopAnimating];
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
    [self.view setUserInteractionEnabled:YES];
    self.disableView.hidden = YES;
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
    self.userEmail.text = @"";
    self.userFirstName.text = @"";
    self.userLastName.text = @"";
    self.userPassword.text = @"";
    self.userConfirmPassword.text = @"";
    [activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    self.disableView.hidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([elementName isEqualToString:@"Result"]){
        message = [NSString stringWithFormat:@"%@", tempString];
        if ([message isEqualToString:@"0"]) {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Thanks For Registering! \n Registration Complete" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            alertview.tag = 1;
            [alertview show];
        }else{
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Email already exist." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertview show];
        }
    }
    NSLog(@"MESSAGE %@",message);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 1 )
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
