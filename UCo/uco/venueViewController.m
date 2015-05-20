//
//  venueViewController.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/13/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "venueViewController.h"
#import "venuOpeningTimingTableViewCell.h"
#import "NIDropDown.h"
@interface venueViewController ()

@end

@implementation venueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mealTimingArray = [[NSMutableArray alloc]initWithObjects:@"Breakfast",@"Lunch",@"Dinner",nil];
    daysNameArray = [[NSMutableArray alloc] initWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",nil];
    tempArray = [[NSMutableArray alloc] initWithObjects:@"Breakfast",@"Lunch",@"Dinner",nil];
    hoursArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
    dayTypeArray = [[NSMutableArray alloc] initWithObjects:@"A.M",@"P.M",nil];
    minsArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 31; i++) {
        [minsArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self setTabButtons];
    [self addMealViews];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    // get pointer to app delegate, which contains property for menu pointer
    
    
   
        upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Add/Edit Venue" delegate:self];
    
    
    
    [self.view addSubview: upparView];
    
}
-(void)setTabButtons
{
    openingTimingTabBtn.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    openingTimingTabBtn.layer.borderWidth = 1.5;
    openingTimingTabBtn.layer.cornerRadius = 17.0;
    [openingTimingTabBtn setClipsToBounds:YES];
    
     tableViewTabBtn.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;;
    tableViewTabBtn.layer.borderWidth = 1.5;
    tableViewTabBtn.layer.cornerRadius = 17.0;
    [tableViewTabBtn setClipsToBounds:YES];
    
    editVenueTabBtn.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    editVenueTabBtn.layer.borderWidth = 1.5;
    editVenueTabBtn.layer.cornerRadius = 17.0;
    [editVenueTabBtn setClipsToBounds:YES];
    
}

- (IBAction)editVenueButtonAction:(id)sender {
    openingTimingTabBtn.backgroundColor = [UIColor clearColor];
    tableViewTabBtn.backgroundColor = [UIColor clearColor];
    editVenueTabBtn.backgroundColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1];
    editVenueView.hidden = NO;
    [openingTimingView removeFromSuperview];
}

- (IBAction)openingTimmingBtnAction:(id)sender {
    openingTimingTabBtn.backgroundColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1];
    tableViewTabBtn.backgroundColor = [UIColor clearColor];
    editVenueTabBtn.backgroundColor = [UIColor clearColor];
    editVenueView.hidden =YES;
    [openingTimingView setFrame:CGRectMake(0, 166, 1024, 583)];
    [self.view addSubview:openingTimingView];
    [daysTimingTableView reloadData];
}

- (IBAction)tableViewBtnAction:(id)sender {
    openingTimingTabBtn.backgroundColor = [UIColor clearColor];
    tableViewTabBtn.backgroundColor = [UIColor clearColor];
    editVenueTabBtn.backgroundColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1];
    [openingTimingView removeFromSuperview];
}

- (IBAction)hoursFromBtnAction:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :hoursArray :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)minsFromBtnAction:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :minsArray :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)dayTypeFromBtnAction:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 60;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dayTypeArray :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }

}

- (IBAction)dayTypeToBtnAction:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 60;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :dayTypeArray :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }

}

- (IBAction)minsToBtnAction:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :minsArray :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

