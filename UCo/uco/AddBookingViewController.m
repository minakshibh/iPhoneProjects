//
//  AddBookingViewController.m
//  uco
//
//  Created by Br@R on 19/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "AddBookingViewController.h"
#import "DashboardViewController.h"
#import "GreetingsViewController.h"
#import "AllBookingsViewController.h"
#import "MarketingViewController.h"
#import "ReportingViewController.h"
#import "SettingsViewController.h"
#import "PaymentViewController.h"
#import "manageRestaurantViewController.h"
#include "JSON.h"
#include "ASIHTTPRequest.h"
#include "SBJson.h"
#include "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface AddBookingViewController ()

@end

@implementation AddBookingViewController

- (void)viewDidLoad {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    [self hideAllTables];
    self.navigationController.navigationBarHidden=YES;
    mrOrMissArray=[NSArray arrayWithObjects:@"  Mr.",@"  Miss",@"  Mrs.", nil];
    sourceOfBookingArray = [NSMutableArray arrayWithObjects:@"Web",@"Telephone",@"InPerson",@"VT",@"Open Table",@"ResDiary", nil];
    restaurantNameListArray = [NSMutableArray arrayWithObject:@"All"];
    NSString *restaurantStr =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Restaurant Name"]];
    [selectRestaurantBtn setTitle:restaurantStr forState:UIControlStateNormal];
    NSString *retaurantID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
    [[NSUserDefaults standardUserDefaults] setValue:retaurantID forKey:@"Booking List Data ID"];
    [self deselectItems];
    
    insideZoneArray=[[NSMutableArray alloc]init];
    partySizeArray=[[NSMutableArray alloc]init];
    selectedCategoryArray = [[ NSMutableArray alloc]init];
    selectedTableArray = [[ NSMutableArray alloc]init];
    for (int j=1;j<=10;j++)
    {
        NSString*addValue=[NSString stringWithFormat:@"%d",j];
        [insideZoneArray addObject:addValue];
        [partySizeArray addObject:[NSString stringWithFormat:@"%d",j]];
    }
    [self roundCornersOfAllButton];
    
    [self fetchSessions];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void) generateStartTime{
    timeArray = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSDate *startTime = [dateFormat dateFromString:startTimeStr];
    NSDate *endTime = [dateFormat dateFromString:endTimeStr];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.minute = -[slotValue intValue];
    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                   toDate: startTime
                                                                  options:0];
    do{
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.minute = [slotValue intValue];
        NSDate *newDate1 = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                        toDate: newDate
                                                                       options:0];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"hh:mm a"];
        NSString *slottedStartTime  =[ dateFormat stringFromDate:newDate1];
        newDate = newDate1;
        [timeArray addObject:slottedStartTime];
        
//        dateComponents.hour = 2;
//        newDate2 = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
//                                                                       toDate: newDate
//                                                                      options:0];
    }while (newDate  != endTime) ;
    [self addTimeSpan];
}
-(void) addTimeSpan{
    bookingTimeArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [timeArray count]; i++) {
        NSString *bookTime = [NSString stringWithFormat:@"%@",[timeArray objectAtIndex:i]];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm a"];
        NSDate *startTime = [dateFormat dateFromString:bookTime];
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.hour = 2;
        NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                       toDate: startTime
                                                                      options:0];
        NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
        [dateFormat1 setDateFormat:@"hh:mm a"];
        NSString *timeStamp  =[ dateFormat stringFromDate:newDate];
        NSString *bookingTime =[NSString stringWithFormat:@"%@-%@",bookTime,timeStamp];
        [bookingTimeArray addObject:bookingTime];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    // get pointer to app delegate, which contains property for menu pointer
    
    
//    Leftsideview = [[LeftSideBarView alloc] initWithFrame:CGRectMake(0, 90, 300,self.view.frame.size.height-90) fontName:@"Helvetica" delegate:self];
//    
//    [self.view addSubview: Leftsideview];
    Leftsideview.hidden=YES;
    
    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Payment" delegate:self];
    
    [self.view addSubview: upparView];
}

- (IBAction)sourceOfBookingBtnAction:(id)sender {
    [sourceOfBookingTableView reloadData];
    sourceOfBookingTableView.hidden=NO;
    [sourceOfBookingTableView setFrame:CGRectMake(sourceOfBookingTableView.frame.origin.x, sourceOfBookingTableView.frame.origin.y, sourceOfBookingTableView.frame.size.width, [sourceOfBookingArray count]*30 + 5)];
    sourceOfBookingTableView.layer.borderColor =[UIColor clearColor].CGColor;
    sourceOfBookingTableView.layer.borderWidth = 1.5;
    sourceOfBookingTableView.layer.cornerRadius = 8.0;
    [sourceOfBookingTableView setClipsToBounds:YES];
}

- (IBAction)addBookingBtn:(id)sender {
     [addBookingInnrBtn setBackgroundColor:[UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1]];
    [editBookingBtn setBackgroundColor: [UIColor clearColor]];
    
}

- (IBAction)editBookingBtn:(id)sender {
     [editBookingBtn setBackgroundColor:[UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1]];
    [addBookingInnrBtn setBackgroundColor: [UIColor clearColor]];

}

- (IBAction)walkInBtn:(id)sender {
}


- (IBAction)DateSelectionBtn:(id)sender {
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
    calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(383, 433, 200, 150) fontName:@"Helvetica" delegate:self];
    calendarView.layer.borderColor =[UIColor blackColor].CGColor;
    calendarView.layer.borderWidth = 0.5;
    calendarView.layer.cornerRadius = 4.0;
    [calendarView setClipsToBounds:YES];
    [self.view addSubview: calendarView];
}
- (IBAction)MrOrMissSelectionBtn:(id)sender
{
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
    calendarView.hidden = YES;
    [MrMissTableView reloadData];
    MrMissTableView.hidden=NO;
    MrMissTableView.layer.borderColor =[UIColor clearColor].CGColor;
    MrMissTableView.layer.borderWidth = 1.5;
    MrMissTableView.layer.cornerRadius = 8.0;
    [MrMissTableView setClipsToBounds:YES];
}
- (IBAction)partySizeSelectionBtn:(id)sender {
    
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
    calendarView.hidden = YES;
    [partySizeTableView reloadData];
    partySizeTableView.hidden=NO;
    partySizeTableView.layer.borderColor =[UIColor clearColor].CGColor;
    partySizeTableView.layer.borderWidth = 1.5;
    partySizeTableView.layer.cornerRadius = 8.0;
    [partySizeTableView setClipsToBounds:YES];
}

