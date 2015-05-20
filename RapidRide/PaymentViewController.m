//
//  PaymentViewController.m
//  RapidRide
//
//  Created by Br@R on 17/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "PaymentViewController.h"
#import "MapViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "JSON.h"
#import "Base64.h"
@interface PaymentViewController ()

@end

@implementation PaymentViewController
@synthesize scrollView,creditCardNumbrTxt,cExpDateTxt,creditHeadrLbl,cZipCodeTxt,promocodeHeadrLbl,promocodeTxt,paymentBtn,paymentHeadrLbl,applyPromocodeBtn,headerLbl,viewPickr,headerView,activityIndicatorObject,disableImg,promocodeBackView,creditBackView,addCreditCardBtn,addCreditInfoView,creditCancelBtn,creditOnfoAddedBtn,creditLBL,promocodeListHeaderLbl,promocodeTableView,creditSecurityTxt,creditCardTableview,tripid,rec_id,tip_amount,suggested_fare,selectCardTableView;


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

    if (tripid.length ==0)
    {
        paymentBtn.hidden=YES;
    }
    else{
        paymentBtn.hidden=NO;
    }
    [super viewDidLoad];
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    dataDict=[[NSMutableDictionary alloc]init];
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    NSArray*promoArrayTemp=[dataDict valueForKey:@"ListPromoCodeInfo"];
    NSArray*creditCardsArrayTemp=[dataDict valueForKey:@"ListCreditCardInfo"];
    
    creditCardsDict=[[NSMutableDictionary alloc]init];
    promocodeDict=[[NSMutableDictionary alloc]init];
    promocodeArray =[[NSMutableArray alloc]init];
    creditCardsNumArray =[[NSMutableArray alloc]init];
     promocodeValueArray=[[NSMutableArray alloc]init];

    userIdStr=[dataDict valueForKey:@"userid"];
    for (int i=0;i<promoArrayTemp.count; i++)
    {
        promocodeDict=[promoArrayTemp objectAtIndex:i];
        [promocodeArray addObject:[NSString stringWithFormat:@"%@ ($%@)",[promocodeDict valueForKey:@"promocode"],[promocodeDict valueForKey:@"value"]]];
        [promocodeValueArray addObject:[promocodeDict valueForKey:@"value"]];
    }
    
    [self.promocodeTableView reloadData];
    
    promocodeBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    promocodeBackView.layer.borderWidth = 1.5;
    promocodeBackView.layer.cornerRadius = 5.0;
    [promocodeBackView setClipsToBounds:YES];
    
    creditCardTableview.layer.borderColor = [UIColor whiteColor].CGColor;
    creditCardTableview.layer.borderWidth = 1.5;
    creditCardTableview.layer.cornerRadius = 5.0;
    [creditCardTableview setClipsToBounds:YES];
    
    creditBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    creditBackView.layer.borderWidth = 1.5;
    creditBackView.layer.cornerRadius = 5.0;
    [creditBackView setClipsToBounds:YES];
   
    
    promocodeTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    promocodeTableView.layer.borderWidth = 1.5;
    promocodeTableView.layer.cornerRadius = 5.0;
    [promocodeTableView setClipsToBounds:YES];

    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [addCreditInfoView setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    
    
    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [paymentHeadrLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:23]];
    [promocodeListHeaderLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];

    [promocodeHeadrLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [creditHeadrLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [applyPromocodeBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    [addCreditCardBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:23]];
    [creditLBL setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [paymentBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [creditOnfoAddedBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:21]];
    [creditCancelBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:21]];

    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        scrollView.contentSize = CGSizeMake(320, 600);
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
    activityIndicatorObject.color=[UIColor grayColor];
    [self.view addSubview:activityIndicatorObject];

    [self addPickerView];
    [self fetchCardsList];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)fetchCardsList
{
    [activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=YES;

    disableImg.hidden=NO;
    webService=3;
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://appba.riderapid.com/avail_cards/?riderid=%@",userIdStr]];
    
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
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addPickerView
{
    monthsArray=[[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    yearsArray=[[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM"];
    monthStr=[dateFormatter1 stringFromDate:now];
    
    yearString = [dateFormatter stringFromDate:now];
    yearStr=[yearString substringFromIndex:[yearString length]-2];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 52,250, 160)];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 62,250, 170)];
        // this is iphone 4 xib
    }
    else
    {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 82,650, 270)];
    }
    
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [myPickerView selectRow:6 inComponent:1 animated:YES];
    [myPickerView selectRow:[monthStr intValue]-1  inComponent:0 animated:YES];
    
    [self.viewPickr addSubview:myPickerView];
    
}

