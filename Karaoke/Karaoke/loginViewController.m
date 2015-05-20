//
//  loginViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/3/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "loginViewController.h"
#import "registerViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AvailableSongsViewController.h"
#import "forgotPasswordViewController.h"
@interface loginViewController ()

@end

@implementation loginViewController

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

- (IBAction)loginBtn:(id)sender {
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    if ([self.userEmailtxt.text isEqualToString:@""] || [self.userPassword.text isEqualToString:@""]) {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Karaoke" message:@"Please enter the details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
    }
    else if ([emailTest evaluateWithObject:self.userEmailtxt.text] != YES)
    {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Karaoke" message:@"Please enter valid user email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
    }else{
        [activityIndicator startAnimating];
        [self.view setUserInteractionEnabled:NO];
       [self userLogin];
        [self.userPassword resignFirstResponder];
    }

}

- (IBAction)forgotBtn:(id)sender {
    forgotPasswordViewController *forgotPasswordVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        forgotPasswordVC =[[forgotPasswordViewController alloc] initWithNibName:@"forgotPasswordViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        forgotPasswordVC =[[forgotPasswordViewController alloc] initWithNibName:@"forgotPasswordViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        forgotPasswordVC =[[forgotPasswordViewController alloc] initWithNibName:@"forgotPasswordViewController_ipad" bundle:Nil];
    }
    
    [self.navigationController pushViewController:forgotPasswordVC animated:YES];
}
- (IBAction)registerBtn:(id)sender {
    registerViewController *registerVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        registerVC =[[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        registerVC =[[registerViewController alloc] initWithNibName:@"registerViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        registerVC =[[registerViewController alloc] initWithNibName:@"registerViewController_ipad" bundle:Nil];
    }

    [self.navigationController pushViewController:registerVC animated:YES];
}
-(void)userLogin
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/LoginUser",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *userEmail;
    NSString *userPassword;
    webserviceCode = 1;
    if(userEmail==nil)
        userEmail = [NSString stringWithFormat:@"%@",self.userEmailtxt.text];
    [request setPostValue:userEmail forKey:@"email"];
    
    if(userPassword==nil)
        userPassword = [NSString stringWithFormat:@"%@",self.userPassword.text];
    [request setPostValue:userPassword forKey:@"Password"];
    
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

{if (webserviceCode == 2) {
    if ([elementName isEqualToString:@"Result"]){
        tempString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"Message"]){
        tempString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"TotalCredits"]){
        tempString = [[NSMutableString alloc] init];
    }
}else{
    if ([elementName isEqualToString:@"Result"]){
        tempString = [[NSMutableString alloc] init];
    }else if ([elementName isEqualToString:@"Success"]){
        tempString = [[NSMutableString alloc] init];
    }
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
    if (webserviceCode == 2) {
        if ([elementName isEqualToString:@"Result"]){
            
            message = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"TotalCredits"])
        {
            creditValue = [NSString stringWithFormat:@"%@", tempString];
            [defaults setObject:creditValue forKey:@"totalSongs"];
        }
        NSLog(@"MESSAGE %@",message);
    }else{
    
    [defaults setObject:[NSString stringWithFormat:@"%@",self.userEmailtxt.text] forKey:@"Email"];
    if ([elementName isEqualToString:@"Success"]){
        
        message = [NSString stringWithFormat:@"%@", tempString];
    }else if ([elementName isEqualToString:@"Result"])
    {
        self.userPassword.text = @"";
        self.userPassword.text = @"";
        [activityIndicator stopAnimating];
        [self.view setUserInteractionEnabled:YES];
        self.disableView.hidden = YES;
        NSString *results = [NSString stringWithFormat:@"%@",tempString];
        if ([results isEqualToString:@"0"]) {
            [self addCredits:[NSString stringWithFormat:@"0"]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"NO"] forKey:@"isLogedOut"];
            NSLog(@"%@",[defaults valueForKey:@"isLogedOut"]);
            AvailableSongsViewController *availableSongsVc;
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                availableSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController" bundle:nil];
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480){
                availableSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_iphone4" bundle:Nil];
                // this is iphone 4 xib
            }
            else{
                availableSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_ipad" bundle:Nil];
            }
            [self.navigationController pushViewController:availableSongsVc animated:YES];
        }else{
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Invalid UserEmail/Password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertview show];
        }
        
    }
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    if (alertView.tag == 1)
//    {
//         [self addCredits:[NSString stringWithFormat:@"0"]];
//        AvailableSongsViewController *availableSongsVc;
//        if ([[UIScreen mainScreen] bounds].size.height == 568) {
//            availableSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController" bundle:nil];
//            //this is iphone 5 xib
//        }
//        else if([[UIScreen mainScreen] bounds].size.height == 480){
//            availableSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_iphone4" bundle:Nil];
//            // this is iphone 4 xib
//        }
//        else{
//            availableSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_ipad" bundle:Nil];
//        }
//        [self.navigationController pushViewController:availableSongsVc animated:YES];
//        
//    }
//}
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
-(void)addCredits:(NSString *)creditsValue
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/AddCredits",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *UDID;
    NSString *Credits;
    webserviceCode = 2;
    if(UDID==nil)
        UDID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Email"]];
    [request setPostValue:UDID forKey:@"user_email"];
    
    if(Credits==nil)
        Credits = [NSString stringWithString:creditsValue];
    [request setPostValue:Credits forKey:@"Credit"];
    
    
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

@end
