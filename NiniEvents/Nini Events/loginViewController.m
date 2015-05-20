//
//  loginViewController.m
//  Nini Events
//
//  Created by Krishna_Mac_1 on 11/17/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import "loginViewController.h"
#import "homeViewController.h"
#import "serviceProviderHomeViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "appHomeViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "Base64.h"
@interface loginViewController ()

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self menuItems];
    [self.userPasswordTxt setDelegate:self];
    appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.navigator.navigationBarHidden = YES;
    [self.userPasswordTxt setDelegate:self];
    [self.userNameTxt setDelegate:self];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
       // [self menuItems];
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

- (IBAction)login:(id)sender {
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];
    [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.userPasswordTxt resignFirstResponder];
    if ([self.userNameTxt.text isEqualToString:@""] || [self.userPasswordTxt.text isEqualToString:@""]) {
        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Nini Events" message:@"Please enter the required information." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [registeralert show];
//    }
//    else if ([emailTest evaluateWithObject:self.userNameTxt.text] != YES)
//    {
//        UIAlertView *registeralert = [[UIAlertView alloc] initWithTitle:@"Nini Events" message:@"Please enter valid user email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [registeralert show];
    }else{
        [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.userPasswordTxt resignFirstResponder];
        NSString *userID = [NSString stringWithFormat:@"%@",self.userNameTxt.text];
        NSString *password = [NSString stringWithFormat:@"%@",self.userPasswordTxt.text];
        [self loginWebservice:userID :password];
        
    }
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    svos = self.loginScroller.contentOffset;
    
    if (textField == self.userNameTxt || textField == self.userPasswordTxt) {
        
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:self.loginScroller];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 100;
        [self.loginScroller setContentOffset:pt animated:YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.loginScroller setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}
-(void)menuItems
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *timeStamp = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"menuTimeStamp"]];
    if ([timeStamp isEqualToString:@"(null)"]) {
        timeStamp = [NSString stringWithFormat:@"-1"];
    }
     NSString *eventId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:timeStamp, @"Timestamp",eventId,@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchCategoryItems",Kwebservices]];
   
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =2;
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


