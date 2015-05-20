//
//  AddcardViewController.m
//  RapidRide
//
//  Created by Br@R on 19/12/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "AddcardViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJSON.h"
#import "JSON.h"

#import "RideFinishViewController.h"
@interface AddcardViewController ()

@end

@implementation AddcardViewController
@synthesize cZipCodeTxt,creditSecurityTxt,creditOnfoAddedBtn,creditCardNumbrTxt,creditCancelBtn,creditBackView,cExpDateTxt,viewPickr,activityIndicatorObject,disablImg;


- (void)viewDidLoad
{
    [super viewDidLoad];    
    creditBackView.layer.borderColor = [UIColor whiteColor].CGColor;
    creditBackView.layer.borderWidth = 1.5;
    creditBackView.layer.cornerRadius = 5.0;
    [creditBackView setClipsToBounds:YES];
    [creditOnfoAddedBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:21]];
    [creditCancelBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:21]];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];

    [self addPickerView];
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        activityIndicatorObject.center = CGPointMake(160, 190);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor grayColor];
    [self.disablImg addSubview:activityIndicatorObject];
    
    // Do any additional setup after loading the view from its nib.
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
    // viewPickr.backgroundColor=[UIColor grayColor];
    [myPickerView selectRow:6 inComponent:1 animated:YES];
    [myPickerView selectRow:[monthStr intValue]-1  inComponent:0 animated:YES];
    
    //[myPickerView selectRow:[currentDateComponents month]-1 inComponent:0 animated:YES];
    [self.viewPickr addSubview:myPickerView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    uCreditCardNumStr=@"";
    [self.view endEditing:YES];
    self.view.userInteractionEnabled=YES;
    self.creditCardNumbrTxt.text=@"";
    self.creditSecurityTxt.text=@"";
    self.cZipCodeTxt.text=@"";
    self.creditSecurityTxt.text=@"";
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)CreditInfoAddedBtn:(id)sender {
    [self.view endEditing:YES];
    // [scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    
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
        self.view.userInteractionEnabled=NO;
        [activityIndicatorObject startAnimating];
        self.disablImg.hidden=NO;
        
        
        NSString *riderIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"];
        
       NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://appba.riderapid.com/c_verify/?c_info=%@&e_info=%@&riderid=%@&z_info=%@&s_info=%@",uCreditCardNumStr,uCreditExpStr,riderIdStr,uCreditZipStr,uCreditSecuritytr]];
        
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


-(void)dismissKeyboard
{
   
    [self.view endEditing:YES];
}





#pragma mark - Text field Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    viewPickr.hidden=YES;
    
    
    if (textField== creditCardNumbrTxt || textField == cZipCodeTxt ||creditSecurityTxt ) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:tap];
    }
    
    if([[UIScreen mainScreen] bounds].size.height == 480)
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


#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    disablImg.hidden=YES;
    
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
    disablImg.hidden=YES;
    
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    
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
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            UIAlertView *alert;
            if (result ==1)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=2;
            }
            else if(result ==0)
            {
                
              //  [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"payment_status"];
                alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag=1;
            }
            [alert show];
        }
        self.creditSecurityTxt.text=@"";
        self.creditCardNumbrTxt.text=@"";
        self.cZipCodeTxt.text=@"";
        self.cExpDateTxt.text=@"";
    
    [self.navigationController popViewControllerAnimated:YES];
}





@end
