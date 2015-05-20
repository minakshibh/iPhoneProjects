//
//  OrdersListViewController.m
//  Nini Events
//
//  Created by Br@R on 09/02/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "OrdersListViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "OrderListTableViewCell.h"
#import "OrderListDetailViewController.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "CheckOutViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
@interface OrdersListViewController ()

@end

@implementation OrdersListViewController
@synthesize type;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
    }
    else{
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    type=@"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int chatCount = [[defaults valueForKey:@"Chat Count"] intValue];
    if (chatCount != 0) {
        self.assisstanceNotificationBadgeImg.hidden = NO;
        self.assisstanceNotificationBadgeLbl.hidden = NO;
        self.assisstanceNotificationBadgeLbl.text = [NSString stringWithFormat:@"%d",chatCount];
    }else{
        self.assisstanceNotificationBadgeImg.hidden = YES;
        self.assisstanceNotificationBadgeLbl.hidden = YES;
    }
    NSString *orderCount = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Order Item Count"]];
    if (![orderCount isEqualToString:@"(null)"])
    {
        if (![orderCount isEqualToString:@"0"]) {
            
            self.batchLbl.hidden = NO;
            self.batchImg.hidden = NO;
            self.otherMenuBatchLbl.hidden = NO;
            self.otheMenuBatchImg.hidden = NO;
            NSLog(@"ordr count..%@",orderCount);
            self.batchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            self.otherMenuBatchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
            
        }
        else{
            self.batchLbl.hidden = YES;
            self.batchImg.hidden = YES;
            self.otherMenuBatchLbl.hidden = YES;
            self.otheMenuBatchImg.hidden = YES;
        }
        
    }else{
        self.batchLbl.hidden = YES;
        self.batchImg.hidden = YES;
        self.otherMenuBatchLbl.hidden = YES;
        self.otheMenuBatchImg.hidden = YES;
    }
    
    NSString *eventStatus = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Status"]];
    NSString *eventChatSupport = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Event Chat Support"]];
    
    if ([eventChatSupport isEqualToString:@"true"]) {
        [self.sideMenuWithoutReqAssistance setFrame:CGRectMake(-269, 19, self.sideMenuWithoutReqAssistance.frame.size.width, self.sideMenuWithoutReqAssistance.frame.size.height)];
        [self.sideScroller addSubview:self.sideMenuWithoutReqAssistance];
        
    }else{
        [self.sideMenuWithoutReqAssistance removeFromSuperview];
        
    }
    if ([eventStatus isEqualToString:@"0"]) {
        [self.footerWithoutEventsDetail setFrame:CGRectMake(0, 704, self.footerWithoutEventsDetail.frame.size.width, self.footerWithoutEventsDetail.frame.size.height)];
        [self.sideScroller addSubview:self.footerWithoutEventsDetail];
    }else{
        [self.footerWithoutEventsDetail removeFromSuperview];
    }

    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicator];
    if (self.flagValue == 1) {
         headrLbl.text=@"ORDER HISTORY";
        startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        ordrHistryLbl.textColor=[UIColor whiteColor];
        exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        
        ordrhistryImag.image=[UIImage imageNamed:@"orderhistoryselect.png"];
        [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"open"]];
    }else if (self.flagValue == 2){
        startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
        spCornerLbl.textColor=[UIColor whiteColor];
        
        spCornrImag.image=[UIImage imageNamed:@"spcornerselect.png"];
        headrLbl.text=@"SP CORNER";
        [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"delivered"]];
    }
   

   
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)FetchPendingPlacedOrder:(NSString*)passedOrderType
{
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *staffId;
    NSString *tableId;
    NSString *OrderType;
    NSString *TriggerValue;
    
    if (staffId == nil) {
        staffId = [NSString stringWithFormat:@""];
    }
    if (tableId == nil) {
        tableId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    }
    if (OrderType == nil) {
        OrderType = [NSString stringWithFormat:@"%@",passedOrderType];
    }
    if (TriggerValue == nil) {
        TriggerValue = [NSString stringWithFormat:@"customer"];
    }
    
    NSString *timeStamp = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"fetchOrderTimeStamp"]];
    //    if ([timeStamp isEqualToString:@"(null)"]) {
    timeStamp = [NSString stringWithFormat:@"-1"];
    //    }
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:staffId,@"StaffId",tableId, @"TableId",OrderType,@"OrderType",TriggerValue, @"Trigger",timeStamp,@"timestamp",[defaults valueForKey:@"Event ID"],@"EventId",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchOrders",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode = 1;
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
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Please Check the Internet Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
     if(webServiceCode == 1)
     {
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        pendingOrderTimeOfDeliveryArray = [[NSMutableArray alloc] init];
        pendingOrderListArray = [[NSMutableArray alloc] init];
        processingOrderList = [[NSMutableArray alloc] init];
        NSMutableArray *pendingOrdersrderList = [[NSMutableArray alloc]initWithArray:[userDetailDict valueForKey:@"ListPendingOrder"]];
        for (int i = 0; i < [pendingOrdersrderList count]; i ++) {
            pendingOrderObj = [[pendingOrdersOC alloc] init];
            pendingOrderObj.DateTimeOfOrder = [[pendingOrdersrderList valueForKey:@"DateTimeOfOrder"] objectAtIndex:i];
            pendingOrderObj.LastUpdate = [[pendingOrdersrderList valueForKey:@"LastUpdate"] objectAtIndex:i];
            pendingOrderObj.OrderId = [[pendingOrdersrderList valueForKey:@"OrderId"]objectAtIndex:i];
            pendingOrderObj.RestaurantId = [[pendingOrdersrderList valueForKey:@"RestaurantId"] objectAtIndex:i];
            pendingOrderObj.Status = [[pendingOrdersrderList valueForKey:@"Status"]objectAtIndex:i];
            pendingOrderObj.TableId = [[pendingOrdersrderList valueForKey:@"TableId"] objectAtIndex:i];
            pendingOrderObj.TimeOfDelivery = [[pendingOrdersrderList valueForKey:@"DateTimeOfOrder"]objectAtIndex:i];
            pendingOrderObj.TotalBill = [[pendingOrdersrderList valueForKey:@"TotalBill"]objectAtIndex:i];
            pendingOrderObj.pendingOrderDetails = [[pendingOrdersrderList valueForKey:@"ListOrderDetails"] objectAtIndex:i];
            pendingOrderObj.note = [[pendingOrdersrderList valueForKey:@"Notes"] objectAtIndex:i];
            pendingOrderObj.lastUpdatedTime = [[pendingOrdersrderList valueForKey:@"LastUpdate"]objectAtIndex:i];
            [pendingOrderListArray addObject:pendingOrderObj];
            [pendingOrderTimeOfDeliveryArray addObject:pendingOrderObj.TimeOfDelivery];
            if([pendingOrderObj.Status isEqualToString:@"processing"])
            {
                [processingOrderList addObject:pendingOrderObj];
            }
        }
        pendingOrderListArray=[[[pendingOrderListArray reverseObjectEnumerator] allObjects] mutableCopy];
        NSLog(@"pending Order List %@",pendingOrderObj.pendingOrderDetails);
        [self.pendingOrdersTableView reloadData];
        
        
     }else if (webServiceCode == 0) {
         NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
         NSLog(@"responseString:%@",responseString);
         NSError *error;
         
         responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
         
         SBJsonParser *json = [[SBJsonParser alloc] init];
         
         NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
         NSLog(@"Dictionary %@",userDetailDict);
         NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
         
    [activityIndicator stopAnimating];
}
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   if (self.flagValue == 1){
       return [pendingOrderListArray count];
   }else if (self.flagValue == 2){
       return [processingOrderList count];
   }return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
           return 110;
    }

  // Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }

    
    if (self.flagValue == 1)
    {
        pendingOrderObj = [pendingOrderListArray objectAtIndex:indexPath.row];
    }else if (self.flagValue == 2){
        pendingOrderObj = [processingOrderList objectAtIndex:indexPath.row];
    }
    
        NSDate *startTime;
        
        startTime = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSString *curruntTime = [ dateFormat stringFromDate:startTime];
        
        NSDate *convertedTime = [dateFormat dateFromString:curruntTime];
        NSString *time = [NSString stringWithFormat:@"%@",pendingOrderObj.lastUpdatedTime];
        
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [dateFormat dateFromString:time];
        
        // Convert date object to desired output format
        //[dateFormat setDateFormat:@"HH:mm"];
        NSString *dateStr = [dateFormat stringFromDate:date];
        NSDate *date1=[dateFormat dateFromString:dateStr];
        NSTimeInterval secs = [date1 timeIntervalSinceDate:convertedTime];
        NSString *timeDelay = [NSString stringWithFormat:@"%f",secs];
        timeDelay = [timeDelay
                     stringByReplacingOccurrencesOfString:@"-" withString:@""];
        int timeINteger = [timeDelay integerValue];
        int minutes = timeINteger / 60;
        NSLog(@"interval %d",minutes);
    int hours = timeINteger / 3600;
    int days = timeINteger / 86400;
    NSLog(@"interval %d",minutes);
    NSLog(@"interval %d",hours);
    NSLog(@"interval %d",days);
    
    NSString *timeStr;
    if (days > 0) {
        timeStr =[NSString stringWithFormat:@"%d DAYS AGO",days];
    }else if (hours > 0){
        timeStr =[NSString stringWithFormat:@"%d HOUR AGO",hours];
    }else{
        timeStr =[NSString stringWithFormat:@"%d MINS AGO",minutes];
    }

        NSString *statusStr = [NSString stringWithFormat:@"%@",pendingOrderObj.Status];
        statusStr = [statusStr uppercaseString];
        NSLog(@"Order Status %@",pendingOrderObj.OrderId);
    
    NSString *orderNumberStr = [NSString stringWithFormat:@"%@",pendingOrderObj.OrderId];
    orderNumberStr = [orderNumberStr uppercaseString];
    itemNamesArray = [[NSMutableArray alloc]init];
    
        NSString *str = [NSString stringWithFormat:@"%@",[pendingOrderObj.pendingOrderDetails valueForKey:@"itemname"]];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@", "];
    
    [cell setLabelText:[NSString stringWithString:statusStr] :[NSString stringWithString:timeStr] :[NSString stringWithFormat: @"ORDER NUMBER : %@",orderNumberStr]: str];
    
        UIButton *showDetailoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [showDetailoBtn setTitle: @"VIEW DETAILS" forState: UIControlStateNormal];

        showDetailoBtn.frame = CGRectMake(845.0f, 60.0f, 144.0f,35.0f);
        showDetailoBtn.tag = indexPath.row;
        showDetailoBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:16.0f];

        [showDetailoBtn setTintColor:[UIColor whiteColor]] ;
        [cell.contentView addSubview:showDetailoBtn];
        
        [showDetailoBtn addTarget:self action:@selector(showDetailoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"viewdetail"];
        
        [showDetailoBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];

        [cell.contentView addSubview:showDetailoBtn];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    int section = indexPath.section;
    // [self.menuTableView reloadData];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %@", newIndexPath);

}