- (IBAction)tableSelectionBtn:(id)sender {
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
    calendarView.hidden = YES;
    [tableSelectdTableView reloadData];
    tableSelectdTableView.hidden=NO;
    [tableSelectdTableView setFrame:CGRectMake(tableSelectdTableView.frame.origin.x, tableSelectdTableView.frame.origin.y, tableSelectdTableView.frame.size.width, [tablesSelectdArray count]*30 + 5)];
    tableSelectdTableView.layer.borderColor =[UIColor clearColor].CGColor;
    tableSelectdTableView.layer.borderWidth = 1.5;
    tableSelectdTableView.layer.cornerRadius = 8.0;
    [tableSelectdTableView setClipsToBounds:YES];
}
- (IBAction)floorSeletionBtnSeletionBtn:(id)sender {
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    calendarView.hidden = YES;
    [floorSelectTableView reloadData];
    floorSelectTableView.hidden=NO;
    [floorSelectTableView setFrame:CGRectMake(floorSelectTableView.frame.origin.x, floorSelectTableView.frame.origin.y, floorSelectTableView.frame.size.width, [floorArray count]*30 + 5)];
    floorSelectTableView.layer.borderColor =[UIColor clearColor].CGColor;
    floorSelectTableView.layer.borderWidth = 1.5;
    floorSelectTableView.layer.cornerRadius = 8.0;
    [floorSelectTableView setClipsToBounds:YES];
    
}