-(void)loginWebservice:(NSString *)userid:(NSString *)password
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:userid,@"UserId",password, @"Password", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/Login",Kwebservices]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =3;
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
    
    if (webServiceCode == 1) {
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        [self enable];
        [activityIndicator stopAnimating];
        eventImagesSlideViewViewController *homeVC= [[eventImagesSlideViewViewController alloc]initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
        [self.navigationController pushViewController:homeVC animated:YES];
    }
    else if (webServiceCode == 2){
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
            NSLog(@"responseString:%@",responseString);
            NSError *error;
            
            responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
            
            SBJsonParser *json = [[SBJsonParser alloc] init];
            menuDetails = [[NSMutableArray alloc]init];
            menuCategoryIdsArray = [[NSMutableArray alloc]init];
            menuItemsDetail = [[NSMutableArray alloc] init];
            itemsIdsArray = [[NSMutableArray alloc]init];
            NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
            NSLog(@"Dictionary %@",userDetailDict);
            if (userDetailDict.count != 0) {
             
            NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"updatedtimestamp"]];
            [defaults setObject:resultStr forKey:@"menuTimeStamp"];
            NSMutableArray *menuData = [[NSMutableArray alloc] initWithArray:[userDetailDict valueForKey:@"listCategory"]];
            for (int i =0; i < [menuData count]; i++) {
                menuObj = [[menuOC alloc]init];
                menuObj.categoryID = [[[menuData valueForKey:@"categoryId"] objectAtIndex:i] intValue];
                menuObj.categoryName = [[menuData valueForKey:@"categoryName"] objectAtIndex:i];
                menuObj.type = [[menuData valueForKey:@"type"] objectAtIndex:i];
                
                menuObj.isDeleted = [[[menuData valueForKey:@"IsDeleted"] objectAtIndex:i]intValue];
                menuObj.itemsList = [[menuData valueForKey:@"listFoodItems"] objectAtIndex:i];
                
                for (int j = 0;j<[menuObj.itemsList count]; j++) {
                    
                    menuItemsObj = [[menuItemsOC alloc]init];
                    menuItemsObj.categoryId = [[NSString stringWithFormat:@"%d",menuObj.categoryID]intValue];
                    menuItemsObj.ItemId = [[[menuObj.itemsList valueForKey:@"ItemId"] objectAtIndex:j]intValue];
                    menuItemsObj.ItemName = [[menuObj.itemsList valueForKey:@"ItemName"] objectAtIndex:j];
                    menuItemsObj.Cuisine = [[menuObj.itemsList valueForKey:@"Cuisine"] objectAtIndex:j];
                    menuItemsObj.type = [[menuObj.itemsList valueForKey:@"Type"] objectAtIndex:j];
                    menuItemsObj.Quantity = [[[menuObj.itemsList valueForKey:@"Quantity"] objectAtIndex:j] intValue];
                    menuItemsObj.Price = [[menuObj.itemsList valueForKey:@"Price"] objectAtIndex:j];
                    menuItemsObj.Image = [[menuObj.itemsList valueForKey:@"Image"] objectAtIndex:j];
                    menuItemsObj.Image = [menuItemsObj.Image stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", menuItemsObj.Image]];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [UIImage imageWithData:data];
                    
                    NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
                    NSString *strEncoded = [Base64 encode:imgdata];
                    menuItemsObj.Image = [NSString stringWithString:strEncoded];
                    menuObj.imageUrl = strEncoded;
                    menuItemsObj.IsDeletedItem = [[[menuObj.itemsList valueForKey:@"IsDeleted"] objectAtIndex:j] intValue];
                    [menuItemsDetail addObject:menuItemsObj];
                    [itemsIdsArray addObject:[NSString stringWithFormat:@"%d",menuItemsObj.ItemId]];
                }
                
                [menuDetails addObject:menuObj];
                [menuCategoryIdsArray addObject:[NSString stringWithFormat:@"%d",menuObj.categoryID]];
            }
            
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            
            NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM menu "];
            FMResultSet *results1 = [database executeQuery:queryString1];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            while([results1 next]) {
                [tempArray addObject:[results1 stringForColumn:@"categoryID"]];
            }
            
            
            for (int i = 0;i < [menuCategoryIdsArray count]; i++) {
                menuObj = [menuDetails objectAtIndex:i];
                if ([tempArray containsObject:[menuCategoryIdsArray objectAtIndex:i]]) {
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE menu SET categoryName = \"%@\" , type = \"%@\",imageUrl = \"%@\" , where categoryID = %d" ,menuObj.categoryName,menuObj.type,menuObj.imageUrl,menuObj.categoryID];
                    [database executeUpdate:updateSQL];
                }else{
                    NSString *insert = [NSString stringWithFormat:@"INSERT INTO menu (categoryID, categoryName, type, imageUrl) VALUES (%d, \"%@\", \"%@\", \"%@\")",menuObj.categoryID,menuObj.categoryName,menuObj.type,menuObj.imageUrl];
                    [database executeUpdate:insert];
                }
                
            }
            //
            //
            //
            //            NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu where type = \"%@\"", [NSString stringWithFormat:@"Food"]];
            //            FMResultSet *results = [database executeQuery:queryString];
            //
            //
            //            while([results next]) {
            //                menuObj = [[menuOC alloc] init];
            //                menuObj.categoryID = [results intForColumn:@"categoryID"];
            //                menuObj.categoryName = [results stringForColumn:@"categoryName"];
            //                menuObj.type = [results stringForColumn:@"type"];
            //            }
            
            NSString *itemsQueryString = [NSString stringWithFormat:@"Select * FROM categoryItems "];
            FMResultSet *itemsResults = [database executeQuery:itemsQueryString];
            NSMutableArray *itemsTempArray = [[NSMutableArray alloc] init];
            while([itemsResults next]) {
                [itemsTempArray addObject:[itemsResults stringForColumn:@"itemID"]];
            }
            for (int i = 0;i < [itemsIdsArray count]; i++) {
                
                menuItemsObj = [menuItemsDetail objectAtIndex:i];
                if ([itemsTempArray containsObject:[itemsIdsArray objectAtIndex:i]]) {
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE categoryItems SET itemName = \"%@\" , cuisine = \"%@\", categoryID = %d, typeID=\"%@\" ,quantity=%d ,itemPrice=\"%@\" ,itemImage=\"%@\" where itemID = %d" ,menuItemsObj.ItemName,menuItemsObj.Cuisine,menuItemsObj.categoryId,menuItemsObj.type,menuItemsObj.Quantity,menuItemsObj.Price,menuItemsObj.Image,menuItemsObj.ItemId];
                    [database executeUpdate:updateSQL];
                }else{
                    
                    NSString *insert = [NSString stringWithFormat:@"INSERT INTO categoryItems (itemID, itemName, cuisine, categoryID, typeID, quantity,itemPrice, itemImage) VALUES (%d, \"%@\", \"%@\",%d,\"%@\",%d,\"%@\",\"%@\")",menuItemsObj.ItemId,menuItemsObj.ItemName,menuItemsObj.Cuisine,menuItemsObj.categoryId,menuItemsObj.type,menuItemsObj.Quantity,menuItemsObj.Price,menuItemsObj.Image];
                    [database executeUpdate:insert];
                }
                
            }
            [database close];
            //[self loginWebservice:[NSString stringWithFormat:@"table3@test.com"] :[NSString stringWithFormat:@"table3"]];
                
        }
        }
        [self fetchBannerImages];
        
    }
    
    else if(webServiceCode == 3){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
        NSString *prevEventIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
        
        [defaults setObject:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"role"]] forKey:@"Role"];
        if ([resultStr isEqualToString:@"0"]) {
            if ([[userDetailDict valueForKey:@"role"] isEqualToString:@"ServiceProvider"]) {
                tablesArray = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"listTables"]];
                [defaults setObject:tablesArray forKey:@"Alloted Tables"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [defaults setValue:[userDetailDict valueForKey:@"id"] forKey:@"Service Provider ID"];
                [defaults setValue:[userDetailDict valueForKey:@"name"] forKey:@"Service Provider Name"];
                [defaults setValue:[userDetailDict valueForKey:@"image"] forKey:@"Service Provider image"];
                [defaults setValue:[userDetailDict valueForKey:@"eventId"] forKey:@"Event ID"];
                serviceProviderHomeViewController *serviceProviderHomeVC= [[serviceProviderHomeViewController alloc]initWithNibName:@"serviceProviderHomeViewController" bundle:nil];
                
                [self.navigationController pushViewController:serviceProviderHomeVC animated:YES];
            }else{
                tablesArray = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"listTables"]];
                [defaults setObject:tablesArray forKey:@"Alloted Service Provider"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [defaults setValue:[userDetailDict valueForKey:@"id"] forKey:@"Table ID"];
                [defaults setValue:[userDetailDict valueForKey:@"name"] forKey:@"Table Name"];
                [defaults setValue:[userDetailDict valueForKey:@"image"] forKey:@"Table image"];
                [defaults setValue:[userDetailDict valueForKey:@"eventId"] forKey:@"Event ID"];
                NSString *newEventIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
                
//                if (![prevEventIdStr isEqualToString:newEventIdStr]) {
                    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    documentsDir = [docPaths objectAtIndex:0];
                    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
                    database = [FMDatabase databaseWithPath:dbPath];
                    [database open];
                    
                    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM categoryItems"];
                    [database executeUpdate:queryString1];
                    NSString *queryString2 = [NSString stringWithFormat:@"Delete FROM menu"];
                    [database executeUpdate:queryString2];
                    
                    [database close];
                    [defaults setValue:@"-1" forKey:@"menuTimeStamp"];
//                }
                [self menuItems];
                
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[NSString stringWithFormat:@"NO"] forKey:@"isLogedOut"];
            
        }else{
            [self enable];
            [activityIndicator stopAnimating];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"GOGO EVENTS" message:[userDetailDict valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }else if (webServiceCode == 4){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSMutableArray *fetchingImages = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"ListBanner"]];
        imagesUrlArray = [[NSMutableArray alloc]init];
        for (int i = 0; i < [fetchingImages count]; i++) {
            
            NSString *urlStr = [NSString stringWithFormat:@"%@",[[fetchingImages valueForKey:@"URL"] objectAtIndex:i]];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlStr]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            
            NSData* imgdata = UIImageJPEGRepresentation(img, 0.3f);
            NSString *strEncoded = [Base64 encode:imgdata];
            
            urlStr = [NSString stringWithString:strEncoded];
            [imagesUrlArray addObject:urlStr];
        }
        [defaults setObject:imagesUrlArray forKey:@"ImageArray"];
        [self registerDevice];
    }
    
    
    
}
-(void)registerDevice
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *role;
    NSString *deviceUDID;
    NSString *tokenId;
    NSString *triggerValue;
    NSString *tableID;
    NSString *serviceProviderID;
    NSUUID *myDevice1 = [[UIDevice currentDevice] identifierForVendor];
    NSLog(@"udid is %@",myDevice1.UUIDString);
    NSString *deviceUdid=myDevice1.UUIDString;
    NSLog(@"Device Tocken is %@",[defaults valueForKey:@"DeviceToken"]);
    NSString *user_UDID_Str=[NSString stringWithString:deviceUdid];
    if (role == nil) {
        role =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Role"]];
    }
    if (deviceUDID == nil) {
        deviceUDID = [NSString stringWithFormat:@"%@",user_UDID_Str];
    }
    if (tokenId == nil) {
        tokenId = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"DeviceToken"]];
    }
    if (triggerValue == nil) {
        triggerValue = [NSString stringWithFormat:@"ios"];
    }
    if (tableID == nil) {
        if ([role isEqualToString:@"customer"]) {
            tableID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
        }else{
            tableID = [NSString stringWithFormat:@"0"];
        }
    }
    if (serviceProviderID == nil) {
        if ([role isEqualToString:@"serviceprovider"]) {
            serviceProviderID = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Service Provider ID"]];
        }else{
            serviceProviderID = [NSString stringWithFormat:@"0"];
        }
    }
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:role,@"Role",[NSString stringWithFormat:@"1"], @"RestaurantId",tableID,@"TableId",serviceProviderID,@"StaffId",deviceUDID, @"DeviceUDId",tokenId,@"TokenID",triggerValue, @"Trigger", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RegisterDevice",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    webServiceCode = 1;
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
-(void) fetchBannerImages
{
    [activityIndicator startAnimating];
    NSString *eventId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Event ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:eventId,@"EventId", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetBanners",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"Post"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode = 4;
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
- (IBAction)ForgotPassword:(id)sender {
    
}

@end
