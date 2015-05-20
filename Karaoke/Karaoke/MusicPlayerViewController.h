//
//  MusicPlayerViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

#import "mySongs.h"

@interface MusicPlayerViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer *forwardlongPress,* backwardwardlongPress ;
    UITapGestureRecognizer *tapGesture, *previoustapGesture;
    UISlider *slideVideo;
    CMTime duration;
    NSURL *url;
    BOOL canRotateToAllOrientations;
    NSString* timeString;
    BOOL isRepeat;
}



- (IBAction)pauseBtn:(id)sender;
- (IBAction)reloadbtn:(id)sender;
- (IBAction)backBtn:(id)sender;


@property (strong, nonatomic) IBOutlet NSString *SongNameStr;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic)  UIButton *backwrdbtnoutlet;
@property (strong, nonatomic)  UIButton *pauseBtnoutlet;
@property (strong, nonatomic)  UIButton *reloadBtnOutlet;
@property (strong, nonatomic)  UIButton *forwrdBtnOutlt;
@property (assign, nonatomic) BOOL isAlbumSongs;
@property (assign, nonatomic) BOOL isDownlodedSong;
@property (assign, nonatomic) BOOL isAlbumTab;
@property (strong, nonatomic) NSArray * songsList, *songsNameList;
@property (strong, nonatomic) IBOutlet UILabel *totalTime;
@property (strong, nonatomic) IBOutlet UILabel *colapsedTime;
@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (strong, nonatomic) IBOutlet UIView *landscapeView;
@property (strong, nonatomic) UIView * playerControl;
@property (strong, nonatomic) IBOutlet UIImageView *appBackgroundImg;
@property (strong, nonatomic) UIImageView *playerBackgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtnView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *playerControlImg;
@property (strong, nonatomic) IBOutlet UIView *playerControlView;
@property (strong, nonatomic)  NSTimer * myTimer ;
@property (strong, nonatomic) IBOutlet UILabel *songNmaelbl;
@property (strong, nonatomic) NSString *sampleVideoUrl;
@property (nonatomic , assign) int index, counter;
@property (strong, nonatomic) IBOutlet UIView *playerComtrollerView;
@property (strong, nonatomic) IBOutlet UIImageView *controllerBgImg;

@end
