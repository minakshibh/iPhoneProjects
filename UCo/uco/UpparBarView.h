//
//  DDCalendarView.h
//  DDCalendarView
//
//  Created by Damian Dawber on 28/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UpparBarViewDelegate <NSObject>

@optional
- (void)addBookingBtnPressed;
- (void)mainMenuBtnPressed;
- (void)calenderViewBtnPressed;
- (void)feedbackViewBtnPressed;
- (void)createPromotionViewBtnPressed;
@end

@interface UpparBarView : UIView  {
    id <UpparBarViewDelegate> upparBardelegate;

    float calendarWidth;
	float calendarHeight;
	float buttonWidth;
	float buttonHeight;
    float buttonYaxis;
}

@property(nonatomic, assign) id <UpparBarViewDelegate> upparBardelegate;

- (id)initWithFrame:(CGRect)frame HeaderName:(NSString *)HeaderName delegate:(id)theDelegate;

- (void)addBookingBtnPressed:(id)sender;
- (void)mainMenuBtnPressed:(id)sender;
- (void)calenderViewBtnPressed:(id)sender;
- (void)feedbackViewBtnPressed:(id)sender;
- (void)createPromotionViewBtnPressed:(id)sender;
@end




