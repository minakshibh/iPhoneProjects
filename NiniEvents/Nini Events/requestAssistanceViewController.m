//
//  requestAssistanceViewController.m
//  Nini Events
//
//  Created by Krishna_Mac_1 on 2/9/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "requestAssistanceViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "CheckOutViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
@interface requestAssistanceViewController ()

@end

@implementation requestAssistanceViewController

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

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
    
    self.messageBgLbl.layer.borderColor = [UIColor grayColor].CGColor;
    self.messageBgLbl.layer.borderWidth = 1.5;
    
    
    self.sendBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.sendBtn.layer.borderWidth = 1.5;
    [self fetchHelpMessage];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Pending PLaced Order Web Services

-(void) fetchHelpMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString *timestamp= [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Customer Incoming Chat Timestamp"]];
    NSLog(@"TimeStamp %@",timestamp);
    if ([timestamp isEqualToString:@"(null)"]) {
        timestamp = [NSString stringWithFormat:@"-1"];
    }
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@" "withString:@""];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@"("withString:@""];
    timestamp = [timestamp stringByReplacingOccurrencesOfString:@")"withString:@""];
    NSString *ids = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    NSString *user = [NSString stringWithFormat:@"table"];
    NSString *assignedTableList= [NSString stringWithFormat:@""];;
    NSString *timeStampList= [NSString stringWithFormat:@""];;
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:timestamp,@"timestamp",ids, @"id",user, @"user",assignedTableList, @"assignedtablelist",timeStampList, @"timestamplist",@"chat",@"trigger", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchHelpMessages",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    webServiceCode =1;
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

#pragma mark - Send Help Message
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
    NSString *chatMessage = [NSString stringWithFormat:@"%@",self.chatMessageTxtView.text];;
    
    if ([chatMessage isEqualToString:@""]) {
        chatTrigger = [NSString stringWithFormat:@"ping"];
        chatMessage = [NSString stringWithFormat:@"%@ is requesting for Assistance.",tableName];
    }else{
        chatTrigger = [NSString stringWithFormat:@"chat"];
        chatMessage = [NSString stringWithFormat:@"%@",self.chatMessageTxtView.text];
    }
    
    NSString *sender = [NSString stringWithFormat:@"table"];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tableID,@"tableId",serviceProviderId,@"serviceproviderId",chatMessage,@"message",sender, @"sender",[NSString stringWithFormat:@"1"],@"restaurantId",chatTrigger,@"trigger", nil];
    
    NSLog(@"jsonRequest is %@", jsonDict);
    
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