- (IBAction)hoursToBtnAction:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :hoursArray :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }

}

 
-(void)addMealViews{
    int y= 70;
    for (int i = 0 ; i< [mealTimingArray count]; i++) {
        UIView *mealTimingView = [[UIView alloc] initWithFrame:CGRectMake(500, y,461 , 80)];
        [mealTimingView setBackgroundColor:[UIColor clearColor]];
        [openingTimingView addSubview:mealTimingView];
        [openingTimingView sendSubviewToBack:mealTimingView];
        ///////  Edit BUTTON //////////
        UIButton *selectDayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        selectDayBtn.frame = CGRectMake(9.0f, 15.0f,15.0f,15.0f);
        [selectDayBtn setTintColor:[UIColor whiteColor]] ;
        //[selectDayBtn addTarget:self action:@selector(selectDayActionBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"checkbox_unchecked.png"];
        [selectDayBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
        [mealTimingView addSubview:selectDayBtn];
        
        UILabel *mealNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(34, 13, 82, 21)];
        mealNameLbl.text = [mealTimingArray objectAtIndex:i];
        mealNameLbl.textColor = [UIColor whiteColor];
        [mealNameLbl setFont:[UIFont fontWithName:@"Lovelo" size:13]];
        [mealTimingView addSubview:mealNameLbl];
        
        UILabel *mealFromLbl = [[UILabel alloc]initWithFrame:CGRectMake(118, 13, 43, 21)];
        mealFromLbl.text = @"From";
        mealFromLbl.textColor = [UIColor whiteColor];
        [mealFromLbl setFont:[UIFont fontWithName:@"Lovelo" size:13]];
        [mealTimingView addSubview:mealFromLbl];
        UILabel *mealToLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 47, 24, 21)];
        mealToLbl.text = @"TO";
        mealToLbl.textColor = [UIColor whiteColor];
        [mealToLbl setFont:[UIFont fontWithName:@"Lovelo" size:13]];
        [mealTimingView addSubview:mealToLbl];
        ///////// From Start Button /////////
        UIImageView *imageBg1 = [[UIImageView alloc] initWithFrame:CGRectMake(167, 11, 86, 26)];
        imageBg1.image = [UIImage imageNamed:@"label1_1.png"];
        [mealTimingView addSubview:imageBg1];
        
        UIImageView *dropDownImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(236, 20, 8, 6)];
        dropDownImage1.image = [UIImage imageNamed:@"dropdown-arrow.png"];
        [mealTimingView addSubview:dropDownImage1];
        
        UIButton *fromStartBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fromStartBtn setTitle: @"1" forState: UIControlStateNormal];
        fromStartBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        fromStartBtn.frame = CGRectMake(169.0f, 9.0f,84.0f,30.0f);
        fromStartBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        [fromStartBtn setTintColor:[UIColor whiteColor]] ;
        [fromStartBtn addTarget:self action:@selector(hoursFromBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [fromStartBtn setBackgroundColor:[UIColor clearColor]];
        [mealTimingView addSubview:fromStartBtn];
        
        ///////// From End Button /////////
        
        UIImageView *imageBg2 = [[UIImageView alloc] initWithFrame:CGRectMake(267, 11, 86, 26)];
        imageBg2.image = [UIImage imageNamed:@"label1_1.png"];
        [mealTimingView addSubview:imageBg2];
        
        UIImageView *dropDownImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(336, 22, 8, 6)];
        dropDownImage2.image = [UIImage imageNamed:@"dropdown-arrow.png"];
        [mealTimingView addSubview:dropDownImage2];
        
        UIButton *fromEndBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fromEndBtn setTitle: @"1" forState: UIControlStateNormal];
        fromEndBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        fromEndBtn.frame = CGRectMake(269.0f,8.0f,84.0f,30.0f);
        fromEndBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        [fromEndBtn setTintColor:[UIColor whiteColor]] ;
        [fromEndBtn addTarget:self action:@selector(minsFromBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [fromEndBtn setBackgroundColor:[UIColor clearColor]];
        [mealTimingView addSubview:fromEndBtn];
        
        ///////// AM/PM Button /////////
        
        UIImageView *imageBg3 = [[UIImageView alloc] initWithFrame:CGRectMake(364, 11, 86, 26)];
        imageBg3.image = [UIImage imageNamed:@"label1_1.png"];
        [mealTimingView addSubview:imageBg3];
        
        UIImageView *dropDownImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(433, 20, 8, 6)];
        dropDownImage3.image = [UIImage imageNamed:@"dropdown-arrow.png"];
        [mealTimingView addSubview:dropDownImage3];
        
        UIButton *fromdayTypeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [fromdayTypeBtn setTitle: @"A.M" forState: UIControlStateNormal];
        
        fromdayTypeBtn.frame = CGRectMake(364.0f, 8.0f,84.0f,30.0f);
        fromdayTypeBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        [fromdayTypeBtn setTintColor:[UIColor whiteColor]] ;
        fromdayTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [fromdayTypeBtn addTarget:self action:@selector(dayTypeFromBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [fromdayTypeBtn setBackgroundColor:[UIColor clearColor]];
        [mealTimingView addSubview:fromdayTypeBtn];
        
        ///////// To Start Button /////////
        UIImageView *imageBg4 = [[UIImageView alloc] initWithFrame:CGRectMake(167, 44, 86, 26)];
        imageBg4.image = [UIImage imageNamed:@"label1_1.png"];
        [mealTimingView addSubview:imageBg4];
        
        UIImageView *dropDownImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(236, 54, 8, 6)];
        dropDownImage4.image = [UIImage imageNamed:@"dropdown-arrow.png"];
        [mealTimingView addSubview:dropDownImage4];
        
        UIButton *toStartBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [toStartBtn setTitle: @"1" forState: UIControlStateNormal];
        toStartBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        toStartBtn.frame = CGRectMake(168.0f,43.0f,84.0f,30.0f);
        toStartBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        [toStartBtn setTintColor:[UIColor whiteColor]] ;
        [toStartBtn addTarget:self action:@selector(hoursToBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [toStartBtn setBackgroundColor:[UIColor clearColor]];
        [mealTimingView addSubview:toStartBtn];
        
        ///////// To End Button /////////
        UIImageView *imageBg5 = [[UIImageView alloc] initWithFrame:CGRectMake(267, 44, 86, 26)];
        imageBg5.image = [UIImage imageNamed:@"label1_1.png"];
        [mealTimingView addSubview:imageBg5];
        
        UIImageView *dropDownImage5 = [[UIImageView alloc] initWithFrame:CGRectMake(336, 54, 8, 6)];
        dropDownImage5.image = [UIImage imageNamed:@"dropdown-arrow.png"];
        [mealTimingView addSubview:dropDownImage5];
        
        UIButton *toEndBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [toEndBtn setTitle: @"1" forState: UIControlStateNormal];
        toEndBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        toEndBtn.frame = CGRectMake(268.0f,42.0f,84.0f,30.0f);
        toEndBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        [toEndBtn setTintColor:[UIColor whiteColor]] ;
        [toEndBtn addTarget:self action:@selector(minsToBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [toEndBtn setBackgroundColor:[UIColor clearColor]];
        [mealTimingView addSubview:toEndBtn];
        
        ///////// To AM/PM Button /////////
        UIImageView *imageBg6 = [[UIImageView alloc] initWithFrame:CGRectMake(364, 44, 86, 26)];
        imageBg6.image = [UIImage imageNamed:@"label1_1.png"];
        [mealTimingView addSubview:imageBg6];
        
        UIImageView *dropDownImage6 = [[UIImageView alloc] initWithFrame:CGRectMake(433, 54, 8, 6)];
        dropDownImage6.image = [UIImage imageNamed:@"dropdown-arrow.png"];
        [mealTimingView addSubview:dropDownImage6];
        
        UIButton *todayTypeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [todayTypeBtn setTitle: @"P.M" forState: UIControlStateNormal];
        todayTypeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        todayTypeBtn.frame = CGRectMake(364.0f, 42.0f,84.0f,30.0f);
        todayTypeBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        [todayTypeBtn setTintColor:[UIColor whiteColor]] ;
        [todayTypeBtn addTarget:self action:@selector(dayTypeToBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [todayTypeBtn setBackgroundColor:[UIColor clearColor]];
        [mealTimingView addSubview:todayTypeBtn];
        
        
        
        y= y + mealTimingView.frame.size.height+5;
    }
}

@end
