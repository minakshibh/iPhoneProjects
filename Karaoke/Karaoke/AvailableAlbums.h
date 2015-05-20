//
//  AvailableAlbums.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 25/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvailableAlbums : NSObject

@property (nonatomic, assign) int AlbumId;

@property (nonatomic, copy) NSString *AlbumCode;
@property (nonatomic, copy) NSString *AlbumUrl;
@property (nonatomic, copy) NSString *AlbumPrice;
@property (nonatomic, copy) NSString *ArtistName;
@property (nonatomic, copy) NSString *AlbumName;
@property (nonatomic, copy) NSString *Songs;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *albumUploadDate;
@property (nonatomic, copy) NSString *albumImage;
@property (nonatomic, copy) NSString *ThumbnailUrl;
@property (nonatomic, copy) NSArray *videoAlbumArray;;
@property (nonatomic, copy) NSString *itemStatus;

//video in Album
@property (nonatomic, assign) int videoId;
@property (nonatomic, copy) NSString *TrackCode;
@property (nonatomic, copy) NSString *VideoUrl;
@property (nonatomic, copy) NSString *SampleVideoUrl;
@property (nonatomic, copy) NSString *VideoName;
@property (nonatomic, copy) NSString *videoThumbnailUrl;
@property (nonatomic, copy) NSString *videoArtistName;
@property (nonatomic, copy) NSString *Duration;


@end