#pragma mark -Json Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
//    NSString *str = [NSString stringWithFormat:@"%@",er]
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Error" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"ERROR with the Connection ");
    webData =nil;
    [self.view setUserInteractionEnabled:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (webServiceCode == 1) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        
        NSMutableArray *timestampArray = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"MaxTimestammpList"]];
        NSString *newtimestamp = [NSString stringWithFormat:@"%@",[timestampArray valueForKey:@"Maxtimestamp"]];
        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@" "withString:@""];
        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@"\n"withString:@""];
        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@"("withString:@""];
        newtimestamp = [newtimestamp stringByReplacingOccurrencesOfString:@")"withString:@""];
        
        NSMutableArray *fetchingChat = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"MessageList"]];
        if ([fetchingChat count] != 0) {
            NSLog(@"MAXIMUM TIME STAMP .... %@",newtimestamp);
            [defaults setObject:newtimestamp forKey:@"Customer Incoming Chat Timestamp"];
            
            NSMutableArray *fetchMessages = [NSMutableArray arrayWithArray:[[fetchingChat valueForKey:@"listMessage"]objectAtIndex:0]];
            for (int i = 0; i < [fetchMessages count]; i++)
            {
                docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                documentsDir = [docPaths objectAtIndex:0];
                dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
                database = [FMDatabase databaseWithPath:dbPath];
                [database open];
                NSString *compairStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"CompareDate"]];
                NSString *dateStr = [NSString stringWithFormat:@"%@",[[fetchMessages valueForKey:@"time"]objectAtIndex:i]];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSDate *dateFromStr = [formatter dateFromString:dateStr];
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                [formatter1 setDateFormat:@"dd-MM-yyyy"];
                dateStr = [formatter1 stringFromDate:dateFromStr];
                NSString *dateChangedString;
                if (![dateStr isEqualToString:compairStr]) {
                    dateChangedString =[NSString stringWithFormat:@"YES"];
                }else{
                    dateChangedString =[NSString stringWithFormat:@"NO"];
                }
                
                [[NSUserDefaults standardUserDefaults] setValue:dateStr forKey:@"CompareDate"];
                NSString *insert = [NSString stringWithFormat:@"INSERT INTO tableChat (tableid, serviceProviderId, message, time,sender,isDateChanged) VALUES (\"%@\",\"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",[[fetchMessages valueForKey:@"tableid"] objectAtIndex:i],[[fetchMessages valueForKey:@"serviceproviderid"]objectAtIndex:i],[[fetchMessages valueForKey:@"message"]objectAtIndex:i],[[fetchMessages valueForKey:@"time"]objectAtIndex:i],[[fetchMessages valueForKey:@"sender"]objectAtIndex:i],dateChangedString];
                [database executeUpdate:insert];
            }
        }
        [self fetchChatFromDB];
        
        
    }else if(webServiceCode == 0){
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        if ([chatTrigger isEqualToString:@"ping"]) {
            NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
            
            
        }
        [self.view setUserInteractionEnabled:YES];
        [self fetchHelpMessage];
    }
    
}
-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    
    [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.chatTableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.chatTableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}


- (IBAction)sendMessage:(id)sender {
    NSString*messageStr=[self.chatMessageTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (messageStr.length>0)
        
    {
        [self.view setUserInteractionEnabled:NO];
        [self sendHelpMessage];
    }
    
    
    [self.chatMessageTxtView resignFirstResponder];
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [allChatMessages count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    NSLog(@"All Mesages %@",allChatMessages);
    return [allChatMessages objectAtIndex:row];
}

#pragma mark - TextView Delegates implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = self.chatScroller.contentOffset;
    
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:self.chatScroller];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 200;
    [self.chatScroller setContentOffset:pt animated:YES];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.chatScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.chatScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)menuBtn:(id)sender {
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
- (IBAction)newOrderAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = YES;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)orderHistoryAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 1;
    [self.navigationController pushViewController:ordrVc animated:YES];
}

- (IBAction)spcornerAction:(id)sender {
    OrdersListViewController*ordrVc=[[OrdersListViewController alloc]initWithNibName:@"OrdersListViewController" bundle:nil];
    ordrVc.flagValue = 2;
    [self.navigationController pushViewController:ordrVc animated:YES];
}
- (IBAction)requestAssistanceAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"0" forKey:@"Chat Count"] ;
    self.assisstanceNotificationBadgeImg.hidden = YES;
    self.assisstanceNotificationBadgeLbl.hidden = YES;
    requestAssistanceViewController *requestVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestVC animated:NO];
}


- (IBAction)exitAction:(id)sender {
    [self.exitPopUpView setFrame:CGRectMake(0, 0, self.exitPopUpView.frame.size.width, self.exitPopUpView.frame.size.height)];
    [self.view addSubview:self.exitPopUpView];}

