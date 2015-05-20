
//
//  DDCalendarView.m
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UpparBarView.h"
#import "DashboardViewController.h"
#import "manageRestaurantViewController.h"

DashboardViewController*dashboardViewObj;


NSMutableArray *Dayarray;

@implementation UpparBarView
@synthesize upparBardelegate;

- (id)initWithFrame:(CGRect)frame HeaderName:(NSString *)HeaderName delegate:(id)theDelegate{
	if ((self = [super initWithFrame:frame])) {
        
        
		self.upparBardelegate = theDelegate;
        
		
		//Initialise vars
		calendarWidth = frame.size.width;
		calendarHeight = frame.size.height;
		buttonWidth = 300;
		buttonHeight = 60;
        buttonYaxis=80;
        
		//View properties
        
        self.backgroundColor= [UIColor colorWithRed:16.0/255.0f green:22.0f/255.0f blue:38.0f/255.0f alpha:1];

	
        UIButton *addBookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBookingBtn.frame = CGRectMake(705,30,150,35);
        [addBookingBtn addTarget:self action:@selector(addBookingBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [addBookingBtn setBackgroundColor:[UIColor colorWithRed:221.0/255.0f green:98.0f/255.0f blue:0.0f/255.0f alpha:1]];
        [addBookingBtn setTitle: @"ADD A BOOKING" forState: UIControlStateNormal];
        addBookingBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        addBookingBtn.layer.borderColor =[UIColor clearColor].CGColor;
        addBookingBtn.layer.borderWidth = 1.5;
        addBookingBtn.layer.cornerRadius = 17.0;
        [addBookingBtn setClipsToBounds:YES];
        
        UIButton *createPromotionViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        createPromotionViewBtn.frame = CGRectMake(545,30,150,35);
        [createPromotionViewBtn addTarget:self action:@selector(createPromotionViewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [createPromotionViewBtn setBackgroundColor:[UIColor colorWithRed:190.0/255.0f green:31.0f/255.0f blue:59.0f/255.0f alpha:1]];
        createPromotionViewBtn.hidden = NO;
        [createPromotionViewBtn setTitle: @"Create Promotion" forState: UIControlStateNormal];
        createPromotionViewBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        createPromotionViewBtn.layer.borderColor =[UIColor clearColor].CGColor;
        createPromotionViewBtn.layer.borderWidth = 1.5;
        createPromotionViewBtn.layer.cornerRadius = 17.0;
        [createPromotionViewBtn setClipsToBounds:YES];
        
        UIButton *feedbackViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        feedbackViewBtn.frame = CGRectMake(382,30,150,35);
        [feedbackViewBtn addTarget:self action:@selector(feedbackViewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [feedbackViewBtn setBackgroundColor:[UIColor colorWithRed:35.0/255.0f green:90.0f/255.0f blue:9.0f/255.0f alpha:1]];
        [feedbackViewBtn setTitle: @"FeedBack" forState: UIControlStateNormal];
        feedbackViewBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
        feedbackViewBtn.layer.borderColor =[UIColor clearColor].CGColor;
        feedbackViewBtn.layer.borderWidth = 1.5;
        feedbackViewBtn.layer.cornerRadius = 17.0;
        feedbackViewBtn.hidden = NO;
        [feedbackViewBtn setClipsToBounds:YES];
        
       
        
        
        UIImageView *searchBgImageView= [[UIImageView alloc] initWithFrame: CGRectMake(865, 30, 124, 32)];
        searchBgImageView.image = [UIImage imageNamed:@"search-box.png"];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.frame = CGRectMake(97,10,13,12);
        [searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"search-btn.png"] forState:UIControlStateNormal];
       
        UITextField *searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, 95, 28)];
        searchTxt.placeholder = @"search";
        searchTxt.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
        
        UILabel*titleLbl=[[UILabel alloc] initWithFrame:CGRectMake(140, 25, 200, 50)];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.textColor = [UIColor whiteColor];
        [titleLbl setTextAlignment:NSTextAlignmentLeft];
        NSString *restaurantTitleName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Restaurant Name"]];
        titleLbl.text = [NSString stringWithFormat:@"%@",restaurantTitleName];
        titleLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
        [self addSubview:titleLbl];

        
        
        UIButton *mainMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([HeaderName isEqualToString:@"DASHBOARD"])
        {
            

            [mainMenuBtn setImage:[UIImage imageNamed:@"header-logo.png"] forState:UIControlStateNormal];

        }
        else{
            [mainMenuBtn setImage:[UIImage imageNamed:@"header-logo-with-menu-icon.png"] forState:UIControlStateNormal];
            
        }
        
        if ([HeaderName isEqualToString:@"Manage Restaurant"])
        {
            addBookingBtn.hidden = YES;
           
        }
        if ([HeaderName isEqualToString:@"Manage Venue"]||[HeaderName isEqualToString:@"Setting"]||[HeaderName isEqualToString:@"Calendar"]||[HeaderName isEqualToString:@"Greeting"]||[HeaderName isEqualToString:@"Payment"]||[HeaderName isEqualToString:@"Add/Edit Venue"]) {
            feedbackViewBtn.hidden = YES;
            createPromotionViewBtn.hidden = YES;
        }
        
        if ([HeaderName isEqualToString:@"All booking"])
        {
            feedbackViewBtn.hidden = NO;
            createPromotionViewBtn.hidden = NO;
            [feedbackViewBtn setTitle: @"Greeting" forState: UIControlStateNormal];
            [createPromotionViewBtn setTitle:@"Marketing" forState:UIControlStateNormal];
            
            
        }
                mainMenuBtn.frame = CGRectMake(0, 0, 125, 95);
        [mainMenuBtn addTarget:self action:@selector(mainMenuBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [mainMenuBtn setBackgroundColor:[UIColor colorWithRed:23.0/255.0f green:32.0f/255.0f blue:57.0f/255.0f alpha:1]];
        [mainMenuBtn setTitle: @"Menu" forState: UIControlStateNormal];
        
        
        CGRect backLabelFrame;
        backLabelFrame = CGRectMake(0, 0,1024 ,95);
        UILabel*backLbl=[[UILabel alloc] initWithFrame:backLabelFrame];
        backLbl.backgroundColor = [UIColor whiteColor];
        backLbl.text=HeaderName;
        [backLbl setTextAlignment:NSTextAlignmentCenter];
        
        if ([HeaderName isEqualToString:@"Venue"])
        {
            addBookingBtn.hidden = YES;
            titleLbl.hidden = YES;
            feedbackViewBtn.hidden = YES;
            createPromotionViewBtn.hidden = YES;
            
        }

		//Add the calendar header to view
      //  [self addSubview:backLbl];
		[self addSubview: addBookingBtn];
        [self addSubview:mainMenuBtn];
        [self addSubview:searchBgImageView];
        [self addSubview:feedbackViewBtn];
        [self addSubview:createPromotionViewBtn];
        [searchBgImageView addSubview:searchTxt];
        [searchBgImageView addSubview:searchBtn];
       }
    return self;
}

-(void)mainMenuBtnPressed:(id)sender{
    if ([self.upparBardelegate respondsToSelector:@selector(mainMenuBtnPressed)]) {
        [self.upparBardelegate mainMenuBtnPressed];
    }
    NSLog(@"mainmenu preesed");
}
- (void)addBookingBtnPressed:(id)sender{
    
    if ([self.upparBardelegate respondsToSelector:@selector(addBookingBtnPressed)]) {
        [self.upparBardelegate addBookingBtnPressed];
    }
    NSLog(@"addBookingBtn preesed");
}
- (void)feedbackViewBtnPressed:(id)sender{
    
    if ([self.upparBardelegate respondsToSelector:@selector(feedbackViewBtnPressed)]) {
        [self.upparBardelegate feedbackViewBtnPressed];
    }
    NSLog(@"addBookingBtn preesed");
}
- (void)createPromotionViewBtnPressed:(id)sender{
    
    if ([self.upparBardelegate respondsToSelector:@selector(createPromotionViewBtnPressed)]) {
        [self.upparBardelegate createPromotionViewBtnPressed];
    }
    NSLog(@"addBookingBtn preesed");
}

@end
