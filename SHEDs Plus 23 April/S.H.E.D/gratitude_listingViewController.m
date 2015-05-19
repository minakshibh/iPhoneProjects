
//
//  testViewController.m
//  AccordionTableView
//
//  Created by Krishna_Mac on 12/26/13.
//  Copyright (c) 2013 Vladimir Olexa. All rights reserved.
//

#import "gratitude_listingViewController.h"
#import "homescreenViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "PageWebViewController.h"

#define NUM_TOP_ITEMS 6
#define NUM_SUBITEMS 1
#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 60
#define kColumnMargin 10
#define kOFFSET_FOR_KEYBOARD 70.0

@interface gratitude_listingViewController ()

@end

@implementation gratitude_listingViewController

@synthesize myTableView, gratitude_list,gratimgup,gratimgdown,rowIndex,selectIndex,gratlbl,datelbl,fileName,gratArchievArray,editBtn,deleteBtn,gratitudeDescription,doneBtn,gratPopUp,gratTxtView,hideTxtView,disableImgView;

- (id)init {
    self = [super init];
    
    if (self) {
        //topItems = [[NSArray alloc] initWithArray:[self topLevelItems]];
//        subItems = [NSMutableArray new];
//        currentExpandedIndex = -1;
//        
//        for (int i = 0; i < [topItems count]; i++) {
//            [subItems addObject:[self subItems]];
//        }
    }
    return self;
}

#pragma mark - Data generators

- (NSArray *)topLevelItems:(NSArray *) arr {
    NSMutableArray *items = [NSMutableArray array];

    for (int i = 0; i < [arr count]; i++)
    {
        Gratitude *myGrat =[arr objectAtIndex:i];
        [items addObject:myGrat.gratitude];
    }
    return items;
}

- (NSArray *)subItems:(NSString *)str {
    NSMutableArray *items = [NSMutableArray array];
   // int numItems = NUM_SUBITEMS;
    
  //  for (int i = 0; i < numItems; i++) {
        [items addObject:str];
  //  }
    return items;
}

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    currentSelection = 0;
    lastSelection = 0;
    isMovingDown = false;
    flag = 0;
    
    
    NSUserDefaults *value = [NSUserDefaults standardUserDefaults];
    autoArchieve=[value valueForKey:@"autoArchieve"];
    keepHistry=[value valueForKey:@"keepArchieveHisty"];
    emailid=[value valueForKey:@"Emailid"];
    if (autoArchieve==nil)
    {
        [value setObject:@"Off" forKey:@"autoArchieve"];
        autoArchieve=@"Off";
    }
    if (keepHistry==nil) {
        
        [value setObject:@"No History" forKey:@"keepArchieveHisty"];
        keepHistry=@"No History";
    }
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn addTarget:self action:@selector(moveback:) forControlEvents:UIControlEventTouchUpInside];
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    backbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:backbtn];
    UILabel *titlelbl;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(35,24, 250, 43)];
          backbtn.frame = CGRectMake(5, 19, 60, 40);
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:26]];

        //this is iphone 5 xib
    }else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
        titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(34,24, 240, 43)];
          backbtn.frame = CGRectMake(5, 19, 60, 40);
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:24]];

        // this is iphone 4 xib
    }
    else {
        titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(109,47, 550, 80)];
        backbtn.frame = CGRectMake(15, 22, 128, 95);
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];
        // this is iphone 4 xib
    }

    titlelbl.text = @"I am Grateful for";
    titlelbl.textColor = [UIColor whiteColor];
    titlelbl.shadowColor = [UIColor colorWithRed:22/255.0f green:22/255.0f blue:72/255.0f alpha:1];
    titlelbl.shadowOffset = CGSizeMake(0, 2);
    titlelbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titlelbl];
    
    gratitude_list = [[NSMutableArray alloc]init];
    
    [self loadGratitudes];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(dismissKeyboard)];
