//
//  registerViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/26/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "registerViewController.h"
#import "loginViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "RegisterVerificationViewController.h"

@interface registerViewController ()

@end

@implementation registerViewController
@synthesize role,trigger;

- (void)viewDidLoad {
    
    registerScroller.scrollEnabled = YES;
    registerScroller.delegate = self;
    registerScroller.contentSize = CGSizeMake(200, 460);
    registerScroller.backgroundColor=[UIColor clearColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:singleTap];
    
    registerBttn.layer.borderColor = [UIColor grayColor].CGColor;
    registerBttn.layer.borderWidth = 1.0;
    registerBttn.layer.cornerRadius = 4.0;
    [registerBttn setClipsToBounds:YES];
    
    registerBgLbl.layer.borderColor = [UIColor grayColor].CGColor;
    registerBgLbl.layer.borderWidth = 1.0;
    registerBgLbl.layer.cornerRadius = 4.0;
    [registerBgLbl setClipsToBounds:YES];
    
    if ([trigger isEqualToString:@"edit"])
    {
        backBttn.hidden=NO;
        [self fetchProfileInfoFromDatabase];
        [registerBttn setTitle:@"UPDATE" forState:UIControlStateNormal];
        alreadyAccountBtn.hidden=YES;
        loginHereBttn.hidden=YES;
        lineLbl.hidden=YES;
    }
    
    if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"view" ] isEqualToString:@"verifyView"])
    {
        backBttn.hidden=NO;
    }
    
   NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Login Here"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    
    [loginHereBttn setAttributedTitle:commentString forState:UIControlStateNormal];
    
    [loginHereBttn setTintColor:[UIColor colorWithRed:224.0f/255.0f green:15.0f/255.0f blue:70.0f/255.0f alpha:1.0f ]] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapDetected{
    [registerScroller setContentOffset:CGPointMake(0, 0) animated:YES];

    [self.view endEditing:YES];
}
- (IBAction)registerBtnAction:(id)sender
{
    
    [self.view endEditing:YES];
    [registerScroller setContentOffset:CGPointMake(0, 0) animated:YES];

    NSString* nameStr = [nameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* emailAddressStr = [emailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* passwordStr = [passwordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* confrmPassStr = [confirmPasswordTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* phoneNumStr = [phoneNumberTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
    
    
    
    
     if (nameStr.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
     else if (emailAddressStr.length==0)
     {
         UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Email Address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
         [alert show];
         return;
     }
    
   else  if (![self validateEmailWithString:emailAddressStr]==YES)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Check Your Email Address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [emailTxt becomeFirstResponder];
        return;
    }
   else if (phoneNumStr.length==0)
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter Phone Number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       [alert show];
       return;
   }
    

   else if (passwordStr.length==0)
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       [alert show];
       return;
   }
   else if (confrmPassStr.length==0)
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Please Enter password to confirm." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
       [alert show];
       return;
   }
    
    
    else if (![passwordStr isEqualToString:confrmPassStr])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:KalertTittle message:@"Password donot match." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [passwordTxt becomeFirstResponder];
        return;
        
    }
    [self UserRegistration:nameStr Emailid:emailAddressStr Password:passwordStr Contactnum:phoneNumStr];
}


-(void)UserRegistration:(NSString*)name Emailid:(NSString*)emailid Password:(NSString *)password Contactnum:(NSString *)contactnum
{
    [kappDelegate ShowIndicator];
    NSMutableURLRequest *request ;
    NSString*_postData ;
    
    if ([trigger isEqualToString:@"edit"])
    {
        webservice=2;
        _postData = [NSString stringWithFormat:@"name=%@&email=%@&password=%@&phone=%@&img=&user_id=%@",name,emailid,password,contactnum,[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/edit-profile.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }
    else{
        webservice=1;
        _postData = [NSString stringWithFormat:@"name=%@&email=%@&password=%@&phone=%@&role=%@",name,emailid,password,contactnum,role];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/register.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    }
    
    NSLog(@"data post >>> %@",_postData);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
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
    [kappDelegate HideIndicator];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    [kappDelegate HideIndicator];
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    if ([webData length]==0)
        return;
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableDictionary *userDetailDict=[json objectWithString:responseString error:&error];
    //  NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
    
    //  NSMutableDictionary *userDetailDicttemp=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        UIAlertView *alert;
        if (result ==1)
        {
            alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(result==0)
        {
            if (webservice==1)
            {
              
                NSString*userId=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"user_id"]];
                [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userid"];
                
                NSString *verificationCode = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"verification_code"]];
                
                
                NSString *messageStr = [NSString stringWithFormat:@"Your Registeration is Successful. And your verification code is %@",verificationCode];
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:messageStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=2;
                [alert show];
                
            }
            else if (webservice==2)
            {
              
                [self FetchBasicProfile];
            }
            else if (webservice==3)
            {
                [kappDelegate HideIndicator];
                
                NSString*userName=[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"name"]];
                [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"userName"];
                
                [self saveDataTodtaaBase:userDetailDict];
                
                
                UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Your Profile updated Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag=3;
                [alert show];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 3)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 2){
        RegisterVerificationViewController *registrVerifyVc=[[RegisterVerificationViewController alloc]initWithNibName:@"RegisterVerificationViewController" bundle:nil];
        [self.navigationController pushViewController:registrVerifyVc animated:YES];
    }
}


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)loginHereBtnAction:(id)sender {
    loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [registerScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = registerScroller.contentOffset;
    
    if (IS_IPHONE_4_OR_LESS)
    {
        if ( textField == emailTxt|| textField == passwordTxt || textField == phoneNumberTxt || textField == confirmPasswordTxt) {
            
            CGPoint pt;
            CGRect rc = [textField bounds];
            rc = [textField convertRect:rc toView:registerScroller];
            pt = rc.origin;
            pt.x = 0;
            
            
            pt.y -=98;
            [registerScroller setContentOffset:pt animated:YES];
        }

    }
    else
    if (textField == emailTxt|| textField == passwordTxt || textField == phoneNumberTxt || textField == confirmPasswordTxt) {
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:registerScroller];
        pt = rc.origin;
        pt.x = 0;
        
        
        pt.y -=130;
        [registerScroller setContentOffset:pt animated:YES];
    }
}
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void) fetchProfileInfoFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM userProfile where userId=\"%@\" ",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        nameTxt.text =[results stringForColumn:@"name"];
        emailTxt.text =[results stringForColumn:@"email"];
        passwordTxt.text =[results stringForColumn:@"password"];
        confirmPasswordTxt.text =[results stringForColumn:@"password"];
        phoneNumberTxt.text =[results stringForColumn:@"contact"];
        imageUrlStr=[results stringForColumn:@"image"];
        creditCardNumbrStr=[results stringForColumn:@"creditCardNumber"];
    }
    [database close];
}

-(void) saveDataTodtaaBase :(NSDictionary*)userDetailDict
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"userid"];
    
    NSString* updateSQL = [NSString stringWithFormat:@"UPDATE userProfile SET  name = \"%@\", email = \"%@\", password =\"%@\", role = \"%@\" ,contact = \"%@\" ,image =\"%@\", creditCardNumber = \"%@\"  where userId = %@" ,[userDetailDict valueForKey:@"name"],[userDetailDict valueForKey:@"email"],[userDetailDict valueForKey:@"password"],[userDetailDict valueForKey:@"role"],[userDetailDict valueForKey:@"contact_info"],[userDetailDict valueForKey:@"imageUrl"],[userDetailDict valueForKey:@"CreditCardNumber"],userId ];

    [database executeUpdate:updateSQL];
    
    [database close];
}

-(void) FetchBasicProfile
{
    webservice=3;
    NSString*_postData = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]];
    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/getbasicdetail.php",Kwebservices]] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    NSLog(@"data post >>> %@",_postData);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [_postData dataUsingEncoding:NSUTF8StringEncoding]];
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
@end
