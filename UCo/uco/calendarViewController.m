//
//  calendarViewController.m
//  uco
//
//  Created by Krishna_Mac_1 on 3/27/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "calendarViewController.h"
#import "DashboardViewController.h"
#import "calendarCellTableViewCell.h"
#import "AddBookingViewController.h"
#include "JSON.h"
#include "ASIHTTPRequest.h"
#include "SBJson.h"
@interface calendarViewController ()

@end

@implementation calendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchRestaurant];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityIndicator.center = CGPointMake(512, 374);
    
    activityIndicator.color=[UIColor whiteColor];
    
    [self.view addSubview:activityIndicator];
    
    expandedRowIndex = -1;
    [self.view addSubview:activityIndicator];
    calenderDateLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    calenderDateLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    calenderDateLbl.layer.borderWidth = 1.5;
    calenderDateLbl.layer.cornerRadius = 11.0;
    [calenderDateLbl setClipsToBounds:YES];
    
    calenderViewLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    calenderViewLbl.layer.borderColor = [UIColor clearColor].CGColor;
    calenderViewLbl.layer.borderWidth = 1.5;
    calenderViewLbl.layer.cornerRadius = 13.0;
    [calenderViewLbl setClipsToBounds:YES];
    
    todayLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    todayLbl.layer.borderColor = [UIColor clearColor].CGColor;
    todayLbl.layer.borderWidth = 1.5;
    todayLbl.layer.cornerRadius = 4.0;
    [todayLbl setClipsToBounds:YES];
    
    tomorrowLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    tomorrowLbl.layer.borderColor = [UIColor clearColor].CGColor;
    tomorrowLbl.layer.borderWidth = 1.5;
    tomorrowLbl.layer.cornerRadius = 4.0;
    [tomorrowLbl setClipsToBounds:YES];
    
    saturdayLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    saturdayLbl.layer.borderColor = [UIColor clearColor].CGColor;
    saturdayLbl.layer.borderWidth = 1.5;
    saturdayLbl.layer.cornerRadius = 4.0;
    [saturdayLbl setClipsToBounds:YES];
    
    sundayLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    sundayLbl.layer.borderColor = [UIColor clearColor].CGColor;
    sundayLbl.layer.borderWidth = 1.5;
    sundayLbl.layer.cornerRadius = 4.0;
    [sundayLbl setClipsToBounds:YES];
    calenderTableView.hidden = YES;
    
    tableBookingList = [[NSMutableArray alloc] initWithObjects:@"Table1",@"Table2",@"Table3", nil];
    bookingStartTimeList = [[NSMutableArray alloc] initWithObjects:@"12:00",@"15:00",@"12:00", nil];
    bookingEndTimeList = [[NSMutableArray alloc] initWithObjects:@"15:00",@"17:00",@"14:00", nil];
    startTimeStr = [NSString stringWithFormat:@"12:00"];
    endTimeString = [NSString stringWithFormat:@"17:00"];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addRestaurantView{
   
    UIView *restaurantView = [[UIView alloc] initWithFrame:CGRectMake(100, 207, 912, 50)];
    
    [restaurantView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:restaurantView];
   
    restaurantNameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [restaurantNameBtn setTitle: [NSString stringWithFormat:@"%@",[restaurantListArray objectAtIndex:0]] forState: UIControlStateNormal];
    restaurantNameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //    calenderDateBtn.tag = indexPath.row + 300;
    restaurantNameBtn.frame = CGRectMake(10, 9, 150, 30);
    restaurantNameBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
    [restaurantNameBtn setTintColor:[UIColor lightGrayColor]] ;
    [restaurantNameBtn addTarget:self action:@selector(restaurantNameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [restaurantNameBtn setBackgroundColor:[UIColor clearColor]];
    restaurantNameBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    restaurantNameBtn.layer.borderWidth = 1.5;
    restaurantNameBtn.layer.cornerRadius = 15.0;
    [restaurantNameBtn setClipsToBounds:YES];
    [restaurantView addSubview:restaurantNameBtn];
    
    UIImageView *dropDownImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(140, 20, 8, 6)];
    dropDownImage1.image = [UIImage imageNamed:@"dropdown-arrow.png"];
    [restaurantView addSubview:dropDownImage1];
    
    calenderDateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [calenderDateBtn setTitle: @"Select Date" forState: UIControlStateNormal];
    calenderDateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    calenderDateBtn.tag = indexPath.row + 300;
    calenderDateBtn.frame = CGRectMake(185.0f, 9.0f,200.0f,30.0f);
    calenderDateBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
    [calenderDateBtn setTintColor:[UIColor whiteColor]] ;
    [calenderDateBtn addTarget:self action:@selector(calenderDateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [calenderDateBtn setBackgroundColor:[UIColor clearColor]];
    calenderDateBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    calenderDateBtn.layer.borderWidth = 1.5;
    calenderDateBtn.layer.cornerRadius = 15.0;
    [calenderDateBtn setClipsToBounds:YES];
    [restaurantView addSubview:calenderDateBtn];
    
    UIImageView *calenderDropDownImage = [[UIImageView alloc] initWithFrame:CGRectMake(365, 20, 8, 6)];
    calenderDropDownImage.image = [UIImage imageNamed:@"dropdown-arrow.png"];
    [restaurantView addSubview:calenderDropDownImage];
    
    floorBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [floorBtn setTitle: @"Select Floor" forState: UIControlStateNormal];
    floorBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    foorBtn.tag = indexPath.row+100;
    floorBtn.frame = CGRectMake(410.0f, 9.0f,200.0f,30.0f);
    floorBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
    [floorBtn setTintColor:[UIColor whiteColor]] ;
    [floorBtn addTarget:self action:@selector(floorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [floorBtn setBackgroundColor:[UIColor clearColor]];
    floorBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    floorBtn.layer.borderWidth = 1.5;
    floorBtn.layer.cornerRadius = 15.0;
    [floorBtn setClipsToBounds:YES];
    [restaurantView addSubview:floorBtn];
    
    UIImageView *floorDropDownImage = [[UIImageView alloc] initWithFrame:CGRectMake(585, 20, 8, 6)];
    floorDropDownImage.image = [UIImage imageNamed:@"dropdown-arrow.png"];
    [restaurantView addSubview:floorDropDownImage];
    
    menuSlotBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [menuSlotBtn setTitle: @"Select Meal Slot" forState: UIControlStateNormal];
    menuSlotBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    menuSlotBtn.tag = indexPath.row +200;
    menuSlotBtn.frame = CGRectMake(645.0f, 9.0f,200.0f,30.0f);
    menuSlotBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
    [menuSlotBtn setTintColor:[UIColor whiteColor]] ;
    [menuSlotBtn addTarget:self action:@selector(menuSlotBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuSlotBtn setBackgroundColor:[UIColor clearColor]];
    menuSlotBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    menuSlotBtn.layer.borderWidth = 1.5;
    menuSlotBtn.layer.cornerRadius = 15.0;
    [menuSlotBtn setClipsToBounds:YES];
    [restaurantView addSubview:menuSlotBtn];
    
    UIImageView *menuSlotDropDownImage = [[UIImageView alloc] initWithFrame:CGRectMake(820, 20, 8, 6)];
    menuSlotDropDownImage.image = [UIImage imageNamed:@"dropdown-arrow.png"];
    [restaurantView addSubview:menuSlotDropDownImage];
}
-(void)restaurantNameBtnAction:(UIButton*)sender{
    selectionView.hidden = NO;
    selectionNameLbl.text = @"Select the Restaurant.";
    restaurantListDropDown = [[UITableView alloc] initWithFrame:CGRectMake(10, 30, selectionView.frame.size.width-20, selectionView.frame.size.height-40)];
    [restaurantListDropDown setDataSource:self];
    [restaurantListDropDown setDelegate:self];
    [selectionView addSubview:restaurantListDropDown];
    [self.view bringSubviewToFront:selectionView];
}

-(void)floorBtnAction:(UIButton *)sender{

    selectionNameLbl.text = @"Select the Floor.";
    selectionView.hidden = NO;
    floorDropDown = [[UITableView alloc] initWithFrame:CGRectMake(10, 30, selectionView.frame.size.width-20, selectionView.frame.size.height-40)];
    [floorDropDown setDataSource:self];
    [floorDropDown setDelegate:self];
    [selectionView addSubview:floorDropDown];
    [self.view bringSubviewToFront:selectionView];
}
-(void)menuSlotBtnAction:(UIButton *)sender{
    
    selectionView.hidden = NO;
    selectionNameLbl.text = @"Select the Menu Slot.";
        menuSlotsDropDown = [[UITableView alloc] initWithFrame:CGRectMake(10, 30, selectionView.frame.size.width-20, selectionView.frame.size.height-40)];
    [menuSlotsDropDown setDataSource:self];
    [menuSlotsDropDown setDelegate:self];
    [selectionView addSubview:menuSlotsDropDown];
    [self.view bringSubviewToFront:selectionView];
}
-(void)calenderDateBtnAction:(UIButton*)sender
{
    
    selectionView.hidden = NO;
    selectionNameLbl.text = @"Select the Date.";
    calendarView = [[DDCalendarView alloc] initWithFrame:CGRectMake(10, 30, selectionView.frame.size.width-20, selectionView.frame.size.height-40) fontName:@"Helvetica" delegate:self];
    calendarView.layer.borderColor =[UIColor blackColor].CGColor;
    calendarView.layer.borderWidth = 0.5;
    calendarView.layer.cornerRadius = 4.0;
    [calendarView setClipsToBounds:YES];
    [selectionView addSubview: calendarView];
    [self.view bringSubviewToFront:selectionView];
    
}

- (void)dayButtonPressed:(DayButton *)button {
    //For the sake of example, we obtain the date from the button object
    //and display the string in an alert view
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyy"];
    NSString *theDate = [dateFormatter stringFromDate:button.buttonDate];
    NSLog(@"Tag Value... %ld",(long)button.tag);
    [calendarView removeFromSuperview];
    selectionView.hidden = YES;
    
    if ([floorBtn.titleLabel.text isEqualToString:@"Select Floor"] || [menuSlotBtn.titleLabel.text isEqualToString:@"Select Meal Slot"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"U&CO" message:@"Please select Floor/Meal slot first." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }else{
        [calenderDateBtn setTitle:theDate forState:UIControlStateNormal];
        [self addCalenderView];
    }
    
}

-(void) addCalenderView{
    
    int y= 270;
    
    for (int i = 0; i < [tableBookingList count]+1; i++) {
        
        
        UIView *headerView;
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(145, y, 821, 36)];
        [headerView setBackgroundColor:[UIColor colorWithRed:24/255.0f green:45/255.0f blue:72/255.0f alpha:1.0]];
        headerView.layer.borderColor = [UIColor clearColor].CGColor;
        headerView.layer.borderWidth = 1.5;
        headerView.layer.cornerRadius = 4.0;
        [headerView setClipsToBounds:YES];
        [self.view addSubview:headerView];
        
        NSLog(@"Header Location ..... %f",headerView.frame.origin.x);
        NSLog(@"Header Y Location...... %f",headerView.frame.origin.y);
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        NSDate *startTime = [dateFormat dateFromString:startTimeStr];
        NSDate *endTime = [dateFormat dateFromString:endTimeString];
        
        // Convert date object to desired output format
        
        NSTimeInterval secs = [startTime timeIntervalSinceDate:endTime];
        NSString *timeDelay = [NSString stringWithFormat:@"%f",secs];
        timeDelay = [timeDelay
                     stringByReplacingOccurrencesOfString:@"-" withString:@""];
        int timeINteger = [timeDelay integerValue];
        int hours = timeINteger / 3600;
        NSLog(@"interval %d",hours);
        int parts = hours*2 + 1;
        NSDate *addingTime;
        if (i == 0) {
            
            for (int i = 0; i < parts; i++) {
                
                UILabel *TimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(i* headerView.frame.size.width/parts , 0 , headerView.frame.size.width/parts, headerView.frame.size.height)];
                NSString *timelbl;
                if (addingTime == nil) {
                    addingTime = startTime;
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"HH:mm"];
                    timelbl  =[ dateFormat stringFromDate:addingTime];
                    
                }else{
                    NSDateComponents *dateComponents = [NSDateComponents new];
                    dateComponents.minute = 30;
                    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                                   toDate: addingTime
                                                                                  options:0];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"HH:mm"];
                    timelbl  =[ dateFormat stringFromDate:newDate];
                    addingTime = newDate;
                }
                
                TimeTitle.text = [NSString stringWithFormat:@"%@",timelbl];
                
                TimeTitle.textColor = [UIColor whiteColor];
                [TimeTitle setTextAlignment:NSTextAlignmentCenter];
                TimeTitle.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
                if (i%2 == 0 || i == 0) {
                    [TimeTitle setBackgroundColor:[UIColor colorWithRed:24/255.0f green:45/255.0f blue:72/255.0f alpha:1.0]];
                }else{
                    [TimeTitle setBackgroundColor:[UIColor colorWithRed:16.0/255.0f green:22.0f/255.0f blue:38.0f/255.0f alpha:1.0]];
                }
                [headerView addSubview:TimeTitle];
                
            }
            
        }else{
            NSDate *startDate = [dateFormat dateFromString:[bookingStartTimeList objectAtIndex:i - 1]];
            NSDateComponents *dateComponents = [NSDateComponents new];
            dateComponents.hour = 2;
            NSDate *enddate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                           toDate: startDate
                                                                          options:0];
            
            UILabel *bookerTableNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, y+2, 150, 30)];
            bookerTableNameLbl.text = [NSString stringWithFormat:@"%@",[tableBookingList objectAtIndex:i-1]];
            bookerTableNameLbl.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
            [bookerTableNameLbl setTextAlignment:NSTextAlignmentLeft];
            bookerTableNameLbl.textColor= [UIColor lightGrayColor];
            [headerView bringSubviewToFront:bookerTableNameLbl];
            [self.view addSubview:bookerTableNameLbl];
            
            for (int i = 0; i < parts; i++) {
                
                UILabel *TimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(i* headerView.frame.size.width/parts , 1 , headerView.frame.size.width/parts+3, headerView.frame.size.height-2)];
                NSString *timelbl;
                
                if (i == 0) {
                    TimeTitle.frame =CGRectMake(i* headerView.frame.size.width/parts+1 , 1 , headerView.frame.size.width/parts+30, headerView.frame.size.height-2);
                    TimeTitle.layer.borderColor = [UIColor clearColor].CGColor;
                    TimeTitle.layer.borderWidth = 1.5;
                    TimeTitle.layer.cornerRadius = 4.0;
                    [TimeTitle setClipsToBounds:YES];
                    
                }
                if (i == parts-1) {
                    TimeTitle.frame =CGRectMake(i* headerView.frame.size.width/parts-2 , 1 , headerView.frame.size.width/parts+1, headerView.frame.size.height-2);
                    TimeTitle.layer.borderColor = [UIColor clearColor].CGColor;
                    TimeTitle.layer.borderWidth = 1.5;
                    TimeTitle.layer.cornerRadius = 4.0;
                    [TimeTitle setClipsToBounds:YES];
                }
                if (addingTime == nil) {
                    addingTime = startTime;
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"HH:mm"];
                    timelbl  =[ dateFormat stringFromDate:addingTime];
                    
                }else{
                    NSDateComponents *dateComponents = [NSDateComponents new];
                    dateComponents.minute = 30;
                    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                                                   toDate: addingTime
                                                                                  options:0];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"HH:mm"];
                    timelbl  =[ dateFormat stringFromDate:newDate];
                    addingTime = newDate;
                }
                
                if ([startDate compare:addingTime] == NSOrderedAscending) {
                    [TimeTitle setBackgroundColor:[UIColor colorWithRed:237/255.0f green:114/255.0f blue:18/255.0f alpha:1.0]];
                    [headerView addSubview:TimeTitle];
                }
                if ([enddate compare:addingTime] == NSOrderedAscending) {
                    [TimeTitle setBackgroundColor:[UIColor clearColor]];
                    [headerView addSubview:TimeTitle];
                }
                if ([startDate compare:addingTime] == NSOrderedSame) {
                    [TimeTitle setBackgroundColor:[UIColor colorWithRed:237/255.0f green:114/255.0f blue:18/255.0f alpha:1.0]];
                    [headerView addSubview:TimeTitle];
                    
                    UILabel *bookerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(TimeTitle.frame.origin.x+ 130, y, 350, 30)];
                    bookerNameLbl.text = @"Mr. Peter (5 People)";
                    bookerNameLbl.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
                    [bookerNameLbl setTextAlignment:NSTextAlignmentCenter];
                    bookerNameLbl.textColor= [UIColor whiteColor];
                    [headerView bringSubviewToFront:bookerNameLbl];
                    [self.view addSubview:bookerNameLbl];
                }
            }
            
        }
        y= y + 45;
    }
    int x=145;
    for (int i = 0; i<2; i++) {
        UIView *headerView;
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(x, y + 10, 200, 100)];
        [headerView setBackgroundColor:[UIColor colorWithRed:24/255.0f green:45/255.0f blue:72/255.0f alpha:1.0]];
        headerView.layer.borderColor = [UIColor clearColor].CGColor;
        headerView.layer.borderWidth = 1.5;
        headerView.layer.cornerRadius = 4.0;
        [headerView setClipsToBounds:YES];
        [self.view addSubview:headerView];
        x= x + 230;
        if (i == 0) {
            
            UILabel *bookerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 150, 30)];
            bookerNameLbl.text = @"Next Available Table";
            bookerNameLbl.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
            [bookerNameLbl setTextAlignment:NSTextAlignmentLeft];
            bookerNameLbl.textColor= [UIColor whiteColor];
            [headerView addSubview:bookerNameLbl];
            int y= 40;
            for (int j = 0; j<2; j++) {
                UILabel *tableDetailsLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 150, 20)];
                tableDetailsLbl.text = @"Table 4 at 14:30";
                tableDetailsLbl.font = [UIFont fontWithName:@"Lovelo" size:12.0f];
                [tableDetailsLbl setTextAlignment:NSTextAlignmentLeft];
                tableDetailsLbl.textColor= [UIColor whiteColor];
                
                [headerView addSubview:tableDetailsLbl];
                y = y+23;
            }
            
            
        }else if (i == 1){
            UILabel *bookerNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 150, 30)];
            bookerNameLbl.text = @"Expected Arival";
            bookerNameLbl.font = [UIFont fontWithName:@"Lovelo" size:14.0f];
            [bookerNameLbl setTextAlignment:NSTextAlignmentLeft];
            bookerNameLbl.textColor= [UIColor whiteColor];
            [headerView addSubview:bookerNameLbl];
            int y= 40;
            for (int j = 0; j<2; j++) {
                UILabel *arrivalsDetailsLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, y, 150, 20)];
                arrivalsDetailsLbl.text = @"Table 4 at 14:30";
                arrivalsDetailsLbl.font = [UIFont fontWithName:@"Lovelo" size:12.0f];
                [arrivalsDetailsLbl setTextAlignment:NSTextAlignmentLeft];
                arrivalsDetailsLbl.textColor= [UIColor whiteColor];
                [headerView addSubview:arrivalsDetailsLbl];
                y = y+23;
            }
        }
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    // get pointer to app delegate, which contains property for menu pointer
    
    
   
    
    [self.view addSubview: Leftsideview];
    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Calendar" delegate:self];
    
    [self.view addSubview: upparView];
    
}
- (void)mainMenuBtnPressed{
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
    NSLog(@"dashboard preesed");
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == floorDropDown){
        return [calenderFloorList count];
    }else if (tableView == menuSlotsDropDown){
        return [calenderMenuSlots count];
    } else if(tableView == restaurantListDropDown){
        return [restaurantListArray count];
    }else{
        return 0;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (tableView == floorDropDown || tableView == menuSlotsDropDown || tableView == restaurantListDropDown) {
        return 30;
    }else{
    return 50;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == floorDropDown){
       
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        floorOC = [calenderFloorList objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"Lovelo" size:14.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",floorOC.Value];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if(tableView == menuSlotsDropDown){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        menuSlotsOC = [calenderMenuSlots objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont fontWithName:@"Lovelo" size:14.0f]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",menuSlotsOC.Value];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
        
    }else if(tableView == restaurantListDropDown){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        calenderRestaurantOC = [calendarRestaurantList objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",calenderRestaurantOC.VenueName];
         [cell.textLabel setFont:[UIFont fontWithName:@"Lovelo" size:14.0f]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;
        
    }
    return nil;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == floorDropDown) {
       
        floorOC = [calenderFloorList objectAtIndex:indexPath.row];
        [floorBtn setTitle:[NSString stringWithFormat:@"%@",floorOC.Value] forState:UIControlStateNormal];
        [floorDropDown removeFromSuperview];
        selectionView.hidden = YES;
    }else if (tableView == menuSlotsDropDown) {
        
        menuSlotsOC = [calenderMenuSlots objectAtIndex:indexPath.row];
        [menuSlotBtn setTitle:[NSString stringWithFormat:@"%@",menuSlotsOC.Value] forState:UIControlStateNormal];
        [floorDropDown removeFromSuperview];
        selectionView.hidden = YES;
    }else if (tableView == restaurantListDropDown) {
        
        calenderRestaurantOC = [calendarRestaurantList objectAtIndex:indexPath.row];
        [restaurantNameBtn setTitle:[NSString stringWithFormat:@"%@",calenderRestaurantOC.VenueName] forState:UIControlStateNormal];
        [floorDropDown removeFromSuperview];
        selectionView.hidden = YES;
    }
   
}

- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:addBookingVC animated:NO];
    NSLog(@"addBookingBtn Pressed ");
    
}

