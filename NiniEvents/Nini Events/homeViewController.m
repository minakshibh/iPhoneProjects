//
//  homeViewController.m
//  Nini Events
//
//  Created by Krishna_Mac_1 on 11/17/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import "homeViewController.h"
#import "JSON.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "AppDelegate.h"
#import "loginViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "CheckOutViewController.h"
#import "requestAssistanceViewController.h"
#import "OrdersListViewController.h"
#import "appHomeViewController.h"
#import "eventImagesSlideViewViewController.h"
#import "menuStateViewController.h"
#import "NSData+Base64.h"
static int curveValues[] = {
    UIViewAnimationOptionCurveEaseInOut,
    UIViewAnimationOptionCurveEaseIn,
    UIViewAnimationOptionCurveEaseOut,
    UIViewAnimationOptionCurveLinear };
@interface homeViewController ()

@end

@implementation homeViewController

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

    
    NSLog(@"Image Tag Value..... %d",self.itemTag);
    NSLog(@"Menu Tag Value..... %d",self.menuTagValue);
    nameLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
    roleLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
    
    nameLbl.text=[[NSUserDefaults standardUserDefaults ]valueForKey:@"Table Name"];
    roleLbl.text=[[NSUserDefaults standardUserDefaults ]valueForKey:@"Role"];
    NSString*picUrl=[[NSUserDefaults standardUserDefaults ]valueForKey:@"Table image"];
    
    self.subMenuBgView.layer.borderColor = [UIColor colorWithRed:86/255.0f green:86/255.0f blue:86/255.0f alpha:1].CGColor;
    self.subMenuBgView.layer.borderWidth = 1.0;
    
    mainItemName = [NSString stringWithFormat:@"FOOD"];
    if (picUrl.length==0) {
        tableImageView.image = [UIImage imageNamed:@"dummy_user.png"];
    }
    else{
        
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        objactivityindicator.center = CGPointMake((tableImageView.frame.size.width/2),(tableImageView.frame.size.height/2));
        [tableImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *imageURL=[NSURL URLWithString:[picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [tableImageView setImage:imgData];
                                   //  [UserImageDict setObject:imgData forKey:UrlString];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                               else
                               {
                                   //[self.imageview setImage:[UIImage imageNamed:@"dummy_user.png"]];
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.navigator.navigationBarHidden = YES;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    chatUsed = 1;
    activityIndicator.center = CGPointMake(512, 374);
    self.chatView.hidden=YES;
    
    activityIndicator.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicator];
    originalPt.x = self.chatView.frame.origin.x;
    originalPt.y = self.chatView.frame.origin.y;
    notesOriginalPt.x = self.notesPopUpView.frame.origin.x;
    notesOriginalPt.y = self.notesPopUpView.frame.origin.y;
    menuItemsArray = [[NSMutableArray alloc] initWithObjects:@"Food",@"Drink",@"",@"Exit", nil];
    menuDisplayItemsArray = [[NSMutableArray alloc] initWithObjects:@"Food Menu",@"Drink Menu",@"Request Assistance",@"            Exit", nil];
    UIImage *image1 = [UIImage imageNamed:@"foodMenu-icon.png"];
    UIImage *image2 = [UIImage imageNamed:@"drinkMenu-icon.png"];
    UIImage *image3 = [UIImage imageNamed:@"resAssistant-icon.png"];
    UIImage *image4 = [UIImage imageNamed:@"edit-icon.png"];
    menuImages = [[NSArray alloc] initWithObjects:image1,image2,image3,image4,nil];
    
    for (int i = 0; i < [menuItemsArray count]-2; i++) {
        [self fetchDataDB:[menuItemsArray objectAtIndex:i]];
    }
    [self fetchMenuItemsDB:[NSString stringWithFormat:@"1"]];
    
    if (!arrayForBool) {
        arrayForBool=[[NSMutableArray alloc] init];
        
        for (int j = 0; j< [menuItemsArray count]; j++) {
            if (j < 1) {
                [arrayForBool addObject:[NSNumber numberWithBool:YES]];
            }else{
                [arrayForBool addObject:[NSNumber numberWithBool:NO]];
            }
        }
        
    }
    
    [self.menuTableView reloadData];
    [self orderlist];
    [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"Open"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
    
    //~~~~~~~~~~~~~~~~~ 2nd Xib~~~~~~~~~~~~~~~//
    //    self.menuBgView.layer.borderColor = [UIColor grayColor].CGColor;
    //    self.menuBgView.layer.borderWidth = 1.5;
    //    self.menuBgView.layer.cornerRadius = 0.0;
    //
    //    [self.view setUserInteractionEnabled:YES];
    //    for (int i = 0; i < [menuDisplayItemsArray count]; i++) {
    //        UIButton *menuItemBtn;
    //        if (i == 2) {
    //            menuItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(i *85 +105, 5,135, 40)];
    //        }else if (i == 3){
    //            menuItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(i *85 +105, 5, 85, 40)];
    //        }
    //        else{
    //            menuItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(i *85 +105, 5, 85, 40)];
    //        }
    //        menuItemBtn.tag = i;
    //        [menuItemBtn setTitle:[NSString stringWithFormat:@"%@",[menuDisplayItemsArray objectAtIndex:i]] forState:UIControlStateNormal];
    //
    //        [menuItemBtn setTitleColor:[UIColor colorWithRed:12/255.0f green:99/255.0f blue:158/255.0f alpha:1] forState:UIControlStateNormal] ;
    //        [menuItemBtn setUserInteractionEnabled:YES];
    //        menuItemBtn.titleLabel.font =[UIFont fontWithName:@"Helvetica Neue" size:14];
    //
    //        if(i != 3){
    //        UILabel *menuItemSeperator = [[UILabel alloc] initWithFrame:CGRectMake(menuItemBtn.frame.origin.x+menuItemBtn.frame.size.width,0, 1, self.menuBgView.frame.size.height)];
    //        [menuItemSeperator setBackgroundColor:[UIColor grayColor]];
    //        [self.menuBgView addSubview:menuItemSeperator];
    //        }
    //        [menuItemBtn addTarget:self action:@selector(openSubMenu:) forControlEvents:UIControlEventTouchUpInside];
    //        [self.menuBgView addSubview:menuItemBtn];
    //        [self.view bringSubviewToFront:menuItemBtn];
    //        [self.menuBgView bringSubviewToFront:menuItemBtn];
    //   }
    submenuTagValue = 1;
    UIControl* sender;
    
    [self menuItems:sender];
}
- (IBAction)menuItems:(UIControl*)sender {
    for (UIButton* button in self.menuBgView.subviews)
    {
        NSLog(@"object class : %@", [button class]);
        NSLog(@"Button found!.... %ld",(long)button.tag);
        
        if(self.menuTagValue != button.tag){
            [button setBackgroundColor:[UIColor clearColor]];
        }else{
            [button setBackgroundColor:[UIColor colorWithRed:49/255.0f green:48/255.0f blue:45/255.0f alpha:1.0]];
        }
    }
    UIButton *check = (UIButton*)[sender viewWithTag:sender.tag];
    NSLog(@"BUTTON TITLE...... %@",check.titleLabel.text);
    mainItemName = [NSString stringWithFormat:@"%@",check.titleLabel.text ];
    if ([mainItemName isEqualToString:@"FOOD"]) {
        [self.foodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.drinksbtn setTitleColor:[UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1] forState:UIControlStateNormal];
        self.foodMenuImage.image = [UIImage imageNamed:@"foodselect.png"];
        self.drinkMenuImage.image = [UIImage imageNamed:@"drink.png"];
        self.menuTagValue = 1;
        if (sender != nil) {
        drinksButtonTapped = NO;
        }
    }else if ([mainItemName isEqualToString:@"DRINKS"]){
        [self.drinksbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.foodBtn setTitleColor:[UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1] forState:UIControlStateNormal];
        self.foodMenuImage.image = [UIImage imageNamed:@"food.png"];
        self.drinkMenuImage.image = [UIImage imageNamed:@"drinkselect.png"];
        self.menuTagValue = 2;
        if (sender != nil) {
        drinksButtonTapped = YES;
        }
    }
    [self openSubMenu:sender];
}
-(void)openSubMenu:(UIControl*)sender1
{
    for (UIButton* b in self.subMenuBgView.subviews)
    {
        [b removeFromSuperview];
    }
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu "];
    FMResultSet *queryResults = [database executeQuery:queryString];
    menuCategoryArray = [[NSMutableArray alloc] init];
    drinkMenuItems = [[NSMutableArray alloc] init];
    menuCategoryId = [[NSMutableArray alloc]init];
    while([queryResults next]) {
        categoriesType = [queryResults stringForColumn:@"type"];
        [menuCategoryId addObject:[queryResults stringForColumn:@"categoryID"]];
        if ([categoriesType isEqualToString:@"Food"]) {
            [menuCategoryArray addObject:[queryResults stringForColumn:@"categoryName"]];
        }else{
            [drinkMenuItems addObject:[queryResults stringForColumn:@"categoryName"]];
        }
        
        
    }
    [database close];
    
    menuContentDict  = [[NSMutableDictionary alloc] init];
    
    categoryFirst     = [NSArray arrayWithArray:menuCategoryArray];
    [menuContentDict setValue:categoryFirst forKey:[menuItemsArray objectAtIndex:0]];
    
    categorySecond = [NSArray arrayWithArray:drinkMenuItems];
    [menuContentDict setValue:categorySecond forKey:[menuItemsArray objectAtIndex:1]];
    
    NSLog(@"SENDER TAG VALUE..... %ld",(long)sender1.tag);
    UIButton *check = (UIButton*)[sender1 viewWithTag:sender1.tag];
    NSLog(@"BUTTON TITLE...... %@",check.titleLabel.text);
    mainItemName = [NSString stringWithFormat:@"%@",check.titleLabel.text ];
    if (self.menuTagValue == 1) {
        [self.foodBtn setBackgroundColor:[UIColor colorWithRed:49/255.0f green:48/255.0f blue:45/255.0f alpha:1.0]];
        [self.drinksbtn setBackgroundColor:[UIColor clearColor]];
    }else if (self.menuTagValue == 2){
        [self.foodBtn setBackgroundColor:[UIColor clearColor]];
        [self.drinksbtn setBackgroundColor:[UIColor colorWithRed:49/255.0f green:48/255.0f blue:45/255.0f alpha:1.0]];
        
        [check setBackgroundColor:[UIColor colorWithRed:49/255.0f green:48/255.0f blue:45/255.0f alpha:1.0]];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.menuTagValue-1 inSection:0];
    content = [[NSMutableArray alloc] init];
    content = [menuContentDict valueForKey:[menuItemsArray objectAtIndex:indexPath.row]];
    
    for (int i = 0; i < [content count]; i++) {
        UIButton *subMenuItemBtn;
        
        subMenuItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(i *self.subMenuBgView.frame.size.width/content.count+2,1,self.subMenuBgView.frame.size.width/content.count, 45)];
        if (self.menuTagValue == 2)  {
            subMenuItemBtn.tag = i + [menuCategoryArray count];
        }else if (self.menuTagValue == 1){
            subMenuItemBtn.tag = i;
        }
        
        [subMenuItemBtn setTitle:[[NSString stringWithFormat:@"%@",[content objectAtIndex:i]] uppercaseString] forState:UIControlStateNormal];
        if (i == 0) {
            [subMenuItemBtn setBackgroundColor:[UIColor colorWithRed:49/255.0f green:48/255.0f blue:45/255.0f alpha:1.0]];
        }
        
        [subMenuItemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        [subMenuItemBtn setUserInteractionEnabled:YES];
        subMenuItemBtn.titleLabel.font =[UIFont fontWithName:@"Helvetica-Condensed" size:20];
        
        [subMenuItemBtn addTarget:self action:@selector(openSubMenuItems:) forControlEvents:UIControlEventTouchUpInside];
        [self.subMenuBgView addSubview:subMenuItemBtn];
        [self.view bringSubviewToFront:subMenuItemBtn];
        [self.subMenuBgView bringSubviewToFront:subMenuItemBtn];
//        UILabel *vertLine = [[UILabel alloc] initWithFrame:CGRectMake(i*135+1,1,1, 45)];
//        [vertLine setBackgroundColor:[UIColor colorWithRed:86/255.0f green:86/255.0f blue:86/255.0f alpha:1]];
//        [self.subMenuBgView addSubview:vertLine];
    }
   
    [self openSubMenuItems:sender1];
    
}



-(void)openSubMenuItems:(UIControl*)sender2
{
    if (sender2 != nil) {
        self.itemTag = sender2.tag;
        NSLog(@"Item Tag ..... %d",self.itemTag);
    for (UIButton* b in self.scrollerimage.subviews)
    {
        [b removeFromSuperview];
    }
    }
    if (self.itemTag >= 0) {
        
        for (UIButton* button in self.subMenuBgView.subviews)
        {
            NSLog(@"object class : %@", [button class]);
            NSLog(@"Button found!.... %ld",(long)button.tag);
            if (self.menuTagValue != 2) {
                if(self.itemTag != button.tag){
                    [button setBackgroundColor:[UIColor clearColor]];
                }else{
                    [button setBackgroundColor:[UIColor colorWithRed:49/255.0f green:48/255.0f blue:45/255.0f alpha:1.0]];
                }
                
                
            }
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.itemTag inSection:0];
    NSLog(@"INDEX PATH.... %ld",(long)indexPath.row);
    UIButton *check = (UIButton*)[sender2 viewWithTag:indexPath.row];
    NSLog(@"BUTTON TITLE...... %@",check.titleLabel.text);
    [check setBackgroundColor:[UIColor colorWithRed:49/255.0f green:48/255.0f blue:45/255.0f alpha:1.0]];
    
    int menuId = 1;
    
    if (self.menuTagValue == 1) {
        menuId =[[menuCategoryId objectAtIndex:indexPath.row] intValue];
        
    }else if (self.menuTagValue == 2)
    {
//        if (sender2.tag == 1) {
        
            NSLog(@"INDEX PATH.... %ld",(long)indexPath.row);
            
            int indxPath=indexPath.row+ [menuCategoryArray count];
            NSLog(@"index path.. %u",indexPath.row + [menuCategoryArray count]);
        if ([drinkMenuItems count] != 0) {
        
            if (drinksButtonTapped == YES)
            {
                menuId =[[menuCategoryId objectAtIndex:indexPath.row + [menuCategoryArray count]-1] intValue];
                
            }
            else{
                menuId =[[menuCategoryId objectAtIndex:indexPath.row ] intValue];
            }
        }
//        }else{
//            NSLog(@"INDEX PATH.... %ld",(long)indexPath.row);
//            
//            int indxPath=indexPath.row;
//            NSLog(@"index path.. %ld",(long)indexPath.row );
//            
//            if ([menuCategoryId containsObject:[NSString stringWithFormat:@"%d",indxPath]])
//                
//            {
//                menuId =[[menuCategoryId objectAtIndex:indexPath.row] intValue];
//            }
//            else{
//                int count=[menuCategoryArray count]-1;
//                menuId =indxPath + count ;
//            }
//        }
        
    }
    
    
    [self fetchMenuItemsDB:[NSString stringWithFormat:@"%d",menuId]];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu where categoryID = %d",menuId];
    FMResultSet *queryResults = [database executeQuery:queryString];
    while([queryResults next]) {
        NSString *categoryName = [queryResults stringForColumn:@"categoryName"];
        headerTitleName = [[NSString stringWithString:categoryName]uppercaseString];
        self.itemTypeName.text = [[NSString stringWithString:categoryName] uppercaseString];
    }
    [database close];
    
    //    menuItemsObj = [menuItemsDetailsArray objectAtIndex:indexPath.row];
    //    itemName.text = [NSString stringWithFormat:@"%@",menuItemsObj.ItemName];
    //    priceLabel.text =[NSString stringWithFormat:@"$%@",menuItemsObj.Price];
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",menuItemsObj.Image]];
    //    NSData *data = [NSData dataWithContentsOfURL:url];
    //    UIImage *img = [UIImage imageWithData:data];
    //    NSLog(@"Image Name %@",img);
    //    itemImage.image = img;
    [self.view bringSubviewToFront:self.scrollerimage];
    int count = [menuItemsDetailsArray count];
    if (count%2 != 0) {
        count = count+ 1;
    }
    self.scrollerimage.contentSize = CGSizeMake(150,count *  200);
    _scrollerimage.showsHorizontalScrollIndicator = NO;
    _scrollerimage.showsVerticalScrollIndicator = NO;
    
    
    int x = 5;
    int y= 0;
    
    for (NSUInteger i = 0; i < [menuItemsDetailsArray count]; ++i) {
        imageTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        imageTapRecognizer.numberOfTapsRequired = 1;
        menuItemsObj = [menuItemsDetailsArray objectAtIndex:i];
        if (i %2 == 0 || i == 0) {
            UIImageView *page = [[UIImageView alloc] init];
            NSData *data = [[NSData alloc] initWithData:[NSData
                                                         dataFromBase64String:[NSString stringWithFormat:@"%@",menuItemsObj.Image]]];
            
            UIImage *itemsImage = [UIImage imageWithData:data];
            
            
            page.image = itemsImage;
            page.frame = CGRectMake(0, y, 506, 350);
            //page.contentMode = UIViewContentModeScaleAspectFill;
            page.tag = i;
            page.userInteractionEnabled = YES;
            page.multipleTouchEnabled = YES;
            [_scrollerimage addSubview:page];
            UILabel *pageName = [[UILabel alloc] initWithFrame:CGRectMake(0,300 ,506, 50)];
            NSString *pageNameString = [NSString stringWithFormat:@"%@",menuItemsObj.ItemName];
            pageNameString = [pageNameString uppercaseString];
            pageName.text = pageNameString;
            pageName.textColor = [UIColor whiteColor];
            [pageName setBackgroundColor:[UIColor colorWithRed:36/255.f green:36/255.f blue:36/255.f alpha:0.5]];
            [pageName setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:20]];
            pageName.textAlignment = NSTextAlignmentCenter;
            [page addSubview:pageName];
            [page addGestureRecognizer:imageTapRecognizer];
            
        }else{
            UIImageView *page = [[UIImageView alloc] init];
            NSData *data = [[NSData alloc] initWithData:[NSData
                                                         dataFromBase64String:[NSString stringWithFormat:@"%@",menuItemsObj.Image]]];
            
            UIImage *itemsImage = [UIImage imageWithData:data];
            
            
            page.image = itemsImage;
            page.frame = CGRectMake(508, y, 506, 350);
            //page.contentMode = UIViewContentModeScaleAspectFill;
            page.tag = i;
            page.userInteractionEnabled = YES;
            page.multipleTouchEnabled = YES;
            [_scrollerimage addSubview:page];
            y=y+353;
            UILabel *pageName = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 506,50)];
            NSString *pageNameString = [NSString stringWithFormat:@"%@",menuItemsObj.ItemName];
            pageNameString = [pageNameString uppercaseString];
            pageName.text = pageNameString;
            pageName.textColor = [UIColor whiteColor];
            [pageName setBackgroundColor:[UIColor colorWithRed:36/255.f green:36/255.f blue:36/255.f alpha:0.5]];
            [pageName setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:20]];
            pageName.textAlignment = NSTextAlignmentCenter;
            [page addSubview:pageName];
            [page addGestureRecognizer:imageTapRecognizer];
            
        }
    }
    
}
- (void)imageTapped:(UITapGestureRecognizer *)sender{
    [self.view sendSubviewToBack:self.mainMenuFooter];
    
    CGRect theFrame = self.itemView.frame;
    theFrame.size.height = 769.0f;
    theFrame.origin.x = 0.0f;
    theFrame.origin.y = 20.0f;
    theFrame.size.width = 1024.0f;
    self.itemView.frame = theFrame;
    
    
    itemImagePage.hidden = NO;
    self.headerView.hidden = NO;
    self.footerView.hidden = NO;
    self.minimizeAnimatedView.hidden = YES;
    [itemImagePage removeFromSuperview];
    UIView *view = sender.view; //cast pointer to the derived class if needed
    NSLog(@"%ld", (long)view.tag);
    
    menuItemsObj = [menuItemsDetailsArray objectAtIndex:view.tag];
    NSLog(@"%@",menuItemsObj.ItemName);
    NSLog(@"%@",menuItemsObj.Price);
    self.itemView.hidden=NO;
    //    [self.itemView setFrame:CGRectMake(0, 23, 1024, 700)];
    //    [self.view addSubview:self.itemView];
    //[self.view bringSubviewToFront:self.itemView];
    self.itemView.hidden = NO;
    [self.itemView setBackgroundColor:[UIColor whiteColor]];
    [self.view bringSubviewToFront:self.itemView];
    itemImagePage = [[AsyncImageView alloc] init];
    NSData *data = [[NSData alloc] initWithData:[NSData
                                                 dataFromBase64String:[NSString stringWithFormat:@"%@",menuItemsObj.Image]]];
    
    UIImage *itemsImage = [UIImage imageWithData:data];
    itemImagePage.image = itemsImage;
    itemImagePage.showActivityIndicator = YES;
    itemImagePage.frame = CGRectMake(0,53,1024,640);
//    itemImagePage.contentMode = UIViewContentModeScaleAspectFit;
    itemImagePage.autoresizesSubviews = YES;
    
    [self.itemView addSubview:itemImagePage];
    
    
    NSData *data1 = [[NSData alloc] initWithData:[NSData
                                                  dataFromBase64String:[NSString stringWithFormat:@"%@",menuItemsObj.Image]]];
    
    UIImage *itemsImage1 = [UIImage imageWithData:data1];
    self.showMinimizeItemImage.image = itemsImage1;
    
    [itemNamebg removeFromSuperview];
    [itemNameToDisplay  removeFromSuperview];
    
    
    itemNamebg = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 480, 170)];
    [itemNamebg setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:30]];
    
    [itemNamebg setBackgroundColor:[UIColor whiteColor]];
    
    // itemNamebg.textColor = [UIColor whiteColor];
    [itemNamebg setBackgroundColor:[UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:0.5]];
    [self.itemView addSubview:itemNamebg];
    
    itemNameToDisplay = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 450, 100)];
    itemNameToDisplay.text =[[NSString stringWithFormat:@"%@", menuItemsObj.ItemName] uppercaseString];
    [itemNameToDisplay setFont:[UIFont fontWithName:@"Helvetica-Condensed" size:42]];
    itemNameToDisplay.textColor = [UIColor whiteColor];
    itemNameToDisplay.numberOfLines = 3;
    [itemNameToDisplay setBackgroundColor:[UIColor clearColor]];
    [itemNamebg addSubview:itemNameToDisplay];
    
    self.priceLbl.text = [NSString stringWithFormat:@"$ %.2f",[menuItemsObj.Price floatValue]];
    self.quantityLbl.text = [NSString stringWithFormat:@"%d",menuItemsObj.Quantity];
    self.headerTitleLbl.text = headerTitleName;
    [self changeQuantity:[[NSString stringWithFormat:@"%d",menuItemsObj.ItemId] intValue]];
    self.minimizeViewHeader.text = @"YOU JUST ADDED";
    self.minimizeItemName.text =[NSString stringWithFormat:@"%@", menuItemsObj.ItemName];
    
}

