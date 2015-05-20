//
//  CheckOutViewController.m
//  Nini Events
//
//  Created by Br@R on 29/01/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "CheckOutViewController.h"
#import "orderOC.h"
#import "OrderTableViewCell.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "OrdersListViewController.h"
#import "homeViewController.h"
#import "requestAssistanceViewController.h"
#import "loginViewController.h"
#import "appHomeViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
#import "NSData+Base64.h"
@interface CheckOutViewController ()

@end

@implementation CheckOutViewController

- (void)viewDidLoad {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"ON"]) {
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
    }
    else{
        
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb.png"]];
    }
    self.notesTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.notesTextView.layer.borderWidth = 1.0;
    self.notesTextView.layer.cornerRadius = 5.0;
    [self.notesTextView setClipsToBounds:YES];
    orderList=[[NSMutableArray alloc]init];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor grayColor];
    [self.view addSubview:activityIndicator];
    self.orderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

    
    [self fetchOrders];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)fetchOrders
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results = [database executeQuery:queryString];
    
    orderList = [[NSMutableArray alloc] init];
    int k = 0 ;
    
    while([results next]) {
        orderObj = [[orderOC alloc]init];
        orderObj.orderItemName=[results stringForColumn:@"orderItemName"];
        orderObj.orderQuantity = [results intForColumn:@"orderQuantity"];
        orderObj.orderItemID = [results intForColumn:@"orderItemID"];
        orderObj.orderPrice = [results intForColumn:@"orderPrice"];
        orderObj.orderImage = [results stringForColumn:@"orderItemImage"];
        [orderList addObject:orderObj];
        
        int j = orderObj.orderPrice ;
        j=j+k;
        k= j;
    }
    NSString *orderCount =[NSString stringWithFormat:@"%lu",(unsigned long)[orderList count]];
    NSLog(@"Order Count .... %@",orderCount);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:orderCount forKey:@"Order Item Count"];
    
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
    
    self.batchLbl.text = [NSString stringWithFormat:@"%@",orderCount];
    float delievrycharg=0.00;
    float taxes=0.00;
    taxesPriceLbl.text=[NSString stringWithFormat:@"$%.2f",taxes];
    deliveryChargPriceLbl.text=[NSString stringWithFormat:@"$%.2f",delievrycharg];
    foodDrinkPriceLbl.text = [NSString stringWithFormat:@"$%d.00",k];
    totalPrice=k+taxes+delievrycharg;
    orderTotalPriceLbl.text=[NSString stringWithFormat:@"$%.2f",k+taxes+delievrycharg];
    [database close];
    
    [self.orderTableView reloadData];
    [foodDrinkPriceLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [deliveryChargPriceLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [taxesPriceLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [self.foodDrinkLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [self.deliverChargeLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
    [self.taxLbl setFont:[UIFont fontWithName:@"Bebas Neue" size:20]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    [emptyCartLabel removeFromSuperview];
    if (orderList.count==0)
    {
        self.emptyOrderListView.hidden = NO;
//        checkoutPriceDetailView.hidden=YES;
//        self.orderTableView .hidden=YES;
//        emptyCartLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 80, 1024, 500)];
//        emptyCartLabel.text=@"YOUR CART IS EMPTY.";
//        emptyCartLabel.textAlignment = NSTextAlignmentCenter;
//        [emptyCartLabel setFont:[UIFont fontWithName:@"Bebas Neue" size:60]];
//        
//        [emptyCartLabel setUserInteractionEnabled:YES];
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyCartLabelTappedAction:)];
//        [tapGestureRecognizer setNumberOfTapsRequired:1];
//        [emptyCartLabel addGestureRecognizer:tapGestureRecognizer];
//        
//        [self.view addSubview:emptyCartLabel];
//        
//        orderSomthing = [[UIButton alloc]initWithFrame:CGRectMake(415, 450, 200, 60)];
//        [orderSomthing setTitle:[NSString stringWithFormat:@"START A NEW ORDER"] forState:UIControlStateNormal];
//        UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"viewdetail"];
//        
//        [orderSomthing setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
//        [orderSomthing setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
//        [orderSomthing setUserInteractionEnabled:YES];
//        orderSomthing.titleLabel.font =[UIFont fontWithName:@"Helvetica-Condensed" size:20];
//        
//        [orderSomthing addTarget:self action:@selector(orderSomthingAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:orderSomthing];
        
        
    }
    else {
        self.emptyOrderListView.hidden = YES;
    }
    return [orderList count];
    
    
    
}
-(void)orderSomthingAction
{
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
}
-(IBAction)emptyCartLabelTappedAction:(id)sender
{
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = NO;
    [self.navigationController pushViewController:homeVC animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    OrderTableViewCell *cell = (OrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    orderOC *ordrobject = (orderOC *)[orderList objectAtIndex:indexPath.row];
    NSData *data = [[NSData alloc] initWithData:[NSData
                                                 dataFromBase64String:[NSString stringWithFormat:@"%@",ordrobject.orderImage]]];
    
    UIImage *itemsImage = [UIImage imageWithData:data];
    
    
    [cell setLabelText:ordrobject.orderItemName :ordrobject.orderQuantity :[NSString stringWithFormat:@"%d",ordrobject.orderPrice] :itemsImage];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    deleteBtn.frame = CGRectMake(170.0f, 80.0f, 50.0f, 50.0f);
    deleteBtn.tag = indexPath.row;
    
    [deleteBtn setTintColor:[UIColor colorWithRed:159.0f/255.0 green:14.0f/255.0 blue:14.0f/255.0 alpha:1.0]] ;
    
    
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    increaseItemBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    increaseItemBtn.frame = CGRectMake(681, 104.0f, 30.0f, 35.0f);
    increaseItemBtn.tag = indexPath.row;
    [increaseItemBtn setTintColor:[UIColor colorWithRed:159.0f/255.0 green:14.0f/255.0 blue:14.0f/255.0 alpha:1.0]] ;
    [cell.contentView addSubview:increaseItemBtn];
    
    //    [increaseItemBtn addTarget:self action:@selector(increaseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    decreaseItemBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    decreaseItemBtn.frame = CGRectMake(600.0f, 104.0f, 30.0f, 35.0f);
    decreaseItemBtn.tag = indexPath.row;
    [decreaseItemBtn setTintColor:[UIColor colorWithRed:159.0f/255.0 green:14.0f/255.0 blue:14.0f/255.0 alpha:1.0]] ;
    [cell.contentView addSubview:decreaseItemBtn];
    
    //    [decreaseItemBtn addTarget:self action:@selector(decreaseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundDelete= [UIImage imageNamed:@"delete.png"];
    UIImage *buttonBackgroundincrease= [UIImage imageNamed:@"increaseselect.png"];
    UIImage *buttonBackgroundDecrease= [UIImage imageNamed:@"decreaseselect.png"];
   
    [deleteBtn setBackgroundImage:buttonBackgroundDelete forState:UIControlStateNormal];
    [increaseItemBtn setBackgroundImage:buttonBackgroundincrease forState:UIControlStateNormal];
    [decreaseItemBtn setBackgroundImage:buttonBackgroundDecrease forState:UIControlStateNormal];
    [cell.contentView addSubview:deleteBtn];
    NSMutableArray* quantityCounts = [[NSMutableArray alloc] init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where itemID = %d", ordrobject.orderItemID];
    FMResultSet *results = [database executeQuery:queryString];
    
    int  maxQty=0;
    while([results next])
    {
        maxQty =[[results stringForColumn:@"quantity"]intValue];
        NSLog(@"Max Value %d",maxQty);
    }
    int k = 0;
    for (int j =1; j <= k; j++)
    {
        [quantityCounts addObject:[NSString stringWithFormat:@"%d",j]];
    }
    
    if (ordrobject.orderQuantity ==maxQty)
    {
        [increaseItemBtn setBackgroundImage:[UIImage imageNamed:@"increase.png"] forState:UIControlStateNormal];
        // [increaseItemBtn setUserInteractionEnabled:NO];
    }
    else{
        [increaseItemBtn addTarget:self action:@selector(increaseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (ordrobject.orderQuantity ==1)
    {
        [decreaseItemBtn setBackgroundImage:[UIImage imageNamed:@"decrease.png"] forState:UIControlStateNormal];
        // [decreaseItemBtn setUserInteractionEnabled:NO];
    }
    else{
        [decreaseItemBtn addTarget:self action:@selector(decreaseItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [database close];
    
    return cell;
}


- (IBAction)deleteBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    orderOC *ordr = (orderOC *)[orderList objectAtIndex:indexPath.row];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Delete FROM orderHistory WHERE orderItemID = %d ",ordr.orderItemID];
    [database executeUpdate:queryString];
    [database close];
    [self fetchOrders];
    [self.orderTableView reloadData];
    
}

- (IBAction)increaseItemBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    orderOC *ordr = (orderOC *)[orderList objectAtIndex:indexPath.row];
    
    NSString *currentValue = [NSString stringWithFormat:@"%d",ordr.orderQuantity];
    int quantity = [currentValue integerValue];
    quantity += 1;
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where categoryID = \"%d\"", ordr.orderItemID];
    FMResultSet *results = [database executeQuery:queryString];
    
    int  maxQty=0;
    while([results next])
    {
        maxQty =[[results stringForColumn:@"quantity"]intValue];
        NSLog(@"Max Value %d",maxQty);
    }
    [database close];
    
    [self orderList:[NSString stringWithFormat:@"%d",ordr.orderItemID] :quantity];
    
    [self fetchOrders];
    
}
- (IBAction)decreaseItemBtnAction:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    orderOC *ordr = (orderOC *)[orderList objectAtIndex:indexPath.row];
    
    
    NSString *currentValue = [NSString stringWithFormat:@"%d",ordr.orderQuantity];
    int quantity = [currentValue integerValue];
    quantity -= 1;
    
    [self orderList:[NSString stringWithFormat:@"%d",ordr.orderItemID] :quantity];
    
    [self fetchOrders];
}


-(void) orderList:(NSString *)itemsID:(int)orderItemQuantities
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results1 = [database executeQuery:queryString1];
    NSMutableArray *tempOrder = [[NSMutableArray alloc] init];
    while ([results1 next]) {
        [tempOrder addObject:[results1 stringForColumn:@"orderItemID"]];
    }
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where itemID = \"%@\"",[NSString stringWithString:itemsID]];
    FMResultSet *results = [database executeQuery:queryString];
    //    menuCategoryArray = [[NSMutableArray alloc] init];
    //    menuCategoryId = [[NSMutableArray alloc]init];
    while([results next]) {
        
        NSString *totalValue = [results stringForColumn:@"itemPrice"];
        int tPrice = [totalValue intValue];
        
        tPrice = tPrice * orderItemQuantities;
        
        if ([tempOrder containsObject:[NSString stringWithFormat:@"%@",itemsID]]) {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE orderHistory SET orderItemName = \"%@\" , ordercuisine = \"%@\", orderType = \"%@\", orderQuantity = %d, orderPrice = \"%d\" where orderItemID = \"%@\"" ,[results stringForColumn:@"itemName"],[results stringForColumn:@"cuisine"],[results stringForColumn:@"typeID"],orderItemQuantities,tPrice,[NSString stringWithFormat:@"%@",itemsID]];
            [database executeUpdate:updateSQL];
        }else{
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO orderHistory (orderItemID, orderItemName, ordercuisine, orderType, orderQuantity, orderPrice) VALUES (%@, \"%@\",\"%@\",\"%@\", \"%d\",\"%d\")",[results stringForColumn:@"itemID"],[results stringForColumn:@"itemName"],[results stringForColumn:@"cuisine"],[results stringForColumn:@"typeID"],orderItemQuantities,tPrice];
            [database executeUpdate:insert];
        }
    }
    [database close];
}

- (IBAction)CheckOutBtn:(id)sender
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    NSMutableArray *placeOrderArray = [[NSMutableArray alloc]init];
    
    NSLog(@"ordrlist count ..%d  ",orderList.count);
    for (int i= 0; i < [orderList count]; i ++) {
        
        orderOC* placeOrderObj= [[orderOC alloc]init];
        placeOrderObj = [orderList objectAtIndex:i];
        
        NSLog(@"placeOrderObj.Price ..%d  ",placeOrderObj.orderPrice);
        NSLog(@"placeOrderObj.Quantity ..%d  ", placeOrderObj.orderQuantity);
        
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",placeOrderObj.orderItemID],@"ItemId",[NSString stringWithFormat:@"%d",placeOrderObj.orderQuantity],@"Quantity",[NSString stringWithFormat:@"%d",placeOrderObj.orderPrice],@"Price", nil];
        
        NSLog(@"Object %@", postDict);
        [placeOrderArray addObject:postDict];
        
    }
    NSError *err;
    NSDictionary * jsonArray = [[NSDictionary alloc] initWithObjectsAndKeys:placeOrderArray,@"objPlaceOrder", nil];
    NSLog(@"Objects Array %@", placeOrderArray);
    NSString *tableIds = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *PlaceOrders = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonString,@"objPlaceOrder",tableIds,@"tableId",[NSString stringWithFormat:@"1"],@"restaurantId",[NSString stringWithFormat:@"%.2f",totalPrice],@"totalbill",[NSString stringWithFormat:@"%@",self.notesTextView.text],@"notes",date_String,@"datetimeoforder",[defaults valueForKey:@"Event ID"],@"EventId", nil];
    
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:PlaceOrders options:NSJSONWritingPrettyPrinted error:&err];
    
    NSLog(@"JSON = %@", [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding]);
    // Checking the format
    NSLog(@"%@",[[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding]);
    NSString *jsonRequest = [PlaceOrders JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
   
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/PlaceOrders",Kwebservices]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =1;
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
    [self enable];
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
    if (webServiceCode == 0) {
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
       
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
        if([resultStr isEqualToString:@"0"])
        {
           
            [defaults setValue:@"" forKey:@"Note"];
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            
            NSString *queryString = [NSString stringWithFormat:@"Delete FROM orderHistory "];
            [database executeUpdate:queryString];
            [database close];
            
            [self fetchOrders];
            [self.orderTableView reloadData];
            
            menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
            homeVC.isNewOrder = NO;
            homeVC.isOrderPlaced = YES;
            [self.navigationController pushViewController:homeVC animated:NO];
        }
        [self enable];
        [activityIndicator stopAnimating];
    }
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
    [self.view addSubview:self.exitPopUpView];
}

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
    }else if( alertView.tag == 999 && buttonIndex == 0){
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString = [NSString stringWithFormat:@"Delete FROM orderHistory "];
        [database executeUpdate:queryString];
        [database close];
        
        [self fetchOrders];
        [self.orderTableView reloadData];
        
        menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:NO];
        
    }
}
- (IBAction)pingBtnAction:(id)sender {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"bulb"] isEqualToString:@"OFF"]) {
        [self sendHelpMessage];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"ON" forKey:@"bulb"];
        [self.pingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        [self.otherMenuPingBulbImg setImage:[UIImage imageNamed:@"bulb-select.png"]];
        self.pingMessageView.hidden = NO;
        [self.pingMessageView setFrame:CGRectMake(52, 585, self.pingMessageView.frame.size.width, self.pingMessageView.frame.size.height)];
        self.pingMessageView.alpha= 1.0;
        [self.sideScroller addSubview:self.pingMessageView];
        [self.sideScroller bringSubviewToFront:self.pingMessageView];
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

- (IBAction)startNewOrderAction:(id)sender {
    [self orderSomthingAction];
}
- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
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
