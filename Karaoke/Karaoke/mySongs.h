//
//  mySongs.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 29/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mySongs : NSObject
@property (nonatomic, copy) NSString *serverUrl;
@property (nonatomic, copy) NSString *VideoName;
@property (nonatomic, copy) NSString *ThumbnailUrl;
@property (nonatomic, copy) NSString *ArtistName;
@property (nonatomic, copy) NSString *AlbumName;
@property (nonatomic, copy) NSString *Songs;
@property (nonatomic, copy) NSString *LocalUrl;
@property (nonatomic, copy) NSString *songBuydate;
@property (nonatomic, copy) NSString *albumBuydate;
@property (nonatomic, copy) NSString *songImage;
@property (nonatomic, copy) NSString *albumImage;
@property (nonatomic, copy) NSString *songTrackCode;
@property (nonatomic, copy) NSString *songDuration;
@property (nonatomic, copy) NSString *playlistName;
@property (nonatomic, copy) NSString *albumCode;
@property (nonatomic, assign) int VideoId;
@property (nonatomic, assign) int AlbumId;


@end
