//
//  RegistrationRiderViewController.m
//  RapidRide
//
//  Created by Br@R on 14/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "RegistrationRiderViewController.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "JSON.h"
#import "Base64.h"
#define kCountriesFileName @"countries.json"

@interface RegistrationRiderViewController ()

@end


@implementation RegistrationRiderViewController
@synthesize headerLbl,registerBtn,regHeaderLbl,uConfirmPasswrdTxt,uEmailAddressTxt,uFirstNameTxt,uLastNameTxt,undoManager,uPasswordTxt,profileImageView,loginHereBtn,loginLbl,activityIndicatorObject,uContactNoTxt,uEmailAdressStr,uPasswordStr,scrollView,disableImg,headerView;

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
    [super viewDidLoad];
    
    
    phoneCode=@"";
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    NSArray*countriesList = (NSArray *)parsedObject;
    
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    // NSString *currntCountryCode=@"IN";
    
    for (NSDictionary *countryCode1 in countriesList)
    {
        NSLog(@"%@",[countryCode1 valueForKey:@"code"]);
        if ([countryCode isEqualToString:[countryCode1 valueForKey:@"code"]])
        {
            phoneCode=[countryCode1 valueForKey:@"dial_code"];
        }
    }

    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
     [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.backView setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:0.5]];
    
    self.backView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backView.layer.borderWidth = 1.5;
    
    // Set image corner radius
    self.backView.layer.cornerRadius = 5.0;
    
    // To enable corners to be "clipped"
    [self.backView setClipsToBounds:YES];

    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [regHeaderLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:23]];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        [regHeaderLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
        
    }

    [registerBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [loginLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [loginHereBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:19]];
    
    
    NSMutableAttributedString *loginString = [[NSMutableAttributedString alloc] initWithString:@"Login Here"];
    [loginString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [loginString length])];
    
    [loginHereBtn setAttributedTitle:loginString forState:UIControlStateNormal];
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        scrollView.contentSize = CGSizeMake(320, 500);
        
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        scrollView.contentSize = CGSizeMake(320, 550);
    }
    
    else{
        scrollView.contentSize = CGSizeMake(768, 1700);
        
    }
    scrollView.backgroundColor=[UIColor clearColor];

   
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

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard

{
    [uContactNoTxt resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

}
#pragma mark - Text field Delegates


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==uContactNoTxt)
    {
        NSString *currentString = [uContactNoTxt.text stringByReplacingCharactersInRange:range withString:string];
        int length = [currentString length];
        if (length > 10) {
            return NO;
        }
      
    }
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        if (textField== uFirstNameTxt  )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        }
        if (textField== uContactNoTxt || textField==uConfirmPasswrdTxt ) {
            [scrollView setContentOffset:CGPointMake(0.0, 70) animated:YES];
        }
        
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        if (textField== uFirstNameTxt  )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        }
        if (textField== uEmailAddressTxt || textField==uConfirmPasswrdTxt|| textField==uPasswordTxt ) {
            [scrollView setContentOffset:CGPointMake(0.0, 100) animated:YES];
        }
        
    }
    if (textField== uContactNoTxt ) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
    }

    return  YES;

}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
      return  YES;
}


