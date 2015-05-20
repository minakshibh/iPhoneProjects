//
//  DashboardViewController.m
//  uco
//
//  Created by Br@R on 17/03/15.
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
#import "SpecialOffersViewController.h"
#import "calendarViewController.h"
#import "feedbackViewController.h"
#import "manageVenueViewController.h"
#import "checkWebserviceViewController.h"
#import "bookingTableViewCell.h"
#include "JSON.h"
#include "ASIHTTPRequest.h"
#include "SBJson.h"
#include "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AsyncImageView.h"
@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden=YES;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    [self roundCornersOfAllButton];
    [self fetchVenues];
    [super viewDidLoad];
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
-(void)viewWillAppear:(BOOL)animated
{
    // get pointer to app delegate, which contains property for menu pointer
    
    
    Leftsideview = [[LeftSideBarView alloc] initWithFrame:CGRectMake(0, 90, 125,self.view.frame.size.height-90) fontName:@"Helvetica" delegate:self];
    
    [self.view addSubview: Leftsideview];
    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"DASHBOARD" delegate:self];
    
    [self.view addSubview: upparView];
    
}



- (IBAction)futureBooking:(id)sender {
    [self hideSideBar];
    
    AllBookingsViewController* allBookingsView=[[AllBookingsViewController alloc]initWithNibName:@"AllBookingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:allBookingsView animated:NO];
    NSLog(@"allBookingButton Pressed ");
}

- (IBAction)pastBooking:(id)sender {
    [self hideSideBar];
    
    AllBookingsViewController* allBookingsView=[[AllBookingsViewController alloc]initWithNibName:@"AllBookingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:allBookingsView animated:NO];
    NSLog(@"allBookingButton Pressed ");
}

- (IBAction)specialOffers:(id)sender {
    SpecialOffersViewController*specialOffersVC=[[SpecialOffersViewController alloc]initWithNibName:@"SpecialOffersViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:specialOffersVC animated:NO];
    
    NSLog(@"specialOffers Pressed ");
}

- (IBAction)manageVenue:(id)sender{
    manageVenueViewController*manageVenueVC=[[manageVenueViewController alloc]initWithNibName:@"manageVenueViewController" bundle:[NSBundle mainBundle]];
    manageVenueVC.flag = 2;
    [self.navigationController pushViewController:manageVenueVC animated:YES];
}

- (IBAction)comments:(id)sender {
    checkWebserviceViewController*manageVenueVC=[[checkWebserviceViewController alloc]init];
    
    [self.navigationController pushViewController:manageVenueVC animated:YES];
}


- (void)dashboardButtonPressed{
    [self hideSideBar];
    
//    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:dashboardView animated:NO];
    NSLog(@"dashboard preesed");
}
- (void)allBookingButtonPressed{
    [self hideSideBar];

    AllBookingsViewController* allBookingsView=[[AllBookingsViewController alloc]initWithNibName:@"AllBookingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:allBookingsView animated:NO];
    NSLog(@"allBookingButton Pressed ");
}
- (void)manageRestaurantButtonPressed{
    [self hideSideBar];

    manageRestaurantViewController*managMntView=[[manageRestaurantViewController alloc]initWithNibName:@"manageRestaurantViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:managMntView animated:NO];
    NSLog(@"allBookingButton Pressed ");
}
- (void)greetingButtonPressed{
    [self hideSideBar];

    GreetingsViewController*greetingVviewView=[[GreetingsViewController alloc]initWithNibName:@"GreetingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:greetingVviewView animated:NO];
    NSLog(@"manageRestaurantButton Pressed ");
}
- (void)markettingButtonPressed{
    [self hideSideBar];

    MarketingViewController* marketingView=[[MarketingViewController alloc]initWithNibName:@"MarketingViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:marketingView animated:NO];
    NSLog(@"markettingButton Pressed ");
}
- (void)reportingButtonPressed{
    [self hideSideBar];

    ReportingViewController*reportingView=[[ReportingViewController alloc]initWithNibName:@"ReportingViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:reportingView animated:NO];
    NSLog(@"reportingButton Pressed");
}
- (void)paymentButtonPressed{
    [self hideSideBar];

    PaymentViewController*paymentView=[[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:paymentView animated:NO];
    NSLog(@"paymentButton Pressed  ");
}
- (void)settingButtonPressed{
    [self hideSideBar];

    SettingsViewController* settingsView=[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:settingsView animated:NO];

    NSLog(@"settingButton Pressed ");
}

- (void)calendarButtonPressed{
    [self hideSideBar];
    
    calendarViewController* settingsView=[[calendarViewController alloc]initWithNibName:@"calendarViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:settingsView animated:NO];
    
    NSLog(@"settingButton Pressed ");
}
-(void)feedbackViewBtnPressed{
    feedbackViewController *calendarVC=[[feedbackViewController alloc]initWithNibName:@"feedbackViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:calendarVC animated:NO];
    NSLog(@"calendarViewController Pressed ");
    
}

- (void)mainMenuBtnPressed{
//    NSLog(@"x--%f",self.view.frame.origin.x);
//    if (Leftsideview.hidden==YES)
//    {
//        [self showSideBar ];
//        return ;
//
//    }
//    else{
//        [self hideSideBar];
//        return ;
//
//    }
}
- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:addBookingVC animated:NO];
    NSLog(@"addBookingBtn Pressed ");
    
}
-(void) hideSideBar{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [Leftsideview.layer addAnimation:transition forKey:nil];
 //   Leftsideview.hidden=YES;

}
-(void)showSideBar{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [Leftsideview.layer addAnimation:transition forKey:nil];
//    
//    // [sideView addSubview:self.view];
//    Leftsideview.hidden=NO;
 
}
-(void)roundCornersOfAllButton
{
    
//    [pastBookingbtn setBackgroundColor:[UIColor colorWithRed:220.0/255.0f green:96.0f/255.0f blue:0.0f/255.0f alpha:1]];
//    [futureBookingBtn setBackgroundColor:[UIColor colorWithRed:220.0/255.0f green:96.0f/255.0f blue:0.0f/255.0f alpha:1]];
//    [specialOffrsbtn setBackgroundColor:[UIColor colorWithRed:220.0/255.0f green:96.0f/255.0f blue:0.0f/255.0f alpha:1]];
//    [commentsBtn setBackgroundColor:[UIColor clearColor]];
//    [reviewsBtn setBackgroundColor:[UIColor clearColor]];
    
    pastBookingbtn.layer.borderColor = [UIColor clearColor].CGColor;
    pastBookingbtn.layer.borderWidth = 1.5;
    pastBookingbtn.layer.cornerRadius = 17.0;
    [pastBookingbtn setClipsToBounds:YES];
    
    futureBookingBtn.layer.borderColor = [UIColor clearColor].CGColor;
    futureBookingBtn.layer.borderWidth = 1.5;
    futureBookingBtn.layer.cornerRadius = 17.0;
    [futureBookingBtn setClipsToBounds:YES];
    
    
    specialOffrsbtn.layer.borderColor =[UIColor clearColor].CGColor;
    specialOffrsbtn.layer.borderWidth = 1.5;
    specialOffrsbtn.layer.cornerRadius = 17.0;
    [specialOffrsbtn setClipsToBounds:YES];
    
    commentsBtn.layer.borderColor =[UIColor clearColor].CGColor;
    commentsBtn.layer.borderWidth = 1.5;
    commentsBtn.layer.cornerRadius = 17.0;
    [commentsBtn setClipsToBounds:YES];
    
    
    reviewsBtn.layer.borderColor =[UIColor clearColor].CGColor;
    reviewsBtn.layer.borderWidth = 1.5;
    reviewsBtn.layer.cornerRadius = 17.0;
    [reviewsBtn setClipsToBounds:YES];
    
    pastBookingbtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    futureBookingBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    specialOffrsbtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    commentsBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    reviewsBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    userNameLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    userContactlbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [bookingArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    bookingTableViewCell *cell = (bookingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"bookingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    bookingOC = [bookingArray objectAtIndex:indexPath.row];
    [cell setLabelText:bookingOC.status :bookingOC.PhoneNumber :bookingOC.FirstName :bookingOC.TableId :bookingOC.NoOfGuests :bookingOC.TimeSlotFrom];
    
    
    
    ///////  Edit BUTTON //////////
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void) fetchVenues
{
     [activityIndicator startAnimating];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    NSString *theDate = [dateFormatter stringFromDate:currentDate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Client Id"]];
    NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
    NSString *showPastData, *showUpcoming;
    
        showPastData = [NSString stringWithFormat:@"false"];
        showUpcoming = [NSString stringWithFormat:@"false"];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:clientId,@"ClientId",theDate,@"date",listDataIdStr,@"listDataId",showPastData,@"showPast",showUpcoming,@"showUpcoming",@"",@"day",@"",@"refType",@"",@"groupId", nil];
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetDashBoardBookingsDetails"];
    
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
    bookingArray = [[NSMutableArray alloc] init];
    NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Message"]];
    messageStr = [ messageStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    messageStr = [ messageStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    messageStr = [messageStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    messageStr = [ messageStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if (![messageStr isEqualToString:@"No Bookings are Available"]) {
    
    for (int i = 0; i < [userDetailDict count]; i++) {
        bookingOC = [[bookingObj alloc] init];
        bookingOC.Address = [[userDetailDict valueForKey:@"Address"] objectAtIndex:i];
        bookingOC.BookingDataItemId = [[userDetailDict valueForKey:@"BookingDataItemId"]objectAtIndex:i];
        bookingOC.BookingId = [[userDetailDict valueForKey:@"BookingId"]objectAtIndex:i];
        bookingOC.City = [[userDetailDict valueForKey:@"City"]objectAtIndex:i];
        bookingOC.ClientId = [[userDetailDict valueForKey:@"ClientId"]objectAtIndex:i];
        bookingOC.Comments = [[userDetailDict valueForKey:@"Comments"]objectAtIndex:i];
        bookingOC.Country = [[userDetailDict valueForKey:@"Country"]objectAtIndex:i];
        bookingOC.DateOfBooking = [[userDetailDict valueForKey:@"DateOfBooking"]objectAtIndex:i];
        bookingOC.Day = [[userDetailDict valueForKey:@"Day"]objectAtIndex:i];
        bookingOC.Detail = [[userDetailDict valueForKey:@"Detail"]objectAtIndex:i];
        bookingOC.ListDataId = [[userDetailDict valueForKey:@"ListDataId"]objectAtIndex:i];
        bookingOC.EmailId = [[userDetailDict valueForKey:@"EmailId"]objectAtIndex:i];
        bookingOC.FirstName = [[userDetailDict valueForKey:@"FirstName"]objectAtIndex:i];
        bookingOC.FloorId = [[userDetailDict valueForKey:@"FloorId"]objectAtIndex:i];
        bookingOC.LastName = [[userDetailDict valueForKey:@"LastName"]objectAtIndex:i];
        bookingOC.ListDataId = [[userDetailDict valueForKey:@"ListDataId"]objectAtIndex:i];
        bookingOC.Name = [[userDetailDict valueForKey:@"Name"]objectAtIndex:i];
        bookingOC.NoOfGuests = [[userDetailDict valueForKey:@"NoOfGuests"]objectAtIndex:i];
        bookingOC.PhoneNumber = [[userDetailDict valueForKey:@"PhoneNumber"]objectAtIndex:i];
        bookingOC.Picture = [[userDetailDict valueForKey:@"Picture"]objectAtIndex:i];
        bookingOC.ReviewTag = [[userDetailDict valueForKey:@"ReviewTag"]objectAtIndex:i];
        bookingOC.SpecialOfferId = [[userDetailDict valueForKey:@"SpecialOfferId"]objectAtIndex:i];
        bookingOC.State = [[userDetailDict valueForKey:@"State"]objectAtIndex:i];
        bookingOC.TableId = [[userDetailDict valueForKey:@"TableId"]objectAtIndex:i];
        bookingOC.TableValue = [[userDetailDict valueForKey:@"TableValue"]objectAtIndex:i];
        bookingOC.Tag = [[userDetailDict valueForKey:@"Tag"]objectAtIndex:i];
        bookingOC.TimeSlotFrom = [[userDetailDict valueForKey:@"TimeSlotFrom"]objectAtIndex:i];
        bookingOC.TimeSlotTo = [[userDetailDict valueForKey:@"TimeSlotTo"]objectAtIndex:i];
        bookingOC.Zip = [[userDetailDict valueForKey:@"Zip"]objectAtIndex:i];
        bookingOC.status = [[userDetailDict valueForKey:@"status"]objectAtIndex:i];
        
        
        [bookingArray addObject:bookingOC];
    }
    [bookingTableView reloadData];
    }
    [activityIndicator stopAnimating];
    
    
}

@end
