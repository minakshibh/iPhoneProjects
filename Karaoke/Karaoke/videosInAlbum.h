//
//  videosInAlbum.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 15/04/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface videosInAlbum : NSObject

@property (nonatomic, assign) int videoId;
@property (nonatomic, copy) NSString *TrackCode;
@property (nonatomic, copy) NSString *VideoUrl;
@property (nonatomic, copy) NSString *SampleVideoUrl;
@property (nonatomic, copy) NSString *VideoName;
@property (nonatomic, copy) NSString *videoThumbnailUrl;
@property (nonatomic, copy) NSString *videoArtistName;
@property (nonatomic, copy) NSString *Duration;


@end
