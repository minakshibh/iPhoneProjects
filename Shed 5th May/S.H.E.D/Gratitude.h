//
//  gratitude.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/23/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gratitude : NSObject
{
    
    NSString *gratitude;
    int grat_id;
    NSString *gratitudedate;
}

@property (nonatomic , copy) NSString *gratitude;
@property (nonatomic , assign) int  grat_id;
@property (nonatomic , copy) NSString *gratitudedate;
@end