-(void) fetchRestaurant
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
    webserviceCode =1;
    showPastData = [NSString stringWithFormat:@"false"];
    showUpcoming = [NSString stringWithFormat:@"false"];
    
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
-(void) fetchMenuSlots
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
    webserviceCode =2;
    showPastData = [NSString stringWithFormat:@"false"];
    showUpcoming = [NSString stringWithFormat:@"false"];
    
//    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:clientId,@"ClientId", nil];
//    NSString *jsonRequest = [jsonDict JSONRepresentation];
//    
//    NSLog(@"jsonRequest is %@", jsonRequest);
    NSURL *urlString=[NSURL URLWithString:@"http://ucoservice.vishalshahi.com/IPadServices.svc/IpadGetListOfFoodMenuSlot"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
//    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
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

-(void) fetchfloorList
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
    webserviceCode =3;
    showPastData = [NSString stringWithFormat:@"false"];
    showUpcoming = [NSString stringWithFormat:@"false"];
    
    NSDictionary *jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:clientId,@"clientId",listDataIdStr,@"listDataId", nil];
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
    if (webserviceCode == 1) {
        restaurantListArray = [[NSMutableArray alloc]init];
    calendarRestaurantList = [[NSMutableArray alloc]init];
    for (int i = 0; i < [userDetailDict count]; i++) {
        calenderRestaurantOC = [[calenderRestaurantObj alloc] init];
        calenderRestaurantOC.VenueName =[[userDetailDict valueForKey:@"Name"] objectAtIndex:i];
        calenderRestaurantOC.Address = [[userDetailDict valueForKey:@"Address"] objectAtIndex:i];
        calenderRestaurantOC.City = [[userDetailDict valueForKey:@"City"]objectAtIndex:i];
        calenderRestaurantOC.Country = [[userDetailDict valueForKey:@"Country"]objectAtIndex:i];
        calenderRestaurantOC.Created = [[userDetailDict valueForKey:@"Created"]objectAtIndex:i];
        calenderRestaurantOC.Description = [[userDetailDict valueForKey:@"Description"]objectAtIndex:i];
        calenderRestaurantOC.DetailDescription = [[userDetailDict valueForKey:@"DetailDescription"]objectAtIndex:i];
        calenderRestaurantOC.Entertaintment = [[userDetailDict valueForKey:@"Entertaintment"]objectAtIndex:i];
        calenderRestaurantOC.EventType = [[userDetailDict valueForKey:@"EventType"]objectAtIndex:i];
        calenderRestaurantOC.IsOther = [[userDetailDict valueForKey:@"IsOther"]objectAtIndex:i];
        calenderRestaurantOC.IsRecommended = [[userDetailDict valueForKey:@"IsRecommended"]objectAtIndex:i];
        calenderRestaurantOC.ListDataId = [[userDetailDict valueForKey:@"ListDataId"]objectAtIndex:i];
        calenderRestaurantOC.CleintId = [[userDetailDict valueForKey:@"CleintId"]objectAtIndex:i];
        calenderRestaurantOC.ParentId = [[userDetailDict valueForKey:@"ParentId"]objectAtIndex:i];
        calenderRestaurantOC.Phone = [[userDetailDict valueForKey:@"Phone"]objectAtIndex:i];
        calenderRestaurantOC.Picture = [[userDetailDict valueForKey:@"Picture"]objectAtIndex:i];
        calenderRestaurantOC.RecordStatus = [[userDetailDict valueForKey:@"RecordStatus"]objectAtIndex:i];
        calenderRestaurantOC.SortOrder = [[userDetailDict valueForKey:@"SortOrder"]objectAtIndex:i];
        calenderRestaurantOC.State = [[userDetailDict valueForKey:@"State"]objectAtIndex:i];
        calenderRestaurantOC.Status = [[userDetailDict valueForKey:@"Status"]objectAtIndex:i];
        calenderRestaurantOC.ThemeVenues = [[userDetailDict valueForKey:@"ThemeVenues"]objectAtIndex:i];
        calenderRestaurantOC.TypeOfRestaurant = [[userDetailDict valueForKey:@"TypeOfRestaurant"]objectAtIndex:i];
        calenderRestaurantOC.Typeofmenu = [[userDetailDict valueForKey:@"Typeofmenu"]objectAtIndex:i];
        calenderRestaurantOC.VenueClassification = [[userDetailDict valueForKey:@"VenueClassification"]objectAtIndex:i];
        calenderRestaurantOC.Zip = [[userDetailDict valueForKey:@"Zip"]objectAtIndex:i];
        [restaurantListArray addObject:calenderRestaurantOC.VenueName];
        [calendarRestaurantList addObject:calenderRestaurantOC];
    }
    isCalenderRestaurantList = YES;
        [self fetchMenuSlots];
//    [calenderTableView reloadData];
    }else if (webserviceCode == 2){
        calenderMenuSlots = [[NSMutableArray alloc] init];
        for (int i = 0; i < [userDetailDict count]; i++) {
            menuSlotsOC = [[menuSlotsObj alloc] init];
            menuSlotsOC.Key =[[userDetailDict valueForKey:@"Key"] objectAtIndex:i];
            menuSlotsOC.Value = [[userDetailDict valueForKey:@"Value"] objectAtIndex:i];
            [calenderMenuSlots addObject:menuSlotsOC];
        }
        [self fetchfloorList];
        
    }else if (webserviceCode == 3){
        calenderFloorList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [userDetailDict count]; i++) {
            floorOC = [[floorObj alloc] init];
            floorOC.Key =[[userDetailDict valueForKey:@"Key"] objectAtIndex:i];
            floorOC.Value = [[userDetailDict valueForKey:@"Value"] objectAtIndex:i];
            [calenderFloorList addObject:floorOC];
        }
       [self addRestaurantView];

    }
     [activityIndicator stopAnimating];
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
   
    
}


@end
