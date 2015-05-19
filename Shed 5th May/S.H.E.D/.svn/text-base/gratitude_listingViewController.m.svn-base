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
#define NUM_TOP_ITEMS 6
#define NUM_SUBITEMS 1

@interface gratitude_listingViewController ()

@end

@implementation gratitude_listingViewController

@synthesize myTableView,gratitude_list,gratimgup,gratimgdown,rowIndex,selectIndex,gratlbl,datelbl;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    currentSelection = 0;
    lastSelection = 0;
    isMovingDown = false;
    flag = 0;
    
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn addTarget:self action:@selector(moveback:) forControlEvents:UIControlEventTouchUpInside];
  
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back-icon.png"] forState:UIControlStateNormal];
    backbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:backbtn];
    UILabel *titlelbl;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(35,20, 250, 43)];
          backbtn.frame = CGRectMake(5, 19, 60, 40);
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:26]];

        //this is iphone 5 xib
    }else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
        titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(35,20, 250, 43)];
          backbtn.frame = CGRectMake(5, 19, 60, 40);
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:26]];

        // this is iphone 4 xib
    }
    else {
        titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(109,25, 550, 90)];
        backbtn.frame = CGRectMake(15, 22, 128, 95);
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];


        // this is iphone 4 xib
    }

    titlelbl.text = @"I am Grateful for";
    titlelbl.textColor = [UIColor whiteColor];
    titlelbl.shadowColor = [UIColor colorWithRed:228/255.0f green:97/255.0f blue:0/255.0f alpha:1];
    titlelbl.shadowOffset = CGSizeMake(0, 2);
    titlelbl.textAlignment = NSTextAlignmentCenter;
       [self.view addSubview:titlelbl];
    
    gratitude_list = [[NSMutableArray alloc]init];
   // gratitude_tableview = [[UITableView alloc] init];
    NSString *queryString = [NSString stringWithFormat:@"select * from Gratitude order by gratitude_date desc LIMIT 15"];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
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
        
       // gratitudeoc.gratitudesarray = gratitude_list;
        //gratitudeoc.gratitudedatesarray = gratitudedate_list;
      //  [gratitude_list containsObject:gratitudeoc.gratitude];
        //NSLog(@"%@", gratitudeoc.gratitude);
       // NSLog(@"list %@", gratitudeoc.gratitudedate);
    }
    
    
    [database close];

    topItems = [[NSArray alloc] initWithArray:[self topLevelItems:gratitude_list]];
    subItems = [NSMutableArray new];
    currentExpandedIndex = -1;
    
    for (int i = 0; i < [topItems count]; i++) {
        Gratitude *myGrat =[gratitude_list objectAtIndex:i];
        [subItems addObject:[self subItems:myGrat.gratitude]];
    }
}
- (IBAction)moveback:(id)sender
{
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
         gratlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 30)];
        datelbl = [[UILabel alloc] initWithFrame:CGRectMake(210, 11, 100, 30)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(300, 21, 10, 10)];
        [gratlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [datelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:12]];

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        gratlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 200, 30)];
        datelbl = [[UILabel alloc] initWithFrame:CGRectMake(210, 11, 100, 30)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(300, 21, 10, 10)];
        [gratlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:20]];
        [datelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:12]];

    }
    else{
        gratlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 500, 80)];
        datelbl = [[UILabel alloc] initWithFrame:CGRectMake(565, 1, 200, 40)];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(700, 40,16, 27)];
        [gratlbl setFont:[UIFont fontWithName:@"Lucida Sans" size:35]];
        [datelbl setFont:[UIFont fontWithName:@"Lucida Sans" size:18]];

    }

    
            gratlbl.textAlignment = NSTextAlignmentLeft;
    
            datelbl.textColor = [UIColor grayColor];
            datelbl.textAlignment = NSTextAlignmentCenter;
    
    
            gratlbl.tag =1;
            datelbl.tag =2;
            gratimgup.tag = 200 + indexPath.row;
    
            [cell.contentView addSubview:datelbl] ;
            [cell.contentView addSubview:gratlbl] ;
            [cell.contentView addSubview:gratimgup];
       
        
        int topIndex = (currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex)
        ? indexPath.row - [[subItems objectAtIndex:currentExpandedIndex] count]
        : indexPath.row;
       //
        Gratitude *myGrat =[gratitude_list objectAtIndex:topIndex];
        
    
        cell.detailTextLabel.text = @"";
    
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        NSDate *changedDate = [formatter1 dateFromString:myGrat.gratitudedate];
        
        NSDateFormatter* df = [[NSDateFormatter alloc] init] ;
        [df setDateFormat:@"MM-dd-yyyy"];
        
        NSString* todaydate = [df stringFromDate:changedDate];
        gratlbl = (UILabel *) [cell.contentView viewWithTag:1];
        gratlbl.text = myGrat.gratitude;
        
        datelbl = (UILabel *) [cell.contentView viewWithTag:2];
        datelbl.text = [NSString stringWithFormat:@"%@",todaydate];
    
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
    }
    
    if(currentExpandedIndex == indexPath.row){
        
        gratimgup.image = [UIImage imageNamed:@"arrow-icon.png"];
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
            gratimgup.frame = CGRectMake(700, 35, 10, 10);
        }
        else{
            gratimgup.frame = CGRectMake(700, 40, 26, 15);

        }

        NSLog(@"down arrow %d", indexPath.row);
        cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    }
    else if(currentExpandedIndex + 1 == indexPath.row && currentExpandedIndex!= -1){
        gratimgup.image = nil;
        NSLog(@"empty arrow %d", indexPath.row);
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
            gratimgup.frame = CGRectMake(700, 35, 10, 10);
        }
        else{
            gratimgup.frame = CGRectMake(700, 40, 26, 15);
        }

        cell.backgroundColor = [UIColor colorWithRed:150/255.0f green:150/255.0f blue:150/255.0f alpha:1];
    }
    else{
        gratimgup.image = [UIImage imageNamed:@"arrow.png"];
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
            gratimgup.frame = CGRectMake(700, 35,10,10);
        }
        else{
            gratimgup.frame = CGRectMake(700, 40, 16, 27);
        }

        NSLog(@"normal arrow %d", indexPath.row);
        cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        check1.image = [UIImage imageNamed:@"arrow-icon.png"];
    
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
- (void)dealloc
{
//    [topItems release];
//    [subItems release];
//    [super dealloc];
}

@end
