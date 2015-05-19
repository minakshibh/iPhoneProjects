//
//  SHED.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/5/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHED : NSObject
{
    NSString *shed_id;
    NSString *name;
    NSString *description;
    NSString *start_date;
    NSString *followed_date;
    NSString *masteredDate;
    NSString *alarm_time;
    NSString *alarm_status;
    NSString *alarm_days;
    NSString *isMastered;
    NSString *type;
    NSString *rewardImage;
    NSString *rewardDetail;
    NSString *rewardStreak;
    int rewardStatus;
    
    int current_run;
    int longest_run;
    NSArray *datesarray;
    int applieddays;
    int totaldays;
    float percentage;
    bool isBeingFollowedToday;
}
@property (nonatomic , copy) NSString *shed_id;
@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *description;
@property (nonatomic , copy) NSString *start_date;
@property (nonatomic , copy) NSString *followed_date;
@property (nonatomic , copy) NSString *masteredDate;
@property (nonatomic , copy) NSString *alarm_time;
@property (nonatomic , copy) NSString *alarm_status;
@property (nonatomic , copy) NSString *alarm_days;
@property (nonatomic , copy) NSString *isMastered;
@property (nonatomic , copy) NSString *type;
@property (nonatomic , assign) int  current_run;
@property (nonatomic , assign) int  longest_run;
@property (nonatomic , assign) NSArray *datesArray;
@property (nonatomic , assign) int applieddays;
@property (nonatomic , assign) int  totaldays;
@property (nonatomic , assign) float percentage;
@property (nonatomic , assign) bool  isBeingFollowedToday;

@property (nonatomic , copy) NSString *rewardImage;
@property (nonatomic , copy) NSString *rewardDetail;
@property (nonatomic , copy) NSString *rewardStreak;
@property (nonatomic , assign) int rewardStatus;

//-(id) initWithUniqueId:(NSString *)SHED_ID name:(NSString *)SHED_Name description:(NSString *)SHED_description time:(NSString*)SHED_time date:(NSString*)SHED_Date status:(NSString *)SHED_timestatus;

@end