- (IBAction)createBookingActionBtn:(id)sender
{
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if ([firstNameTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:@"Please enter First Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if ([lastNameTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:@"Please enter Last Name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if ([emailAddressTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:@"Please enter Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if ([phoneNumbrTxt.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:@"Please enter Phone Number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else if ([emailTest evaluateWithObject:emailAddressTxt.text] == NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:@"Please enter Enter Valid Email Address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        [self addBookingSchedule];
    }
}

- (IBAction)todaySelectionBtn:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    NSString *theDate = [dateFormatter stringFromDate:[NSDate date]];
    [calendarView removeFromSuperview];
    dateSelectedLbl.text = [NSString stringWithString:theDate];
    [timeSelectedBtn setBackgroundColor:[UIColor clearColor]];
    [timeSelectedBtn setAlpha:1.0];
    [timeSelectedBtn setUserInteractionEnabled:YES];
    [sourceOfBookingBtnTitle setBackgroundColor:[UIColor grayColor]];
    [sourceOfBookingBtnTitle setAlpha:0.7];
    [sourceOfBookingBtnTitle setUserInteractionEnabled:NO];
    [sourceOfBookingBtnTitle setTitle:@"(Select Booking)" forState:UIControlStateNormal];
    [selectFloorBtn setBackgroundColor:[UIColor grayColor]];
    [selectFloorBtn setAlpha:0.7];
    [selectFloorBtn setUserInteractionEnabled:NO];
    [saveTypeBtn setBackgroundColor:[UIColor grayColor]];
    [saveTypeBtn setAlpha:0.7];
    [saveTypeBtn setUserInteractionEnabled:NO];
    [tableSelectedBtn setBackgroundColor:[UIColor grayColor]];
    [tableSelectedBtn setAlpha:0.7];
    [tableSelectedBtn setUserInteractionEnabled:NO];
    [tableSelectedBtn setTitle:@"(Select table)" forState:UIControlStateNormal];
    [selectFloorBtn setTitle:@"(Select Floor)" forState:UIControlStateNormal];
    [timeSelectedBtn setTitle:@"(Select Time)" forState:UIControlStateNormal];
    [self fetchTimeStamp];
}

- (IBAction)timeSelectedBtn:(id)sender {
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
    calendarView.hidden = YES;
    [bookingTimeTableView reloadData];
    bookingTimeTableView.hidden=NO;
    [bookingTimeTableView setFrame:CGRectMake(bookingTimeTableView.frame.origin.x, bookingTimeTableView.frame.origin.y, bookingTimeTableView.frame.size.width, [bookingTimeArray count]*30 + 5)];
    bookingTimeTableView.layer.borderColor =[UIColor clearColor].CGColor;
    bookingTimeTableView.layer.borderWidth = 1.5;
    bookingTimeTableView.layer.cornerRadius = 8.0;
    [bookingTimeTableView setClipsToBounds:YES];
}

- (IBAction)sessionBtnAction:(id)sender {
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
    calendarView.hidden = YES;
    [sessionTableView reloadData];
    sessionTableView.hidden=NO;
    [sessionTableView setFrame:CGRectMake(sessionTableView.frame.origin.x, sessionTableView.frame.origin.y, sessionTableView.frame.size.width, [sessionArray count]*30 + 5)];
    sessionTableView.layer.borderColor =[UIColor clearColor].CGColor;
    sessionTableView.layer.borderWidth = 1.5;
    sessionTableView.layer.cornerRadius = 8.0;
    [sessionTableView setClipsToBounds:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==tableSelectdTableView)
    {
        return  [tablesSelectdArray count];
    }
    else if (tableView==MrMissTableView)
    {
        [MrMissTableView setFrame:CGRectMake(MrMissTableView.frame.origin.x, MrMissTableView.frame.origin.y, MrMissTableView.frame.size.width, [mrOrMissArray count]*30 + 5)];
        return  [mrOrMissArray count];
    }
    else if (tableView==insideZoneTableView)
    {
        return [insideZoneArray count];
    }
    else if (tableView==partySizeTableView)
    {
        return [partySizeArray count];
    }
    else if (tableView==sessionTableView)
    {
        return [sessionArray count];
    }
    else if (tableView==sourceOfBookingTableView)
    {
        return [sourceOfBookingArray count];
    }
    else if (tableView==bookingTimeTableView)
    {
        return [bookingTimeArray count];
    }
    else if (tableView==floorSelectTableView)
    {
        return [floorArray count];
    }
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
static NSString *MyIdentifier = @"MyIdentifier";

UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:MyIdentifier] ;
    }
    
    if (tableView==tableSelectdTableView)
    {
        tableOC = [tablesSelectdArray objectAtIndex:indexPath.row];
        NSString *tableCapacity = [NSString stringWithFormat:@"%@",tableOC.Capacity];
        NSString *tableName = [NSString stringWithFormat:@"%@",tableOC.TableName];
        if (tableName == nil) {
            tableName = [NSString stringWithFormat:@"Table(%@)",tableCapacity];
        }else{
            tableName = [NSString stringWithFormat:@"%@(%@)",tableOC.TableName,tableOC.Capacity];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",tableName];
    }
    else if (tableView==MrMissTableView)
    {
        cell.textLabel.text = [mrOrMissArray objectAtIndex:indexPath.row];
    }
    else if (tableView==insideZoneTableView)
    {
        cell.textLabel.text = [insideZoneArray objectAtIndex:indexPath.row];
    }
    else if (tableView==partySizeTableView)
    {
        cell.textLabel.text = [partySizeArray objectAtIndex:indexPath.row];
    }
    else if (tableView==sessionTableView)
    {
        sessionOC = [sessionArray objectAtIndex:indexPath.row];
        NSLog(@"Session %@",sessionOC.Value);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",sessionOC.Value];
        
    }
    else if (tableView==sourceOfBookingTableView)
    {
        
        
        cell.textLabel.text = [sourceOfBookingArray objectAtIndex:indexPath.row];
    }
    else if (tableView==bookingTimeTableView)
    {
        cell.textLabel.text = [bookingTimeArray objectAtIndex:indexPath.row];
    }
    else if (tableView==floorSelectTableView)
    {
        floorOC = [floorArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",floorOC.Value];
    }

    cell.textLabel.font = [UIFont fontWithName:@"Lovelo" size:11];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
     cell.textLabel.textColor = [UIColor blackColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==tableSelectdTableView)
    {
        tableOC = [tablesSelectdArray objectAtIndex:indexPath.row];
        NSString *tableCapacity = [NSString stringWithFormat:@"%@",tableOC.Capacity];
        NSString *tableName = [NSString stringWithFormat:@"%@",tableOC.TableName];
        if (tableName == nil) {
            tableName = [NSString stringWithFormat:@"Table(%@)",tableCapacity];
        }else{
            tableName = [NSString stringWithFormat:@"%@(%@)",tableOC.TableName,tableOC.Capacity];
        }
        NSString *tableSelectdStr = [NSString stringWithFormat:@"%@",tableName];
        [tableSelectedBtn setTitle: tableSelectdStr forState: UIControlStateNormal];

    }
    else if (tableView==MrMissTableView)
    {
        NSString *mrOrMissSelectdStr = [mrOrMissArray objectAtIndex:indexPath.row];
        [mrMissSelectdBtn setTitle:mrOrMissSelectdStr forState: UIControlStateNormal];

    }
    else if (tableView==insideZoneTableView)
    {
       NSString *insideSelectdStr = [insideZoneArray objectAtIndex:indexPath.row];
        [insideZoneSelectdBtn setTitle: insideSelectdStr forState: UIControlStateNormal];

    }
    else if (tableView==partySizeTableView)
    {
        NSString *partSizeSelectdStr = [partySizeArray objectAtIndex:indexPath.row];
        [partySizeBtn setTitle: partSizeSelectdStr forState: UIControlStateNormal];

    }
    else if (tableView==sessionTableView)
    {
        sessionOC = [sessionArray objectAtIndex:indexPath.row];
        NSString *sessionStr = [NSString stringWithFormat:@"%@",sessionOC.Value];
        [sessionBtnTitle setTitle: sessionStr forState: UIControlStateNormal];
        [dateSelectedLbl setBackgroundColor:[UIColor clearColor]];
        [dateSelectedLbl setAlpha:1.0];
        [showCalendarBtn setAlpha:1.0];
        [showCalendarBtn setUserInteractionEnabled:YES];
        
        [todaySelectdBtn setBackgroundColor:[UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1]];
        [todaySelectdBtn setAlpha:1.0];
        [todaySelectdBtn setUserInteractionEnabled:YES];
        
    }else if (tableView==sourceOfBookingTableView)
    {
        NSString *sourceOfBookingSelectdStr = [sourceOfBookingArray objectAtIndex:indexPath.row];
        [sourceOfBookingBtnTitle setTitle: sourceOfBookingSelectdStr forState: UIControlStateNormal];
        
    }
    else if (tableView==bookingTimeTableView)
    {
        NSString *bookingTimeSelectdStr = [bookingTimeArray objectAtIndex:indexPath.row];
        [timeSelectedBtn setTitle: bookingTimeSelectdStr forState: UIControlStateNormal];
        [sourceOfBookingBtnTitle setBackgroundColor:[UIColor clearColor]];
        [sourceOfBookingBtnTitle setAlpha:1.0];
        [sourceOfBookingBtnTitle setUserInteractionEnabled:YES];
        [selectFloorBtn setBackgroundColor:[UIColor clearColor]];
        [selectFloorBtn setAlpha:1.0];
        [selectFloorBtn setUserInteractionEnabled:YES];
        [saveTypeBtn setBackgroundColor:[UIColor clearColor]];
        [saveTypeBtn setAlpha:1.0];
        [saveTypeBtn setUserInteractionEnabled:YES];
//        [tableSelectedBtn setBackgroundColor:[UIColor clearColor]];
//        [tableSelectedBtn setAlpha:1.0];
//        [tableSelectedBtn setUserInteractionEnabled:YES];
        [self fetchFloorList];
    }
    else if (tableView==floorSelectTableView)
    {
        floorOC = [floorArray objectAtIndex:indexPath.row];
        NSString *floorSelectdStr = [NSString stringWithFormat:@"%@",floorOC.Value];
        NSString *groupIdStr = [NSString stringWithFormat:@"%@",floorOC.Key];
        [[NSUserDefaults standardUserDefaults] setValue:groupIdStr forKey:@"Group Id"];
        [selectFloorBtn setTitle: floorSelectdStr forState: UIControlStateNormal];
        for (UIView* b in tableHorizontalScroller.subviews)
        {
            [b removeFromSuperview];
        }

        for (UIView* b in horizontalScroller.subviews)
        {
            [b removeFromSuperview];
        }

        [self fetchCategoryList];
    }
    [self hideAllTables];
}


-(void)hideAllTables{
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
}



- (void)mainMenuBtnPressed
{
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
}
- (void)addBookingBtnPressed{
    
    NSLog(@"addBookingBtn Pressed ");
    
}


-(void)roundCornersOfAllButton
{
    
    [addBookingInnrBtn setBackgroundColor:[UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1]];
    [createBookingBtn setBackgroundColor:[UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1]];
    [todaySelectdBtn setBackgroundColor:[UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1]];
    [mrMissSelectdBtn setBackgroundColor:[UIColor clearColor]];
    [partySizeBtn setBackgroundColor:[UIColor clearColor]];
    

    todaySelectdBtn.layer.borderColor = [UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor;
    todaySelectdBtn.layer.borderWidth = 1.4;
    todaySelectdBtn.layer.cornerRadius = 11.0;
    [todaySelectdBtn setClipsToBounds:YES];
    
    addBookingInnrBtn.layer.borderColor = [UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor;
    addBookingInnrBtn.layer.borderWidth = 1.5;
    addBookingInnrBtn.layer.cornerRadius = 11.0;
    [addBookingInnrBtn setClipsToBounds:YES];
    
     
    editBookingBtn.layer.borderColor =[UIColor colorWithRed:223.0/255.0f green:94.0f/255.0f blue:0.0f/255.0f alpha:1].CGColor;
    editBookingBtn.layer.borderWidth = 1.5;
    editBookingBtn.layer.cornerRadius = 11.0;
    [editBookingBtn setClipsToBounds:YES];
    
    createBookingBtn.layer.borderColor =[UIColor clearColor].CGColor;
    createBookingBtn.layer.borderWidth = 1.5;
    createBookingBtn.layer.cornerRadius = 11.0;
    [createBookingBtn setClipsToBounds:YES];
    
    
    tableSelectedBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    tableSelectedBtn.layer.borderWidth = 1.5;
    tableSelectedBtn.layer.cornerRadius = 11.0;
    [tableSelectedBtn setClipsToBounds:YES];
    
    
    mrMissSelectdBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    mrMissSelectdBtn.layer.borderWidth = 1.5;
    mrMissSelectdBtn.layer.cornerRadius = 11.0;
    [mrMissSelectdBtn setClipsToBounds:YES];
    
    
    timeSelectedBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    timeSelectedBtn.layer.borderWidth = 1.5;
    timeSelectedBtn.layer.cornerRadius = 11.0;
    [timeSelectedBtn setClipsToBounds:YES];
    
    insideZoneSelectdBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    insideZoneSelectdBtn.layer.borderWidth = 1.5;
    insideZoneSelectdBtn.layer.cornerRadius = 11.0;
    [insideZoneSelectdBtn setClipsToBounds:YES];
    
    partySizeBtn.layer.borderColor =[UIColor whiteColor].CGColor;;
    partySizeBtn.layer.borderWidth = 1.5;
    partySizeBtn.layer.cornerRadius = 11.0;
    [partySizeBtn setClipsToBounds:YES];
    
    dateSelectedLbl.layer.borderColor =[UIColor whiteColor].CGColor;
    dateSelectedLbl.layer.borderWidth = 1.5;
    dateSelectedLbl.layer.cornerRadius = 11.0;
    [dateSelectedLbl setClipsToBounds:YES];
    
    sessionBtnTitle.layer.borderColor =[UIColor whiteColor].CGColor;
    sessionBtnTitle.layer.borderWidth = 1.5;
    sessionBtnTitle.layer.cornerRadius = 11.0;
    [sessionBtnTitle setClipsToBounds:YES];
    
    sourceOfBookingBtnTitle.layer.borderColor =[UIColor whiteColor].CGColor;
    sourceOfBookingBtnTitle.layer.borderWidth = 1.5;
    sourceOfBookingBtnTitle.layer.cornerRadius = 11.0;
    [sourceOfBookingBtnTitle setClipsToBounds:YES];
    
    selectFloorBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    selectFloorBtn.layer.borderWidth = 1.5;
    selectFloorBtn.layer.cornerRadius = 11.0;
    [selectFloorBtn setClipsToBounds:YES];
    
    saveTypeBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    saveTypeBtn.layer.borderWidth = 1.5;
    saveTypeBtn.layer.cornerRadius = 11.0;
    [saveTypeBtn setClipsToBounds:YES];
    
    selectRestaurantBtn.layer.borderColor =[UIColor whiteColor].CGColor;
    selectRestaurantBtn.layer.borderWidth = 1.5;
    selectRestaurantBtn.layer.cornerRadius = 11.0;
    [selectRestaurantBtn setClipsToBounds:YES];
    

}
#pragma mark -Fetch Session

-(void) fetchSessions
{
    [activityIndicator startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    NSDictionary *jsonDict=[[NSDictionary alloc]init];
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetListOfFoodMenuSlot"];
    
    
    
    NSLog(@"Request:%@",urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    //NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webserviceCode = 1;
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
#pragma mark -Fetch Time

-(void) fetchTimeStamp
{
     [activityIndicator startAnimating];
    NSString *dateStr = [NSString stringWithFormat:@"%@",dateSelectedLbl.text];
    NSString *clientId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Client Id"]];
    NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
    NSString *mealNameStr = [NSString stringWithFormat:@"%@",sessionBtnTitle.titleLabel.text];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"tableViewDate",listDataIdStr,@"listDataId",clientId,@"clientId",mealNameStr, @"mealName",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetminMaxTime"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webserviceCode = 2;
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

#pragma mark -Fetch Floor List

-(void) fetchFloorList
{
    [activityIndicator startAnimating];
    NSString *clientId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Client Id"]];
    NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:listDataIdStr,@"listDataId",clientId,@"clientId",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetFloorList"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webserviceCode = 3;
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

#pragma mark -Fetch Category List

-(void) fetchCategoryList
{
     [activityIndicator startAnimating];
    NSString *clientId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Client Id"]];
    NSString *groupId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Group Id"]];
     NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"List Data ID"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:groupId,@"groupId",listDataIdStr,@"listDataId",clientId,@"clientId",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetCategory"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webserviceCode = 4;
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

#pragma mark -Fetch tables List

-(void) fetchTablesList:(NSString *)categoryValues
{
     [activityIndicator startAnimating];
    //NSString *categoryValues = [NSString stringWithFormat:@"%@",selectedCategoryArray];
    for (UIView* b in tableHorizontalScroller.subviews)
    {
        [b removeFromSuperview];
    }
    NSString *groupId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Group Id"]];
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:groupId,@"groupId",categoryValues,@"catValue",nil];
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetTables"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webserviceCode = 5;
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
    NSLog(@"ERROR ...%@",error);
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (webserviceCode == 1) {
    
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
    sessionArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [userDetailDict count]; i ++) {
        sessionOC = [[sessionObj alloc] init];
        sessionOC.Key = [[userDetailDict valueForKey:@"Key"] objectAtIndex:i];
        sessionOC.Value = [[userDetailDict valueForKey:@"Value"] objectAtIndex:i];
        [sessionArray addObject:sessionOC];
    }
    }else if(webserviceCode == 2){
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
            NSString *messageStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"Message"]];
            messageStr = [ messageStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
            messageStr = [ messageStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            messageStr = [messageStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            messageStr = [ messageStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            if ([messageStr isEqualToString:@"There is no opening hours available for selected day"]) {
                [timeSelectedBtn setBackgroundColor:[UIColor grayColor]];
                [timeSelectedBtn setAlpha:0.7];
                [timeSelectedBtn setUserInteractionEnabled:NO];
                [sourceOfBookingBtnTitle setBackgroundColor:[UIColor grayColor]];
                [sourceOfBookingBtnTitle setAlpha:0.7];
                [sourceOfBookingBtnTitle setUserInteractionEnabled:NO];
                [selectFloorBtn setBackgroundColor:[UIColor grayColor]];
                [selectFloorBtn setAlpha:0.7];
                [selectFloorBtn setUserInteractionEnabled:NO];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }else{
            startTimeStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"MealFromTime"]];
            NSArray* startTimeArray = [startTimeStr componentsSeparatedByString: @":"];
            startTimeStr = [NSString stringWithFormat:@"%@:%@ %@",[startTimeArray objectAtIndex:0],[startTimeArray objectAtIndex:1],[startTimeArray objectAtIndex:2]];
            endTimeStr = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"MealToTime"]];
            NSArray* endTimeArray = [endTimeStr componentsSeparatedByString: @":"];
            endTimeStr = [NSString stringWithFormat:@"%@:%@ %@",[endTimeArray objectAtIndex:0],[endTimeArray objectAtIndex:1],[endTimeArray objectAtIndex:2]];
            slotValue = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"FoodTimeSlot"]];
            [self generateStartTime];
            [timeSelectedBtn setBackgroundColor:[UIColor clearColor]];
            [timeSelectedBtn setAlpha:1.0];
            [timeSelectedBtn setUserInteractionEnabled:YES];
            [sourceOfBookingBtnTitle setBackgroundColor:[UIColor grayColor]];
            [sourceOfBookingBtnTitle setAlpha:0.7];
            [sourceOfBookingBtnTitle setUserInteractionEnabled:NO];
            [sourceOfBookingBtnTitle setTitle:@"(Select Booking)" forState:UIControlStateNormal];
            [selectFloorBtn setBackgroundColor:[UIColor grayColor]];
            [selectFloorBtn setAlpha:0.7];
            [selectFloorBtn setUserInteractionEnabled:NO];
            [tableSelectedBtn setBackgroundColor:[UIColor grayColor]];
            [tableSelectedBtn setAlpha:0.7];
            [tableSelectedBtn setUserInteractionEnabled:NO];
            [tableSelectedBtn setTitle:@"(Select table)" forState:UIControlStateNormal];
            [selectFloorBtn setTitle:@"(Select Floor)" forState:UIControlStateNormal];
            [timeSelectedBtn setTitle:@"(Select Time)" forState:UIControlStateNormal];
        }
    }else if(webserviceCode == 3){
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
        floorArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [userDetailDict count]; i++) {
            floorOC = [[floorObj alloc] init];
            floorOC.Key = [[userDetailDict valueForKey:@"Key"] objectAtIndex:i];
            floorOC.Value = [[userDetailDict valueForKey:@"Value"] objectAtIndex:i];
            [floorArray addObject:floorOC];
        }
        
    }else if(webserviceCode == 4){
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
        categoryArray =[[ NSMutableArray alloc] init];
        for (int i = 0; i < [userDetailDict count]; i++) {
            categoryOC = [[categoryObj alloc]init];
            categoryOC.ClientId = [[userDetailDict valueForKey:@"ClientId"] objectAtIndex:i];
            categoryOC.Created = [[userDetailDict valueForKey:@"Created"] objectAtIndex:i];
            categoryOC.Desc = [[userDetailDict valueForKey:@"Desc"] objectAtIndex:i];
            categoryOC.GroupId = [[userDetailDict valueForKey:@"GroupId"] objectAtIndex:i];
            categoryOC.categoryID = [[userDetailDict valueForKey:@"Id"] objectAtIndex:i];
            categoryOC.Name = [[userDetailDict valueForKey:@"Name"] objectAtIndex:i];
            categoryOC.SearchText = [[userDetailDict valueForKey:@"SearchText"] objectAtIndex:i];
            categoryOC.Status = [[userDetailDict valueForKey:@"Status"] objectAtIndex:i];
            categoryOC.Type = [[userDetailDict valueForKey:@"Type"] objectAtIndex:i];
            categoryOC.Updated = [[userDetailDict valueForKey:@"Updated"] objectAtIndex:i];
            categoryOC.listClientListDataItemsDTO = [[userDetailDict valueForKey:@"listClientListDataItemsDTO"] objectAtIndex:i];
            [categoryArray addObject:categoryOC];
            
        }
        [self addCategoriesToView];
    }else if(webserviceCode == 5){
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
        NSMutableDictionary *userDetailDict1=[json objectWithString:responseString error:&error];
        NSLog(@"Dictionary %@",userDetailDict1);
        tablesSelectdArray=[[NSMutableArray alloc]init];
        for (int j = 0; j < [selectedCategoryArray count]; j++) {
          //  NSMutableDictionary *userDetailDict = [[NSMutableDictionary alloc] init] ;
            NSString *KeyStr=[NSString stringWithFormat:@"%@",[selectedCategoryArray objectAtIndex:j]];
            KeyStr = [KeyStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray*userDetailDict=[userDetailDict1 valueForKey:KeyStr];
            
            for (int i = 0; i < [userDetailDict count]; i++)
            {
                tableOC = [[tableObj alloc] init];
                tableOC.Capacity = [[userDetailDict valueForKey:@"Capacity"]objectAtIndex:i];
                tableOC.DumpOfActiveData_DONT = [[userDetailDict valueForKey:@"DumpOfActiveData_DONT"]objectAtIndex:i];
                tableOC.DumpOfNonActiveData_DONT = [[userDetailDict valueForKey:@"DumpOfNonActiveData_DONT"]objectAtIndex:i];
                tableOC.Endorsers_DONT = [[userDetailDict valueForKey:@"Endorsers_DONT"]objectAtIndex:i];
                tableOC.ID_DONT = [[userDetailDict valueForKey:@"ID_DONT"]objectAtIndex:i];
                tableOC.IDorDef_DONT = [[userDetailDict valueForKey:@"IDorDef_DONT"]objectAtIndex:i];
                tableOC.IdsAndNames_DONT = [[userDetailDict valueForKey:@"IdsAndNames_DONT"]objectAtIndex:i];
                tableOC.Ids_DONT = [[userDetailDict valueForKey:@"Ids_DONT"]objectAtIndex:i];
                tableOC.Location = [[userDetailDict valueForKey:@"Location"]objectAtIndex:i];
                tableOC.NameCSV_DONT = [[userDetailDict valueForKey:@"NameCSV_DONT"]objectAtIndex:i];
                tableOC.Name_DONT = [[userDetailDict valueForKey:@"Name_DONT"]objectAtIndex:i];
                tableOC.NameorDef_DONT = [[userDetailDict valueForKey:@"NameorDef_DONT"]objectAtIndex:i];
                tableOC.Names_DONT = [[userDetailDict valueForKey:@"Names_DONT"]objectAtIndex:i];
                tableOC.OthersRefType_DONT = [[userDetailDict valueForKey:@"OthersRefType_DONT"]objectAtIndex:i];
                tableOC.Others_DONT = [[userDetailDict valueForKey:@"Others_DONT"]objectAtIndex:i];
                tableOC.RecStatus = [[userDetailDict valueForKey:@"RecStatus"]objectAtIndex:i];
                tableOC.RefType = [[userDetailDict valueForKey:@"RefType"]objectAtIndex:i];
                tableOC.RestaurantPlanItems_DONT = [[userDetailDict valueForKey:@"RestaurantPlanItems_DONT"]objectAtIndex:i];
                tableOC.RowGuid = [[userDetailDict valueForKey:@"RowGuid"]objectAtIndex:i];
                
                tableOC.TableId = [[userDetailDict valueForKey:@"TableId"]objectAtIndex:i];
                tableOC.TableName = [[userDetailDict valueForKey:@"TableName"]objectAtIndex:i];
                tableOC.TableType = [[userDetailDict valueForKey:@"TableType"]objectAtIndex:i];
                tableOC.Title = [[userDetailDict valueForKey:@"Title"]objectAtIndex:i];
                tableOC.TypeItems_DONT = [[userDetailDict valueForKey:@"TypeItems_DONT"]objectAtIndex:i];
                tableOC.UseSameTagForSubModels_DONT = [[userDetailDict valueForKey:@"UseSameTagForSubModels_DONT"]objectAtIndex:i];
                [tablesSelectdArray addObject:tableOC];
                NSLog(@"Capacity ..... %@",tableOC.Capacity);
                NSLog(@"Table ID ..... %@",tableOC.TableId);
                NSLog(@"Table Name ..... %@",tableOC.TableName);
        }
        }
        [self addTablesToView];
    }else if(webserviceCode == 6){
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:@"Your booking has been confirmed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    [activityIndicator stopAnimating];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AllBookingsViewController *allbookingVC = [[AllBookingsViewController alloc] initWithNibName:@"AllBookingsViewController" bundle:nil];
    [self.navigationController pushViewController:allbookingVC animated:NO];
}
-(void)deselectItems{
    [dateSelectedLbl setBackgroundColor:[UIColor grayColor]];
    [dateSelectedLbl setAlpha:0.7];
    [showCalendarBtn setAlpha:0.7];
    [showCalendarBtn setUserInteractionEnabled:NO];
    [timeSelectedBtn setBackgroundColor:[UIColor grayColor]];
    [timeSelectedBtn setAlpha:0.7];
    [timeSelectedBtn setUserInteractionEnabled:NO];
    [sourceOfBookingBtnTitle setBackgroundColor:[UIColor grayColor]];
    [sourceOfBookingBtnTitle setAlpha:0.7];
    [sourceOfBookingBtnTitle setUserInteractionEnabled:NO];
    [selectFloorBtn setBackgroundColor:[UIColor grayColor]];
    [selectFloorBtn setAlpha:0.7];
    [selectFloorBtn setUserInteractionEnabled:NO];
    [tableSelectedBtn setBackgroundColor:[UIColor grayColor]];
    [tableSelectedBtn setAlpha:0.7];
    [tableSelectedBtn setUserInteractionEnabled:NO];
    [todaySelectdBtn setBackgroundColor:[UIColor grayColor]];
    [todaySelectdBtn setAlpha:0.7];
    [todaySelectdBtn setUserInteractionEnabled:NO];
    [saveTypeBtn setBackgroundColor:[UIColor grayColor]];
    [saveTypeBtn setAlpha:0.7];
    [saveTypeBtn setUserInteractionEnabled:NO];
    
}
- (void)dayButtonPressed:(DayButton *)button {
    //For the sake of example, we obtain the date from the button object
    //and display the string in an alert view
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    
    dateSelectedLbl.text = [NSString stringWithString:theDate];
    [calendarView removeFromSuperview];
    for (UIView* b in tableHorizontalScroller.subviews)
    {
        [b removeFromSuperview];
    }
    for (UIView* b in horizontalScroller.subviews)
    {
        [b removeFromSuperview];
    }

    [self fetchTimeStamp];
}

- (void)nextButtonPressed {
    NSLog(@"Next...");
}

- (void)prevButtonPressed {
    NSLog(@"Prev...");
}

-(void)addCategoriesToView
{
    for (UIView* b in horizontalScroller.subviews)
    {
        [b removeFromSuperview];
    }

    int x = 2;
    for (int i = 0; i < [categoryArray count]; i++) {
        
        categoryOC = [categoryArray objectAtIndex:i];
       
        UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(x,0, 150, 50)];
        [categoryView setBackgroundColor:[UIColor clearColor]];
        [horizontalScroller addSubview:categoryView];
        
        x = x + categoryView.frame.size.width+5;
        
        UIButton *radioBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 15, 15)];
        [radioBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
        radioBtn.tag =i;
        [radioBtn addTarget:self action:@selector(radioActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [categoryView addSubview:radioBtn];
        
        UILabel *categoryNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 150, 30)];
        categoryNameLbl.text = [NSString stringWithFormat:@"%@",categoryOC.Name];
        [categoryNameLbl setFont:[UIFont fontWithName:@"Lovelo" size:11]];
        [categoryNameLbl setTextColor:[UIColor whiteColor]];
        [categoryNameLbl setBackgroundColor:[UIColor clearColor]];
        [categoryView addSubview:categoryNameLbl];
        
    
    }
    
}

-(void)addTablesToView
{
    for (UIView* b in tableHorizontalScroller.subviews)
    {
        [b removeFromSuperview];
    }

    int x = 2;
    for (int i = 0; i < [tablesSelectdArray count]; i++) {
        
        tableOC = [tablesSelectdArray objectAtIndex:i];
        
        UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(x,0, 150, 50)];
        [categoryView setBackgroundColor:[UIColor clearColor]];
        [tableHorizontalScroller addSubview:categoryView];
        
        x = x + categoryView.frame.size.width+5;
        
        UIButton *radioBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 8, 15, 15)];
        [radioBtn setBackgroundImage:[UIImage imageNamed:@"checkbox_unchecked.png"] forState:UIControlStateNormal];
        radioBtn.tag =i;
        [radioBtn addTarget:self action:@selector(tableRadioBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [categoryView addSubview:radioBtn];
        
        NSString *tableCapacity = [NSString stringWithFormat:@"%@",tableOC.Capacity];
        NSString *tableName = [NSString stringWithFormat:@"%@",tableOC.TableName];
        if ([tableName isEqualToString:@"<null>"]) {
            if ([tableCapacity isEqualToString:@"<null>"]) {
                tableName = [NSString stringWithFormat:@"Table(0)"];
            }else{
                tableName = [NSString stringWithFormat:@"Table(%@)",tableCapacity];
            }
        }else if([tableName isEqualToString:@""]){
            if ([tableCapacity isEqualToString:@"<null>"]) {
                tableName = [NSString stringWithFormat:@"Table(0)"];
            }else{
                tableName = [NSString stringWithFormat:@"Table(%@)",tableCapacity];
            }
        }
        
        else{
            
                tableName = [NSString stringWithFormat:@"%@(%@)",tableOC.TableName,tableOC.Capacity];
        }
        
        UILabel *tableNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 150, 30)];
        tableNameLbl.text = [NSString stringWithFormat:@"%@",tableName];
        [tableNameLbl setFont:[UIFont fontWithName:@"Lovelo" size:11]];
        [tableNameLbl setTextColor:[UIColor whiteColor]];
        [tableNameLbl setBackgroundColor:[UIColor clearColor]];
        [categoryView addSubview:tableNameLbl];
        
        
    }
    
}
- (IBAction)radioActionBtn:(UIButton *)sender {
    NSLog(@"Tag %ld",(long)sender.tag);
    
    UIImageView *btnimg = [[UIImageView alloc] initWithImage:sender.currentBackgroundImage];
    categoryOC = [categoryArray objectAtIndex:sender.tag];
    NSString *categoryId = [NSString stringWithFormat:@"%@",categoryOC.Name];
    categoryId = [ categoryId stringByReplacingOccurrencesOfString:@"(" withString:@""];
    categoryId = [ categoryId stringByReplacingOccurrencesOfString:@")" withString:@""];
    categoryId = [categoryId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    categoryId = [ categoryId stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSData *img1Data = UIImageJPEGRepresentation(btnimg.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"checkbox_unchecked.png"], 1.0);
    
    if ([img1Data isEqualToData:img2Data]){
        [sender setBackgroundImage:[UIImage imageNamed:@"checkbox1_checked.png"]forState:UIControlStateNormal];
        [selectedCategoryArray addObject:categoryId];
    }
    else{
        [sender setBackgroundImage:[UIImage imageNamed:@"checkbox_unchecked.png"]forState:UIControlStateNormal];
        [selectedCategoryArray removeObject:categoryId];
    }

    
}
- (IBAction)tableRadioBtnActionBtn:(UIButton *)sender {
    NSLog(@"Tag %ld",(long)sender.tag);
    
    UIImageView *btnimg = [[UIImageView alloc] initWithImage:sender.currentBackgroundImage];
    tableOC = [tablesSelectdArray objectAtIndex:sender.tag];
    NSString *tableID = [NSString stringWithFormat:@"%@",tableOC.TableId];
    tableID = [ tableID stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tableID = [ tableID stringByReplacingOccurrencesOfString:@")" withString:@""];
    tableID = [tableID stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tableID = [ tableID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSData *img1Data = UIImageJPEGRepresentation(btnimg.image, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"checkbox_unchecked.png"], 1.0);
    
    if ([img1Data isEqualToData:img2Data]){
        [sender setBackgroundImage:[UIImage imageNamed:@"checkbox1_checked.png"]forState:UIControlStateNormal];
        [selectedTableArray addObject:tableID];
    }
    else{
        [sender setBackgroundImage:[UIImage imageNamed:@"checkbox_unchecked.png"]forState:UIControlStateNormal];
        [selectedTableArray removeObject:tableID];
    }
    
    
}
- (IBAction)saveBtnAction:(id)sender {
    if ([selectedCategoryArray count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"U&CO" message:@"Please Select the type of the table." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        NSString *selectedCategoriesStr = [NSString stringWithFormat:@"%@",selectedCategoryArray];
        selectedCategoriesStr = [selectedCategoriesStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
        selectedCategoriesStr = [selectedCategoriesStr stringByReplacingOccurrencesOfString:@")" withString:@""];
        selectedCategoriesStr = [selectedCategoriesStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        selectedCategoriesStr = [selectedCategoriesStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        selectedCategoriesStr = [selectedCategoriesStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        selectedCategoriesStr = [selectedCategoriesStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [self fetchTablesList:selectedCategoriesStr];
    }
}

- (IBAction)hideTapGesture:(id)sender {
    [self hideAllTables];
}

- (IBAction)hideAllTablesAction:(id)sender {
    partySizeTableView.hidden=YES;
    insideZoneTableView.hidden=YES;
    tableSelectdTableView.hidden=YES;
    MrMissTableView.hidden=YES;
    sessionTableView.hidden = YES;
    sourceOfBookingTableView.hidden = YES;
    bookingTimeTableView.hidden = YES;
    floorSelectTableView.hidden = YES;
    calendarView.hidden = YES;
}

- (IBAction)selectRestaurantBtnAction:(id)sender {
    NSLog(@"Restaurant List ..... %@",restaurantListArray);
    for (int i =0; i < [restaurantListArray count]; i++) {
        manageVenueOC = [restaurantListArray objectAtIndex:i];
        [restaurantNameListArray addObject:manageVenueOC.venueName];
    }
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :restaurantNameListArray :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}
-(void)addBookingSchedule{
     [activityIndicator startAnimating];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    NSString *theDate = [dateFormatter stringFromDate:currentDate];
    
    NSString *timeFrom = [NSString stringWithFormat:@"%@",timeSelectedBtn.titleLabel.text];
    NSArray* TimeFromArray = [timeFrom componentsSeparatedByString: @"-"];
    NSString *fromeTime = [NSString stringWithFormat:@"%@",[TimeFromArray objectAtIndex:0]];
    fromeTime = [fromeTime stringByReplacingOccurrencesOfString:@" AM" withString:@":00"];
    fromeTime = [fromeTime stringByReplacingOccurrencesOfString:@" PM" withString:@":00"];
    NSString *toTime = [NSString stringWithFormat:@"%@",[TimeFromArray objectAtIndex:1]];
    toTime = [toTime stringByReplacingOccurrencesOfString:@" AM" withString:@":00"];
    toTime = [toTime stringByReplacingOccurrencesOfString:@" PM" withString:@":00"];
  
    NSString *partySize = [NSString stringWithFormat:@"%@",partySizeBtn.titleLabel.text];
    
    NSString *tablesSelectedStr = [NSString stringWithFormat:@"%@,",selectedTableArray];
    tablesSelectedStr = [tablesSelectedStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
    tablesSelectedStr = [tablesSelectedStr stringByReplacingOccurrencesOfString:@")" withString:@""];
    tablesSelectedStr = [tablesSelectedStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tablesSelectedStr = [tablesSelectedStr stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tablesSelectedStr = [tablesSelectedStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tablesSelectedStr = [tablesSelectedStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *listDataIdStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Booking List Data ID"]];
    
    NSString *clientId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Client Id"]];
    
    NSString *UserId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"User Id"]];
    
    NSString *bookingType = [NSString stringWithFormat:@"%@",sourceOfBookingBtnTitle.titleLabel.text];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:firstNameTxt.text,@"FirstName",lastNameTxt.text,@"LastName",emailAddressTxt.text, @"CustomerEmail",phoneNumbrTxt.text,@"PhoneNumber",theDate,@"Date",fromeTime,@"TimeFrom",toTime,@"TimeTo",partySize,@"PartySize",tablesSelectedStr,@"tables",listDataIdStr,@"dataListId",UserId,@"UserId",clientId,@"ClientId",@"0",@"BookingId",bookingType,@"Tag",@"Alakata",@"reftype",nil];
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadInsertUpdateCartDetails"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    webserviceCode = 6;
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
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    NSTimer* hideTimer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(FadeView) userInfo:nil repeats:NO];
    NSLog(@"Drop Down Sender .... %@",selectRestaurantBtn.titleLabel.text);

}
-(void)FadeView
{
   NSLog(@"Drop Down Sender .... %@",selectRestaurantBtn.titleLabel.text);
    NSString *restaurantNameStr = [NSString stringWithFormat:@"%@",selectRestaurantBtn.titleLabel.text];
    if ([restaurantNameStr isEqualToString:@"All"]) {
        NSString *listDataIdStr = [NSString stringWithFormat:@"0"];
        [[NSUserDefaults standardUserDefaults] setObject:listDataIdStr forKey:@"Booking List Data ID"];
    }else{
    NSUInteger index = [restaurantNameListArray indexOfObject:restaurantNameStr];
    index = index - 1;
    manageVenueOC = [restaurantListArray objectAtIndex:index];
        NSString *listDataIdStr = [NSString stringWithFormat:@"%@",manageVenueOC.ListDataId];
        [[NSUserDefaults standardUserDefaults] setObject:listDataIdStr forKey:@"Booking List Data ID"];
    }
    NSLog(@"List Data ID .... %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Booking List Data ID"]);
    
}
@end