- (IBAction)cExpDateBtn:(id)sender {
    [self.view endEditing:YES];
    yearsArray=[[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    yearString = [dateFormatter stringFromDate:now];
    yearStr=[yearString substringFromIndex:[yearString length]-2];
    int year=[yearString intValue];
    yearString=[NSMutableString stringWithFormat:@"%d",year];
    
    for (int i=0; i<11; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"%d",[yearString intValue]+i]];
    }
    [self.view endEditing:YES];
    viewPickr.hidden=NO;
    [myPickerView reloadAllComponents];
    [myPickerView selectRow:0 inComponent:1 animated:YES];
}


- (IBAction)applyBtn:(id)sender {
    
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

    [self.view endEditing:YES];
    
    NSString* promocodeStr = [promocodeTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if ([promocodeStr isEqualToString:@""])
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the promocode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        self.view.userInteractionEnabled=NO;
        [activityIndicatorObject startAnimating];
        disableImg.hidden=NO;

        webService=1;
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString*dateStr=[dateFormatter stringFromDate:now];
        NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:promocodeStr,@"PromoCode",dateStr,@"CurrentDate",userIdStr,@"riderId",nil];
        
        NSString *jsonRequest = [jsonDict JSONRepresentation];
        
        NSLog(@"jsonRequest is %@", jsonRequest);
        
        NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/ValidatePromoCode",Kwebservices]];
        
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
    disableImg.hidden=YES;
    
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
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
    disableImg.hidden=YES;
    
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;

    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;

    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];

    SBJsonParser *json = [[SBJsonParser alloc] init];
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
   
    if (webService==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            
            NSArray *promocodeInfo=[userDetailDict valueForKey:@"ListPromoCodeInfo"];
            if (promocodeInfo.count>0)
            {
                NSMutableDictionary *promocodeDict=[[NSMutableDictionary alloc]init];
                promocodeValueArray=[[NSMutableArray alloc]init];
                for (int j=0;j<promocodeInfo.count; j++)
                {
                    promocodeDict=[promocodeInfo objectAtIndex:0];

                    if (![promocodeArray containsObject:[promocodeDict valueForKey:@"promoname"]]) {
                         [promocodeArray addObject:[NSString stringWithFormat:@"%@ ($%@)",[promocodeDict valueForKey:@"promoname"],[promocodeDict valueForKey:@"value"]]];
                       
                        [promocodeValueArray addObject:[promocodeDict valueForKey:@"value"]];
                    }
                }
            }
            
            UIAlertView *alert;
            
            if (result ==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=2;
            }
            else if (result ==0)
            {
               promocodeTxt.text=@"";
                NSArray *promocodeInfo=[userDetailDict valueForKey:@"ListPromoCodeInfo"];
                
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=1;
            }
            [self.promocodeTableView reloadData];
            [alert show];
        }

    }
    else if(webService==2)
    {
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
            else if(result ==0)
            {
                
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"payment_status"];
                

                 [self fetchCardsList];
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=1;
            }
            [alert show];
        }
        self.refreshbtn.hidden=NO;
        addCreditInfoView.hidden=YES;
        [self.promocodeTableView reloadData];
        self.creditSecurityTxt.text=@"";
        self.creditCardNumbrTxt.text=@"";
        self.cZipCodeTxt.text=@"";
        self.cExpDateTxt.text=@"";
       
        [self.promocodeTableView reloadData];
    }
    else if (webService==3)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
           int result=[[userDetailDict valueForKey:@"result" ]intValue];
            
            if(result ==0)
            {
                NSArray* tempArray ;
                creditCardsNumArray =[[NSMutableArray alloc]init];
                if (![messageStr isEqualToString:@""]) {
                    tempArray = [messageStr componentsSeparatedByString: @","];
                }
                if (tempArray.count>0) {
                    for (int j =0; j<tempArray.count; j++)
                    {
                        if (![[tempArray objectAtIndex:j]isEqualToString:@""])
                        {
                            [creditCardsNumArray addObject:[NSString stringWithFormat:@"%@", [tempArray objectAtIndex: j]]];
                            rec_id=[creditCardsNumArray objectAtIndex:0];
                            rec_id=[rec_id substringFromIndex:5];
                        }
                    }
                }
            }
        }
       
        if (creditCardsNumArray.count==0)
        {
            [creditCardsNumArray addObject:[NSString stringWithFormat:@"None" ]];
            
        }
        [self.creditCardTableview reloadData];
    }
    else if (webService==4)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
           paymentResult=[[userDetailDict valueForKey:@"result" ]intValue];
            

            self.selectCardBackView.hidden=YES;;
             [self launchDialog:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]]];
            
            if(paymentResult ==0)
            {
            }
        }
    }
}


