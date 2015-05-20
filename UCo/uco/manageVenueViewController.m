//
//  manageVenueViewController.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "manageVenueViewController.h"
#import "DashboardViewController.h"
#import "manageVenueTableViewCell.h"
#import "AddBookingViewController.h"
#include "JSON.h"
#include "ASIHTTPRequest.h"
#include "SBJson.h"
#include "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AsyncImageView.h"
#import "venueViewController.h"
@interface manageVenueViewController ()

@end

@implementation manageVenueViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    venueTypeLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    venueTypeLbl.layer.borderWidth = 1.5;
    venueTypeLbl.layer.cornerRadius = 13.0;
    [venueTypeLbl setClipsToBounds:YES];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    descriptionTextView.layer.borderColor = [UIColor whiteColor].CGColor;
    descriptionTextView.layer.borderWidth = 1.5;
    descriptionTextView.layer.cornerRadius = 13.0;
    [descriptionTextView setClipsToBounds:YES];
    
    updateVenue.layer.borderColor = [UIColor clearColor].CGColor;
    updateVenue.layer.borderWidth = 1.5;
    updateVenue.layer.cornerRadius = 13.0;
    [updateVenue setClipsToBounds:YES];
    
    
    [self fetchVenues];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    // get pointer to app delegate, which contains property for menu pointer
    
    
    if (self.flag == 1) {
        upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Venue" delegate:self];
    }else if (self.flag == 2){
        upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Manage Venue" delegate:self];
    }
    
    
    [self.view addSubview: upparView];
    
}
- (void)mainMenuBtnPressed{
    if (self.flag == 2) {
        DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:dashboardView animated:NO];
        NSLog(@"dashboard preesed");
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [venueArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    manageVenueTableViewCell *cell = (manageVenueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"manageVenueTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    manageVenueOC = [venueArray objectAtIndex:indexPath.row];
    
    
    
    NSString *name = [NSString stringWithFormat:@"%@",manageVenueOC.venueName];
    NSString *address = [NSString stringWithFormat:@"%@",manageVenueOC.adress];
    NSString *desp = [NSString stringWithFormat:@"%@",manageVenueOC.DetailDescription];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",manageVenueOC.Picture];
    NSLog(@"NAME.... %@", name);
    NSLog(@"address... %@",address);
    NSLog(@"Desp..... %@",desp);
    name = [ name stringByReplacingOccurrencesOfString:@"(" withString:@""];
    name = [ name stringByReplacingOccurrencesOfString:@")" withString:@""];
    name = [name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    name = [ name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    address = [ address stringByReplacingOccurrencesOfString:@"(" withString:@""];
    address = [ address stringByReplacingOccurrencesOfString:@")" withString:@""];
    address =[address stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    address = [ address stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    desp = [ desp stringByReplacingOccurrencesOfString:@"(" withString:@""];
    desp = [ desp stringByReplacingOccurrencesOfString:@")" withString:@""];
    desp =  [desp stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    desp = [ desp stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    imageUrl = [ imageUrl stringByReplacingOccurrencesOfString:@"(" withString:@""];
    imageUrl = [ imageUrl stringByReplacingOccurrencesOfString:@")" withString:@""];
    imageUrl =  [imageUrl stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    imageUrl = [ imageUrl stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    AsyncImageView *itemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",imageUrl];
    itemImage.imageURL = [NSURL URLWithString:imageUrls];
    itemImage.showActivityIndicator = YES;
    itemImage.frame = CGRectMake(16, 13, 130, 130);
    itemImage.contentMode = UIViewContentModeScaleAspectFill;
    itemImage.userInteractionEnabled = YES;
    itemImage.multipleTouchEnabled = YES;
    itemImage.layer.borderColor = [UIColor clearColor].CGColor;
    itemImage.layer.borderWidth = 1.5;
    itemImage.layer.cornerRadius = 4.0;
    [itemImage setClipsToBounds:YES];
    [cell.contentView addSubview:itemImage];
    
    if (self.flag == 2) {
     NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
        NSString *listDataID = [NSString stringWithFormat:@"%@",manageVenueOC.ListDataId];
    if ([listDataID isEqualToString:listDataIdStr]) {
        UIImageView *highlightView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 967, 154)];
        [highlightView setBackgroundColor:[UIColor grayColor]];
        highlightView.layer.borderColor = [UIColor clearColor].CGColor;
        highlightView.layer.borderWidth = 1.5;
        highlightView.layer.cornerRadius = 10.0;
        [highlightView setAlpha:0.3];
        [cell.contentView addSubview:highlightView];
    }else if ([listDataIdStr isEqualToString:@"0"]){
        UIImageView *highlightView= [[UIImageView alloc] initWithFrame:CGRectMake(23, 140, manageVenueTableView.frame.size.width, 30)];
        [highlightView setBackgroundColor:[UIColor grayColor]];
        highlightView.layer.borderColor = [UIColor clearColor].CGColor;
        highlightView.layer.borderWidth = 1.5;
        highlightView.layer.cornerRadius = 10.0;
        [highlightView setAlpha:0.3];
        [self.view addSubview:highlightView];
    }
    }
    [cell setLabelText:name : address : desp : imageUrl];
    
    
    
    ///////  Edit BUTTON //////////
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
    
    editBtn.frame = CGRectMake(790.0f, 40.0f,120.0f,30.0f);
    editBtn.tag = indexPath.row;
    editBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    [editBtn setTintColor:[UIColor whiteColor]] ;
    [editBtn addTarget:self action:@selector(editActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"Pending arrival"];
    [editBtn setBackgroundColor:[UIColor colorWithRed:13/255.0f green:54/255.0f blue:108/255.0f alpha:1.0]];
    [editBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    editBtn.layer.borderColor = [UIColor clearColor].CGColor;
    editBtn.layer.borderWidth = 1.5;
    editBtn.layer.cornerRadius = 16.0;
    [cell.contentView addSubview:editBtn];
    
    ///////  Delete BUTTON //////////
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteBtn setTitle: @"Delete" forState: UIControlStateNormal];
    
    deleteBtn.frame = CGRectMake(790.0f, 95.0f,120.0f,30.0f);
    deleteBtn.tag = indexPath.row;
    deleteBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    [deleteBtn setTintColor:[UIColor blackColor]] ;
//    [deleteBtn addTarget:self action:@selector(deleteBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *deleteBtnBackgroundShowDetail= [UIImage imageNamed:@"Pending arrival"];
    [deleteBtn setBackgroundColor:[UIColor colorWithRed:207/255.0f green:191/255.0f blue:142/255.0f alpha:1.0]];
    [deleteBtn setBackgroundImage:deleteBtnBackgroundShowDetail forState:UIControlStateNormal];
    deleteBtn.layer.borderColor = [UIColor clearColor].CGColor;
    deleteBtn.layer.borderWidth = 1.5;
    deleteBtn.layer.cornerRadius = 16.0;
    [cell.contentView addSubview:deleteBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UIImageView *highlightView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 967, 154)];
    [highlightView setBackgroundColor:[UIColor grayColor]];
    highlightView.layer.borderColor = [UIColor clearColor].CGColor;
    highlightView.layer.borderWidth = 1.5;
    highlightView.layer.cornerRadius = 10.0;
    [highlightView setAlpha:0.3];
    [cell.contentView addSubview:highlightView];
    
    manageVenueOC = [venueArray objectAtIndex:indexPath.row];
    NSString *listDataIdStr = [NSString stringWithFormat:@"%@",manageVenueOC.ListDataId];
    NSString *restaurantNameStr = [NSString stringWithFormat:@"%@",manageVenueOC.venueName];
    restaurantNameStr = [ restaurantNameStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    restaurantNameStr = [ restaurantNameStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    restaurantNameStr = [restaurantNameStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    restaurantNameStr = [ restaurantNameStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    [[NSUserDefaults standardUserDefaults] setObject:listDataIdStr forKey:@"List Data ID"];
    [[NSUserDefaults standardUserDefaults] setObject:restaurantNameStr forKey:@"Restaurant Name"];
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
    
}
- (IBAction)editActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    manageVenueTableView.hidden = YES;
//    [venueView setFrame:CGRectMake(52, 162, 920, 565)];
//    [self.view addSubview:venueView];

    venueViewController*VenueView=[[venueViewController alloc]initWithNibName:@"venueViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:VenueView animated:NO];
}

#pragma mark -Json Delegate

-(void) fetchVenues
{
     [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Client Id"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:clientId,@"ClientId", nil];
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetRestaurantDetailsByClientId"];
    
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
    
    [activityIndicator stopAnimating];
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
    venueArray = [[NSMutableArray alloc] init];
    restaurantListArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [userDetailDict count]; i++) {
        manageVenueOC = [[manageVenueObj alloc] init];
        manageVenueOC.adress = [[userDetailDict valueForKey:@"Address"] objectAtIndex:i];
        manageVenueOC.City = [[userDetailDict valueForKey:@"City"]objectAtIndex:i];
        manageVenueOC.Country = [[userDetailDict valueForKey:@"Country"]objectAtIndex:i];
        manageVenueOC.Created = [[userDetailDict valueForKey:@"Created"]objectAtIndex:i];
        manageVenueOC.Description = [[userDetailDict valueForKey:@"Description"]objectAtIndex:i];
        manageVenueOC.DetailDescription = [[userDetailDict valueForKey:@"DetailDescription"]objectAtIndex:i];
        manageVenueOC.Entertaintment = [[userDetailDict valueForKey:@"Entertaintment"]objectAtIndex:i];
        manageVenueOC.EventType = [[userDetailDict valueForKey:@"EventType"]objectAtIndex:i];
        manageVenueOC.IsOther = [[userDetailDict valueForKey:@"IsOther"]objectAtIndex:i];
        manageVenueOC.IsRecommended = [[userDetailDict valueForKey:@"IsRecommended"]objectAtIndex:i];
        manageVenueOC.ListDataId = [[userDetailDict valueForKey:@"ListDataId"]objectAtIndex:i];
        manageVenueOC.venueName = [[userDetailDict valueForKey:@"Name"]objectAtIndex:i];
        manageVenueOC.ParentId = [[userDetailDict valueForKey:@"ParentId"]objectAtIndex:i];
        manageVenueOC.Phone = [[userDetailDict valueForKey:@"Phone"]objectAtIndex:i];
        manageVenueOC.Picture = [[userDetailDict valueForKey:@"Picture"]objectAtIndex:i];
        manageVenueOC.RecordStatus = [[userDetailDict valueForKey:@"RecordStatus"]objectAtIndex:i];
        manageVenueOC.SortOrder = [[userDetailDict valueForKey:@"SortOrder"]objectAtIndex:i];
        manageVenueOC.State = [[userDetailDict valueForKey:@"State"]objectAtIndex:i];
        manageVenueOC.Status = [[userDetailDict valueForKey:@"Status"]objectAtIndex:i];
        manageVenueOC.ThemeVenues = [[userDetailDict valueForKey:@"ThemeVenues"]objectAtIndex:i];
        manageVenueOC.TypeOfRestaurant = [[userDetailDict valueForKey:@"TypeOfRestaurant"]objectAtIndex:i];
        manageVenueOC.Typeofmenu = [[userDetailDict valueForKey:@"Typeofmenu"]objectAtIndex:i];
        manageVenueOC.VenueClassification = [[userDetailDict valueForKey:@"VenueClassification"]objectAtIndex:i];
        manageVenueOC.Zip = [[userDetailDict valueForKey:@"Zip"]objectAtIndex:i];
       
        [restaurantListArray addObject:manageVenueOC.venueName];
        [venueArray addObject:manageVenueOC];
    }
    restaurantListArray = [NSMutableArray arrayWithArray:venueArray];
    UIButton *allButton;
    if ([venueArray count]>1) {
        
        allButton = [[UIButton alloc]initWithFrame:CGRectMake(23, 140, manageVenueTableView.frame.size.width, 30)];
        [allButton setTitle: @"ALL" forState: UIControlStateNormal];
        [allButton setBackgroundColor:[UIColor colorWithRed:15/255.0f green:32/255.0f blue:58/255.0f alpha:1.0]];
        allButton.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:17.0f];
        [allButton setTintColor:[UIColor whiteColor]] ;
        [allButton addTarget:self action:@selector(allActionBtn) forControlEvents:UIControlEventTouchUpInside];
        allButton.layer.borderColor = [UIColor clearColor].CGColor;
        allButton.layer.borderWidth = 1.5;
        allButton.layer.cornerRadius = 4.0;
        [self.view addSubview:allButton];
        
    }
    [manageVenueTableView reloadData];
    [activityIndicator stopAnimating];
    
    
}
- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:addBookingVC animated:NO];
    NSLog(@"addBookingBtn Pressed ");
    
}

- (IBAction)updateVenueBtn:(id)sender {
    [venueView removeFromSuperview];
    manageVenueTableView.hidden = NO;
    [manageVenueTableView reloadData];
}
-(void)allActionBtn
{
    NSString *listDataIdStr = [NSString stringWithFormat:@"0"];
    NSString *restaurantNameStr = [NSString stringWithFormat:@"ALL"];
    [[NSUserDefaults standardUserDefaults] setObject:listDataIdStr forKey:@"List Data ID"];
    [[NSUserDefaults standardUserDefaults] setObject:restaurantNameStr forKey:@"Restaurant Name"];
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
}
@end
