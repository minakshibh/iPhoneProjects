
//
//  DDCalendarView.m
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LeftSideBarView.h"
#import "DashboardViewController.h"
#import "manageRestaurantViewController.h"

DashboardViewController*dashboardViewObj;


NSMutableArray *Dayarray;

@implementation LeftSideBarView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate
{
	if ((self = [super initWithFrame:frame])) {
        
        
		self.delegate = theDelegate;
        
        self.backgroundColor= [UIColor colorWithRed:23.0/255.0f green:32.0f/255.0f blue:57.0f/255.0f alpha:1];
		//Initialise vars
		calendarWidth =125;
		calendarHeight = frame.size.height;
		buttonWidth = 125;
		buttonHeight = frame.size.height / 8.0f;
        buttonYaxis=0;
        
        
        //////DASHBOARD////////
		UIButton *dashboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[dashboardBtn setImage:[UIImage imageNamed:@"dashboard-icon.png"] forState:UIControlStateNormal];
        [dashboardBtn setBackgroundColor:[UIColor clearColor]];
        dashboardBtn.frame = CGRectMake(0, buttonYaxis,buttonWidth, buttonHeight);
		[dashboardBtn addTarget:self action:@selector(dashboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        buttonYaxis=dashboardBtn.frame.origin.y+buttonHeight;
        
    
        CGRect dashBoardLblFrame;
        dashBoardLblFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*dashBoardLbl=[[UILabel alloc] initWithFrame:dashBoardLblFrame];
        dashBoardLbl.backgroundColor = [UIColor clearColor];
        dashBoardLbl.text=@"DASHBOARD";
        [dashBoardLbl setTextAlignment:NSTextAlignmentCenter];
        dashBoardLbl.textColor=[UIColor whiteColor];
        
        
        //////Table View Btn////////

        UIButton *tableViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[tableViewBtn setImage:[UIImage imageNamed:@"table-view-icon.png"] forState:UIControlStateNormal];
        tableViewBtn.frame = CGRectMake(0, buttonYaxis, buttonWidth, buttonHeight);
		[tableViewBtn addTarget:self action:@selector(tableViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [tableViewBtn setBackgroundColor:[UIColor clearColor]];
        buttonYaxis=tableViewBtn.frame.origin.y+buttonHeight;

        CGRect tableViewBtnLabelFrame;
        tableViewBtnLabelFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*tableViewBtnLabel=[[UILabel alloc] initWithFrame:tableViewBtnLabelFrame];
        tableViewBtnLabel.backgroundColor = [UIColor clearColor];
        tableViewBtnLabel.text=@"Table View";
        [tableViewBtnLabel setTextAlignment:NSTextAlignmentCenter];
        tableViewBtnLabel.textColor=[UIColor whiteColor];

        ///////CalendarBtn/////////
        
        UIButton *calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [calendarBtn setImage:[UIImage imageNamed:@"calendar-view-icon.png"] forState:UIControlStateNormal];
        calendarBtn.frame = CGRectMake(0, buttonYaxis, buttonWidth, buttonHeight);
        [calendarBtn addTarget:self action:@selector(calendarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [calendarBtn setBackgroundColor:[UIColor clearColor]];
        buttonYaxis=calendarBtn.frame.origin.y+buttonHeight;
        
        CGRect calendarBtnLabelFrame;
        calendarBtnLabelFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*calendarLabel=[[UILabel alloc] initWithFrame:calendarBtnLabelFrame];
        calendarLabel.backgroundColor = [UIColor clearColor];
        calendarLabel.text=@"Calendar View";
        [calendarLabel setTextAlignment:NSTextAlignmentCenter];
        calendarLabel.textColor=[UIColor whiteColor];
        
        ///////greetingsBtn/////////
        
        UIButton *greetingsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [greetingsBtn setImage:[UIImage imageNamed:@"greetings-icon.png"] forState:UIControlStateNormal];
        greetingsBtn.frame = CGRectMake(0, buttonYaxis, buttonWidth, buttonHeight);
        [greetingsBtn addTarget:self action:@selector(greetingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [greetingsBtn setBackgroundColor:[UIColor clearColor]];
        buttonYaxis=greetingsBtn.frame.origin.y+buttonHeight;

        
        CGRect greetingsLabelFrame;
        greetingsLabelFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*greetingsLabel=[[UILabel alloc] initWithFrame:greetingsLabelFrame];
        greetingsLabel.backgroundColor = [UIColor clearColor];
        greetingsLabel.text=@"GREETINGS";
        [greetingsLabel setTextAlignment:NSTextAlignmentCenter];
        greetingsLabel.textColor=[UIColor whiteColor];

        
        ///////allBookingBtn/////////

        UIButton *allBookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [allBookingBtn setImage:[UIImage imageNamed:@"all-booking-icon.png"] forState:UIControlStateNormal];
        allBookingBtn.frame = CGRectMake(0, buttonYaxis, buttonWidth, buttonHeight);
        [allBookingBtn addTarget:self action:@selector(allBookingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [allBookingBtn setBackgroundColor:[UIColor clearColor]];
        buttonYaxis=allBookingBtn.frame.origin.y+buttonHeight;

        CGRect allBookingLabelFrame;
        allBookingLabelFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*allBookingLabel=[[UILabel alloc] initWithFrame:allBookingLabelFrame];
        allBookingLabel.backgroundColor = [UIColor clearColor];
        allBookingLabel.text=@"ALL BOOKINGS";
        [allBookingLabel setTextAlignment:NSTextAlignmentCenter];
        allBookingLabel.textColor=[UIColor whiteColor];

        
        

        ////////reportBtn///////
        
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportBtn setImage:[UIImage imageNamed:@"reporting-icon.png"] forState:UIControlStateNormal];
        reportBtn.frame = CGRectMake(0, buttonYaxis, buttonWidth, buttonHeight);
        [reportBtn addTarget:self action:@selector(reportingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [reportBtn setBackgroundColor:[UIColor clearColor]];
        buttonYaxis=reportBtn.frame.origin.y+buttonHeight;
        
        CGRect reportLabelFrame;
        reportLabelFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*reportLabel=[[UILabel alloc] initWithFrame:reportLabelFrame];
        reportLabel.backgroundColor = [UIColor clearColor];
        reportLabel.text=@"REPORTING";
        [reportLabel setTextAlignment:NSTextAlignmentCenter];
        reportLabel.textColor=[UIColor whiteColor];

        ////////PaymentBtn///////

        UIButton *PaymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [PaymentBtn setImage:[UIImage imageNamed:@"payment-icon.png"] forState:UIControlStateNormal];
        PaymentBtn.frame = CGRectMake(0, buttonYaxis, buttonWidth, buttonHeight);
        [PaymentBtn addTarget:self action:@selector(paymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [PaymentBtn setBackgroundColor:[UIColor  clearColor]];
        buttonYaxis=PaymentBtn.frame.origin.y+buttonHeight;
        
        CGRect PaymentLabelFrame;
        PaymentLabelFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*PaymentLabel=[[UILabel alloc] initWithFrame:PaymentLabelFrame];
        PaymentLabel.backgroundColor = [UIColor clearColor];
        PaymentLabel.text=@"PAYMENT";
        [PaymentLabel setTextAlignment:NSTextAlignmentCenter];
        PaymentLabel.textColor=[UIColor whiteColor];

        
        ////////settingBtn///////

        UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingBtn setImage:[UIImage imageNamed:@"settings-icon.png"] forState:UIControlStateNormal];
        settingBtn.frame = CGRectMake(0, buttonYaxis, buttonWidth, buttonHeight);
        [settingBtn addTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [settingBtn setBackgroundColor:[UIColor clearColor]];
        buttonYaxis=settingBtn.frame.origin.y+buttonHeight;
        
        CGRect settingLabelFrame;
        settingLabelFrame = CGRectMake(0, buttonYaxis-35,buttonWidth ,40);
        UILabel*settingLabel=[[UILabel alloc] initWithFrame:settingLabelFrame];
        settingLabel.backgroundColor = [UIColor clearColor];
        settingLabel.text=@"SETTING";
        [settingLabel setTextAlignment:NSTextAlignmentCenter];
        settingLabel.textColor=[UIColor whiteColor];

        // Add Font
        
        dashBoardLbl.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        allBookingLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        tableViewBtnLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        greetingsLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        PaymentLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        settingLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        reportLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        calendarLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        

		//Add buttons
		[self addSubview: dashboardBtn];
		[self addSubview: allBookingBtn];
        [self addSubview: tableViewBtn];
        [self addSubview: greetingsBtn];
        [self addSubview: PaymentBtn];
        [self addSubview: settingBtn];
        [self addSubview: reportBtn];
        [self addSubview: calendarBtn];
        [self addSubview: dashBoardLbl];
        [self addSubview: allBookingLabel];
        [self addSubview: tableViewBtnLabel];
        [self addSubview: greetingsLabel];
        [self addSubview: PaymentLabel];
        [self addSubview: settingLabel];
        [self addSubview: reportLabel];
        [self addSubview: calendarLabel];
        
        
    }
    return self;
}


- (void)dashboardButtonPressed:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(dashboardButtonPressed)]) {
        [self.delegate dashboardButtonPressed];
    }
    NSLog(@"dashboard preesed");
}
- (void)allBookingButtonPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(allBookingButtonPressed)]) {
        [self.delegate allBookingButtonPressed];
    }
    NSLog(@"allBookingButton Pressed ");
}
- (void)tableViewButtonPressed:(id)sender{
    NSLog(@"manageRestaurantButton Pressed ");
    if ([self.delegate respondsToSelector:@selector(tableViewButtonPressed)]) {
        [self.delegate tableViewButtonPressed];
    }
}
- (void)greetingButtonPressed:(id)sender{
    NSLog(@"greetingButton Pressed ");
    if ([self.delegate respondsToSelector:@selector(greetingButtonPressed)]) {
        [self.delegate greetingButtonPressed];
    }
}
- (void)calendarButtonPressed:(id)sender{
    NSLog(@"markettingButton Pressed ");
    if ([self.delegate respondsToSelector:@selector(calendarButtonPressed)]) {
        [self.delegate calendarButtonPressed];
    }
}
- (void)reportingButtonPressed:(id)sender{
    NSLog(@"reportingButton Pressed ");
    if ([self.delegate respondsToSelector:@selector(reportingButtonPressed)]) {
        [self.delegate reportingButtonPressed];
    }
}
- (void)paymentButtonPressed:(id)sender{
    NSLog(@"paymentButton Pressed ");
    if ([self.delegate respondsToSelector:@selector(paymentButtonPressed)]) {
        [self.delegate paymentButtonPressed];
    }
}
- (void)settingButtonPressed:(id)sender{
    NSLog(@"settingButton Pressed ");
    if ([self.delegate respondsToSelector:@selector(settingButtonPressed)]) {
        [self.delegate settingButtonPressed];
    }
}



- (void)dealloc {
	    [super dealloc];
}


@end