- (void)launchDialog:(NSString*)messagetext
{
    // Here we need to pass a full frame
    alertViewCustom = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertViewCustom setContainerView:[self createDemoView:messagetext]];
    
    // Modify the parameters
    [alertViewCustom setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",nil]];
    [alertViewCustom setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertViewCustom setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertViewCustom close];
    }];
    
    [alertViewCustom setUseMotionEffects:true];
    
    // And launch the dialog
    [alertViewCustom show];
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if(paymentResult ==1)
    {
        MapViewController*mapVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }

        [self.navigationController pushViewController:mapVc  animated:NO];
    }
    [alertView close];
}

- (UIView *)createDemoView:(NSString*)message1
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
    [demoView setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    demoView.layer.borderColor = [UIColor clearColor].CGColor;
    demoView.layer.borderWidth = 1.5;
    demoView.layer.cornerRadius = 6.0;
    [demoView setClipsToBounds:YES];
    
    UILabel*messageLbl=[[UILabel alloc] initWithFrame:CGRectMake(8, 8, 270, 100)];
    messageLbl.numberOfLines=3;
    messageLbl.text=message1;
    [demoView addSubview:messageLbl];
    messageLbl.textColor=[UIColor whiteColor];
    
    [messageLbl setBackgroundColor: [UIColor clearColor]];
    messageLbl.textAlignment = NSTextAlignmentCenter;
    [meassageLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];

    [demoView addSubview:messageLbl];
    
    return demoView;
}





- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    if (alertView.tag==6)
    {
        MapViewController*mapVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }

        [self.navigationController pushViewController:mapVc  animated:NO];
    }
}

- (IBAction)paymentBtn:(id)sender {
    
    
    self.selectCardBackView.hidden=NO;
    [selectCardTableView reloadData];
}

- (IBAction)refreshBtn:(id)sender {
      [self fetchCardsList];
}

- (IBAction)addCreditCardBtn:(id)sender {
      addCreditInfoView.hidden=NO;
    self.refreshbtn.hidden=YES;

}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Text field Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    viewPickr.hidden=YES;
    
    if (textField==promocodeTxt)
    {
        [scrollView setContentOffset:CGPointMake(0.0, 90) animated:YES];
    }
    else{
        [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }
       if (textField== creditCardNumbrTxt || textField == cZipCodeTxt ||creditSecurityTxt ) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    }
    
        if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            if (textField ==creditSecurityTxt || textField==cZipCodeTxt)
            {
                [addCreditInfoView setFrame:CGRectMake(addCreditInfoView.frame.origin.x, 70, addCreditInfoView.frame.size.width, addCreditInfoView.frame.size.height)];
            }
            else{
                [addCreditInfoView setFrame:CGRectMake(addCreditInfoView.frame.origin.x, 138, addCreditInfoView.frame.size.width, addCreditInfoView.frame.size.height)];
            }
        }
    return  YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

    [textField resignFirstResponder];
      return  YES;
}


- (IBAction)expDoneBtn:(id)sender {
    monthYearStr=[NSString stringWithFormat:@"%@%@",monthStr,yearStr];
    NSLog(@"%@",monthYearStr);
    cExpDateTxt.text=monthYearStr;
    viewPickr.hidden=YES;
}

- (IBAction)expCancelBtn:(id)sender {
    viewPickr.hidden=YES;

}

