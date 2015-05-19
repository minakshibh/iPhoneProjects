//
//  motivational.h
//  S.H.E.D
//
//  Created by Krishna_Mac on 11/29/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface motivational : NSObject
@property (nonatomic ,copy) NSString *motivation_id;
@property (nonatomic , copy) NSString *motivation;
@property (nonatomic , copy) NSString *author;

-(id) initWithMotivationID:(NSString *)motivation_id motivation:(NSString *)motivation author:(NSString *)author;
@end
