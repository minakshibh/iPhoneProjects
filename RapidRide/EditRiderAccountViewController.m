//
//  EditRiderAccountViewController.m
//  RapidRide
//
//  Created by Br@R on 14/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "EditRiderAccountViewController.h"
#import "MapViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "JSON.h"
#import "Base64.h"
@interface EditRiderAccountViewController ()

@end

@implementation EditRiderAccountViewController
@synthesize userFirstNameTxt,userLastNameTxt,passwordTxt,confirmPasswrdTxt,contactNumbrTxt,adressLbl,imageview,scrollView,addressZipTxt,cityTxt,stateTxt,headerLbl,editDoneBtn,registertionLbl,addressTxt,activityIndicatorObject,headerView,loginAsLbl,countryTxt,addressBackView,userInfoBackView,countryListTable,flightNumTxt;


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
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    dataDict=[[NSMutableDictionary alloc]init];
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    userIdStr=[dataDict valueForKey:@"userid"];
    userEmailStr=[userdefaults valueForKey:@"userEmail"];
    promocodeArray=[dataDict valueForKey:@"ListPromoCodeInfo"];
    creditCardArray=[dataDict valueForKey:@"ListCreditCardInfo"];
    vehicleType=[dataDict valueForKey:@"prefvehicletype"];
    driverId=[dataDict valueForKey:@"driverid"];
    specialneedString=[dataDict valueForKey:@"specialneedsnotes"];
    flightNumbrStr=[dataDict valueForKey:@"flightNumber"];
    NSString *  handicapedStr=[dataDict valueForKey:@"handicap"];
    NSString *  animalStr=[dataDict valueForKey:@"animal"];
    
    if ([animalStr isEqualToString:@"1"])
    {
        animal=1;
        animalYesBtn.backgroundColor=[UIColor whiteColor];
        animalNobtn.backgroundColor=[UIColor grayColor];
    }
    else{
        animal=0;
        animalYesBtn.backgroundColor=[UIColor grayColor];
        animalNobtn.backgroundColor=[UIColor whiteColor];
    }
    if ([handicapedStr isEqualToString:@"1"])
    {
        handicaped=1;
        self.handicapedYesBtn.backgroundColor=[UIColor whiteColor];
        self.handicapedNoBtn.backgroundColor=[UIColor grayColor];
    }
    else{
        handicaped=0;
        self.handicapedYesBtn.backgroundColor=[UIColor grayColor];
        self.handicapedNoBtn.backgroundColor=[UIColor whiteColor];
    }
    
   // promoValueArray=[dataDict valueForKey:@"value"];
    [loginAsLbl setText:[NSString stringWithFormat:@"Welcome %@",[dataDict valueForKey:@"firstname"]]];
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [editDoneBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [self.editBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [handicapedlbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [servicAnimlLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [animalNobtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [animalYesBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.handicapedNoBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.handicapedYesBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [adressLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [self.userAccountHeader setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [specialneedHdrLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [registertionLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:23]];
    [loginAsLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];

    userInfoBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    userInfoBackView.layer.borderWidth = 1.5;
    userInfoBackView.layer.cornerRadius = 5.0;
    [userInfoBackView setClipsToBounds:YES];
    
    addressBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    addressBackView.layer.borderWidth = 1.5;
    addressBackView.layer.cornerRadius = 5.0;
    [addressBackView setClipsToBounds:YES];
    
    [self DisableView];
    
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        scrollView.contentSize = CGSizeMake(320, 770);
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        scrollView.contentSize = CGSizeMake(320, 770);
    }
    
    scrollView.backgroundColor=[UIColor clearColor];
    [self registerForKeyboardNotifications];
   
    
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


-(void)dismissKeyboard
{
    [contactNumbrTxt resignFirstResponder];
    [addressZipTxt resignFirstResponder];
    [flightNumTxt resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editDoneBtn:(id)sender {
    
    countryListTable.hidden=YES;

    [self.view endEditing:YES];
    
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    [self.view endEditing:YES];
    NSData *img1Data = UIImageJPEGRepresentation(imageview.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"upload-btn.png"], 1.0);
    
  
    specialNeedStr=[specialneedTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uFirstNameStr = [userFirstNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uLastNameStr = [userLastNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uPasswordStr = [passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uConfrmPassStr = [confirmPasswrdTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    uContactNumStr=@"";
    uContactNumStr = [contactNumbrTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uAddressStr = [addressTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uCityStr = [cityTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uStateStr = [stateTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     uCountryStr = [countryTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

     uAddressZipStr = [addressZipTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
     flightNumbrStr= [flightNumTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([uFirstNameStr isEqualToString:@""] &&[uLastNameStr isEqualToString:@""] && [uPasswordStr isEqualToString:@""] && [uConfrmPassStr isEqualToString:@""] && [uContactNumStr isEqualToString:@""]&& [uAddressStr isEqualToString:@""] && [uCityStr isEqualToString:@""]&& [uStateStr isEqualToString:@""] && [uAddressZipStr isEqualToString:@""]  )
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
  
    else if([uAddressStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the Address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([uCityStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the City." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([uStateStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the State." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([uCountryStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the Country." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([uAddressZipStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the Zip." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        self.disablImg.hidden=NO;
        
        [Base64 initialize];
        NSData* data = UIImageJPEGRepresentation(imageview.image, 0.3f);
        NSString *strEncoded = [Base64 encode:data];
        
        [self UserRegistration:uFirstNameStr UserLastName:uLastNameStr Password:uPasswordStr Contactnumbr:uContactNumStr Address:uAddressStr City:uCityStr State:uStateStr ZipCode:uAddressZipStr Country:uCountryStr Image:strEncoded specialNeed:specialNeedStr flightNum:flightNumbrStr];
    }
}

-(void)UserRegistration:(NSString*)userfirstname UserLastName:(NSString*)userlastName Password:(NSString *)password Contactnumbr:(NSString*)contactnumbr Address:(NSString *)address City:(NSString*)city State:(NSString*)state ZipCode:(NSString*)zipcode Country:(NSString*)country  Image:(NSString*)image specialNeed:(NSString*)specialNeed flightNum:(NSString*)flightNumStr

{
    contactnumbr=[NSString stringWithFormat:@"%@%@",phoneCode,contactnumbr];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:userIdStr ,@"UserId", userfirstname,@"FirstName",userlastName,@"LastName", password,@"Password",contactnumbr,@"Phone",address,@"Address",@"",@"Apt",country,@"Country",state,@"State",city,@"City",zipcode,@"Zip",image,@"ProfilePhoto",[NSString stringWithFormat:@"%d",handicaped],@"Handicap",[NSString stringWithFormat:@"%d",animal],@"Animal",specialNeed,@"Specialneedsnotes",flightNumStr,@"FlightNumber",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/EditProfile",Kwebservices]];
    
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
#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.disablImg.hidden=YES;

    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    self.editBtn.userInteractionEnabled=YES;
    self.editBtn.hidden=NO;
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
    self.disablImg.hidden=YES;

    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    self.editBtn.userInteractionEnabled=YES;
    self.editBtn.hidden=NO;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        UIAlertView *alert;

        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result ==1)
        {
            alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=2;
        }
        else if(result ==0)
        {
            dataDict = [[NSMutableDictionary alloc] init];

            
            [dataDict setObject:flightNumbrStr forKey:@"flightnumber"];

            [dataDict setObject:uFirstNameStr forKey:@"firstname"];
            [dataDict setObject:uLastNameStr forKey:@"lastname"];
            [dataDict setObject:uPasswordStr forKey:@"password"];
            [dataDict setObject:[NSString stringWithFormat:@"%@%@",phoneCode,uContactNumStr] forKey:@"phone"];
            [dataDict setObject:uAddressStr forKey:@"address"];
            [dataDict setObject:uCityStr forKey:@"city"];
            [dataDict setObject:uCountryStr forKey:@"country"];
            [dataDict setObject:uStateStr forKey:@"state"];
            [dataDict setObject:uAddressZipStr forKey:@"zip"];
            [dataDict setObject:picUrl forKey:@"profilepiclocation"];
            [dataDict setObject:userIdStr forKey:@"userid"];
            [dataDict setObject:userEmailStr forKey:@"uEmailAddress" ];
           // [dataDict setObject:creditCardArray forKey:@"ListCreditCardInfo"];
            [dataDict setObject:vehicleType forKey:@"prefvehicletype"];
            [dataDict setObject:driverId forKey:@"driverid"];
            [dataDict setObject:[NSString stringWithFormat:@"%d",handicaped ]forKey:@"handicap"];
            [dataDict setObject:[NSString stringWithFormat:@"%d",animal ]forKey:@"animal"];
            [dataDict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"payment_status"] forKey:@"payment_status"];
             [dataDict setObject:specialNeedStr forKey:@"specialneedsnotes"];
            if (promocodeArray.count>0) {
                [dataDict setObject:promocodeArray forKey:@"ListPromoCodeInfo" ];
            }
            else{
                [dataDict setObject:@"" forKey:@"ListPromoCodeInfo" ];
            }
            

            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"riderInfo"];
            [userdefaults setValue:dataDict forKey:@"riderInfo"];
            [userdefaults synchronize];
            
            [self DisableView];
            alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=1;
            
            UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            objactivityindicator.center = CGPointMake((self.imageview.frame.size.width/2),(self.imageview.frame.size.height/2));
            [self.imageview addSubview:objactivityindicator];
            [objactivityindicator startAnimating];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                NSURL *imageURL=[NSURL URLWithString:[picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
                UIImage *imgData=[UIImage imageWithData:tempData];
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                                   {
                                       [self.imageview setImage:imgData];
                                       //  [UserImageDict setObject:imgData forKey:UrlString];
                                       [objactivityindicator stopAnimating];
                                       
                                   }
                                   else
                                   {
                                       //[self.imageview setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                       [objactivityindicator stopAnimating];
                                       
                                   }
                               });
            });

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

        }
    }
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)aniamlNoBtn:(id)sender
{
    animal=0;
    animalNobtn.backgroundColor=[UIColor whiteColor];
    animalYesBtn.backgroundColor=[UIColor grayColor];
}

- (IBAction)animalYesBtn:(id)sender
{
    animal=1;
    animalYesBtn.backgroundColor=[UIColor whiteColor];
    animalNobtn.backgroundColor=[UIColor grayColor];
}
# pragma mark Image upload

- (IBAction)selectImageBtn:(id)sender
 {
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
    
    self.imageview.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Text field Delegates
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField==contactNumbrTxt)
    {

        NSString *currentString = [contactNumbrTxt.text stringByReplacingCharactersInRange:range withString:string];
        int length = [currentString length];
        if (length > 10) {
            return NO;
        }
        
    }
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    countryListTable.hidden=YES;
    
    
    
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        if (textField ==contactNumbrTxt || textField==confirmPasswrdTxt )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 170) animated:YES];
        }
        else if (textField == addressTxt || textField == stateTxt ||textField == countryTxt ||textField == cityTxt )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 455) animated:YES];
        }
        
        else if ( textField == addressZipTxt  || textField== flightNumTxt)
        {
            [scrollView setContentOffset:CGPointMake(0.0, 555) animated:YES];
        }
        else{
            scrollView.contentOffset = CGPointMake(0,0);
        }
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        if (textField ==userLastNameTxt || textField==passwordTxt )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 80) animated:YES];
        }
        else if (textField ==confirmPasswrdTxt  )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 170) animated:YES];
        }
        else if (textField ==contactNumbrTxt  )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 200) animated:YES];
        }
        else if (textField == addressTxt   ||textField == cityTxt)
        {
            [scrollView setContentOffset:CGPointMake(0.0, 440) animated:YES];
        }
        else if (textField == stateTxt  )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 505) animated:YES];
        }
        else if ( textField==countryTxt || textField == addressZipTxt  )
        {
            [scrollView setContentOffset:CGPointMake(0.0, 575) animated:YES];
        }
        else if (textField == flightNumTxt)
        {
            [scrollView setContentOffset:CGPointMake(0.0, 600) animated:YES];
        }
        else{
            scrollView.contentOffset = CGPointMake(0,0);
        }
    }
  
    
    if (textField== contactNumbrTxt || textField == addressZipTxt || textField==flightNumTxt) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        
        [self.view addGestureRecognizer:tap];
    }
    
    if (textField ==countryTxt)
    {
        
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

    return  YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == specialneedTxtView )
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [scrollView setContentOffset:CGPointMake(0.0, 300) animated:YES];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            [scrollView setContentOffset:CGPointMake(0.0, 315) animated:YES];
        }
    }
    return YES;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - Keyboard movement

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (isContactNumber) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    }
}