//    [self.hideTxtView addGestureRecognizer:tap];
}
-(void)dismissKeyboard
{
    disableImgView.hidden=YES;
    self.myTableView.userInteractionEnabled=YES;
    [self.view endEditing:YES];
    if (gratPopUp.hidden==NO)
    {
        gratPopUp.hidden=YES;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(keyboardWillShow)
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(keyboardWillHide)
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
      if ([[UIScreen mainScreen] bounds].size.height == 480)
      {
          [[NSNotificationCenter defaultCenter] removeObserver:self
                                                          name:UIKeyboardWillShowNotification
                                                        object:nil];
          [[NSNotificationCenter defaultCenter] removeObserver:self
                                                          name:UIKeyboardWillHideNotification
                                                        object:nil];
      }
}


-(void)keyboardWillShow {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}





-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


-(void)loadGratitudes{
  //   gratitude_list =[[NSMutableArray alloc]init];
    isLoadMoreRequired = false;
    
       NSString *queryString = [NSString stringWithFormat:@"select * from Gratitude order by id DESC LIMIT 30 OFFSET %lu ", (unsigned long)gratitude_list.count];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"query %@", queryString);
    NSLog(@"path : %@", dbPath);
    [database open];
    NSLog(@"query %@", queryString);
    FMResultSet *results = [database executeQuery:queryString];
  
  
    while([results next]) {
        NSLog(@"I AM HERE");
        Gratitude *gratitudeoc	= [[Gratitude alloc] init];
        gratitudeoc.grat_id = [results intForColumn:@"id"];
        gratitudeoc.gratitude = [results stringForColumn:@"gratitude"];
        gratitudeoc.gratitudedate = [results stringForColumn:@"gratitude_date"];

        NSLog(@"grat id :: %d", gratitudeoc.grat_id);
        NSLog(@"grat name :: %@", gratitudeoc.gratitude);
        NSLog(@"grat date :: %@", gratitudeoc.gratitudedate);
        [gratitude_list addObject:gratitudeoc];
    }
   
    queryString = [NSString stringWithFormat:@"select * from Gratitude order by id DESC LIMIT 1 OFFSET %lu", (unsigned long)gratitude_list.count];
    
    FMResultSet *subResultSet = [database executeQuery:queryString];
    int count =0;
    while([subResultSet next]){
        count++;
        break;
    }
    
    if(count>0){
        isLoadMoreRequired = true;
    }else{
        isLoadMoreRequired = false;
    }
    
    [database close];

    topItems = [[NSArray alloc] initWithArray:[self topLevelItems:gratitude_list]];
    subItems = [NSMutableArray new];
    currentExpandedIndex = -1;
    
    for (int i = 0; i < [topItems count]; i++) {
        Gratitude *myGrat =[gratitude_list objectAtIndex:i];
        [subItems addObject:[self subItems:myGrat.gratitude]];
    }
    
    [self.myTableView reloadData];
}

