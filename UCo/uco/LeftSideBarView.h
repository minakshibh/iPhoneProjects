//
//  DDCalendarView.h
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftSideBarViewDelegate <NSObject>

@optional
- (void)dashboardButtonPressed;
- (void)allBookingButtonPressed;
- (void)manageRestaurantButtonPressed;
- (void)greetingButtonPressed;
- (void)markettingButtonPressed;
- (void)reportingButtonPressed;
- (void)paymentButtonPressed;
- (void)settingButtonPressed;
- (void)tableViewButtonPressed;
- (void)calendarButtonPressed;
@end

@interface LeftSideBarView : UIView  {
    id <LeftSideBarViewDelegate> delegate;

    float calendarWidth;
	float calendarHeight;
	float buttonWidth;
	float buttonHeight;
    float buttonYaxis;
}

@property(nonatomic, assign) id <LeftSideBarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame fontName:(NSString *)fontName delegate:(id)theDelegate;
- (void)prevBtnPressed:(id)sender;
- (void)nextBtnPressed:(id)sender;
- (void)dashboardButtonPressed:(id)sender;
- (void)allBookingButtonPressed:(id)sender;
- (void)manageRestaurantButtonPressed:(id)sender;
- (void)greetingButtonPressed:(id)sender;
- (void)markettingButtonPressed:(id)sender;
- (void)reportingButtonPressed:(id)sender;
- (void)paymentButtonPressed:(id)sender;
- (void)settingButtonPressed:(id)sender;
- (void)tableViewButtonPressed:(id)sender;
- (void)calendarButtonPressed:(id)sender;
@end