- (IBAction)showDetailoBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    pendingOrdersOC *ordr;
    if(self.flagValue == 1){
    ordr = (pendingOrdersOC *)[pendingOrderListArray objectAtIndex:indexPath.row];
    }else if (self.flagValue == 2){
        ordr = (pendingOrdersOC *)[processingOrderList objectAtIndex:indexPath.row];
    }
    OrderListDetailViewController*ordrVc=[[OrderListDetailViewController alloc]initWithNibName:@"OrderListDetailViewController" bundle:nil];
    ordrVc.pendingOrderObj=ordr;
    ordrVc.type=[NSString stringWithString:type];
    ordrVc.flag = self.flagValue;
    [self.navigationController pushViewController:ordrVc animated:YES];
}



- (IBAction)backBtn:(id)sender {
}

- (IBAction)menuBtn:(id)sender {
    
    [self showSlider];
}

- (IBAction)startAnewOrdeActionBtn:(id)sender
{
    startNewOrdrLbl.textColor=[UIColor whiteColor];
    ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    
    strtNewOrdrImag.image=[UIImage imageNamed:@""];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistory.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistance.png"];
    spCornrImag.image=[UIImage imageNamed:@""];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = YES;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)orderHistoryActionBtn:(id)sender {
     type=@"";
    [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"open"]];

    startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    ordrHistryLbl.textColor=[UIColor whiteColor];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    
    strtNewOrdrImag.image=[UIImage imageNamed:@"startneworderselect.png"];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistoryselect.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistance.png"];
    spCornrImag.image=[UIImage imageNamed:@"sporder.png"];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    OrdersListViewController *orderVC = [[OrdersListViewController alloc] initWithNibName:@"OrdersListViewController" bundle:nil];
    orderVC.flagValue = 1;
    [self.navigationController pushViewController:orderVC animated:NO];
}