-(void)changeQuantity:(int)itemsID
{
    [self.increaseBtn setBackgroundImage:[UIImage imageNamed:@"increaseselect.png"] forState:UIControlStateNormal];
    [self.increaseBtn setUserInteractionEnabled:YES];
    [self.decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decreaseselect.png"] forState:UIControlStateNormal];
    [self.decreaseBtn setUserInteractionEnabled:YES];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory WHERE orderItemID = %d ",itemsID];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *tempOrderID = [[NSMutableArray alloc]init];
    NSMutableArray *tempOrderQuantity = [[NSMutableArray alloc] init];
    NSString *quantityValue;
    while([results next]) {
        [tempOrderID addObject:[results stringForColumn:@"orderItemID"]];
        [tempOrderQuantity addObject:[results stringForColumn:@"orderQuantity"]];
        quantityValue = [NSString stringWithFormat:@"%@",[results stringForColumn:@"orderQuantity"]];
    }
    
    
    
    
    NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM categoryItems WHERE itemID = %d ",itemsID];
    
    FMResultSet *results1 = [database executeQuery:queryString1];
    NSMutableArray *tempQuantity = [[NSMutableArray alloc] init];
    quantityCounts = [[NSMutableArray alloc] init];
    while([results1 next]) {
        maximumQty =[[results1 stringForColumn:@"quantity"]intValue];
        NSLog(@"Max Value %d",maximumQty);
    }
    int k = 0;
    
    if (quantityValue == nil) {
        self.quantityLbl.text = [NSString stringWithFormat:@"1"];
    }else{
        self.quantityLbl.text = [NSString stringWithFormat:@"%@",quantityValue];
    }
    
    if ([self.quantityLbl.text isEqualToString:[NSString stringWithFormat:@"%d",maximumQty]]) {
        [self.increaseBtn setBackgroundImage:[UIImage imageNamed:@"increase.png"] forState:UIControlStateNormal];
        [self.increaseBtn setUserInteractionEnabled:NO];
    }
    if ([self.quantityLbl.text isEqualToString:[NSString stringWithFormat:@"1"]])  {
        [self.decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decrease.png"] forState:UIControlStateNormal];
        [self.decreaseBtn setUserInteractionEnabled:NO];
    }
    
}
-(void)fetchDataDB:(NSString *)menuItemName
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu where type = \"%@\"", [NSString stringWithFormat:@"%@",menuItemName]];
    FMResultSet *results = [database executeQuery:queryString];
    menuCategoryArray = [[NSMutableArray alloc] init];
    menuCategoryId = [[NSMutableArray alloc]init];
    menuContentDict  = [[NSMutableDictionary alloc] init];
    drinkMenuItems = [[NSMutableArray alloc] init];
    while([results next]) {
        
        if ([menuItemName isEqualToString:@"Food"]) {
            [menuCategoryArray addObject:[results stringForColumn:@"categoryName"]];
            categoryFirst     = [NSArray arrayWithArray:menuCategoryArray];
            [menuContentDict setValue:categoryFirst forKey:[menuItemsArray objectAtIndex:0]];
            self.categoryTitle.text = [NSString stringWithString:[menuCategoryArray objectAtIndex:0]];
        }else{
            [drinkMenuItems addObject:[results stringForColumn:@"categoryName"]];
            categorySecond = [NSArray arrayWithArray:drinkMenuItems];
            [menuContentDict setValue:categorySecond forKey:[menuItemsArray objectAtIndex:1]];
        }
    }
    [database close];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //initData
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//- (void)viewDidAppear:(BOOL)animated {
//    [self.menuItemsTableView reloadData];
//}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.menuTableView){
        return [menuDisplayItemsArray count];
    }else{
        return 1;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.menuItemsTableView)
    {
        return [menuItemsDetailsArray  count];
        
    }else if (tableView == self.ordersTableView){
        return [orderList count];
    }else if (tableView == self.placeOrderTableView){
        return [placeOrderList count];
    }else if (tableView == self.pendingOrdersTableView){
        return [pendingOrderListArray count];
    }
    else if (tableView == self.deliveryOrderTableView){
        return [processingOrderList count];
    }else if (tableView == self.pendingOrderTableView){
        
        if (flag == 0) {
            return [pendingOrderItemNameArray count];
        }else{
            return [pendingOrderItemNameArray count];
        }
        
    }else if (tableView == self.quantityTableView){
        return [quantityCounts count];
    }
    else{
        if ([[arrayForBool objectAtIndex:section] boolValue]) {
            return [[menuContentDict valueForKey:[menuItemsArray objectAtIndex:section]] count];
        }
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 80)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor clearColor];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSLog(@"Tabke view name %ld",(long)tableView.tag);
    UIView *headerView;
    if (tableView == self.menuTableView) {
        headerView              = [[UIView alloc] initWithFrame:CGRectMake(self.menuTableView.frame.origin.x-20, 10, self.menuTableView.frame.size.width, 80)];
        headerView.tag                  = section;
        headerView.backgroundColor      = [UIColor clearColor];
        
        UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(-45, 0, headerView.frame.size.width, 50)];
        BOOL manyCells                  = [[arrayForBool objectAtIndex:section] boolValue];
        
        headerString.text =[NSString stringWithFormat:@"%@",[menuDisplayItemsArray objectAtIndex:section]];
        headerString.font = [UIFont fontWithName:@"Helvetica Neue" size:21];
        headerString.textColor          = [UIColor whiteColor];
        headerString.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:headerString];
        
        UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
        [headerView addGestureRecognizer:headerTapped];
        
        
        UIImageView *upDownArrow        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 400, 1)];
        upDownArrow.image    = [UIImage imageNamed:@"sidemenu_hover_img.png"] ;
        [headerString addSubview:upDownArrow];
        
        if (section == [menuDisplayItemsArray count]- 1) {
            UIImageView *DownArrow        = [[UIImageView alloc] initWithFrame:CGRectMake(0,45, 400, 1)];
            DownArrow.image    = [UIImage imageNamed:@"sidemenu_hover_img.png"] ;
            [headerString addSubview:DownArrow];
            
        }
        
        UIImageView *menuImage        = [[UIImageView alloc] initWithFrame:CGRectMake(353,15, 20, 20)];
        [menuImage setImage:[menuImages objectAtIndex:section]];
        [headerString addSubview:menuImage];
        
    }
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.menuTableView) {
        return 40;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.menuTableView){
        return 5;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.menuItemsTableView) {
        return 90;
    }else if(tableView == self.ordersTableView || tableView == self.pendingOrdersTableView){
        return 50;
    }else if (tableView == self.placeOrderTableView || tableView == self.pendingOrderTableView){
        return 75;
    }else if (tableView == self.deliveryOrderTableView){
        return 50;
    }else if (tableView == self.quantityTableView){
        return 30;
    }else if (tableView == self.menuTableView){
        return 30;
    }
    else{
        
        if ([[arrayForBool objectAtIndex:indexPath.section] boolValue]) {
            return 30;
            
        }
    }
    return 0;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    menuItems= [[UILabel alloc]initWithFrame:CGRectMake(110, -10, 150, 50)];
    menuItems.textColor= [UIColor whiteColor];
    menuItems.textAlignment      = NSTextAlignmentRight;
    menuItems.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
    menuItems.lineBreakMode = NSLineBreakByCharWrapping;
    [cell.contentView addSubview:menuItems];
    
    
    if (tableView == self.menuItemsTableView) {
        itemName= [[UILabel alloc]initWithFrame:CGRectMake(200, 0, 250, 80)];
        itemName.textColor= [UIColor whiteColor];
        itemName.font = [UIFont fontWithName:@"Helvetica Neue" size:24];
        itemName.lineBreakMode = NSLineBreakByCharWrapping;
        itemName.numberOfLines = 2;
        [cell.contentView addSubview:itemName];
        
        addBtn = [[UIButton alloc] initWithFrame:CGRectMake(530, 25, 60, 35)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
        [addBtn setTitle:@"ADD" forState:UIControlStateNormal];
        addBtn.tintColor = [UIColor whiteColor];
        addBtn.tag =indexPath.row+1000;
        [addBtn addTarget:self action:@selector(addMenuItem:)  forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:addBtn];
        
        itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
        [itemImage setBackgroundColor:[UIColor whiteColor]];
        itemImage.layer.borderColor = [UIColor grayColor].CGColor;
        itemImage.layer.borderWidth = 1.0;
        itemImage.layer.cornerRadius = 8.0;
        [itemImage setClipsToBounds:YES];
        [cell.contentView addSubview:itemImage];
        
        cell.backgroundColor = [UIColor clearColor];
        menuItemsObj = [menuItemsDetailsArray objectAtIndex:indexPath.row];
        itemName.text = [NSString stringWithFormat:@"%@",menuItemsObj.ItemName];
        priceLabel.text =[NSString stringWithFormat:@"$%@",menuItemsObj.Price];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",menuItemsObj.Image]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [UIImage imageWithData:data];
        NSLog(@"Image Name %@",img);
        itemImage.image = img;
        
    }
    else if (tableView == self.ordersTableView){
        orderItemsName= [[UILabel alloc]initWithFrame:CGRectMake(20, -15, 150, 80)];
        orderItemsName.textColor= [UIColor whiteColor];
        orderItemsName.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        orderItemsName.lineBreakMode = NSLineBreakByCharWrapping;
        orderItemsName.numberOfLines = 1;
        [cell.contentView addSubview:orderItemsName];
        
        orderItemQuantity= [[UILabel alloc]initWithFrame:CGRectMake(150, -15, 50, 80)];
        orderItemQuantity.textColor= [UIColor whiteColor];
        orderItemQuantity.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        orderItemQuantity.textAlignment = NSTextAlignmentRight;
        orderItemQuantity.lineBreakMode = NSLineBreakByCharWrapping;
        orderItemQuantity.numberOfLines = 2;
        [cell.contentView addSubview:orderItemQuantity];
        
        priceLabel= [[UILabel alloc]initWithFrame:CGRectMake(340, 5, 150, 80)];
        priceLabel.textColor= [UIColor whiteColor];
        priceLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        priceLabel.lineBreakMode = NSLineBreakByCharWrapping;
        priceLabel.numberOfLines = 2;
        [cell.contentView addSubview:priceLabel];
        
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 20, 22)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        
        deleteBtn.tintColor = [UIColor whiteColor];
        deleteBtn.tag =indexPath.row;
        if (tableView == self.ordersTableView) {
            deleteBtn.hidden = NO;
        }else{
            deleteBtn.hidden = YES;
        }
        [deleteBtn addTarget:self action:@selector(deleteOrderItem:)  forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];
        
        cell.backgroundColor = [UIColor clearColor];
        orderObj = [orderList objectAtIndex:indexPath.row];
        orderItemsName.text =[NSString stringWithFormat:@"%@",orderObj.orderItemName];
        orderItemQuantity.text = [NSString stringWithFormat:@"  %d",orderObj.orderQuantity];
        
    }else if (tableView == self.placeOrderTableView){
        placedorderName= [[UILabel alloc]initWithFrame:CGRectMake(20, -10, 200, 80)];
        placedorderName.textColor= [UIColor colorWithRed:132/255.0f green:15/255.0f blue:4/255.0f alpha:1];
        placedorderName.font = [UIFont fontWithName:@"Poor Richard" size:25];
        placedorderName.lineBreakMode = NSLineBreakByCharWrapping;
        placedorderName.numberOfLines = 2;
        [cell.contentView addSubview:placedorderName];
        
        placeOrderquantity= [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 80)];
        placeOrderquantity.textColor= [UIColor blackColor];
        placeOrderquantity.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        placeOrderquantity.lineBreakMode = NSLineBreakByCharWrapping;
        placeOrderquantity.numberOfLines = 2;
        [cell.contentView addSubview:placeOrderquantity];
        
        placedOrderPrice= [[UILabel alloc]initWithFrame:CGRectMake(370, 0, 150, 80)];
        placedOrderPrice.textColor= [UIColor blackColor];
        placedOrderPrice.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        placedOrderPrice.lineBreakMode = NSLineBreakByCharWrapping;
        placedOrderPrice.numberOfLines = 2;
        [cell.contentView addSubview:placedOrderPrice];
        
        cell.backgroundColor = [UIColor clearColor];
        placeOrderObj = [placeOrderList objectAtIndex:indexPath.row];
        placedorderName.text =[NSString stringWithFormat:@"%@",placeOrderObj.itemName];
        placeOrderquantity.text =[NSString stringWithFormat:@"Quantity: %d",placeOrderObj.Quantity];
        placedOrderPrice.text = [NSString stringWithFormat:@"$%d",placeOrderObj.Price];
    }
    
    else if (tableView == self.pendingOrdersTableView)
    {
        pendingOrderObj = [pendingOrderListArray objectAtIndex:indexPath.row];
        pendingOrderIDLbl= [[UILabel alloc]initWithFrame:CGRectMake(20, -28, 150, 80)];
        pendingOrderIDLbl.textColor= [UIColor whiteColor];
        pendingOrderIDLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        pendingOrderIDLbl.font = [UIFont boldSystemFontOfSize:17];
        pendingOrderIDLbl.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderIDLbl.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderIDLbl];
        
        pendingOrderStatusLbl= [[UILabel alloc]initWithFrame:CGRectMake(20, -5, 200, 80)];
        NSString *statusString = [NSString stringWithFormat:@"%@",pendingOrderObj.Status];
        NSLog(@"Status %@",statusString);
        pendingOrderStatusLbl.textColor= [UIColor colorWithRed:255/255.0f green:231/255.0f blue:16/255.0f alpha:1];
        pendingOrderStatusLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        pendingOrderStatusLbl.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderStatusLbl.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderStatusLbl];
        
        pendingorderName= [[UILabel alloc]initWithFrame:CGRectMake(20, -10, 200, 80)];
        pendingorderName.textColor= [UIColor blackColor];
        pendingorderName.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        pendingorderName.lineBreakMode = NSLineBreakByCharWrapping;
        pendingorderName.numberOfLines = 2;
        [cell.contentView addSubview:pendingorderName];
        
        pendingOrderquantity= [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 80)];
        pendingOrderquantity.textColor= [UIColor blackColor];
        pendingOrderquantity.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        pendingOrderquantity.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderquantity.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderquantity];
        
        pendingOrderPrice= [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 150, 80)];
        pendingOrderPrice.textColor= [UIColor blackColor];
        pendingOrderPrice.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        pendingOrderPrice.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderPrice.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderPrice];
        
        pendingOrderTime = [[UILabel alloc]initWithFrame:CGRectMake(80, -28, 150, 80)];
        pendingOrderTime.textColor= [UIColor whiteColor];
        pendingOrderTime.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        pendingOrderTime.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderTime.textAlignment = NSTextAlignmentRight;
        pendingOrderTime.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderTime];
        
        NSDate *startTime;
        
        startTime = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *curruntTime = [ dateFormat stringFromDate:startTime];
        
        NSDate *convertedTime = [dateFormat dateFromString:curruntTime];
        NSString *time = [NSString stringWithFormat:@"%@",pendingOrderObj.lastUpdatedTime];
        
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [dateFormat dateFromString:time];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"HH:mm"];
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
        
        cell.backgroundColor = [UIColor clearColor];
        
        pendingOrderIDLbl.text =[NSString stringWithFormat:@"ORDER # %@",pendingOrderObj.OrderId];
        NSString *statusStr = [NSString stringWithFormat:@"%@",pendingOrderObj.Status];
        statusStr = [statusStr uppercaseString];
        pendingOrderStatusLbl.text =[NSString stringWithString:statusStr];
        pendingOrderTime.text = [NSString stringWithString: timeStr];
        NSLog(@"Order Status %@",pendingOrderObj.OrderId);
        UIImageView *upDownArrow        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 300, 1)];
        upDownArrow.image    = [UIImage imageNamed:@"sidemenu_hover_img.png"] ;
        [cell.contentView addSubview:upDownArrow];
        
    }else if (tableView == self.deliveryOrderTableView)
    {
        
        pendingOrderObj = [processingOrderList objectAtIndex:indexPath.row];
        pendingOrderIDLbl= [[UILabel alloc]initWithFrame:CGRectMake(20, -28, 150, 80)];
        pendingOrderIDLbl.textColor= [UIColor blackColor];
        pendingOrderIDLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        pendingOrderIDLbl.font = [UIFont boldSystemFontOfSize:17];
        pendingOrderIDLbl.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderIDLbl.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderIDLbl];
        
        pendingOrderStatusLbl= [[UILabel alloc]initWithFrame:CGRectMake(20, -5, 200, 80)];
        NSString *statusString = [NSString stringWithFormat:@"%@",pendingOrderObj.Status];
        NSLog(@"Status %@",statusString);
        pendingOrderStatusLbl.textColor= [UIColor blackColor];
        pendingOrderStatusLbl.font = [UIFont fontWithName:@"Helvetica Neue" size:10];
        pendingOrderStatusLbl.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderStatusLbl.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderStatusLbl];
        
        pendingorderName= [[UILabel alloc]initWithFrame:CGRectMake(20, -10, 200, 80)];
        pendingorderName.textColor= [UIColor blackColor];
        pendingorderName.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        pendingorderName.lineBreakMode = NSLineBreakByCharWrapping;
        pendingorderName.numberOfLines = 2;
        [cell.contentView addSubview:pendingorderName];
        
        pendingOrderquantity= [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 80)];
        pendingOrderquantity.textColor= [UIColor blackColor];
        pendingOrderquantity.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        pendingOrderquantity.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderquantity.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderquantity];
        
        pendingOrderPrice= [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 150, 80)];
        pendingOrderPrice.textColor= [UIColor blackColor];
        pendingOrderPrice.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        pendingOrderPrice.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderPrice.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderPrice];
        
        pendingOrderTime = [[UILabel alloc]initWithFrame:CGRectMake(80, -28, 150, 80)];
        pendingOrderTime.textColor= [UIColor blackColor];
        pendingOrderTime.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        pendingOrderTime.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderTime.textAlignment = NSTextAlignmentRight;
        pendingOrderTime.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderTime];
        
        NSDate *startTime;
        
        startTime = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *curruntTime = [ dateFormat stringFromDate:startTime];
        
        NSDate *convertedTime = [dateFormat dateFromString:curruntTime];
        NSString *time = [NSString stringWithFormat:@"%@",pendingOrderObj.lastUpdatedTime];
        
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *date = [dateFormat dateFromString:time];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"HH:mm"];
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
        
        cell.backgroundColor = [UIColor clearColor];
        
        pendingOrderIDLbl.text =[NSString stringWithFormat:@"ORDER # %@",pendingOrderObj.OrderId];
        NSString *statusStr = [NSString stringWithFormat:@"%@",pendingOrderObj.Status];
        statusStr = [statusStr uppercaseString];
        pendingOrderStatusLbl.text =[NSString stringWithString:statusStr];
        pendingOrderTime.text = [NSString stringWithString:timeStr];
        NSLog(@"Order Status %@",pendingOrderObj.OrderId);
        UIImageView *upDownArrow        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 300, 1)];
        upDownArrow.image    = [UIImage imageNamed:@"sidemenu_hover_img.png"] ;
        [cell.contentView addSubview:upDownArrow];
        
    }else if (tableView == self.pendingOrderTableView){
        pendingorderName= [[UILabel alloc]initWithFrame:CGRectMake(20, -10, 200, 80)];
        pendingorderName.textColor= [UIColor colorWithRed:132/255.0f green:15/255.0f blue:4/255.0f alpha:1];
        pendingorderName.font = [UIFont fontWithName:@"Poor Richard" size:25];
        pendingorderName.lineBreakMode = NSLineBreakByCharWrapping;
        pendingorderName.numberOfLines = 2;
        [cell.contentView addSubview:pendingorderName];
        
        pendingOrderquantity= [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 80)];
        pendingOrderquantity.textColor= [UIColor blackColor];
        pendingOrderquantity.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
        pendingOrderquantity.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderquantity.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderquantity];
        
        pendingOrderPrice= [[UILabel alloc]initWithFrame:CGRectMake(320, 0, 150, 80)];
        pendingOrderPrice.textColor= [UIColor blackColor];
        pendingOrderPrice.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
        pendingOrderPrice.lineBreakMode = NSLineBreakByCharWrapping;
        pendingOrderPrice.numberOfLines = 2;
        [cell.contentView addSubview:pendingOrderPrice];
        
        cell.backgroundColor = [UIColor clearColor];
        if (flag == 0) {
            
            pendingorderName.text =[NSString stringWithFormat:@"%@",[pendingOrderItemNameArray objectAtIndex:indexPath.row]];
            NSString *priceStr = [NSString stringWithFormat:@"%@",[pendingOrderItemPriceArray objectAtIndex:indexPath.row]];
            int p = [priceStr intValue];
            pendingOrderquantity.text =[NSString stringWithFormat:@"Quantity: %@",[pendingOrderItemQuantityArray objectAtIndex:indexPath.row]];
            pendingOrderPrice.text = [NSString stringWithFormat:@"$ %d",p];
        }else{
            
            pendingorderName.text =[NSString stringWithFormat:@"%@",[pendingOrderItemNameArray objectAtIndex:indexPath.row]];
            NSString *priceStr = [NSString stringWithFormat:@"%@",[pendingOrderItemPriceArray objectAtIndex:indexPath.row]];
            int p = [priceStr intValue];
            pendingOrderquantity.text =[NSString stringWithFormat:@"Quantity: %@",[pendingOrderItemQuantityArray objectAtIndex:indexPath.row]];
            pendingOrderPrice.text = [NSString stringWithFormat:@"$ %d",p];
        }
        
        
    }else if (tableView == self.quantityTableView){
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [quantityCounts objectAtIndex:indexPath.row];
    }
    else{
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        if ((menuIndex== Nil && indexPath.row == 0) || ((menuIndex!=Nil && indexPath.row == menuIndex.row) && (menuIndex.section == indexPath.section))) {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
        }
        
        //        menuItemIndex = indexPath;
        
        
        //   if (tableView == self.menuTableView) {
        BOOL manyCells  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
        if (!manyCells) {
            cell.textLabel.text = [menuDisplayItemsArray objectAtIndex:indexPath.row];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 2;
        }
        else{
            content = [menuContentDict valueForKey:[menuItemsArray objectAtIndex:indexPath.section]];
            //cell.textLabel.textAlignment = NSTextAlignmentRight;
            menuItems.text =[NSString stringWithFormat:@"%@",[content objectAtIndex:indexPath.row]];
            //cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            //cell.textLabel.numberOfLines = 2;
            //        if (indexPath.row == 0) {
            //            cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.8];
            //        }
        }
        //    }
        
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    //    if (tableView == self.quantityTableView ||  tableView == self.pendingOrderTableView || tableView == self.pendingOrdersTableView || tableView == self.placeOrderTableView || tableView == self.ordersTableView || tableView == self.menuTableView) {
    //         NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    //        if ([indexArray containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
    //            UITableViewCell *cell = [tableView cellForRowAtIndexPath:newIndexPath];
    //            UIView *bagColorView = [[UIView alloc] init];
    //            bagColorView.backgroundColor = [UIColor redColor];
    //            [cell setSelectedBackgroundView:bagColorView];
    //    }
    //    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.noteTextView resignFirstResponder];
    int row = indexPath.row;
    int section = indexPath.section;
    // [self.menuTableView reloadData];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %@", newIndexPath);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell *cell1;
    
    
    if (tableView == self.quantityTableView ||  tableView == self.pendingOrderTableView || tableView == self.pendingOrdersTableView || tableView == self.placeOrderTableView || tableView == self.ordersTableView || tableView == self.menuTableView)
        indexArray = [[NSMutableArray alloc] init];
    {
        [indexArray addObject:[NSString stringWithFormat:@"%d",row]];
    }
    //    [tableView deselectRowAtIndexPath:newIndexPath animated:NO];
    //
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:newIndexPath];
    //    bgColorView = [[UIView alloc]init];
    //    bgColorView.backgroundColor = [UIColor colorWithRed:0.529 green:0.808 blue:0.922 alpha:0.5];
    //
    //    cell.selectedBackgroundView = bgColorView;
    
    if (tableView == self.menuTableView)
    {
        int index = indexPath.row;
        NSString *titleName;
        if (indexPath.section == 1) {
            index = [menuCategoryArray count] + indexPath.row;
            titleName = [NSString stringWithFormat:@"%@",[drinkMenuItems objectAtIndex:indexPath.row]];
        }
        else{
            titleName = [NSString stringWithFormat:@"%@",[menuCategoryArray objectAtIndex:indexPath.row]];
        }
        
        categoryID = [NSString stringWithFormat:@"%@",[menuCategoryId objectAtIndex:index]];
        [self fetchMenuItemsDB:categoryID];
        menuObj = [menuItemsArray objectAtIndex:index];
        self.categoryTitle.text = [NSString stringWithString:titleName];
        if (menuIndex == Nil) {
            menuIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        if (menuIndex != Nil ) {
            cell1 = [tableView cellForRowAtIndexPath:menuIndex];
            [cell1 setBackgroundColor:[UIColor clearColor]];
        }
        
        
        if ([cell selectionStyle] == UITableViewCellSelectionStyleNone) {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
        }
        
        menuIndex = indexPath;
    }
    else if (tableView == self.quantityTableView){
        NSString *titleStr = [NSString stringWithFormat:@"%@",[quantityCounts objectAtIndex:indexPath.row]];
        [self.selectQuantityBtn setTitle:titleStr forState:UIControlStateNormal];
        self.quantityTableView.hidden = YES;
        
        if (quantityIndex != Nil) {
            cell1 = [tableView cellForRowAtIndexPath:quantityIndex];
            [cell1 setBackgroundColor:[UIColor clearColor]];
        }
        
        
        if ([cell selectionStyle] == UITableViewCellSelectionStyleNone) {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
        }
        
        quantityIndex = indexPath;
    }
    else if (tableView == self.pendingOrdersTableView){
        [[self.pendingOrderPopUpLbl layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[self.pendingOrderPopUpLbl layer] setBorderWidth:1.0];
        [[self.pendingOrderPopUpLbl layer] setCornerRadius:5];
        [self.pendingOrdersPopUpTitle setFont:[UIFont fontWithName:@"Poor Richard" size:25]];
        [self.pendingTotalTitle setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
        //    [[self.placeOrderBtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
        //    [[self.placeOrderBtn layer] setBorderWidth:1.0];
        //[[self.placeOrderBtn layer] setCornerRadius:5];
        [self.pendingOrderDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [[self.pendingOrderTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[self.pendingOrderTableView layer] setBorderWidth:1.0];
        [[self.pendingOrderTableView layer] setCornerRadius:5];
        flag = 0 ;
        pendingOrderObj = [pendingOrderListArray objectAtIndex:indexPath.row];
        self.pendingOrderPopUp.hidden = NO;
        
        int tempPrice=0;
        for (int n=0; n<pendingOrderObj.pendingOrderDetails.count; n++) {
            
            NSString *quantity=[[pendingOrderObj.pendingOrderDetails objectAtIndex:n]valueForKey:@"quantity"];
            NSString *price=[[pendingOrderObj.pendingOrderDetails objectAtIndex:n]valueForKey:@"price"];
            tempPrice= ([quantity intValue] * [price intValue])+tempPrice;
            
        }
        NSString *totalStr = [NSString stringWithFormat:@"%@",pendingOrderObj.TotalBill];
        int p = [totalStr intValue];
        self.pendingOrderTotalLbl.text = [NSString stringWithFormat:@"$ %d",tempPrice];
        [self.pendingOrderTotalLbl setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
        [self pendingOrderItems:indexPath.row];
        
        if (pendingOrderIndex != Nil) {
            cell1 = [tableView cellForRowAtIndexPath:pendingOrderIndex];
            [cell1 setBackgroundColor:[UIColor clearColor]];
        }
        
        
        if ([cell selectionStyle] == UITableViewCellSelectionStyleNone) {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
        }
        
        pendingOrderIndex = indexPath;
        [self DisableBackView];
        
    }else if (tableView == self.deliveryOrderTableView){
        [[self.pendingOrderPopUpLbl layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[self.pendingOrderPopUpLbl layer] setBorderWidth:1.0];
        [[self.pendingOrderPopUpLbl layer] setCornerRadius:5];
        [self.pendingOrdersPopUpTitle setFont:[UIFont fontWithName:@"Poor Richard" size:25]];
        [self.pendingTotalTitle setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
        //    [[self.placeOrderBtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
        //    [[self.placeOrderBtn layer] setBorderWidth:1.0];
        //[[self.placeOrderBtn layer] setCornerRadius:5];
        self.deliveryOrderView.hidden = YES;
        self.pendingOrdersPopUpTitle.text = [NSString stringWithFormat:@"Please Confirm Your Delivery"];
        [[self.pendingOrderTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[self.pendingOrderTableView layer] setBorderWidth:1.0];
        [[self.pendingOrderTableView layer] setCornerRadius:5];
        [self.pendingOrderDoneBtn setTitle:@"Mark As Delivered" forState:UIControlStateNormal];
        pendingOrderObj = [processingOrderList objectAtIndex:indexPath.row];
        self.pendingOrderPopUp.hidden = NO;
        [self.view bringSubviewToFront:self.pendingOrderPopUp];
        flag =1;
        int tempPrice=0;
        for (int n=0; n<pendingOrderObj.pendingOrderDetails.count; n++) {
            
            NSString *quantity=[[pendingOrderObj.pendingOrderDetails objectAtIndex:n]valueForKey:@"quantity"];
            NSString *price=[[pendingOrderObj.pendingOrderDetails objectAtIndex:n]valueForKey:@"price"];
            tempPrice= ([quantity intValue] * [price intValue])+tempPrice;
            
        }
        NSString *totalStr = [NSString stringWithFormat:@"%@",pendingOrderObj.TotalBill];
        int p = [totalStr intValue];
        self.pendingOrderTotalLbl.text = [NSString stringWithFormat:@"$ %d",tempPrice];
        [self.pendingOrderTotalLbl setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
        [self processingOrders:indexPath.row];
        
        if (pendingOrderIndex != Nil) {
            cell1 = [tableView cellForRowAtIndexPath:pendingOrderIndex];
            [cell1 setBackgroundColor:[UIColor clearColor]];
        }
        
        
        if ([cell selectionStyle] == UITableViewCellSelectionStyleNone) {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
        }
        
        pendingOrderIndex = indexPath;
        [self DisableBackView];
        
    }else if (tableView == self.menuItemsTableView){
        if (menuItemIndex != Nil) {
            cell1 = [tableView cellForRowAtIndexPath:menuItemIndex];
            [cell1 setBackgroundColor:[UIColor clearColor]];
        }
        
        
        if ([cell selectionStyle] == UITableViewCellSelectionStyleNone) {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.2]];
        }
        
        menuItemIndex = indexPath;
    }
    
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

-(void)fetchMenuItemsDB:(NSString *)categoryIDs
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM categoryItems where categoryID = \"%@\"", categoryIDs];
    FMResultSet *results = [database executeQuery:queryString];
    menuItemsDetailsArray = [[NSMutableArray alloc] init];
    
    while([results next]) {
        menuItemsObj = [[menuItemsOC alloc] init];
        menuItemsObj.ItemId = [results intForColumn:@"itemID"];
        menuItemsObj.ItemName = [results stringForColumn:@"itemName"];
        menuItemsObj.type = [results stringForColumn:@"typeID"];
        menuItemsObj.Cuisine = [results stringForColumn:@"cuisine"];
        menuItemsObj.Image = [results stringForColumn:@"itemImage"];
        menuItemsObj.Price = [results stringForColumn:@"itemPrice"];
        //        menuItemsObj.IsDeletedItem = [[results stringForColumn:@"type"]integerValue];
        menuItemsObj.Quantity = [[results stringForColumn:@"quantity"] integerValue];
        [menuItemsDetailsArray addObject:menuItemsObj];
    }
    [self.menuItemsTableView reloadData];
    
}
#pragma mark - Add Button Action

-(void)addMenuItem:(UIControl *)sender
{
    [self.increaseBtn setBackgroundImage:[UIImage imageNamed:@"increaseselect.png"] forState:UIControlStateNormal];
    [self.increaseBtn setUserInteractionEnabled:YES];
    [self.decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decreaseselect.png"] forState:UIControlStateNormal];
    [self.decreaseBtn setUserInteractionEnabled:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-1000 inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    menuItemsObj = [menuItemsDetailsArray objectAtIndex:indexPath.row];
    itemID = menuItemsObj.ItemId;
    
    UITableViewCell *cell = (UITableViewCell*)[self.menuItemsTableView cellForRowAtIndexPath:indexPath];
    UIButton *check1 = (UIButton*)[cell.contentView viewWithTag:indexPath.row+1000];
    
    if ([[check1 backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"small_button.png"]]){
        [check1 setBackgroundImage:[UIImage imageNamed:@"small_button_hover.png"] forState:UIControlStateNormal];
        [check1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        [check1 setBackgroundImage:[UIImage imageNamed:@"small_button.png"] forState:UIControlStateNormal];
        [check1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [[self.quantityPopUpLbl layer] setCornerRadius:5];
    
    [[self.quantityTxtImage layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.quantityTxtImage layer] setBorderWidth:1.0];
    [[self.quantityTxtImage layer] setCornerRadius:5];
    
    [[self.quantityDoneBtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.quantityDoneBtn layer] setBorderWidth:1.0];
    [[self.quantityDoneBtn layer] setCornerRadius:5];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory WHERE orderItemID = %d ",itemID];
    
    FMResultSet *results = [database executeQuery:queryString];
    NSMutableArray *tempOrderID = [[NSMutableArray alloc]init];
    NSMutableArray *tempOrderQuantity = [[NSMutableArray alloc] init];
    NSString *quantityValue;
    while([results next]) {
        [tempOrderID addObject:[results stringForColumn:@"orderItemID"]];
        [tempOrderQuantity addObject:[results stringForColumn:@"orderQuantity"]];
        quantityValue = [NSString stringWithFormat:@"%@",[results stringForColumn:@"orderQuantity"]];
    }
    
    
    
    
    NSString *queryString1 = [NSString stringWithFormat:@"Select * FROM categoryItems WHERE itemID = %d ",itemID];
    
    FMResultSet *results1 = [database executeQuery:queryString1];
    NSMutableArray *tempQuantity = [[NSMutableArray alloc] init];
    quantityCounts = [[NSMutableArray alloc] init];
    while([results1 next]) {
        maximumQty =[[results1 stringForColumn:@"quantity"]intValue];
        NSLog(@"Max Value %d",maximumQty);
    }
    int k = 0;
    //    for (int i= 0; i < [tempQuantity count] ; i++) {
    //        k = [[tempQuantity objectAtIndex:i] intValue];
    //        maximumQty = k;
    //    }
    
    
    for (int j =1; j <= k; j++) {
        [quantityCounts addObject:[NSString stringWithFormat:@"%d",j]];
    }
    self.quantityPopUp.hidden = NO;
    
    if (quantityValue == nil) {
        self.quantityTxt.text = [NSString stringWithFormat:@"1"];
    }else{
        self.quantityTxt.text = [NSString stringWithFormat:@"%@",quantityValue];
    }
    
    if ([self.quantityTxt.text isEqualToString:[NSString stringWithFormat:@"%d",maximumQty]]) {
        [self.increaseBtn setBackgroundImage:[UIImage imageNamed:@"increase.png"] forState:UIControlStateNormal];
        [self.increaseBtn setUserInteractionEnabled:NO];
    }
    if ([self.quantityTxt.text isEqualToString:[NSString stringWithFormat:@"1"]])  {
        [self.decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decrease.png"] forState:UIControlStateNormal];
        [self.decreaseBtn setUserInteractionEnabled:NO];
    }
    
    [self.quantityPopUpTitle setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
    
    [self DisableBackView];
    // [self launchDialog];
}




- (void)launchDialog
{
    // Here we need to pass a full frame
    alertViewCustom = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertViewCustom setContainerView:[self createDemoView]];
    
    // Modify the parameters
    [alertViewCustom setButtonTitles:[NSMutableArray arrayWithObjects:@"DONE",nil]];
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


- (UIView *)createDemoView
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 300)];
    [demoView addSubview:self.quantityPopUp];
    return demoView;
}





- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
    
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}



#pragma mark - Delete Button Action

-(void)deleteOrderItem:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    orderObj = [orderList objectAtIndex:indexPath.row];
    itemID = orderObj.orderItemID;
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString = [NSString stringWithFormat:@"Delete FROM orderHistory WHERE orderItemID = %d ",itemID];
    [database executeUpdate:queryString];
    [database close];
    [self orderlist];
    [self.ordersTableView reloadData];
    
}

#pragma mark -PopUpDone button

- (IBAction)placedOrderPopUpCloseBtn:(id)sender {
    [self EnableBackView];
    self.placeOrderPopUp.hidden = YES;
}

- (IBAction)quantityDoneBtn:(id)sender {
    
    NSLog(@"Item ID %d",itemID);
    
    
    [self orderList:[NSString stringWithFormat:@"%d",itemID] :[self.quantityTxt.text intValue]];
    
    [self orderlist];
    [self.menuItemsTableView reloadData];
    self.quantityTableView.hidden =YES;
    self.quantityPopUp.hidden = YES;
    
    [self EnableBackView];
    
    
}

- (IBAction)quantityPopUpCloseBtn:(id)sender {
    self.quantityPopUp.hidden = YES;
    self.quantityTableView.hidden =YES;
    
    [self.menuItemsTableView reloadData];
    [self EnableBackView];
}

- (IBAction)pendingOrderPopUpCloseBtn:(id)sender {
    self.pendingOrderPopUp.hidden = YES;
    [self.pendingOrdersTableView reloadData];
    [self EnableBackView];
}

- (IBAction)tapGestureOfHideMenu:(id)sender {
    CGPoint pt;
    CGRect rc = [self.sideScroller bounds];
    rc = [self.sideScroller convertRect:rc toView:self.sideScroller];
    pt = rc.origin;
    pt.x = 0;
    pt.y =0;
    [self.sideScroller setContentOffset:pt animated:YES];
    [self.sideScroller sendSubviewToBack:self.tapGestureBtn];
}
#pragma mark - place order button action
- (IBAction)placeOrder:(id)sender {
    
    
    
    if ([placeOrderList count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nini-Events" message:@"Please add items to the list before placing the order" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    else
    {
        [self placedOrder:[[NSString stringWithFormat:@"%@",self.totalAmountLbl.text]intValue]];
        
        [self EnableBackView];
    }
    
}

#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.noteTextView resignFirstResponder];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.section == 3) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"GOGO EVENTS" message:@"ARE YOU SURE YOU WANT TO EXIT?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
        alert.tag = 1000;
        [alert show];
        
    }else if (indexPath.section == 2){
        if (chatUsed == 1) {
            if(self.chatView.hidden==YES)
            {
                [self.view bringSubviewToFront:self.chatView];
                self.chatView.hidden=NO;
                [self fetchHelpMessage];
                
            }
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"GOGO EVENTS" message:@"YOUR ASSISTANCE HAS BEEN DELIVERED." delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            [alert show];
        }
    }else{
        int index = indexPath.section;
        
        //[self menuItems:[NSString stringWithFormat:@"%@",[menuItemsArray objectAtIndex:indexPath.section]]:index];
        NSLog(@"Row %ld",(long)indexPath.row);
        NSLog(@"Section %ld",(long)indexPath.section);
        if (indexPath.row == 0) {
            
            BOOL collapsed  = [[arrayForBool objectAtIndex:indexPath.section] boolValue];
            collapsed       = !collapsed;
            [arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
            
            //reload specific section animated
            NSRange range   = NSMakeRange(indexPath.section, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.menuTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - order Now Button
- (IBAction)orderNow:(id)sender {
    
    [self popUpOrderlist];
    if(placeOrderList.count<1)
    {
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"Your cart is empty." message:@"Please add some food items to your cart." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self.orderNoteLbl setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
    [self.totalAmountLbl setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
    [self.noteTitle setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
    [self.totalTitle setFont:[UIFont fontWithName:@"Poor Richard" size:20]];
    [self.placeOrderPopupTitle setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
    
    [[self.placeOrderPopUpLbl layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.placeOrderPopUpLbl layer] setBorderWidth:1.0];
    [[self.placeOrderPopUpLbl layer] setCornerRadius:5];
    
    //    [[self.placeOrderBtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
    //    [[self.placeOrderBtn layer] setBorderWidth:1.0];
    [[self.placeOrderBtn layer] setCornerRadius:5];
    
    [[self.placeOrderTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.placeOrderTableView layer] setBorderWidth:1.0];
    [[self.placeOrderTableView layer] setCornerRadius:5];
    self.placeOrderPopUp.hidden = NO;
    [self DisableBackView];
    
}

#pragma mark - Menu Button
- (IBAction)menuBtn:(id)sender {
    
    //    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    documentsDir = [docPaths objectAtIndex:0];
    //    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    //    database = [FMDatabase databaseWithPath:dbPath];
    //    [database open];
    //
    //    NSString *queryString = [NSString stringWithFormat:@"Select * FROM menu "];
    //    FMResultSet *queryResults = [database executeQuery:queryString];
    //    menuCategoryArray = [[NSMutableArray alloc] init];
    //    drinkMenuItems = [[NSMutableArray alloc] init];
    //    menuCategoryId = [[NSMutableArray alloc]init];
    //    while([queryResults next]) {
    //        NSString *categoriesType = [queryResults stringForColumn:@"type"];
    //        [menuCategoryId addObject:[queryResults stringForColumn:@"categoryID"]];
    //        if ([categoriesType isEqualToString:@"Food"]) {
    //            [menuCategoryArray addObject:[queryResults stringForColumn:@"categoryName"]];
    //        }else{
    //            [drinkMenuItems addObject:[queryResults stringForColumn:@"categoryName"]];
    //        }
    //
    //
    //    }
    //    [database close];
    //
    //    menuContentDict  = [[NSMutableDictionary alloc] init];
    //
    //    categoryFirst     = [NSArray arrayWithArray:menuCategoryArray];
    //    [menuContentDict setValue:categoryFirst forKey:[menuItemsArray objectAtIndex:0]];
    //
    //    categorySecond = [NSArray arrayWithArray:drinkMenuItems];
    //    [menuContentDict setValue:categorySecond forKey:[menuItemsArray objectAtIndex:1]];
    //
    //    [self.menuTableView reloadData];
    //    [self.sideScroller bringSubviewToFront:self.tapGestureBtn];
    [self showSlider];
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
    
    pt.y =0;
    [self.sideScroller setContentOffset:pt animated:YES];
    
}
#pragma mark -PLace Order Web Services

-(void)placedOrder:(int)k
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"YYYYMMddHHmmss"];
    
    NSString *date_String=[dateformate stringFromDate:[NSDate date]];
    
    NSMutableArray *placeOrderArray = [[NSMutableArray alloc]init];
    for (int i= 0; i < [placeOrderList count]; i ++) {
        
        placeOrderObj = [placeOrderList objectAtIndex:i];
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",placeOrderObj.ItemId],@"ItemId",[NSString stringWithFormat:@"%d",placeOrderObj.Quantity],@"Quantity",[NSString stringWithFormat:@"%d",placeOrderObj.Price],@"Price", nil];
        
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
    NSMutableDictionary *PlaceOrders = [[NSMutableDictionary alloc] initWithObjectsAndKeys:jsonString,@"objPlaceOrder",tableIds,@"tableId",[NSString stringWithFormat:@"1"],@"restaurantId",[NSString stringWithFormat:@"%d",k],@"totalbill",[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Note"]],@"notes",date_String,@"datetimeoforder", nil];
    
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
    webServiceCode = 2;
    
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

#pragma mark -Pending PLaced Order Web Services

-(void)FetchPendingPlacedOrder:(NSString*)passedOrderType
{
    [self disabled];
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
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:staffId,@"StaffId",tableId, @"TableId",OrderType,@"OrderType",TriggerValue, @"Trigger",[defaults valueForKey:@"Event ID"],@"EventId", nil];
    
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
    webServiceCode =10;
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
- (IBAction)sendChatMessage:(id)sender {
    [self sendHelpMessage];
    [self.chatMessageTxtView resignFirstResponder];
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

#pragma mark - Fetch Help Message
-(void) fetchHelpMessage
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString *timestamp= [NSString stringWithFormat:@"(null)"];
    if ([timestamp isEqualToString:@"(null)"]) {
        timestamp = [NSString stringWithFormat:@"-1"];
    }
    NSString *ids = [NSString stringWithFormat:@"%@",[defaults valueForKey:@"Table ID"]];
    NSString *user = [NSString stringWithFormat:@"table"];
    NSString *assignedTableList= [NSString stringWithFormat:@""];;
    NSString *timeStampList= [NSString stringWithFormat:@""];;
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:timestamp,@"timestamp",ids, @"id",user, @"user",assignedTableList, @"assignedtablelist",timeStampList, @"timestamplist", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchHelpMessages",Kwebservices]];
    
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

#pragma mark - Send Help Message
-(void) changeStatus:(NSString *)pendingOrdersIDS
{
    [self disabled];
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *startTime;
    
    startTime = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curruntTime = [ dateFormat stringFromDate:startTime];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:pendingOrdersIDS,@"OrderId",[NSString stringWithFormat:@"delivered"], @"Status",curruntTime,@"Datetime", nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/ChangeOrderStatus",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webServiceCode =11;
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
    [self enable];
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
    if (webServiceCode == 1) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
//        NSLog(@"responseString:%@",responseString);
//        NSError *error;
//        
//        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
//        
//        SBJsonParser *json = [[SBJsonParser alloc] init];
//        
//        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
//        NSLog(@"Dictionary %@",userDetailDict);
//        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"maxtimestamp"]];
//        [defaults setObject:resultStr forKey:@"Customer Incoming Chat Timestamp"];
//        NSMutableArray *fetchingChat = [NSMutableArray arrayWithArray:[userDetailDict valueForKey:@"MessageList"]];
//        NSMutableArray *fetchMessages = [NSMutableArray arrayWithArray:[[fetchingChat valueForKey:@"listMessage"]objectAtIndex:0]];
//        fetchedChatData = [[NSMutableArray alloc]init];
//        NSMutableArray *chatMessages = [[NSMutableArray alloc]init];
//        NSMutableArray *chatTime = [[NSMutableArray alloc]init];
//        NSMutableArray *chatSender = [[NSMutableArray alloc]init];
//        for (int i = 0; i < [fetchMessages count]; i++) {
//            fetchChatObj = [[fetchChatOC alloc]init];
//            fetchChatObj.chatMessage = [[fetchMessages valueForKey:@"message"] objectAtIndex:i];
//            fetchChatObj.chatTime = [[fetchMessages valueForKey:@"time"] objectAtIndex:i];
//            fetchChatObj.chatSender = [[fetchMessages valueForKey:@"sender"] objectAtIndex:i];
//            fetchChatObj.TableId = [[fetchMessages valueForKey:@"tableid"] objectAtIndex:i];
//            [chatMessages addObject:fetchChatObj.chatMessage];
//            [chatTime addObject:fetchChatObj.chatTime];
//            [chatSender addObject:fetchChatObj.chatSender];
//            [fetchedChatData addObject:fetchChatObj];
//        }
//        allChatMessages = [[NSMutableArray alloc]init];
//        
//        chatDictionary = [[NSMutableDictionary alloc]initWithObjectsAndKeys:chatMessages,@"messages",chatTime,@"time",chatSender,@"sender",nil];
//        NSLog(@"CHAT OBJECT ... %@",chatDictionary);
//        for (int i = 0; i < [chatMessages count]; i++) {
//            chatObj = [[chatOC alloc]init];
//            chatObj.chatMessage = [[chatDictionary valueForKey:@"messages"] objectAtIndex:i];
//            chatObj.chatTime = [[chatDictionary valueForKey:@"time"] objectAtIndex:i];
//            chatObj.chatSender = [[chatDictionary valueForKey:@"sender"] objectAtIndex:i];
//            [chatArray addObject:chatObj];
//            NSLog(@"CHAT OBJECT ... %@",chatObj.chatSender);
//            NSBubbleData *Bubble;
//            NSString *senderChat =[NSString stringWithFormat:@"%@",chatObj.chatSender];
//            senderChat = [senderChat stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
//            senderChat = [senderChat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            senderChat = [senderChat stringByReplacingOccurrencesOfString:@")" withString:@""];
//            senderChat = [senderChat stringByReplacingOccurrencesOfString:@" " withString:@""];
//            
//            NSString *chatMessage =[NSString stringWithFormat:@"%@",chatObj.chatMessage];
//            chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"(\n " withString:@""];
//            chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
//            chatMessage = [chatMessage stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            
//            if([senderChat isEqualToString:@"table"]){
//                Bubble = [NSBubbleData dataWithText:chatMessage date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine isDateChanged:@"YES"];
//                Bubble.avatar = [UIImage imageNamed:@"avatar1.png"];
//            }else{
//                Bubble = [NSBubbleData dataWithText:chatMessage date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeSomeoneElse isDateChanged:@"YES"];
//                Bubble.avatar = nil;
//            }
//            
//            [allChatMessages addObject:Bubble];
//        }
//        
//        self.chatTableView.bubbleDataSource = self;
//        self.chatTableView.snapInterval = 120;
//        self.chatTableView.showAvatars = YES;
//        self.chatTableView.typingBubble = NSBubbleTypingTypeSomebody;
//        
//        [self.chatTableView reloadData];
//        
//        
//        
//        self.chatTableView.bubbleDataSource = self;
//        
//        self.chatTableView.snapInterval = 120;
//        
//        [self performSelector:@selector(goToBottom) withObject:nil afterDelay:0.001];
//        self.chatTableView.typingBubble = NSBubbleTypingTypeSomebody;
//        NSLog(@"CHAT Array %@",chatObj);
//        self.chatMessageTxtView.text = @"";
//        [self.chatTableView reloadData];
//        
    }else if (webServiceCode == 2) {
        [self.noteTextView resignFirstResponder];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        self.placeOrderPopUp.hidden = YES;
        NSString *resultStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"result"]];
        if([resultStr isEqualToString:@"0"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"GOGO EVENTS" message:@"Your order is placed successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 999;
            [defaults setValue:@"" forKey:@"Note"];
            [alert show];
            //            chatUsed = 2;
        }
        
    }else if (webServiceCode == 3) {
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        
    }
    else if(webServiceCode == 10){
        
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
        
        
    }else if (webServiceCode == 11){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        self.pendingOrderPopUp.hidden = YES;
        [self.view sendSubviewToBack:self.pendingOrderPopUp];
        [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"delivered"]];
    }else if (webServiceCode == 12){
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict);
        NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]];
        
    }
    
    
    [self EnableBackView];
    [self enable];
    [activityIndicator stopAnimating];
}

#pragma mark - Add order
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
        int totalPrice = [totalValue intValue];
        
        totalPrice = totalPrice * orderItemQuantities;
        if ([tempOrder containsObject:[NSString stringWithFormat:@"%@",itemsID]]) {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE orderHistory SET orderItemName = \"%@\" , ordercuisine = \"%@\", orderType = \"%@\", orderQuantity = %d, orderPrice = \"%d\", orderItemImage = \"%@\"  where orderItemID = \"%@\"" ,[results stringForColumn:@"itemName"],[results stringForColumn:@"cuisine"],[results stringForColumn:@"typeID"],orderItemQuantities,totalPrice,[results stringForColumn:@"itemImage"], [NSString stringWithFormat:@"%d",itemID]];
            [database executeUpdate:updateSQL];
        }else{
            NSString *insert = [NSString stringWithFormat:@"INSERT INTO orderHistory (orderItemID, orderItemName, ordercuisine, orderType, orderQuantity, orderPrice,orderItemImage) VALUES (%@, \"%@\",\"%@\",\"%@\", \"%d\",\"%d\",\"%@\")",[results stringForColumn:@"itemID"],[results stringForColumn:@"itemName"],[results stringForColumn:@"cuisine"],[results stringForColumn:@"typeID"],orderItemQuantities,totalPrice,[results stringForColumn:@"itemImage"]];
            [database executeUpdate:insert];
        }
        
    }
    
    [database close];
    
}
#pragma mark - load Order Table
-(void)orderlist
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results = [database executeQuery:queryString];
    
    orderList = [[NSMutableArray alloc] init];
    while([results next]) {
        orderObj = [[orderOC alloc]init];
        orderObj.orderItemName=[results stringForColumn:@"orderItemName"];
        orderObj.orderQuantity = [results intForColumn:@"orderQuantity"];
        orderObj.orderItemID = [results intForColumn:@"orderItemID"];
        orderObj.orderPrice = [results intForColumn:@"orderPrice"];
        [orderList addObject:orderObj];
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
    
    [database close];
    
    
    
}

-(void)popUpOrderlist
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM orderHistory "];
    FMResultSet *results = [database executeQuery:queryString];
    
    placeOrderItemName = [[NSMutableArray alloc]init];
    placeOrderList = [[NSMutableArray alloc] init];
    placeOrderPriceCount = [[NSMutableArray alloc]init];
    while([results next]) {
        placeOrderObj = [[PlaceOrderData alloc]init];
        placeOrderObj.itemName = [results stringForColumn:@"orderItemName"];
        placeOrderObj.Quantity = [results intForColumn:@"orderQuantity"];
        placeOrderObj.ItemId = [results intForColumn:@"orderItemID"];
        placeOrderObj.Price = [results intForColumn:@"orderPrice"];
        [placeOrderList addObject:placeOrderObj];
        [placeOrderPriceCount addObject:[NSString stringWithFormat:@"%d",placeOrderObj.Price]];
    }
    
    [database close];
    
    
    int k = 0 ;
    for (int i = 0;i < [placeOrderPriceCount count]; i++) {
        
        
        int j = [[placeOrderPriceCount objectAtIndex:i] intValue];
        j=j+k;
        k= j;
    }
    self.totalAmountLbl.text = [NSString stringWithFormat:@"$%d",k];
    NSLog(@"Notes %@",[defaults valueForKey:@"Note"]);
    if ([[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Note"]] isEqualToString:@"(null)"]) {
        self.orderNoteLbl.text =[NSString stringWithFormat:@"Please add your note."];
        
    }else{
        self.orderNoteLbl.text =[NSString stringWithFormat:@"%@",[defaults valueForKey:@"Note"]];
    }
    
    [self.placeOrderTableView reloadData];
    
}

- (IBAction)pendingOrderDoneBtn:(id)sender {
    if ([self.pendingOrderDoneBtn.titleLabel.text isEqualToString:@"Done"]) {
        [self EnableBackView];
        self.pendingOrderPopUp.hidden = YES;
        [self.pendingOrdersTableView reloadData];
    }else{
        [self changeStatus:processingOrderID];
    }
    
}

-(void)pendingOrderItems:(int)index
{
    pendingOrderObj = [pendingOrderListArray objectAtIndex:index];
    
    pendingOrderItemNameArray = [[NSMutableArray alloc] initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"itemname"]];
    pendingOrderItemPriceArray = [[NSMutableArray alloc] initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"price"]];
    pendingOrderItemQuantityArray = [[NSMutableArray alloc]initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"quantity"]];
    pendingOrderTimeOfDeliveryArray = [[NSMutableArray alloc]initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"TimeOfDelivery"]];
    NSLog(@"Pending Order Items %@",pendingOrderItemNameArray);
    NSLog(@"Pending Order Item Price %@",pendingOrderItemPriceArray);
    NSLog(@"Pending Order Item Quantity %@",pendingOrderItemQuantityArray);
    NSLog(@"Pending Order Total Price %@",pendingOrderObj.TotalBill);
    NSLog(@"Pending Order TimeOfDelivery%@",pendingOrderTimeOfDeliveryArray);
    [self.pendingOrderTableView reloadData];
    
    
}

-(void)processingOrders:(int)index
{
    pendingOrderObj = [processingOrderList objectAtIndex:index];
    
    pendingOrderItemNameArray = [[NSMutableArray alloc] initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"itemname"]];
    pendingOrderItemPriceArray = [[NSMutableArray alloc] initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"price"]];
    pendingOrderItemQuantityArray = [[NSMutableArray alloc]initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"quantity"]];
    pendingOrderTimeOfDeliveryArray = [[NSMutableArray alloc]initWithArray:[pendingOrderObj.pendingOrderDetails valueForKey:@"TimeOfDelivery"]];
    NSLog(@"Pending Order Items %@",pendingOrderItemNameArray);
    NSLog(@"Pending Order Item Price %@",pendingOrderItemPriceArray);
    NSLog(@"Pending Order Item Quantity %@",pendingOrderItemQuantityArray);
    NSLog(@"Pending Order Total Price %@",pendingOrderObj.TotalBill);
    NSLog(@"Pending Order TimeOfDelivery%@",pendingOrderTimeOfDeliveryArray);
    processingOrderID = [NSString stringWithFormat:@"%@", pendingOrderObj.OrderId];
    [self.pendingOrderTableView reloadData];
    
    
}
- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
    [self.view bringSubviewToFront:self.disabledImgView];
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
    [self.view sendSubviewToBack:self.disabledImgView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 999)
    {
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
        [database executeUpdate:queryString1];
        [database close];
        [self orderlist];
        [self FetchPendingPlacedOrder:[NSString stringWithFormat:@"Open"]];
    }else if (alertView.tag == 1000 && buttonIndex == 1){
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
        [database executeUpdate:queryString1];
    
        [database close];
        [self orderlist];
        
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
- (IBAction)insertNoteBtn:(id)sender {
    
    NSString *str = [NSString stringWithFormat:@"%@",self.noteTextView.text];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:str forKey:@"Note"];
    self.notesPopUpView.hidden = YES;
    self.noteTextView.text = @"";
    
    [self EnableBackView];
}

- (IBAction)notesPopUpCloseBtn:(id)sender {
    if (self.notesPopUpView.hidden == NO) {
        [self EnableBackView];
        self.notesPopUpView.hidden = YES;
        //self.noteTextView.text = @"";
    }
}
- (IBAction)notesBtn:(id)sender {
    
    if (self.notesPopUpView.hidden == YES)
    {
        [self DisableBackView];
        self.notesPopUpView.hidden = NO;
        self.noteTextView.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"Note"];
    }
    [self.placeNotePopUpTitle setFont:[UIFont fontWithName:@"Poor Richard" size:18]];
    [[self.noteTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.noteTextView layer] setBorderWidth:1.0];
    [[self.noteTextView layer] setCornerRadius:5];
}

- (IBAction)chatCloseBtn:(id)sender {
    self.chatView.hidden=YES;
}

-(void) DisableBackView
{
    self.menuTableView.userInteractionEnabled=NO;
    menuBtn.userInteractionEnabled=NO;
    notesBtn.userInteractionEnabled=NO;
    self.ordersTableView.userInteractionEnabled=NO;
    orderNowBtn.userInteractionEnabled=NO;
    self.pendingOrdersTableView.userInteractionEnabled=NO;
    self.menuItemsTableView.userInteractionEnabled=NO;
}
-(void) EnableBackView
{
    self.menuTableView.userInteractionEnabled=YES;
    menuBtn.userInteractionEnabled=YES;
    notesBtn.userInteractionEnabled=YES;
    self.ordersTableView.userInteractionEnabled=YES;
    orderNowBtn.userInteractionEnabled=YES;
    self.pendingOrdersTableView.userInteractionEnabled=YES;
    self.menuItemsTableView.userInteractionEnabled=YES;
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView == self.noteTextView){
        CGPoint pt;
        
        pt.x = self.notesPopUpView.frame.origin.x;
        pt.y = self.notesPopUpView.frame.origin.y - 125;
        [self.notesPopUpView setFrame:CGRectMake(pt.x, pt.y, self.notesPopUpView.frame.size.width, self.notesPopUpView.frame.size.height)];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == self.noteTextView)
    {
        [self.notesPopUpView setFrame:CGRectMake(notesOriginalPt.x, notesOriginalPt.y, self.notesPopUpView.frame.size.width, self.notesPopUpView.frame.size.height)];
    }
    [textView resignFirstResponder];
    
}

- (BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    if (textView == self.noteTextView)
    {
        [self.notesPopUpView setFrame:CGRectMake(notesOriginalPt.x, notesOriginalPt.y, self.notesPopUpView.frame.size.width, self.notesPopUpView.frame.size.height)];
    }
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"user editing");
    if([text isEqualToString:@"\n"])
    {
        if (textView == self.noteTextView)
        {
            [self.notesPopUpView setFrame:CGRectMake(notesOriginalPt.x, notesOriginalPt.y, self.notesPopUpView.frame.size.width, self.notesPopUpView.frame.size.height)];
            [textView resignFirstResponder];
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGPoint pt;
    
    pt.x = self.chatView.frame.origin.x;
    pt.y = self.chatView.frame.origin.y - 385;
    [self.chatView setFrame:CGRectMake(pt.x, pt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)decreaseQuantityBtn:(id)sender {
    NSString *currentValue = [NSString stringWithFormat:@"%@",self.quantityLbl.text];
    int quantity = [currentValue intValue];
    quantity -= 1;
    self.quantityLbl.text = [NSString stringWithFormat:@"%d",quantity];
    if ([self.quantityLbl.text isEqualToString:[NSString stringWithFormat:@"1"]]) {
        [self.decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decrease.png"] forState:UIControlStateNormal];
        [self.decreaseBtn setUserInteractionEnabled:NO];
        [self.increaseBtn setUserInteractionEnabled:YES];

    }else{
        [self.increaseBtn setBackgroundImage:[UIImage imageNamed:@"increaseselect.png"] forState:UIControlStateNormal];
        [self.increaseBtn setUserInteractionEnabled:YES];
    }
}

- (IBAction)increaseQuantityBtn:(id)sender {
    NSString *currentValue = [NSString stringWithFormat:@"%@",self.quantityLbl.text];
    int quantity = [currentValue intValue];
    quantity += 1;
    self.quantityLbl.text = [NSString stringWithFormat:@"%d",quantity];
    if ([self.quantityLbl.text isEqualToString:[NSString stringWithFormat:@"%d",maximumQty]]) {
        [self.increaseBtn setBackgroundImage:[UIImage imageNamed:@"increase.png"] forState:UIControlStateNormal];
        [self.increaseBtn setUserInteractionEnabled:NO];
        [self.decreaseBtn setUserInteractionEnabled:YES];

    }else{
        [self.decreaseBtn setBackgroundImage:[UIImage imageNamed:@"decreaseselect.png"] forState:UIControlStateNormal];
        [self.decreaseBtn setUserInteractionEnabled:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == self.menuTableView || touch.view == self.pendingOrderTableView) {
        return NO;
    }
    return YES;
}
- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    //    CGPoint pt;
    //
    //    pt.x = self.chatView.frame.origin.x;
    //    pt.y = self.chatView.frame.origin.y - 385;
    //    [self.chatView setFrame:CGRectMake(pt.x, pt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    
}
- (IBAction)minimizeBtn:(id)sender {
    if (isMinimized) {
        isMinimized = NO;
        [self.chatView setFrame:CGRectMake(originalPt.x, originalPt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    }else{
        CGPoint pt;
        isMinimized = YES;
        NSLog(@"Height of View .... %f", self.chatView.frame.size.height);
        pt.x = self.chatView.frame.origin.x;
        pt.y = self.chatView.frame.origin.y + self.chatView.frame.size.height - 33;
        [self.chatView setFrame:CGRectMake(pt.x, pt.y, self.chatView.frame.size.width, self.chatView.frame.size.height)];
    }
}

//- (IBAction)markDeliverbtn:(id)sender {
//    if ([processingOrderList count] == 0) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"GoGo Events" message:@"No orders in process." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }else{
//
//        [self.deliveryOrderView setFrame:CGRectMake(8, 58, 1008, 622)];
//        [self.sideScroller addSubview:self.deliveryOrderView];
//
//    }
//
//}
- (IBAction)dismissBack:(id)sender {
    self.itemView.hidden = YES;
}

- (IBAction)viewOrderBtn:(id)sender {
}

- (IBAction)addToOrder:(id)sender {
    [self.itemView setBackgroundColor: [UIColor clearColor]];
    NSLog(@"ITEMID.. %d , %d",menuItemsObj.ItemId,[self.quantityLbl.text intValue]);
    [self orderList:[NSString stringWithFormat:@"%d",menuItemsObj.ItemId] :[self.quantityLbl.text intValue]];
    
    self.headerView.hidden = YES;
    self.footerView.hidden = YES;
    self.itemImageView.hidden = YES;
    itemNamebg.hidden = YES;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect theFrame = self.itemView.frame;
        theFrame.size.height -= 750.0f;
        theFrame.origin.x += 797.0f;
        theFrame.origin.y += 495.0f;
        theFrame.size.width -= 950.0f;
        self.itemView.frame = theFrame;
    }];
    
    [UIView animateWithDuration:0.5f animations:^{
        CGRect theFrame = itemImagePage.frame;
        theFrame.size.height = 240.f;
        theFrame.origin.x = 0.0f;
        theFrame.origin.y = 20.0f;
        theFrame.size.width = 225.0f;
        
        itemImagePage.frame = theFrame;
    }];
    if (self.minimizeAnimatedView.frame.origin.y != 486) {
        CGRect theFrame = self.minimizeAnimatedView.frame;
        theFrame.origin.y -= 250;
        self.minimizeAnimatedView.frame = theFrame;
    }
    
    NSTimer *hideTimer = [NSTimer scheduledTimerWithTimeInterval:1.00 target:self selector:@selector(minimizeView) userInfo:nil repeats:NO];
}
-(void)hideView
{
    // [self.view bringSubviewToFront:self.minimizeAnimatedView];
    itemImagePage.hidden = YES;
    self.itemView.hidden = YES;
    self.minimizeAnimatedView.hidden = NO;
    
    //myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(minimizeView) userInfo:nil repeats:NO];
    
}

-(void)minimizeView
{
    //    [UIView animateWithDuration:1.0f animations:^{
    //        CGRect theFrame = self.showMinimizeItemImage.frame;
    //
    //        theFrame.origin.y += 80.0f;
    //        theFrame.size.height = 0.0f;
    //        self.showMinimizeItemImage.frame = theFrame;
    //    }];
    
    
    
    [self.view bringSubviewToFront:self.mainMenuFooter];
    [UIView animateWithDuration:0.5f animations:^{
        CGRect theFrame = self.itemView.frame;
        theFrame.origin.y += 250;
        self.itemView.frame = theFrame;
        
    }];
    [self.viewOrderBtn setUserInteractionEnabled:YES];
    [self orderlist];
    
    
}

- (IBAction)checkOutView:(id)sender {
    CheckOutViewController*checkoutVc=[[CheckOutViewController alloc]initWithNibName:@"CheckOutViewController" bundle:nil];
    [self.navigationController pushViewController:checkoutVc animated:NO];
}

- (IBAction)requestAssistanceBtn:(id)sender {
    requestAssistanceViewController *requestAssistanceVC = [[requestAssistanceViewController alloc] initWithNibName:@"requestAssistanceViewController" bundle:nil];
    [self.navigationController pushViewController:requestAssistanceVC animated:NO];
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

- (IBAction)exitAction:(id)sender {
    
    [self.exitPopUpView setFrame:CGRectMake(0, 10, self.exitPopUpView.frame.size.width, self.exitPopUpView.frame.size.height)];
    [self.view addSubview:self.exitPopUpView];
    
    
}
- (IBAction)newOrderAction:(id)sender {
    menuStateViewController *homeVC = [[menuStateViewController alloc] initWithNibName:@"menuStateViewController" bundle:nil];
    homeVC.isNewOrder = YES;
    [self.navigationController pushViewController:homeVC animated:NO];
}

- (IBAction)closeStartUpPopUp:(id)sender {
    [self.startUpPopUp removeFromSuperview];
}

- (IBAction)appHomeAction:(id)sender {
    appHomeViewController *homeVC = [[appHomeViewController alloc] initWithNibName:@"appHomeViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}
- (IBAction)ophemyAction:(id)sender {
    eventImagesSlideViewViewController *homeVC = [[eventImagesSlideViewViewController alloc] initWithNibName:@"eventImagesSlideViewViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}
- (IBAction)popUpContinueBtn:(id)sender {
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"niniEvents.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString1 = [NSString stringWithFormat:@"Delete FROM orderHistory"];
    [database executeUpdate:queryString1];
    [database close];
    
    [self.startUpPopUp removeFromSuperview];
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
    webServiceCode =12;
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
