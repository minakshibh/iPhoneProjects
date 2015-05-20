//
//  AllBookingsViewController.m
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "DashboardViewController.h"
#import "GreetingsViewController.h"
#import "AllBookingsViewController.h"
#import "MarketingViewController.h"
#import "ReportingViewController.h"
#import "SettingsViewController.h"
#import "PaymentViewController.h"
#import "manageRestaurantViewController.h"
#import "AddBookingViewController.h"
#import "AllBookingsTableViewCell.h"
#import "calendarViewController.h"
#import "GreetingsViewController.h"
#include "JSON.h"
#include "ASIHTTPRequest.h"
#include "SBJson.h"
#include "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
@interface AllBookingsViewController ()

@end

@implementation AllBookingsViewController

- (void)viewDidLoad {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    bookingTitle.layer.borderColor = [UIColor clearColor].CGColor;
    bookingTitle.layer.borderWidth = 1.5;
    bookingTitle.layer.cornerRadius =20.0;
    [bookingTitle setClipsToBounds:YES];
    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"All booking" delegate:self];
    self.navigationController.navigationBarHidden=YES;
    bookingTitle.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    dateHeaderLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    timeHeaderLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    customerNameHeaderLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    partySizeHeaderLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    tableNumberHeaderLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    allBookingsBtn.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    allBookingsBtn.layer.borderWidth = 1.5;
    allBookingsBtn.layer.cornerRadius = 15.0;
    [allBookingsBtn setClipsToBounds:YES];
    bookingType = @"All";
    pastBookings.layer.borderColor = [UIColor clearColor].CGColor;
    pastBookings.layer.borderWidth = 1.5;
    pastBookings.layer.cornerRadius = 15.0;
    [pastBookings setClipsToBounds:YES];
    
    futureBookingsBtn.layer.borderColor = [UIColor clearColor].CGColor;
    futureBookingsBtn.layer.borderWidth = 1.5;
    futureBookingsBtn.layer.cornerRadius = 15.0;
    [allBookingsBtn setClipsToBounds:YES];
    
    [self fetchbooking];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    // get pointer to app delegate, which contains property for menu pointer
    
    
    Leftsideview = [[LeftSideBarView alloc] initWithFrame:CGRectMake(0, 90, 300,self.view.frame.size.height-90) fontName:@"Helvetica" delegate:self];
    
    [self.view addSubview: Leftsideview];
    Leftsideview.hidden=YES;

    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95
                                                               ) HeaderName:@"All booking" delegate:self];
    
    [self.view addSubview: upparView];
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [bookingsListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    AllBookingsTableViewCell *cell = (AllBookingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AllBookingsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    allBookingsListObj = [bookingsListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:allBookingsListObj.date:allBookingsListObj.time :allBookingsListObj.customername :allBookingsListObj.partySize :allBookingsListObj.tableNumbr];
    
    
    /////// CALL BUTTON //////////
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [modifyBtn setTitle: @"MODIFY" forState: UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    modifyBtn.frame = CGRectMake(655.0f, 8.0f,80.0f,22.0f);
    modifyBtn.tag = indexPath.row;
  //  modifyBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:10.0f];
    [modifyBtn setTintColor:[UIColor whiteColor]] ;
    [modifyBtn addTarget:self action:@selector(modifyActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"VIEW"];
    [modifyBtn setBackgroundColor:[UIColor orangeColor]];
    [modifyBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    modifyBtn.layer.borderColor = [UIColor clearColor].CGColor;
    modifyBtn.layer.borderWidth = 1.5;
    modifyBtn.layer.cornerRadius = 5.0;
    [modifyBtn setClipsToBounds:YES];
    [cell.contentView addSubview:modifyBtn];
    
    
    UIButton *noshowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [noshowBtn setTitle: @"NO SHOW" forState: UIControlStateNormal];
    noshowBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    noshowBtn.frame = CGRectMake(740.0f, 8.0f,80.0f,22.0f);
    noshowBtn.tag = indexPath.row;
 //   noshowBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:10.0f];
    
    [noshowBtn setTintColor:[UIColor whiteColor]] ;
    [noshowBtn addTarget:self action:@selector(noshowBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackground= [UIImage imageNamed:@"VIEW"];
    [noshowBtn setBackgroundColor:[UIColor darkGrayColor]];
    [noshowBtn setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    noshowBtn.layer.borderColor = [UIColor clearColor].CGColor;
    noshowBtn.layer.borderWidth = 1.5;
    noshowBtn.layer.cornerRadius = 5.0;
    [noshowBtn setClipsToBounds:YES];
    [cell.contentView addSubview:noshowBtn];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelBtn setTitle: @"CANCEL" forState: UIControlStateNormal];
    cancelBtn.frame = CGRectMake(825.0f, 8.0f,80.0f,22.0f);
    cancelBtn.tag = indexPath.row;
   cancelBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    [cancelBtn setTintColor:[UIColor whiteColor]] ;
    [cancelBtn addTarget:self action:@selector(cancelBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundbtn= [UIImage imageNamed:@"VIEW"];
    [cancelBtn setBackgroundColor:[UIColor redColor]];
    [cancelBtn setBackgroundImage:buttonBackgroundbtn forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = [UIColor clearColor].CGColor;
    cancelBtn.layer.borderWidth = 1.5;
    cancelBtn.layer.cornerRadius = 5.0;
    [cancelBtn setClipsToBounds:YES];
    [cell.contentView addSubview:cancelBtn];
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    AllBookings*allBookingObj= (AllBookings *)[bookingsListArray objectAtIndex:indexPath.row];
}




- (IBAction)modifyActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    AllBookings*allBookingObj= (AllBookings *)[bookingsListArray objectAtIndex:indexPath.row];
}

- (IBAction)noshowBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    AllBookings*allBookingObj= (AllBookings *)[bookingsListArray objectAtIndex:indexPath.row];
}

- (IBAction)cancelBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    AllBookings*allBookingObj= (AllBookings *)[bookingsListArray objectAtIndex:indexPath.row];
}



- (void)mainMenuBtnPressed{
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
    NSLog(@"dashboard preesed");
}
- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:addBookingVC animated:NO];
    
    NSLog(@"addBookingBtn Pressed ");
    
}
-(void)feedbackViewBtnPressed{
    GreetingsViewController *calendarVC=[[GreetingsViewController alloc]initWithNibName:@"GreetingsViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:calendarVC animated:NO];
    NSLog(@"calendarViewController Pressed ");
    
}
-(void) fetchbooking
{
     [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Client Id"]];
    NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
    NSString *showPastData, *showUpcoming;
    NSString *datePass = @"";
    if ([bookingType isEqualToString:@"Past"]) {
        showPastData = [NSString stringWithFormat:@"true"];
        showUpcoming = [NSString stringWithFormat:@"false"];
    }else if ([bookingType isEqualToString:@"Future"]){
        showPastData = [NSString stringWithFormat:@"false"];
        showUpcoming = [NSString stringWithFormat:@"true"];
    }else if ([bookingType isEqualToString:@"All"]){
        showPastData = [NSString stringWithFormat:@"false"];
        showUpcoming = [NSString stringWithFormat:@"false"];
    }
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:clientId,@"clientId",listDataIdStr,@"listDataId",datePass,@"date",showPastData,@"showPast",showUpcoming,@"showUpcoming",@"",@"day",@"",@"refType",@"",@"groupId", nil];
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString;
    NSLog(@"Booking type .... %@",bookingType);
    
    urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetDashBoardBookingsDetails"];
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
#pragma mark -Json Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    //[activityIndicator stopAnimating];
    [self.view setUserInteractionEnabled:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Internet connection seems to be down. Application might not work properly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
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
    bookingsListArray = [[NSMutableArray alloc] init];
    
    
        for (int i = 0; i < [userDetailDict count]; i++) {
            allBookingsListObj = [[AllBookings alloc] init];
            NSString *firstName = [NSString stringWithFormat:@"%@",[[userDetailDict valueForKey:@"FirstName"] objectAtIndex:i]];
            NSString *lastName = [NSString stringWithFormat:@"%@",[[userDetailDict valueForKey:@"LastName"] objectAtIndex:i]];
            allBookingsListObj.customername = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
            allBookingsListObj.date = [[userDetailDict valueForKey:@"DateOfBooking"]objectAtIndex:i];
            NSString *startTime = [NSString stringWithFormat:@"%@",[[userDetailDict valueForKey:@"TimeSlotFrom"] objectAtIndex:i]];
            NSString *endTime = [NSString stringWithFormat:@"%@",[[userDetailDict valueForKey:@"TimeSlotTo"] objectAtIndex:i]];
            allBookingsListObj.time = [NSString stringWithFormat:@"%@ - %@",startTime,endTime];
            allBookingsListObj.partySize = [[userDetailDict valueForKey:@"NoOfGuests"]objectAtIndex:i];
            allBookingsListObj.tableNumbr = [[userDetailDict valueForKey:@"TableValue"] objectAtIndex:i];
           [bookingsListArray addObject:allBookingsListObj];
        }
        [allBookingTableView reloadData];
    
        [activityIndicator stopAnimating];
    
    
}


- (IBAction)allBookingBtnAction:(id)sender {
    [pastBookings setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    pastBookings.layer.borderColor = [UIColor clearColor].CGColor;
    [futureBookingsBtn setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    futureBookingsBtn.layer.borderColor=[UIColor clearColor].CGColor;
    allBookingsBtn.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    [allBookingsBtn setBackgroundColor:[UIColor clearColor]];
    bookingType = @"All";
    [self fetchbooking];
    
}

- (IBAction)pastBookingBtnAction:(id)sender {
    [pastBookings setBackgroundColor:[UIColor clearColor]];
    pastBookings.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    [futureBookingsBtn setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    futureBookingsBtn.layer.borderColor=[UIColor clearColor].CGColor;
    allBookingsBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [allBookingsBtn setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    bookingType = @"Past";
    [self fetchbooking];
}

- (IBAction)futureBookingBtnAction:(id)sender {
    [pastBookings setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    pastBookings.layer.borderColor = [UIColor clearColor].CGColor;
    [futureBookingsBtn setBackgroundColor:[UIColor clearColor]];
    futureBookingsBtn.layer.borderColor=[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    allBookingsBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [allBookingsBtn setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    bookingType = @"Future";
    [self fetchbooking];
}
@end