- (IBAction)menuAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)sideMenuAction:(id)sender {
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

- (IBAction)appHomeAction:(id)sender {
    appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
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
-(void) FadeView
{
    [UIView animateWithDuration:0.9
                     animations:^{self.pingMessageView.alpha = 0.0;}
                     completion:^(BOOL finished){self.pingMessageView.hidden = YES;}];
}
-(void) fetchChatFromDB{
    fetchedChatData = [[NSMutableArray alloc]init];
    NSMutableArray *chatMessages = [[NSMutableArray alloc]init];
    NSMutableArray *chatTime = [[NSMutableArray alloc]init];
    NSMutableArray *chatSender = [[NSMutableArray alloc]init];
    NSMutableArray *chatdateChanged = [[NSMutableArray alloc]init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
       NSString *tableID = [NSString stringWithFormat:@"'%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"Table ID"]];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM tableChat where tableId = %@",tableID];
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        fetchChatObj = [[fetchChatOC alloc]init];
        
        fetchChatObj.chatMessage = [results stringForColumn:@"message"];
        fetchChatObj.chatTime = [results stringForColumn:@"time"];
        fetchChatObj.chatSender =[results stringForColumn:@"sender"];
        fetchChatObj.TableId = [results stringForColumn:@"tableid"];
        fetchChatObj.isDateChanged = [results stringForColumn:@"isDateChanged"];
        [chatMessages addObject:fetchChatObj.chatMessage];
        [chatTime addObject:fetchChatObj.chatTime];
        [chatSender addObject:fetchChatObj.chatSender];
        [chatdateChanged addObject:fetchChatObj.isDateChanged];
        [fetchedChatData addObject:fetchChatObj];
    }
    
    allChatMessages = [[NSMutableArray alloc]init];
    
    chatDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:chatMessages,@"messages",chatTime,@"time",chatSender,@"sender",chatdateChanged,@"isDateChanged", nil];
    NSLog(@"CHAT OBJECT ... %@",chatDictionary);
    for (int i = 0; i < [chatMessages count]; i++) {
        chatObj = [[chatOC alloc]init];
        chatObj.chatMessage = [[chatDictionary valueForKey:@"messages"] objectAtIndex:i];
        chatObj.chatTime = [[chatDictionary valueForKey:@"time"] objectAtIndex:i];
        chatObj.chatSender = [[chatDictionary valueForKey:@"sender"] objectAtIndex:i];
        chatObj.isDateChanged = [[chatDictionary valueForKey:@"isDateChanged"] objectAtIndex:i];
        [chatArray addObject:chatObj];
        NSLog(@"CHAT OBJECT ... %@",chatObj.chatSender);
        NSBubbleData *Bubble;
        NSString *senderChat =[NSString stringWithFormat:@"%@",chatObj.chatSender];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@")" withString:@""];
        senderChat = [senderChat stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *chatMessage =[NSString stringWithFormat:@"%@",chatObj.chatMessage];
        chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
        chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        NSString *dateChanged =[NSString stringWithFormat:@"%@",chatObj.isDateChanged];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@")" withString:@""];
        dateChanged = [dateChanged stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        NSString *chatTime =[NSString stringWithFormat:@"%@",chatObj.chatTime];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@")" withString:@""];
        chatTime = [chatTime stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *dateFromString = [[NSDate alloc] init];
       
        dateFromString = [dateFormatter dateFromString:chatTime];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *datestr = [dateFormatter1 stringFromDate:dateFromString];
        NSDate *messageDate = [dateFormatter1 dateFromString:datestr];
        
        if([senderChat isEqualToString:@"table"]){
            Bubble = [NSBubbleData dataWithText:chatMessage date:messageDate type:BubbleTypeMine isDateChanged:dateChanged isCorner:@"Table"];
            Bubble.avatar = [UIImage imageNamed:@"avatar1.png"];
        }else{
            Bubble = [NSBubbleData dataWithText:chatMessage date:messageDate type:BubbleTypeSomeoneElse isDateChanged:dateChanged isCorner:@"Table"];
            Bubble.avatar = nil;
        }
        
        [allChatMessages addObject:Bubble];
    }
    
    self.chatTableView.bubbleDataSource = self;
    self.chatTableView.snapInterval = 120;
    self.chatTableView.showAvatars = YES;
    self.chatTableView.typingBubble = NSBubbleTypingTypeSomebody;
    
    [self.chatTableView reloadData];
    
    
    
    self.chatTableView.bubbleDataSource = self;
    
    self.chatTableView.snapInterval = 120;
    
    [self performSelector:@selector(goToBottom) withObject:nil afterDelay:0.001];
    self.chatTableView.typingBubble = NSBubbleTypingTypeSomebody;
    NSLog(@"CHAT Array %@",chatObj);
    self.chatMessageTxtView.text = @"";
    [self.chatTableView reloadData];
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