- (IBAction)moveback:(id)sender
{
    disableImgView.hidden=YES;

    gratPopUp.hidden=YES;
    [self.view endEditing:YES];

    homescreenViewController *homevc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
        //this is iphone 5 xib
    }else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else {
        homevc = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_ipad" bundle:nil];
        // this is iphone 4 xib
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController pushViewController:homevc animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [topItems count] + ((currentExpandedIndex > -1) ? [[subItems objectAtIndex:currentExpandedIndex] count] : 0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[subItems objectAtIndex:currentExpandedIndex] count];
    
    UITableViewCell *cell;
    if (isChild) {
        cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
    }
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ParentCellIdentifier];
    }
    
    if (isChild) {
        //Load text in NSString which you want in Cell's LabelText.
        NSString *myStr = [[subItems objectAtIndex:currentExpandedIndex] objectAtIndex:indexPath.row - currentExpandedIndex - 1];
        
        //define font for Labeltext...
        UIFont *cellFont = [UIFont fontWithName:@"Lucida Sans" size:14.0];
        
        CGSize constraintSize = CGSizeMake(320.0f, MAXFLOAT);
        
        //sizeWithFont: Returns the size of the string if it were rendered with the specified constraints. So it will break your line according to font size and constraint size.
        
        CGSize labelSize_val = [myStr sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:cell.textLabel.lineBreakMode];
        //cell.textLabel.numberOfLines =10;
        
        if(labelSize_val.height>50)
            return  labelSize_val.height + 50;
        // Add 20 in height so your UITableView will be neat and clean.
        
        else
            return labelSize_val.height + 20;
    }
    else if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        
        return 50;
    }
    else{
        return 87.0;
        
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(loadGratitudes) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Load More..." forState:UIControlStateNormal];
    
  if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
      button.titleLabel.font = [UIFont systemFontOfSize:14.0];
         button.frame = CGRectMake(0, 0, 110.0, 30.0);

  }
  else{
      button.titleLabel.font = [UIFont systemFontOfSize:28.0];
         button.frame = CGRectMake(0, 0, 180.0, 35.0);

  }
    
    
    
    [headerView addSubview:button];
   
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(isLoadMoreRequired)
        return 30;
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParentCellIdentifier = @"ParentCell";
    ChildCellIdentifier = @"ChildCell";
    
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[subItems objectAtIndex:currentExpandedIndex] count];
    
    UITableViewCell *cell;
    
    if (isChild) {
        cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
    }
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ParentCellIdentifier];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        gratlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 19, 200, 30)];
        datelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(300, 25, 10, 10)];
        editBtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 17, 25, 25)];
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 17, 25, 25)];
        [gratlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [datelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:12]];
        
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        gratlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 19, 200, 30)];
        datelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(300, 25, 10, 10)];
        editBtn = [[UIButton alloc] initWithFrame:CGRectMake(230 , 17, 25, 25)];
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 17, 25, 25)];
        [gratlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [datelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:12]];
        
    }
    else{
        gratlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 19, 500, 80)];
        datelbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(700, 40,16, 27)];
        editBtn = [[UIButton alloc] initWithFrame:CGRectMake(560, 24, 50, 50)];
        deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(630,24, 50, 50)];
        [gratlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:35]];
        [datelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];
        
    }
    gratlbl.textAlignment = NSTextAlignmentLeft;
    datelbl.textColor = [UIColor grayColor];
    datelbl.textAlignment = NSTextAlignmentCenter;
    UIImage *editbuttonBackgroundImage = [UIImage imageNamed:@"edit-icon.png"];
    UIImage *deletebuttonBackgroundImage = [UIImage imageNamed:@"delete-icon2.png"];
    [editBtn setBackgroundImage:editbuttonBackgroundImage forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:deletebuttonBackgroundImage forState:UIControlStateNormal];
    
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editGratitude:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn addTarget:self action:@selector(deleteGratitude:) forControlEvents:UIControlEventTouchUpInside];
    gratlbl.tag =1;
    datelbl.tag =2;
    
    gratimgup.tag = 200 + indexPath.row;
    
    [cell.contentView addSubview:datelbl] ;
    [cell.contentView addSubview:gratlbl] ;
    [cell.contentView addSubview:gratimgup];
    [cell.contentView addSubview:editBtn];
    [cell.contentView addSubview:deleteBtn];
    
    int topIndex = (currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex)
    ? indexPath.row - [[subItems objectAtIndex:currentExpandedIndex] count]
    : indexPath.row;
   
    gratOC =[gratitude_list objectAtIndex:topIndex];
    
    cell.detailTextLabel.text = @"";
    
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *changedDate = [formatter1 dateFromString:gratOC.gratitudedate];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init] ;
    [df setDateFormat:@"MM-dd-yyyy"];
    
    NSString* todaydate = [df stringFromDate:changedDate];
    gratlbl = (UILabel *) [cell.contentView viewWithTag:1];
    gratlbl.text = gratOC.gratitude;
    
    datelbl = (UILabel *) [cell.contentView viewWithTag:2];
    datelbl.text = [NSString stringWithFormat:@"%@",todaydate];
    editBtn.tag = gratOC.grat_id + 200;
    deleteBtn.tag = gratOC.grat_id +400;
  
    gratimgup.image = [UIImage imageNamed:@"arrow.png"];
    
    if (isChild) {
        NSString *myStr = [[subItems objectAtIndex:currentExpandedIndex] objectAtIndex:indexPath.row - currentExpandedIndex - 1];
        UIFont *cellFont;
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
            cellFont = [UIFont fontWithName:@"Lucida Sans" size:15.0];
        }
        else{
            cellFont = [UIFont fontWithName:@"Lucida Sans" size:21.0];
        }
        
        cell.detailTextLabel.font = cellFont;
        cell.detailTextLabel.text = myStr;
        cell.detailTextLabel.numberOfLines = 100;
        cell.backgroundColor = [UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
        gratimgup.hidden = YES;
        gratimgdown.hidden = YES;
        gratlbl.text = @"";
        datelbl.text = @"";
        gratlbl.hidden = YES;
        datelbl.hidden = YES;
        editBtn.hidden = YES;
        deleteBtn.hidden = YES;
    }
    
    if(currentExpandedIndex == indexPath.row){
        
        gratimgup.image = [UIImage imageNamed:@"arrow-icon.png"];
        //        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
        //            gratimgup.frame = CGRectMake(300, 21, 10, 10);
        //        }
        //        else{
        //            gratimgup.frame = CGRectMake(700, 40, 26, 15);
        //
        //        }
        
        NSLog(@"down arrow %ld", (long)indexPath.row);
        cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    }
    else if(currentExpandedIndex + 1 == indexPath.row && currentExpandedIndex!= -1){
        // gratimgup.image = nil;
        NSLog(@"empty arrow %ld", (long)indexPath.row);
        //        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
        //            gratimgup.frame = CGRectMake(300, 21, 10, 10);
        //        }
        //        else{
        //            gratimgup.frame = CGRectMake(700, 40, 26, 15);
        //        }
        
        cell.backgroundColor = [UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    }
    else{
        gratimgup.image = [UIImage imageNamed:@"arrow.png"];
        //        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
        //            gratimgup.frame = CGRectMake(300, 21, 10, 10);
        //        }
        //        else{
        //            gratimgup.frame = CGRectMake(700, 40, 16, 27);
        //        }
        
        NSLog(@"normal arrow %ld", (long)indexPath.row);
        cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    }
    
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
   
    gratPopUp.hidden=YES;
    [self.view endEditing:YES];
    
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[subItems objectAtIndex:currentExpandedIndex] count];
   
    //UITableViewCell *cell;
    rowIndex = indexPath.row;
    currentSelection = indexPath.row;
    if(lastSelection<currentSelection){
        isMovingDown = YES;
    }else{
        isMovingDown = NO;
    }
    
    lastSelection = currentSelection;
   //NSLog(@"is Moving Down :: %d", isMovingDown);
    
    if (isChild) {
        NSLog(@"A child was tapped, do what you will with it");
        return;
    }
    
    [self.myTableView beginUpdates];
    
    
    if (currentExpandedIndex == indexPath.row) {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        UIImageView *check = (UIImageView*)[cell.contentView viewWithTag:200+indexPath.row];
//        check.image = [UIImage imageNamed:@"arrow.png"];
        
        [self collapseSubItemsAtIndex:currentExpandedIndex];
        currentExpandedIndex = -1;
    }
    else {
        
        shouldCollapse = currentExpandedIndex > -1;
        
        //NSLog(@"Before expanded index %d", currentExpandedIndex);
        
        if (shouldCollapse){
        
            [self collapseSubItemsAtIndex:currentExpandedIndex];
        }
        
        currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[subItems objectAtIndex:currentExpandedIndex] count] : indexPath.row;
        
       // NSLog(@"After expanded index %d", currentExpandedIndex);
        [self expandItemAtIndex:currentExpandedIndex];
    }
    
    [self.myTableView endUpdates];
    [self.myTableView reloadData];
}

