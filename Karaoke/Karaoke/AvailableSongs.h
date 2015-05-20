//
//  AvailableSongs.h
//  Karaoke
//
//  Created by Krishna_Mac_2 on 23/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvailableSongs : NSObject
@property (nonatomic, copy) NSString *VideoUrl;
@property (nonatomic, copy) NSString *VideoName;
@property (nonatomic, copy) NSString *ThumbnailUrl;
@property (nonatomic, copy) NSString *songImage;

@property (nonatomic, copy) NSString *VideoPrice;
@property (nonatomic, copy) NSString *ArtistName;
@property (nonatomic, copy) NSString *AlbumName;
@property (nonatomic, copy) NSString *Songs;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic, copy) NSString *IsActive;
@property (nonatomic, copy) NSString *UploadDate;
@property (nonatomic, copy) NSString *samplevideoUrl;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *trackcode;
@property (nonatomic,copy) NSString *itemStatus;
@property (nonatomic,copy) NSString *transactionDate;
@property (nonatomic,copy) NSString *email;
@property (nonatomic, assign) int VideoId;
@property (nonatomic, assign) int row;

@end
