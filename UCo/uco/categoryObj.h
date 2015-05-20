//
//  categoryObj.h
//  uco
//
//  Created by Krishna_Mac_1 on 4/9/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface categoryObj : NSObject
@property (strong , nonatomic) NSString *ClientId,*Created,*Desc,*GroupId,*categoryID,*Name,*SearchText,*Status,*Type,*Updated;
@property (strong, nonatomic) NSArray *listClientListDataItemsDTO;
@end