- (IBAction)requestAssistntActionBtn:(id)sender {
    startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor whiteColor];
    spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];

    strtNewOrdrImag.image=[UIImage imageNamed:@"startneworder.png"];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistory.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistanceselect.png"];
    spCornrImag.image=[UIImage imageNamed:@"sporder.png"];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Chat Count"] ;
    self.assisstanceNotificationBadgeImg.hidden = YES;
    self.assisstanceNotificationBadgeLbl.hidden = YES;
    requestAssistanceViewController *requestVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestVC animated:NO];
}

- (IBAction)spCornerActionBtn:(id)sender {
   
    
    [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"open"]];

    startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    exitLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
    spCornerLbl.textColor=[UIColor whiteColor];
    
    strtNewOrdrImag.image=[UIImage imageNamed:@"startneworder.png"];
    ordrhistryImag.image=[UIImage imageNamed:@"orderhistory.png"];
    requstAssistImag.image=[UIImage imageNamed:@"requestassistance.png"];
    spCornrImag.image=[UIImage imageNamed:@"sporderselect.png"];
    exitImag.image=[UIImage imageNamed:@"exit.png"];
    [self showSlider];
    OrdersListViewController *orderVC = [[OrdersListViewController alloc] initWithNibName:@"OrdersListViewController" bundle:nil];
    orderVC.flagValue = 2;
    [self.navigationController pushViewController:orderVC animated:NO];
}