- (IBAction)loginHereBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registeratioBtn:(id)sender
{
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

    NSString* uFirstNameStr = [uFirstNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* uLastNameStr = [uLastNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    uEmailAdressStr = [uEmailAddressTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    uPasswordStr = [uPasswordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* uConfrmPassStr = [uConfirmPasswrdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* uContactNumStr = [uContactNoTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
    [self.view endEditing:YES];
    NSData *img1Data = UIImageJPEGRepresentation(profileImageView.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"upload-btn.png"], 1.0);
    
    
    
    if([uFirstNameStr isEqualToString:@""] &&[uLastNameStr isEqualToString:@""] &&[uEmailAdressStr isEqualToString:@""] && [uPasswordStr isEqualToString:@""] && [uConfrmPassStr isEqualToString:@""] && [uContactNumStr isEqualToString:@""])
        
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"RapidRide" message:@"Please enter all the details." delegate:self
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([uFirstNameStr isEqualToString:@""])
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the User First Name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([uLastNameStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the User Last Name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([uEmailAdressStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the User Email Address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([emailTest evaluateWithObject:uEmailAdressStr] != YES)
    {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Enter valid User Email Address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [loginalert show];
    }
    else if ([uPasswordStr isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the Password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([uConfrmPassStr isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter Password to Confirm." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![uPasswordStr isEqualToString:uConfrmPassStr])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Password does not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([uContactNumStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
   
    else if (uContactNumStr.length<10 )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the valid Mobile Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else if ([img1Data isEqualToData:img2Data])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Upload User's Photo." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    else {
        [self.activityIndicatorObject startAnimating];
        self.view.userInteractionEnabled=NO;
        disableImg.hidden=NO;
        [Base64 initialize];
        NSData* data = UIImageJPEGRepresentation(profileImageView.image, 0.3f);
        NSString *strEncoded = [Base64 encode:data];
      //  NSString *strEncoded = @"";

        [self UserRegistration:uFirstNameStr UserLastName:uLastNameStr Emailid:uEmailAdressStr Password:uPasswordStr Contactnum:uContactNumStr Image:strEncoded];
    }
}

-(void)UserRegistration:(NSString*)userfirstname UserLastName:(NSString*)userlastName Emailid:(NSString*)emailid Password:(NSString *)password Contactnum:(NSString *)contactnum Image:(NSString*)image

{
    
    contactnum=[NSString stringWithFormat:@"%@%@",phoneCode,contactnum];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:userfirstname,@"FirstName",userlastName,@"LastName",emailid,@"Email",password,@"Password",contactnum,@"PhoneNumber",image,@"Image",nil];
    
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    

    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Registeration",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
  //  data = [NSData dataWithContentsOfURL:urlString];
    
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

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data1
{
    [webData appendData:data1];
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
    NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
    if (webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            UIAlertView *alert;
            if (result ==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if(result==0)
            {
                    uFirstNameTxt.text=@"";
                    uLastNameTxt.text=@"";
                    uEmailAddressTxt.text=@"";
                    uPasswordTxt.text=@"";
                    uConfirmPasswrdTxt.text=@"";
                    uContactNoTxt.text=@"";
                    profileImageView.image=[UIImage imageNamed:@"upload-btn.png"];
                    
                    LoginViewController *loginVc;
                    
                    if ([[UIScreen mainScreen] bounds].size.height == 568) {
                        
                        loginVc=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480) {
                        loginVc=[[LoginViewController alloc]initWithNibName:@"LoginViewController_iphone4" bundle:nil];
                    }
                loginVc.uName=uEmailAdressStr;
                loginVc.uPasswrd=uPasswordStr;
                webservice=0;
                [self.navigationController pushViewController:loginVc animated:NO];
            }
        }
    }
    else{
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            UIAlertView *alert;
            if (result ==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=2;
            }
            else if(result==0)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"riderInfo"];
                [userdefaults removeObjectForKey:@"userEmail"];
                [userdefaults removeObjectForKey:@"userPassword"];

                
                riderIdString=[userDetailDicttemp valueForKey:@"userid"];
                webservice=2;
                
                NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://appba.riderapid.com/newreg/?riderid=%@",riderIdString]];
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
                
                NSLog(@"Request:%@",urlString);
                
                [request setHTTPMethod:@"GET"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                
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
              //  alert.tag=1;
            }
            
            [alert show];
        }
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    
    if (alertView.tag==1)
    {
        if (buttonIndex==0)
        {
            uFirstNameTxt.text=@"";
            uLastNameTxt.text=@"";
            uEmailAddressTxt.text=@"";
            uPasswordTxt.text=@"";
            uConfirmPasswrdTxt.text=@"";
            uContactNoTxt.text=@"";
            profileImageView.image=[UIImage imageNamed:@"upload-btn.png"];
         
            MapViewController *mapVc;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            }
            [self.navigationController pushViewController:mapVc animated:YES];
        }
    }
}

# pragma mark Image upload

- (IBAction)uploadImageBtn:(id)sender {
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:@"Camera"
                                  otherButtonTitles:nil];
    

    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker
                           animated:YES completion:nil];


    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(100,100));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [chosenImage drawInRect: CGRectMake(0, 0, 100, 100)];
    
    chosenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.profileImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