- (void)expandItemAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = [subItems objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    
    [self.myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:nil];
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    NSLog(@"EXPAND-- current item index %d , index %d", currentExpandedIndex, index);
    NSIndexPath *indexPath1;
    UIImageView *check1;
    UITableViewCell *cell1;
    
    if(isMovingDown && shouldCollapse){
        indexPath1 = [NSIndexPath indexPathForRow:index+1 inSection:0];
        cell1= [myTableView cellForRowAtIndexPath:indexPath1];
        check1 = (UIImageView*)[cell1.contentView viewWithTag:(199+indexPath1.row)];
    }else{
         indexPath1 = [NSIndexPath indexPathForRow:index inSection:0];
        cell1= [myTableView cellForRowAtIndexPath:indexPath1];
        check1 = (UIImageView*)[cell1.contentView viewWithTag:(200+indexPath1.row)];
    }
    
        NSLog(@"INDEX PATH FOR Expand %ld",(long)check1.tag);
        //check1.image = [UIImage imageNamed:@"arrow-icon.png"];
}

- (void)collapseSubItemsAtIndex:(int)index {
//    [gratimgup removeFromSuperview];
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[subItems objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:nil];
    
    NSLog(@"COLLAPSE -- current item index %d , index %d", currentExpandedIndex, index);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
    UIImageView *check = (UIImageView*)[cell.contentView viewWithTag:(200+indexPath.row)];
    NSLog(@"INDEX PATH FOR Collapse %ld",(long)check.tag);
    check.image = [UIImage imageNamed:@"arrow.png"];
}