- (IBAction)ExitBtn:(id)sender {
//    startNewOrdrLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
//    ordrHistryLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
//    exitLbl.textColor=[UIColor whiteColor];
//    requestAssistntLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
//    spCornerLbl.textColor=[UIColor colorWithRed:197.0/255.0  green:95.0/255.0 blue:77.0/255.0 alpha:1.0f];
//    
    
//    strtNewOrdrImag.image=[UIImage imageNamed:@"startneworder.png"];
//    ordrhistryImag.image=[UIImage imageNamed:@"orderhistory.png"];
//    requstAssistImag.image=[UIImage imageNamed:@"requestassistance.png"];
//    spCornrImag.image=[UIImage imageNamed:@"sporder.png"];
//    exitImag.image=[UIImage imageNamed:@"exitselect.png"];
    [self showSlider];
    [self.exitPopUpView setFrame:CGRectMake(0, 0, self.exitPopUpView.frame.size.width, self.exitPopUpView.frame.size.height)];
    [self.view addSubview:self.exitPopUpView];
}

- (IBAction)apphomeAction:(id)sender {
    appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)menuAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    //homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)checkOutView:(id)sender {
    CheckOutViewController*checkoutVc=[[CheckOutViewController alloc]initWithNibName:@"CheckOutViewController" bundle:nil];
    [self.navigationController pushViewController:checkoutVc animated:NO];
}

- (IBAction)ophemyAction:(id)sender {
    eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}
-(void) showSlider
{
    CGPoint pt;
    CGRect rc = [self.sideScroller bounds];
    rc = [self.sideScroller convertRect:rc toView:self.sideScroller];
    pt = rc.origin;
    if (pt.x == 0) {
        pt.x -= 265;
    }else{
        pt.x = 0;
    }
    
    pt.y =-20;
    [self.sideScroller setContentOffset:pt animated:YES];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1 && buttonIndex == 1){
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
        [database executeUpdate:queryString1];
       
        [database close];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults removeObjectForKey:@"Table ID"];
        [defaults removeObjectForKey:@"Table Name"];
        [defaults removeObjectForKey:@"Table image"];
        [defaults removeObjectForKey:@"Role"];
        
        [defaults setObject:[NSString stringWithFormat:@"YES"] forKey:@"isLogedOut"];
        loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
- (IBAction)pingBtnAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"OFF"]) {
        [self sendHelpMessage];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"ON" forKey:@"bulb"];
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        self.pingMessageView.hidden = NO;
        self.pingMessageView.alpha= 1.0;
            hideTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(FadeView) userInfo:nil repeats:NO];
    }
    else{
        
        self.pingMessageView.hidden = YES;
        [hideTimer invalidate];
        [[NSUserDefaults standardUserDefaults] setValue:@"OFF" forKey:@"bulb"];
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    
}
-(void) sendHelpMessage
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tableID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    NSString *serviceProviderId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"AllotedServiceProviderId"]];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@"(" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@")" withString:@""];
    serviceProviderId = [serviceProviderId stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tableName = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table Name"]];
    tableName = [tableName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@")" withString:@""];
    tableName = [tableName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *chatMessage;
    NSString *chatTrigger;
    chatTrigger = [NSString stringWithFormat:@"ping"];
    chatMessage = [NSString stringWithFormat:@"%@ is requesting for Assistance.",tableName];
    NSString *sender = [NSString stringWithFormat:@"table"];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",chatMessage,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",chatTrigger,@"trigger", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/SendHelpMessages",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =0;
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
-(void) FadeView
{
    [UIView animateWithDuration:0.9
                     animations:^{self.pingMessageView.alpha = 0.0;}
                     completion:^(BOOL finished){self.pingMessageView.hidden = YES;}];
}
- (IBAction)exitYesAction:(id)sender {
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
    [database executeUpdate:queryString1];
    
    [database close];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"Table ID"];
    [defaults removeObjectForKey:@"Table Name"];
    [defaults removeObjectForKey:@"Table image"];
    [defaults removeObjectForKey:@"Role"];
    
    
    [defaults setObject:[NSString stringWithFormat:@"YES"] forKey:@"isLogedOut"];
    loginViewController *loginVC = [[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (IBAction)exitNoAction:(id)sender {
    [self.exitPopUpView removeFromSuperview];
}

@end