-(void)keyboardFrameDidChange:(NSNotification*)notification{
    NSDictionary* info = [notification userInfo];
    CGRect kKeyBoardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
}


- (IBAction)SelectCountry:(id)sender
{
    [self.view endEditing:YES];
    
    [self.countryListTable reloadData];

    countryListTable.hidden=NO;
    [self.view bringSubviewToFront:self.countryListTable];
}

- (IBAction)editBtn:(id)sender {
    
    if (iseditView)
    {
        [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        countryListTable.hidden=YES;
        [self DisableView];
    }
    else{
        if (self.countryTxt.text.length<1)
        {
              self.countryTxt.text=@"United States";
        }
            countriesArray = [[NSMutableArray alloc] init];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
            
            NSArray *countryArray = [NSLocale ISOCountryCodes];
            for (NSString *countryCode in countryArray)
            {
                NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
                [countriesArray addObject:displayNameString];
            }
            
            countryListTable.frame=CGRectMake(countryTxt.frame.origin.x, countryTxt.frame.origin.y+countryTxt.frame.size.height, countryTxt.frame.size.width,90);

        [self EnableView];
    }
  }



- (IBAction)handycapedNoBtn:(id)sender
{
    handicaped=0;
    self.handicapedNoBtn.backgroundColor=[UIColor whiteColor];
    self.handicapedYesBtn.backgroundColor=[UIColor grayColor];

}
- (IBAction)handicapedYes:(id)sender
{
    handicaped=1;
    self.handicapedNoBtn.backgroundColor=[UIColor grayColor];
    self.handicapedYesBtn.backgroundColor=[UIColor whiteColor];

}
-(void)DisableView
{
    [self.view endEditing:YES];
    
    self.userFirstNameTxt.text=[dataDict valueForKey:@"firstname"];
    self.userLastNameTxt.text=[dataDict valueForKey:@"lastname"];
    self.contactNumbrTxt.text= [dataDict valueForKey:@"phone"];
    self.passwordTxt.text=[dataDict valueForKey:@"password"];
    self.confirmPasswrdTxt.text=[dataDict valueForKey:@"password"];
    self.addressTxt.text=[dataDict valueForKey:@"address"];
    self.cityTxt.text=[dataDict valueForKey:@"city"];
    self.stateTxt.text=[dataDict valueForKey:@"state"];
    self.flightNumTxt.text=[dataDict valueForKey:@"flightnumber"];
    
    NSString *PhoneCompleteStr=[dataDict valueForKey:@"phone"];
    NSString*PhoneStr;
    if (PhoneCompleteStr.length>10)
    {
    PhoneStr= [PhoneCompleteStr substringFromIndex: [PhoneCompleteStr length] - 10];
    phoneCode= [PhoneCompleteStr stringByReplacingOccurrencesOfString:PhoneStr withString:@""];
    self.contactNumbrTxt.text=[NSString stringWithFormat:@"%@",PhoneStr];
    }
    else{
         self.contactNumbrTxt.text=[NSString stringWithFormat:@"%@",PhoneCompleteStr];
    }
  
    self.countryTxt.text=[dataDict valueForKey:@"country"];
    self.addressZipTxt.text=[dataDict valueForKey:@"zip"];
    specialneedTxtView.text=[dataDict valueForKey:@"specialneedsnotes"];
    
    
    picUrl=[dataDict valueForKey:@"profilepiclocation"];
    if ([picUrl isEqualToString:@""]) {
        self.imageview.image = [UIImage imageNamed:@"upload-btn.png"];
    }
    else
    {
        
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        objactivityindicator.center = CGPointMake((self.imageview.frame.size.width/2),(self.imageview.frame.size.height/2));
        [self.imageview addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [self.imageview setImage:imgData];
                                   //  [UserImageDict setObject:imgData forKey:UrlString];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   //[self.imageview setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }
    

    iseditView=NO;
    registertionLbl.text=@"MY PROFILE";
    userFirstNameTxt.userInteractionEnabled=NO;
    userLastNameTxt.userInteractionEnabled=NO;
    passwordTxt.userInteractionEnabled=NO;
    confirmPasswrdTxt.userInteractionEnabled=NO;
    addressTxt.userInteractionEnabled=NO;
    cityTxt.userInteractionEnabled=NO;
    stateTxt.userInteractionEnabled=NO;
    contactNumbrTxt.userInteractionEnabled=NO;
    countryTxt.userInteractionEnabled=NO;
    addressZipTxt.userInteractionEnabled=NO;
    editDoneBtn.userInteractionEnabled=NO;
    animalNobtn.userInteractionEnabled=NO;
    animalYesBtn.userInteractionEnabled=NO;
    editDoneBtn.hidden=YES;
    self.editPhotoBtn.hidden=YES;
    self.editPhotoBtn.userInteractionEnabled=NO;
    self.handicapedYesBtn.userInteractionEnabled=NO;
    self.handicapedNoBtn.userInteractionEnabled=NO;
    self.selectCountryBtn.userInteractionEnabled=NO;
    specialneedTxtView.userInteractionEnabled=NO;
    flightNumTxt.userInteractionEnabled=NO;
    
    [self.editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
}
-(void)EnableView
{
    iseditView=YES;
    flightNumTxt.userInteractionEnabled=YES;

    specialneedTxtView.userInteractionEnabled=YES;
    self.selectCountryBtn.userInteractionEnabled=YES;
    animalNobtn.userInteractionEnabled=YES;
    animalYesBtn.userInteractionEnabled=YES;
    registertionLbl.text=@"EDIT ACCOUNT";
    userFirstNameTxt.userInteractionEnabled=YES;
    userLastNameTxt.userInteractionEnabled=YES;
    passwordTxt.userInteractionEnabled=YES;
    confirmPasswrdTxt.userInteractionEnabled=YES;
    addressTxt.userInteractionEnabled=YES;
    cityTxt.userInteractionEnabled=YES;
    stateTxt.userInteractionEnabled=YES;
    contactNumbrTxt.userInteractionEnabled=YES;
    countryTxt.userInteractionEnabled=YES;
    addressZipTxt.userInteractionEnabled=YES;
    editDoneBtn.userInteractionEnabled=YES;
    editDoneBtn.hidden=NO;
    self.editPhotoBtn.hidden=NO;
    self.editPhotoBtn.userInteractionEnabled=YES;
    self.editBtn.userInteractionEnabled=YES;
    self.editBtn.hidden=NO;
    self.handicapedYesBtn.userInteractionEnabled=YES;
    self.handicapedNoBtn.userInteractionEnabled=YES;
    [self.editBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
}


#pragma mark - TableView field Delegates and Datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [countriesArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor lightGrayColor];
    cell.textLabel.textColor=[UIColor blackColor];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||  ([[UIScreen mainScreen] bounds].size.height == 480)) {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:15];
        
        //this is iphone 5 xib
    }
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (countriesArray.count>0 ){
        cell.textLabel.text=[countriesArray objectAtIndex:indexPath.row];
    }
return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
        if ( countriesArray.count>0)
        {
            countryTxt.text=@"";
            countryTxt.text=[countriesArray objectAtIndex:indexPath.row];
        }
    countryListTable.hidden=YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25.0;
}



@end