- (void)dealloc
{

}

- (IBAction)archieveBtn:(id)sender
{
    disableImgView.hidden=YES;
    gratPopUp.hidden=YES;
    [self.view endEditing:YES];
    self.myTableView.userInteractionEnabled=YES;

    NSDate *now = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    tenDaysAgo = [now dateByAddingTimeInterval:-10*24*60*60];
    NSLog(@"10 days ago: %@", tenDaysAgo);
    twentyDaysAgo = [now dateByAddingTimeInterval:-20*24*60*60];
    NSLog(@"20 days ago: %@", twentyDaysAgo);
    thirtyDaysAgo = [now dateByAddingTimeInterval:-30*24*60*60];
    NSLog(@"30 days ago: %@", thirtyDaysAgo);
   
    gratArchievArray=[[NSMutableArray alloc]init];

    NSLog(@"GRAT LIST..%@",gratitude_list);
    fileName = [self getPDFFileName];

    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"select * from Gratitude "];

    
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        NSLog(@"I AM HERE");
        Gratitude *gratitudeoc	= [[Gratitude alloc] init];
        gratitudeoc.grat_id = [results intForColumn:@"id"];
        gratitudeoc.gratitude = [results stringForColumn:@"gratitude"];
        gratitudeoc.gratitudedate = [results stringForColumn:@"gratitude_date"];
        
        NSLog(@"grat id :: %d", gratitudeoc.grat_id);
        NSLog(@"grat name :: %@", gratitudeoc.gratitude);
        NSLog(@"grat date :: %@", gratitudeoc.gratitudedate);
      
      
        NSDate* gratDate = [dateFormatter dateFromString:gratitudeoc.gratitudedate];
        NSLog(@"date.%@",gratDate);
        
        if ([keepHistry isEqualToString:@"No History"]) {
             [gratArchievArray addObject:gratitudeoc];
        }
        else if ([keepHistry isEqualToString:@"10 days"])
        {
            if ([gratDate compare:tenDaysAgo] == NSOrderedAscending)
            {
                [gratArchievArray addObject:gratitudeoc];
             }
        }
        else if ([keepHistry isEqualToString:@"20 days"])
        {
            if([gratDate compare:twentyDaysAgo]==NSOrderedAscending)
            {
                [gratArchievArray addObject:gratitudeoc];
            }
        }
        else if ([keepHistry isEqualToString:@"30 days"])
        {
            if([gratDate compare:thirtyDaysAgo]==NSOrderedAscending)
            {
                [gratArchievArray addObject:gratitudeoc];
            }
        }
    }
    NSLog(@"%lu",(unsigned long)gratArchievArray.count);

    if (gratArchievArray.count==0)
    {
        if ([keepHistry isEqualToString:@"No History"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"There is no gratitude to archive." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:[NSString stringWithFormat:@"There is no gratitude to archive after %@.",keepHistry ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        }
    }
    else{
        NSMutableArray *gratArray=[[NSMutableArray alloc]init];
        int gratCount=gratArchievArray.count;
        
        for (int i=0; i<gratCount;i++)
        {
            Gratitude *myGrat =[gratArchievArray objectAtIndex:i];
            NSString *gratId=[NSString stringWithFormat:@"%d",myGrat.grat_id];
            NSArray *array=[NSArray arrayWithObjects:myGrat.gratitudedate,myGrat.gratitude, nil];
            [gratArray addObject:array];
            NSLog(@"gratId.%@",gratId);
        }
        
        [database close];
        
        UIGraphicsBeginPDFContextToFile(self.fileName, CGRectZero, nil);
        CGContextRef context = UIGraphicsGetCurrentContext();
        // int currentPage = 0;
        
        CGFloat maxWidth = kDefaultPageWidth - kMargin * 2;
        CGFloat maxHeight = kDefaultPageHeight - kMargin * 2;
        CGFloat classNameMaxWidth = maxWidth / 2;
        CGFloat gradeMaxWidth = (maxWidth / 2) - kColumnMargin;
        
        UIFont* gratitudeFont= [UIFont boldSystemFontOfSize:17];
        
        CGFloat currentPageY = 0;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        int yOrigin=currentPageY+90 ;
        NSDate *now=[NSDate date];
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        [df setDateFormat:@"MM/dd/yyyy"];
        NSString *date=[[NSString alloc]initWithString:[df stringFromDate:now]];
        NSString *ShedlblStr=[NSString stringWithFormat:@"SHEDs(List of gratitudes till %@)",date];
        UIFont* shedLblFont = [UIFont systemFontOfSize:25];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        
        [ShedlblStr drawInRect:CGRectMake(20,10, 600, 30) withFont:shedLblFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        int rowheight=90;
        for (int i=0;i<gratArray.count;i++)
        {
            currentPageY = kMargin;
            
            NSArray* name = [gratArray  objectAtIndex:i ];
            NSString* date = [name objectAtIndex:0];
            NSString* gratitude = [name objectAtIndex:1];
            CGSize size = [gratitude sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
            NSString* gratitudesDate = @"Gratitude Date";
            NSString* gratitudes = @"Gratitude";
            
            [gratitudesDate drawAtPoint:CGPointMake(kMargin, currentPageY-5) forWidth:maxWidth withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping];
            [gratitudes drawAtPoint:CGPointMake(kMargin+280, currentPageY-5) forWidth:maxWidth withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping];
            
            currentPageY += size.height;
            // draw a one pixel line under the student's name
            CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
            CGContextMoveToPoint(context, kMargin, currentPageY);
            CGContextAddLineToPoint(context, kDefaultPageWidth - kMargin, currentPageY);
            CGContextStrokePath(context);
            
            size = [gratitude sizeWithFont:gratitudeFont constrainedToSize:CGSizeMake(classNameMaxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            
            if ( yOrigin > maxHeight-50 ) {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
                currentPageY = kMargin;
                yOrigin=90;
            }
            
            double height =size.height;
            [self pdfFileHeight:gratitude heightForRow:&height font:gratitudeFont];
            rowheight=height;
            if (rowheight>=maxHeight-yOrigin)
            {
                
                [date drawInRect:CGRectMake(kMargin, yOrigin, classNameMaxWidth, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
                
                int length =kDefaultPageHeight-yOrigin + 70;
                UIFont *font=[UIFont fontWithName:@"Helvetica" size:17.0f];
                NSString *firstPartString=[NSString stringWithString:gratitude];
                
                CGSize firstPartStringSize = [firstPartString sizeWithFont:font constrainedToSize: CGSizeMake(classNameMaxWidth,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                
                while(firstPartStringSize.height > length)
                {
                    firstPartString = [firstPartString substringWithRange:NSMakeRange(0, firstPartString.length-1)];
                    firstPartStringSize = [firstPartString sizeWithFont:font constrainedToSize:CGSizeMake(classNameMaxWidth,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                }
                
                if(firstPartStringSize.height <= length){
                    while(![[firstPartString substringToIndex:[firstPartString length]-1] isEqualToString:@" "])
                    {
                        NSLog(@"%@",[firstPartString substringFromIndex:[firstPartString length]-1]);
                        
                        if([firstPartString substringFromIndex:[firstPartString length]-1].length !=0 && ![[firstPartString substringFromIndex:[firstPartString length]-1] isEqualToString:@" "])
                        {
                            firstPartString = [firstPartString substringWithRange:NSMakeRange(0, firstPartString.length-1)];
                        }
                        else
                        {
                            break;
                        }
                        
                    }
                }
                
                NSString *resultStr=firstPartString;
                
                int secondPartStringLength=[gratitude length]-firstPartString.length;
                NSRange secondPartStringRange=NSMakeRange(firstPartString.length, secondPartStringLength);
                NSString *secondPartString=[gratitude substringWithRange:secondPartStringRange];
                CGSize Firstsize ;
                
                if (![secondPartString isEqualToString:@""])
                {
                    [resultStr drawInRect:CGRectMake(kMargin + classNameMaxWidth + kColumnMargin-120, yOrigin, gradeMaxWidth+120, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
                    
                    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
                    currentPageY = kMargin;
                    yOrigin=90;
                    
                    Firstsize = [resultStr sizeWithFont:gratitudeFont constrainedToSize:CGSizeMake(classNameMaxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    [secondPartString drawInRect:CGRectMake(kMargin + classNameMaxWidth + kColumnMargin-120, yOrigin, gradeMaxWidth+120,rowheight-Firstsize.height ) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
                }
                
                else {
                    [gratitude drawInRect:CGRectMake(kMargin + classNameMaxWidth + kColumnMargin-120, yOrigin, gradeMaxWidth+120, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
                }
                currentPageY += size.height;
                yOrigin +=rowheight+15-Firstsize.height;
            }
            else
            {
                [date drawInRect:CGRectMake(kMargin, yOrigin, classNameMaxWidth, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
                
                // print the grade to the right of the class name
                [gratitude drawInRect:CGRectMake(kMargin + classNameMaxWidth + kColumnMargin-120,yOrigin, gradeMaxWidth+120, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping  alignment:NSTextAlignmentLeft];
                
                currentPageY += size.height;
                yOrigin +=rowheight+15;
            }
            // increment the page number.
            // currentPage++;
        }
        // end and save the PDF.
        UIGraphicsEndPDFContext();
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Would you like to preview or email this PDF? Mailing the pdf would Archive your gratitudes." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Preview", @"Email", nil];
        
        [actionSheet showInView:self.view];
        
    }
}


- (CGFloat)pdfFileHeight:(NSString *)text heightForRow:(double *)height font:(UIFont *)font {
    NSString *labelText = text;
    CGFloat labelWidth =*height ;
    CGSize constrainToSize = (CGSize){.width = labelWidth, .height = MAXFLOAT};
    CGSize textSize = [labelText sizeWithFont:font constrainedToSize:constrainToSize lineBreakMode: NSLineBreakByTruncatingTail];
    return textSize.height ;
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
        {
            UIAlertView *alertview1=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Your mail sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //alertview1.tag=6;
            [alertview1 show];
            
            
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
            
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            NSLog(@"%lu",(unsigned long)gratArchievArray.count);
            
          
                int gratCount=gratArchievArray.count;
                
                
                for (int i=0; i<gratCount;i++)
                {
                    Gratitude *myGrat =[gratArchievArray objectAtIndex:i];
                    NSString *gratId=[NSString stringWithFormat:@"%d",myGrat.grat_id];
                    NSLog(@"gratId.%@",gratId);
                   NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM Gratitude WHERE  id = \"%d\"",myGrat.grat_id] ;
                    [database executeUpdate:deleteQuery];
                  
                }
                [database close];
            
            [gratArchievArray removeAllObjects];
              [self.myTableView reloadData];
             gratitude_list =[[NSMutableArray alloc]init];
            [self loadGratitudes];
             [self.myTableView reloadData];
            
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
        {
            UIAlertView *alertview1=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:[NSString stringWithFormat:@"Mail sent failure: %@", [error localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertview1 show];
            
        }
            break;
        default:
            break;
    }
    [[NSFileManager defaultManager] removeItemAtPath:fileName error: NULL];
    [self dismissViewControllerAnimated:YES completion:NULL];
    [myTableView reloadData];
}


-(NSString*)getPDFFileName
{
    NSString* fileName = @"Gratitudes.PDF";
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    return pdfFileName;
    
}
-(void)editGratitude:(UIControl *)sender{
    self.myTableView.userInteractionEnabled=NO;
    disableImgView.hidden=NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 200 inSection:0];
    NSNumber *selRow = [[NSNumber alloc] initWithInteger:indexPath.row];
    index1 = [selRow intValue];

    NSString *queryString = [NSString stringWithFormat:@"select * from Gratitude where id = %d",index1];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"query %@", queryString);
    NSLog(@"path : %@", dbPath);
    [database open];
    NSLog(@"query %@", queryString);
    FMResultSet *results = [database executeQuery:queryString];
   
    while([results next]) {
        NSLog(@"I AM HERE");
        Gratitude *gratOC1	= [[Gratitude alloc] init];
        gratOC1.grat_id = [results intForColumn:@"id"];
        gratOC1.gratitude = [results stringForColumn:@"gratitude"];
        
        NSLog(@"grat id :: %d", gratOC1.grat_id);
        NSLog(@"grat name :: %@", gratOC1.gratitude);
        gratString = [NSString stringWithFormat:@"%@",gratOC1.gratitude];
        
    }
    [database close];
    NSLog(@"Gratitude String %@",gratString);
    [[gratPopUp layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[gratPopUp layer] setBorderWidth:1.0];
    [[gratPopUp layer] setCornerRadius:5];
    gratPopUp.hidden = NO;
    
    [[doneBtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[doneBtn layer] setBorderWidth:1.0];
    [[doneBtn layer] setCornerRadius:5];

    [[gratTxtView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[gratTxtView layer] setBorderWidth:1.0];
    [[gratTxtView layer] setCornerRadius:5];
    [gratTxtView setDelegate:self];
    gratTxtView.text = [NSString stringWithString:gratString];

}


-(void)deleteGratitude:(UIControl *)sender{
    if (gratPopUp.hidden==NO)
    {
        [self.view endEditing:YES];
        gratPopUp.hidden=YES;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag - 400 inSection:0];
    NSNumber *selRow = [[NSNumber alloc] initWithInteger:indexPath.row];
    index2 = [selRow intValue];
    UIAlertView *alertview1=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"You really want to delete this Gratitude?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alertview1.tag = 6;
    [alertview1 show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  //  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    
    if (alertView.tag == 6 && buttonIndex == 0) {
        
        
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
        
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM Gratitude WHERE  id = \"%d\"",index2] ;
        [database executeUpdate:deleteQuery];
        [database close];
        [self viewDidLoad];

    }
    
    if (alertView.tag==1 && buttonIndex==0)
    {
        gratTxtView.text=gratString;
    }
    
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(alertView.tag==5 && buttonIndex==1 && [title isEqualToString:@"OK"])
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

}
- (IBAction)edittingDoneBtn:(id)sender {
    [self.view endEditing:YES];
    disableImgView.hidden=YES;
    self.myTableView.userInteractionEnabled=YES;

    NSString *tempGratitudeStr = [gratTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    int textLength = [tempGratitudeStr length];
    if(textLength<1 )
    {
        UIAlertView *alertview1=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Please enter the gratitude's description" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertview1.tag = 1;
        [alertview1 show];
        //gratTxtView.text=gratString;
    }
    else{
        NSArray *docPaths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir1 = [docPaths1 objectAtIndex:0];
        NSString *dbPath1 = [documentsDir1   stringByAppendingPathComponent:@"shed_db.sqlite"];
        FMDatabase *database1 = [FMDatabase databaseWithPath:dbPath1];
        [database1 open];
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE Gratitude SET gratitude = \"%@\" where id = %d", tempGratitudeStr, index1];
        [database1 executeUpdate:insertSQL];
        [database1 close];
        [gratTxtView setDelegate:self];
        gratPopUp.hidden = YES;
        [gratTxtView resignFirstResponder];
        [self viewDidLoad];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"user editing");
    if([text isEqualToString:@"\n"]) {
        [gratTxtView resignFirstResponder];
        return NO;
    }
    return YES;
}


#pragma mark - QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.fileName];
}



#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Action Sheet button %ld", (long)buttonIndex);
    
    if (buttonIndex == 0) {
        // present a preview of this PDF File.
        QLPreviewController* preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
//        preview.delegate = self;
//        [self.navigationController pushViewController:preview animated:YES];
       [self presentViewController:preview animated:YES completion:nil];
        
    }
    else if(buttonIndex == 1)
    {
        // email the PDF File.
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        NSMutableArray *toReceipents =[NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@",emailid]];
        [picker setToRecipients:toReceipents];
        [picker setSubject:[NSString stringWithFormat:@"Gratitude List"]];
        [picker setMessageBody:@"Gratitudes List" isHTML:YES];
        NSData *fileData = [NSData dataWithContentsOfFile:fileName];
        NSString *mimeType = @"application/pdf";
        [picker addAttachmentData:fileData mimeType:mimeType fileName:@"Gratitudes"];
        
        if (picker != nil)
        {
            [self presentViewController:picker animated:YES completion:nil];
            [gratitude_list removeAllObjects];
            [myTableView reloadData];
            [self loadGratitudes];
            [myTableView reloadData];
        }
        else
        {
            NSLog(@"hgjdhg");
        }
    }
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
//    dialog.tag = 5;
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
