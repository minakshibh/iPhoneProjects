//
//  GratitudeArchieveViewController.m
//  SHEDs Plus
//
//  Created by Krishna_Mac_3 on 09/05/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "GratitudeArchieveViewController.h"
#import "Gratitude.h"
#import "AppDelegate.h"
#import "PageWebViewController.h"

@interface GratitudeArchieveViewController ()

@end

@implementation GratitudeArchieveViewController
@synthesize autoArchieve,keepArchieveHist,emailid,archieveTableView,isAutoArchieve,iskeepHistry,autoArchLbl,keepHistLbl,emailidTxt,autoArchArrow,keepHistArrow;

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
    NSUserDefaults *value = [NSUserDefaults standardUserDefaults];
    autoArchLbl.text=  [value valueForKey:@"autoArchieve"];
    keepHistLbl.text=  [value valueForKey:@"keepArchieveHisty"];
    emailidTxt.text = [value valueForKey:@"Emailid"];
    AutoArchArray=[NSArray arrayWithObjects:@"Off",@"10 days",@"20 days",@"30 days", nil];
    keepHistryArray=[NSArray arrayWithObjects:@"No History",@"10 days",@"20 days",@"30 days", nil];

    [[archieveTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[archieveTableView layer] setBorderWidth:1.0];
    [[archieveTableView layer] setCornerRadius:5];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [autoArchieve.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:15]];
        [keepArchieveHist.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:15]];
        [emailid.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:15]];
        
    }
    else{
        [autoArchieve.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        [keepArchieveHist.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        [emailid.titleLabel setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
    }
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//            action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
}


//-(void)dismissKeyboard
//{
//    archieveTableView.hidden=YES;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)autoArchieve:(id)sender
{
    [self.view endEditing:YES];
    if (archieveTableView.hidden==YES)
    {
        archieveTableView.hidden=NO;
    }
    else{
        archieveTableView.hidden=YES;
    }
    isAutoArchieve=YES;
    iskeepHistry=NO;
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        archieveTableView.frame=CGRectMake(150, 122,160, 140);
    }
    else{
        archieveTableView.frame=CGRectMake(508, 200,220, 212);
    }
    
    [archieveTableView reloadData];
}
- (IBAction)keepArchieveHistry:(id)sender
{
    [self.view endEditing:YES];

    if (archieveTableView.hidden==YES)
    {
        archieveTableView.hidden=NO;
    }
    else{
        archieveTableView.hidden=YES;
    }
   
    isAutoArchieve=NO;
    iskeepHistry=YES;
   
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        archieveTableView.frame=CGRectMake(150, 179, 160, 140);
    }
    else{
        archieveTableView.frame=CGRectMake(508, 286,220, 212);
    }
      [archieveTableView reloadData];
}
- (IBAction)Emailid:(id)sender
{
    self.archieveTableView.hidden=YES;
    isAutoArchieve=NO;
    iskeepHistry=NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return AutoArchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *gratimgup;
    cell.backgroundColor=[UIColor clearColor];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:17]];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(300, 18,7, 10)];
    }
    else{
        [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:30]];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(700, 35,16, 27)];
    }
   
    if (iskeepHistry) {
        cell.textLabel.text=[keepHistryArray objectAtIndex:indexPath.row];
    }
    else{
        cell.textLabel.text=[AutoArchArray objectAtIndex:indexPath.row];
    }
    gratimgup.image = [UIImage imageNamed:@"arrow.png"];
    [cell.contentView addSubview:gratimgup];
  
    //  cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    archieveTableView.hidden=YES;
    

    if (isAutoArchieve)
    {
        autoArchLbl.text=[AutoArchArray objectAtIndex:indexPath.row];
        autoArchArrow.hidden=YES;

    }
    else if(iskeepHistry)
    {
       keepHistLbl.text=[keepHistryArray objectAtIndex:indexPath.row];
        keepHistArrow.hidden=YES;
       
    }   
}

- (IBAction)hideTableBtn:(id)sender {
    archieveTableView.hidden=YES;
}


- (IBAction)DoneBtn:(id)sender {
    
    [self.view endEditing:YES];
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    
     NSString *tempStr = [emailidTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(![tempStr isEqualToString:@""] && [emailTest evaluateWithObject:emailidTxt.text] != YES)
    {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"SHEDs" message:@"Please enter valid user email address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [loginalert show];
    }
    else
    {
        NSDate *date1 = [NSDate date];
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        NSString*todaysDate = [formatter1 stringFromDate:date1];
        NSUserDefaults *value = [NSUserDefaults standardUserDefaults];
        
        [value removeObjectForKey:@"autoArchivDate"];
        [value setObject:[NSString stringWithFormat:@"%@",todaysDate] forKey:@"autoArchivDate"];
        [value removeObjectForKey:@"autoArchieve"];
        
        [value setObject:[NSString stringWithFormat:@"%@",autoArchLbl.text] forKey:@"autoArchieve"];
        NSLog(@"%@",autoArchLbl.text);
        [value removeObjectForKey:@"Emailid"];
        
        
        [value setObject:[NSString stringWithFormat:@"%@",keepHistLbl.text] forKey:@"keepArchieveHisty"];
        [value setObject:[NSString stringWithFormat:@"%@",tempStr] forKey:@"Emailid"];
        [[NSUserDefaults standardUserDefaults ]synchronize];
        
        self.archieveTableView.hidden=YES;
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Your gratitude archive setting saved successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert.tag=5;
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(alertView.tag==11 && buttonIndex==1 && [title isEqualToString:@"OK"])
    {
        
        
        UITextField *messageTxt = [alertView textFieldAtIndex:0];
        
        NSString *msgTxt=[NSString stringWithFormat:@"%@", messageTxt.text];
        
        if ([msgTxt isEqualToString:@""]) {
            UIAlertView *alrt =[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter your views.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alrt show];
        }else{
            
            AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.facebookConnect=YES;
            [appDelegate facebookIntegration:msgTxt  ];
            
        }
    }
   
      else  if (alertView.tag==5 && buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];

        }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    archieveTableView.hidden=YES;
}

- (IBAction)PostToFacebook:(id)sender {
    
    PageWebViewController *pageVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        pageVc=[[PageWebViewController alloc]initWithNibName:@"PageWebViewController" bundle:nil];
        
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        pageVc = [[PageWebViewController alloc]initWithNibName:@"PageWebViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        pageVc = [[PageWebViewController alloc]initWithNibName:@"PageWebViewController_ipad" bundle:nil];
        // this is ipad xib
    }
    
    
    [self.navigationController presentViewController:pageVc animated:YES completion:nil];
//    UIAlertView* dialog = [[UIAlertView alloc] init];
//    [dialog setDelegate:self];
//    [dialog setTitle:@"Share your views in SHEDs community..."];
//    [dialog setMessage:@" "];
//    [dialog addButtonWithTitle:@"Cancel"];
//    [dialog addButtonWithTitle:@"OK"];
//    dialog.tag = 11;
//    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [dialog textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
//    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
//    [dialog setTransform: moveUp];
//    [dialog show];
    
    //
    //    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    appDelegate.facebookConnect=YES;
    //    [appDelegate facebookIntegration];
}



@end