- (IBAction)creditCancelBtn:(id)sender {
    [addCreditInfoView setFrame:CGRectMake(addCreditInfoView.frame.origin.x, 138, addCreditInfoView.frame.size.width, addCreditInfoView.frame.size.height)];

    uCreditCardNumStr=@"";
     [self.view endEditing:YES];
    addCreditInfoView.hidden=YES;
    self.refreshbtn.hidden=NO;
    self.view.userInteractionEnabled=YES;

    self.creditCardNumbrTxt.text=@"";
    self.creditSecurityTxt.text=@"";
    self.cZipCodeTxt.text=@"";
    self.creditSecurityTxt.text=@"";
    
}


- (IBAction)CreditInfoAddedBtn:(id)sender {
    [addCreditInfoView setFrame:CGRectMake(addCreditInfoView.frame.origin.x, 138, addCreditInfoView.frame.size.width, addCreditInfoView.frame.size.height)];
    [self.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    uCreditCardNumStr = [creditCardNumbrTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString*uCreditExpStr = [cExpDateTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString*uCreditSecuritytr = [creditSecurityTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString*uCreditZipStr = [cZipCodeTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([uCreditCardNumStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the credit card number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([uCreditExpStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the credit expire date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([uCreditSecuritytr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the security code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

    else if([uCreditZipStr isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Enter the credit zip." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        webService=2;
        self.view.userInteractionEnabled=NO;
        [activityIndicatorObject startAnimating];
        disableImg.hidden=NO;
        

        
        
        NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://appba.riderapid.com/c_verify/?c_info=%@&e_info=%@&riderid=%@&z_info=%@&s_info=%@",uCreditCardNumStr,uCreditExpStr,userIdStr,uCreditZipStr,uCreditSecuritytr]];
        
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
    }
}


-(void)dismissKeyboard
{
     [addCreditInfoView setFrame:CGRectMake(addCreditInfoView.frame.origin.x, 138, addCreditInfoView.frame.size.width, addCreditInfoView.frame.size.height)];
    [self.view endEditing:YES];
}



#pragma mark- Picker View Delegates and Data sources


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    if (component==0)
    {
        rowsInComponent=[monthsArray count];
    }
    else
    {
        rowsInComponent=[yearsArray count];
    }
    return rowsInComponent;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component==0) {
        NSLog(@"[currentDateComponents month]-->%ld<--",(long)[currentDateComponents month]);
        NSLog(@"%@",[monthsArray objectAtIndex: row]);
        monthStr= [NSString stringWithFormat:@"%d",row+1];
        NSLog(@"-->%d<--",row+1);
        NSLog(@"-->%@<--",[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]);
        yearStr=[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]];
        NSLog(@"%lu",(unsigned long)[monthStr length]);
        if ( [monthStr length]<2) {
            monthStr =[NSString stringWithFormat:@"0%@",monthStr];
        }
    }
    else{
        NSLog(@"-->%@<--",[monthsArray objectAtIndex:[pickerView selectedRowInComponent:0]]);
        // monthStr=[monthsArray objectAtIndex:[pickerView selectedRowInComponent:1]];
        NSLog(@"%ld",(long)row);
        yearStr=[yearsArray objectAtIndex: row];
        
        NSLog(@"%@",[yearsArray objectAtIndex:row]);
    }
    
    yearStr=[yearStr substringFromIndex:[yearStr length]-2];
    
    //    NSLog(@"[currentDateComponents month]-->%d<--",[currentDateComponents month]);
    //    NSLog(@"-->%d<--",row);
    //    NSLog(@"row->%@<--",[yearsArray objectAtIndex:row]);
    NSLog(@"-->%@<--",[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]);
    //    NSLog(@"%@",[monthsArray objectAtIndex: row]);
    
    if ([pickerView selectedRowInComponent:0]+1<[currentDateComponents month] && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
    {
        [pickerView selectRow:[currentDateComponents month]-1 inComponent:0 animated:YES];
        
        NSLog(@"Need to shift");
    }
    if (component==1) {
        [myPickerView reloadAllComponents];
        [myPickerView reloadComponent:0];
    }
    if (component==0) {
        [myPickerView reloadAllComponents];
        [myPickerView reloadComponent:1];
    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label.text = component==0?[monthsArray objectAtIndex:row]:[yearsArray objectAtIndex:row];
    
    if (component==0)
    {
        if (row+1<[currentDateComponents month] && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
        {
            label.textColor = [UIColor grayColor];
        }
    }
    return label;
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth ;
    
    if (component==0)
    {
        componentWidth = 80;
    }
    else  {
        componentWidth = 80;
    }
    
    return componentWidth;
}




#pragma mark - TableView field Delegates and Datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==promocodeTableView)
    {
        if (promocodeArray.count<=4)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                promocodeTableView.frame = CGRectMake(12, 337,296, promocodeArray.count*30);
            }
            else if ([[UIScreen mainScreen] bounds].size.height ==480) {
                promocodeTableView.frame = CGRectMake(12, 337,296, promocodeArray.count*30);
                
            }
        }
        else{
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                promocodeTableView.frame = CGRectMake(12, 337,296, 150);
            }
            else if ([[UIScreen mainScreen] bounds].size.height ==480) {
                promocodeTableView.frame = CGRectMake(12, 337,296, 150);
            }
        }
        return [promocodeArray count];
    }
    if (tableView==creditCardTableview){
        if (creditCardsNumArray.count<=2)
        {
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                creditCardTableview.frame = CGRectMake(12, 40,280, creditCardsNumArray.count*30);
            }
            else if ([[UIScreen mainScreen] bounds].size.height ==480) {
                creditCardTableview.frame = CGRectMake(12, 40,280, creditCardsNumArray.count*30);
            }
        }
        else{
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                creditCardTableview.frame = CGRectMake(12, 40,280, 60);
            }
            else if ([[UIScreen mainScreen] bounds].size.height ==480) {
                creditCardTableview.frame = CGRectMake(12, 40,280, 60);
            }
        }
        return [creditCardsNumArray count];
    }
    if (tableView==selectCardTableView){
        return [creditCardsNumArray count];
    }

    return YES;
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
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:13];
        //this is iphone 5 xib
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:30];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    
    
    if (tableView==promocodeTableView)
    {
        if (promocodeArray.count>0)
        {
            cell.textLabel.text=[promocodeArray objectAtIndex:indexPath.row];
        }
    }
     if (tableView==creditCardTableview)
     {
        if (creditCardsNumArray.count>0)
        {
            
          
          //  cell.textLabel.text=[creditCardsNumArray objectAtIndex:indexPath.row];
            
            NSString *subStr =[creditCardsNumArray objectAtIndex:indexPath.row];
            if (![subStr isEqualToString:@"None"]){
                subStr=[subStr substringWithRange:NSMakeRange(0, 4)];
                cell.textLabel.text=[NSString stringWithFormat:@"*%@",subStr];

            }
        
            cell.textLabel.text=[NSString stringWithFormat:@"%@",subStr];
            
            cell.imageView.image=[UIImage imageNamed:@"visa.png"];
        }
        else
        {
            cell.textLabel.text=@"None";
        }
    }
    if (tableView==selectCardTableView)
    {
         cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:15];
        if (creditCardsNumArray.count>0)
        {
            
            NSString *subStr =[creditCardsNumArray objectAtIndex:indexPath.row];
            if (![subStr isEqualToString:@"None"]){
                subStr=[subStr substringWithRange:NSMakeRange(0, 4)];
                cell.textLabel.text=[NSString stringWithFormat:@"*%@",subStr];
                
            }
            
            cell.textLabel.text=[NSString stringWithFormat:@"%@",subStr];
            
            cell.imageView.image=[UIImage imageNamed:@"visa.png"];
        }
        else
        {
            cell.textLabel.text=@"None";
        }
        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}


- (IBAction)PayNowBtn:(id)sender {
    {
        [self.view endEditing:YES];
        [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        if([rec_id isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Add the credit card for payment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            webService=4;
            self.view.userInteractionEnabled=NO;
            [activityIndicatorObject startAnimating];
            disableImg.hidden=NO;
            
            tripid = [tripid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://appba.riderapid.com/process/?tripid=%@&rec_id=%@&riderid=%@&tip_amount=%@&suggested_fare=%@",tripid,rec_id,userIdStr,tip_amount,suggested_fare]];
            
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
            
            NSLog(@"Request:%@",urlString);
            
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            // [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
            
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
}
@end
