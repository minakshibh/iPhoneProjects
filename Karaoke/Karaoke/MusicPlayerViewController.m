//
//  MusicPlayerViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "MySongsViewController.h"
#import "AlbumSongsViewController.h"
#import "AvailableSongsViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface MusicPlayerViewController ()

@end

@implementation MusicPlayerViewController
@synthesize backwrdbtnoutlet,forwrdBtnOutlt,pauseBtnoutlet,reloadBtnOutlet,isAlbumSongs,isDownlodedSong,isAlbumTab,songsList,moviePlayer,totalTime,colapsedTime,landscapeView,portraitView,appBackgroundImg,playerBackgroundView,headerImg,backBtnView,titleLabel,playerControlView,myTimer,sampleVideoUrl,songNmaelbl,SongNameStr,index,counter,songsNameList,playerComtrollerView,controllerBgImg,playerControl;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    songNmaelbl.text=[NSString stringWithFormat:@"%@",SongNameStr];
    ;    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    [[controllerBgImg layer] setBorderColor:[[UIColor clearColor] CGColor]];
    [[controllerBgImg layer] setBorderWidth:1.0];
    [[controllerBgImg layer] setCornerRadius:5];
    
    [[playerComtrollerView layer] setBorderColor:[[UIColor clearColor] CGColor]];
    [[playerComtrollerView layer] setBorderWidth:1.0];
    [[playerComtrollerView layer] setCornerRadius:5];
    NSLog(@"Songs Obj is %@",songsNameList);
    [super viewDidLoad];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
   

    NSLog(@"SONGSLIST %lu",(unsigned long)songsList.count);
    NSLog(@"Int i is %d", index);
    
    if (sampleVideoUrl == nil) 
        sampleVideoUrl = @"";
   
    
    if (! [sampleVideoUrl isEqualToString:@""])
     {
         url=[NSURL URLWithString:sampleVideoUrl];
         
    }
    else if( songsList.count !=0)
    {
        NSString *str=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[songsList objectAtIndex:counter]]];
        NSString *playingVideo =str;
        NSString *playingSongName = [NSString stringWithFormat:@"%@",[songsNameList objectAtIndex:counter]];
        songNmaelbl.text = [NSString stringWithString:playingSongName];
       
    //    playingVideo=  [playingVideo stringByReplacingOccurrencesOfString:@" " withString:@""];
         url=[NSURL fileURLWithPath:playingVideo];
    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Karaoke" message:[NSString stringWithFormat:@"%@",url] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
    [self.playerControl removeFromSuperview];
    [self.playerBackgroundView removeFromSuperview];
    [self.moviePlayer.view removeFromSuperview];
    [slideVideo removeFromSuperview];
    
    
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    duration = sourceAsset.duration;
    moviePlayer.controlStyle = MPMovieControlStyleNone;
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"Device is in Portrait Mode");
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            playerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 149, 300, 280)];
            [moviePlayer.view setFrame:CGRectMake(20, 160, 280, 260)];
            slideVideo = [[UISlider alloc] initWithFrame:CGRectMake(45, 62, 220, 30)];
            playerControl = [[UIView alloc] initWithFrame:CGRectMake(6, 470, 308, 91)];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            playerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 132, 300, 240)];
            [moviePlayer.view setFrame:CGRectMake(20, 137, 280, 230)];
            slideVideo = [[UISlider alloc] initWithFrame:CGRectMake(45, 61, 220, 30)];
            playerControl = [[UIView alloc] initWithFrame:CGRectMake(6, 380, 308, 90)];
            // this is iphone 4 xib
        }
        else{
            playerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 295, 748, 540)];
            [moviePlayer.view setFrame:CGRectMake(35, 310, 698, 500)];
            slideVideo = [[UISlider alloc] initWithFrame:CGRectMake(110, 107, 520, 30)];
            playerControl = [[UIView alloc] initWithFrame:CGRectMake(10, 840, 600, 160)];
        }
     
    }
    else {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            playerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 28, 548, 280)];
            [moviePlayer.view setFrame:CGRectMake(20, 38, 528, 265)];
            slideVideo = [[UISlider alloc] initWithFrame:CGRectMake(45, 62, 220, 30)];
            playerControl = [[UIView alloc] initWithFrame:CGRectMake(130, 225, 308, 91)];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            
            playerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 450, 280)];
            [moviePlayer.view setFrame:CGRectMake(20, 42,440, 260)];
            slideVideo = [[UISlider alloc] initWithFrame:CGRectMake(45, 62, 220, 30)];
            playerControl = [[UIView alloc] initWithFrame:CGRectMake(130, 225, 308, 91)];
            // this is iphone 4 xib
        }
        else{
            playerBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 984, 668)];
            [moviePlayer.view setFrame:CGRectMake(35, 70,944, 628)];
            slideVideo = [[UISlider alloc] initWithFrame:CGRectMake(85, 112, 550, 30)];
            playerControl = [[UIView alloc] initWithFrame:CGRectMake(132, 580, 760, 150)];
        }
        
        headerImg.hidden = YES;
        backBtnView.hidden = YES;
        titleLabel.hidden = YES;
        NSLog(@"Device is in Landscape Mode");
    }
    playerBackgroundView.image = [UIImage imageNamed:@"player_bg.png"];
    [self.view addSubview:playerBackgroundView];
    
    [self.view addSubview:moviePlayer.view];
    [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
    [moviePlayer play];
    
    
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    dateFormat.dateFormat = @"HH:mm:ss";
    dateFormat.dateFormat = @"mm:ss";
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"%f",(CMTimeGetSeconds(duration)));
    double time = CMTimeGetSeconds(duration)/60;
    NSNumber *theDouble = [NSNumber numberWithDouble:time];
    double num = [theDouble doubleValue];
    int intpart = (int)num;
    double decpart = num - intpart;
    NSLog(@"%f",decpart*60);
    NSString *seconds=[NSString stringWithFormat:@"%f",decpart *60];
    NSLog(@"Num = %f, intpart = %d, decpart = %.02f\n", num, intpart, decpart);
    timeString=[NSString stringWithString:[NSString stringWithFormat:@"%.02d:%.02d",intpart,[seconds intValue]]];
    NSLog(@"%@",timeString);
    totalTime.text = timeString;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHide:)];
    
    
    tap.delegate=self;
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    self.moviePlayer.view.userInteractionEnabled = YES;
    [self.moviePlayer.view addGestureRecognizer:tap];

    
    playerControl.hidden = YES;
    [playerControl setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:playerControl];
    
    
    
    UIImageView * playerControlImg;
    UIView * controls ;
    UIImageView * playerControlOption;
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        
        playerControlImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 308, 91)];
        controls = [[UIView alloc] initWithFrame:CGRectMake(4, 3, 300, 53)];
        playerControlOption = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 52)];
        backwrdbtnoutlet = [[UIButton alloc] initWithFrame:CGRectMake(16, 4, 46, 39)];
        pauseBtnoutlet = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 51, 39)];
        reloadBtnOutlet = [[UIButton alloc] initWithFrame:CGRectMake(156, 0, 62, 49)];
        forwrdBtnOutlt = [[UIButton alloc] initWithFrame:CGRectMake(242, 5, 46, 39)];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        
        playerControlImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 308, 91)];
        controls = [[UIView alloc] initWithFrame:CGRectMake(4, 3, 300, 53)];
        playerControlOption = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 52)];
        backwrdbtnoutlet = [[UIButton alloc] initWithFrame:CGRectMake(16, 4, 46, 39)];
        pauseBtnoutlet = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 51, 39)];
        reloadBtnOutlet = [[UIButton alloc] initWithFrame:CGRectMake(156, 0, 62, 49)];
        forwrdBtnOutlt = [[UIButton alloc] initWithFrame:CGRectMake(242, 5, 46, 39)];
    
    }
    else{
        playerControlImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 740, 150)];
        controls = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 728, 126)];
        playerControlOption = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 728, 100)];
        backwrdbtnoutlet = [[UIButton alloc] initWithFrame:CGRectMake(35, 4, 107, 84)];
        pauseBtnoutlet = [[UIButton alloc] initWithFrame:CGRectMake(215, 4, 107, 84)];
        reloadBtnOutlet = [[UIButton alloc] initWithFrame:CGRectMake(395, 4, 107, 84)];
        forwrdBtnOutlt = [[UIButton alloc] initWithFrame:CGRectMake(575, 4, 107, 84)];
    }
    

    
    [playerControlImg setImage:[UIImage imageNamed:@"disable480.png"]];
    [playerControl addSubview:playerControlImg];
    
  
    controls.hidden = NO;
    [controls setBackgroundColor:[UIColor clearColor]];
    [playerControl addSubview:controls];
    
    [playerControlOption setImage:[UIImage imageNamed:@"player_options.png"]];
    [controls addSubview:playerControlOption];
    
    [backwrdbtnoutlet setBackgroundImage:[UIImage imageNamed:@"back_icon.png"]  forState:UIControlStateNormal];
    [backwrdbtnoutlet addTarget:self action:@selector(startBackwardSeeking:) forControlEvents:UIControlEventTouchDown];
    [backwrdbtnoutlet addTarget:self action:@selector(stopBackwardSeeking:) forControlEvents:UIControlEventTouchUpInside];
     [controls addSubview:backwrdbtnoutlet];
    
   
    [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"pause_icon.png"]  forState:UIControlStateNormal];
    [pauseBtnoutlet addTarget:self action:@selector(pauseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [controls addSubview:pauseBtnoutlet];
    
    [reloadBtnOutlet setBackgroundImage:[UIImage imageNamed:@"reload_icon.png"]  forState:UIControlStateNormal];
    [reloadBtnOutlet addTarget:self action:@selector(reloadbtn:) forControlEvents:UIControlEventTouchUpInside];
    [controls addSubview:reloadBtnOutlet];
    
    [forwrdBtnOutlt setBackgroundImage:[UIImage imageNamed:@"forward_icon.png"]  forState:UIControlStateNormal];
    [forwrdBtnOutlt addTarget:self action:@selector(startForwardSeeking:) forControlEvents:UIControlEventTouchDown];
    [forwrdBtnOutlt addTarget:self action:@selector(stopForwardSeeking:) forControlEvents:UIControlEventTouchUpInside];
    [controls addSubview:forwrdBtnOutlt];
    
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        totalTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 69, 95, 17)];
        colapsedTime = [[UILabel alloc] initWithFrame:CGRectMake(4, 69, 95, 17)];
        totalTime.font=[totalTime.font fontWithSize:14];
        colapsedTime.font=[colapsedTime.font fontWithSize:14];

    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        totalTime = [[UILabel alloc] initWithFrame:CGRectMake(210, 69, 95, 17)];
        colapsedTime = [[UILabel alloc] initWithFrame:CGRectMake(4, 69, 95, 17)];
          totalTime.font=[totalTime.font fontWithSize:14];
        colapsedTime.font=[colapsedTime.font fontWithSize:14];

        
    }
    else{
        totalTime = [[UILabel alloc] initWithFrame:CGRectMake(520, 105, 200, 40)];
        colapsedTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 105,200, 40)];
        totalTime.font=[totalTime.font fontWithSize:24];
        colapsedTime.font=[colapsedTime.font fontWithSize:24];

    }
    [totalTime setTextAlignment:NSTextAlignmentRight];
    totalTime.text = timeString;
  
    totalTime.textColor = [UIColor whiteColor];
    [playerControl addSubview:totalTime];
    
    [colapsedTime setTextAlignment:NSTextAlignmentLeft];
    colapsedTime.textColor = [UIColor whiteColor];
    [playerControl addSubview:colapsedTime];
    
    [slideVideo addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
    [slideVideo setBackgroundColor:[UIColor clearColor]];
    slideVideo.continuous =YES;
    slideVideo.value =[moviePlayer currentPlaybackTime];
    slideVideo.minimumValue = 0.0;
    slideVideo.maximumValue = CMTimeGetSeconds(duration);
    [playerControl addSubview:slideVideo];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nexttapDetected:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [forwrdBtnOutlt addGestureRecognizer:tapGesture];
    
    previoustapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previoustapDetected:)];
    previoustapGesture.numberOfTapsRequired = 1;
    previoustapGesture.numberOfTouchesRequired = 1;
    [backwrdbtnoutlet addGestureRecognizer:previoustapGesture];
    
    if (isRepeat) {
        [reloadBtnOutlet setBackgroundImage:[UIImage imageNamed:@"reload_icon_h.png"] forState:UIControlStateNormal];
        
    }else {
        [reloadBtnOutlet setBackgroundImage:[UIImage imageNamed:@"reload_icon.png"] forState:UIControlStateNormal];
    }
}
- (void)showHide:(id)sender
{
    NSLog(@"Tap Detected");
    if (playerControl.hidden == YES) {
    playerControl.hidden = NO;
    }
    else{
        playerControl.hidden = YES;
    }
}
- (void)addMusicPlyer
{
    
}
- (void)updateSlider {
    
    // Update the slider about the music time
    if ([colapsedTime.text isEqualToString:[NSString stringWithFormat:@"%f",CMTimeGetSeconds(duration)/60]]) {
        [myTimer invalidate];
    }else{
    slideVideo.value = [moviePlayer currentPlaybackTime];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    dateFormat.dateFormat = @"HH:mm:ss";
        dateFormat.dateFormat = @"mm:ss";
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    
    double time = [moviePlayer currentPlaybackTime];
        NSNumber *theDouble = [NSNumber numberWithDouble:time];
        
        int inputSeconds = [theDouble intValue];
        int hours =  inputSeconds / 3600;
        int minutes = ( inputSeconds - hours * 3600 ) / 60;
        int seconds = inputSeconds - hours * 3600 - minutes * 60;
        
        NSString *theTime = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
//        NSLog(@"Times in seconds %@",theTime);
        if ([theTime isEqualToString:@"nan"] || ([theTime isEqualToString:@"00:29"] && [timeString isEqualToString:@"00:30"])) {
            colapsedTime.text = [NSString stringWithFormat:@"00:00"];
            [moviePlayer stop];
            [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"play_song_icon.png"] forState:UIControlStateNormal];
            [slideVideo setValue:0.0 animated:YES];
        }else{
            colapsedTime.text = theTime;
            if ([[pauseBtnoutlet backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"play_song_icon.png"]]) {
                [moviePlayer pause];
            }
        }
    }
}
- (void) sliderAction
{
    if(slideVideo.value == 0 || slideVideo.value == slideVideo.maximumValue ){
        colapsedTime.text = @"00:00";
    }
       
    [self.moviePlayer setCurrentPlaybackTime:(slideVideo.value)];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startForwardSeeking:(id)sender {
    [moviePlayer beginSeekingForward];
}

- (IBAction)stopForwardSeeking:(id)sender {
    [moviePlayer endSeeking];
}

- (IBAction)startBackwardSeeking:(id)sender {
    [moviePlayer beginSeekingBackward];
}

- (IBAction)stopBackwardSeeking:(id)sender {
    [moviePlayer endSeeking];
}



- (IBAction)pauseBtn:(id)sender {
    NSLog(@"NAme of Background Image .. %@",pauseBtnoutlet.currentImage);
    NSData *img1Data = UIImageJPEGRepresentation(pauseBtnoutlet.currentBackgroundImage, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"play_song_icon.png"], 1.0);
    NSData *img3Data = UIImageJPEGRepresentation([UIImage imageNamed:@"pause_icon.png"], 1.0);
   
    if ([img1Data isEqualToData:img2Data]) {
        NSLog(@"Length of the video is ::: %f",CMTimeGetSeconds(duration));
        [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
        if(moviePlayer.playbackState == MPMoviePlaybackStateStopped){
            [self viewDidLoad];
        }else{
            [moviePlayer play];
           
        }
    }else if ([img1Data isEqualToData:img3Data]){
        [moviePlayer pause];
        [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"play_song_icon.png"] forState:UIControlStateNormal];
    }

    
}

- (IBAction)reloadbtn:(id)sender {
//    NSData *img1Data = UIImageJPEGRepresentation(pauseBtnoutlet.currentBackgroundImage, 0.5);
//    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"reload_icon.png"], 0.5);
//    NSData *img3Data = UIImageJPEGRepresentation([UIImage imageNamed:@"reload_icon_h.png"], 0.5);
//    NSLog(@"Data 1 %@",img1Data);
//    NSLog(@"Data 2 %@", img2Data);
//    NSLog(@"Data 3 %@",img3Data);
    if ([[reloadBtnOutlet backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"reload_icon.png"]]) {
        [reloadBtnOutlet setBackgroundImage:[UIImage imageNamed:@"reload_icon_h.png"] forState:UIControlStateNormal];
        isRepeat = YES;
        
    }else{
        [reloadBtnOutlet setBackgroundImage:[UIImage imageNamed:@"reload_icon.png"] forState:UIControlStateNormal];
        isRepeat = NO;
    }
}


- (IBAction)backBtn:(id)sender {
    sampleVideoUrl=@"";
    [self.myTimer invalidate];
    [myTimer fire];
    [moviePlayer stop];
    
    moviePlayer =nil;
      NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (isAlbumSongs)
    {
            AlbumSongsViewController *albumSongsvc = [self.navigationController.viewControllers objectAtIndex:index-1];
            [self.navigationController popToViewController:albumSongsvc animated:YES];
       
    }
    else{
        if (isDownlodedSong)
        {
            AvailableSongsViewController *availSongsVc;
            
            
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                availSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController" bundle:nil];
                
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480){
                availSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
            }
            else{
                availSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_ipad" bundle:nil];
            }

            
            
            if (isAlbumTab) {
                  availSongsVc.triggerValue=@"albums";
            }
            else{
                availSongsVc.triggerValue=@"videos";

            }
            [self.navigationController pushViewController:availSongsVc animated:NO];
  
        }
        else{
            MySongsViewController *mySongsvc = [self.navigationController.viewControllers objectAtIndex:index-1];
            [self.navigationController popToViewController:mySongsvc animated:YES];
        }
   
    }
}


- (void) handleLongPressForward : (id)sender
{
    NSLog(@"Button is pressed long");
    [moviePlayer endSeeking];
   
    [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"play_song_icon.png"] forState:UIControlStateNormal];
    [moviePlayer beginSeekingForward];
}

- (void) nexttapDetected : (int) flag
{
    
     if (flag == 1) {
             if(counter<[songsList count]-1)
                 counter++;
             else
                 counter = 0;
         
             if(counter!=index || [[reloadBtnOutlet backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"reload_icon_h.png"]]){
                 [self viewDidLoad];

             }else{
                 
                 counter--;
                 if(counter<0)
                     counter = 0;
                 
                 index = counter;
             }

//        if (index == [songsList count]-1) {
//            index = 0;
//            [self viewDidLoad];
//            [moviePlayer play];
//            [pauseBtnoutlet setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
//
//        }
//        else if(index != counter )
//        {
//            if (reloadBtnOutlet.currentImage == [UIImage imageNamed:@"reload_icon_h.png"]) {
//                if (index == [songsList count]-1) {
//                    index = 0;
//                }else{
//                    index = index+1;
//                }
//                [self viewDidLoad];
//                [moviePlayer play];
//                [pauseBtnoutlet setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
//                
//            }else{
//            [moviePlayer stop];
//            [myTimer invalidate];
//            }
//            
//        }else{
//            index = index+1;
//            [self viewDidLoad];
//            [moviePlayer play];
//            [pauseBtnoutlet setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
//            
//        }
    }else{
        if(counter<[songsList count]-1)
            counter++;
        else
            counter = 0;
        
        [self viewDidLoad];
//        [moviePlayer play];
//        [pauseBtnoutlet setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
    }
}
- (void) handleLongPressBackward : (id)sender
{
    NSLog(@"Button is pressed long");
    [moviePlayer endSeeking];
    
    [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"play_song_icon.png"] forState:UIControlStateNormal];
    [moviePlayer beginSeekingBackward];
    
}

- (void) previoustapDetected : (id) sender
{
    NSLog(@"Time Duration%f",[moviePlayer currentPlaybackTime]);
    if(!([moviePlayer currentPlaybackTime] > 5)){
        
        if(index == 0){
            index = 0;
        }else{
            index= index-1;
        }
    }
    
    [self viewDidLoad];
    [moviePlayer play];
    [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
    
}

- (void) playbackFinished:(id) sender
{
    
    [pauseBtnoutlet setBackgroundImage:[UIImage imageNamed:@"play_song_icon.png"] forState:UIControlStateNormal];
    NSLog(@"Duration %f",CMTimeGetSeconds(duration));
//    if (CMTimeGetSeconds(duration) != 0) {
//        if (! [sampleVideoUrl isEqualToString:@""]){
//            [moviePlayer stop];
//        }else{
//            [self nexttapDetected:sender];
//        }
//
//    }else{
//        [self.myTimer invalidate];
//        [moviePlayer stop];
//        
//    }
    if (! [sampleVideoUrl isEqualToString:@""])
    {
        [moviePlayer stop];
        
    }else{
    [self nexttapDetected:1];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {

        NSLog(@"Height %f",[[UIScreen mainScreen] bounds].size.width);
        if ([[UIScreen mainScreen] bounds].size.width == 568) {
            [moviePlayer.view setFrame:CGRectMake(20, 38, 528, 265)];
            [slideVideo setFrame:CGRectMake(45, 62, 220, 30)];
            [playerBackgroundView setFrame:CGRectMake(15, 35, 538, 280)];
            [playerControl setFrame: CGRectMake(130, 225, 308, 91)];
        }
        else if([[UIScreen mainScreen] bounds].size.width == 480){
            [moviePlayer.view setFrame:CGRectMake(20, 42, 440, 260)];
            [slideVideo setFrame:CGRectMake(45, 62, 220, 30)];
            [playerBackgroundView setFrame:CGRectMake(15, 35, 450, 280)];
            [playerControl setFrame: CGRectMake(75, 225, 308, 91)];
        }
        else{
            
            
            [playerBackgroundView setFrame:CGRectMake(20, 60, 984, 668)];
            [moviePlayer.view setFrame:CGRectMake(35, 70,944, 628)];
            [slideVideo setFrame:CGRectMake(85, 112, 550, 30)];
            [playerControl setFrame: CGRectMake(132, 580, 760, 150)];
        }

        headerImg.hidden = YES;
        backBtnView.hidden = YES;
        titleLabel.hidden = YES;
        NSLog(@"Landscape");
        
    } else {
        
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [moviePlayer.view setFrame:CGRectMake(20, 160, 280, 260)];
            [slideVideo setFrame:CGRectMake(45, 62, 220, 30)];
            [playerBackgroundView setFrame:CGRectMake(10, 149, 300, 280)];
            [playerControl setFrame:CGRectMake(6, 470, 308, 91)];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            
            [moviePlayer.view setFrame:CGRectMake(20, 137, 280, 230)];
            [playerBackgroundView setFrame:CGRectMake(10, 132, 300, 240)];
            [slideVideo setFrame:CGRectMake(45, 61, 220, 30)];
            [playerControl setFrame:CGRectMake(6, 380, 308, 90)];
        }
        else{
            
            
            [moviePlayer.view setFrame:CGRectMake(35, 310, 698, 500)];
            [slideVideo setFrame:CGRectMake(110, 107, 520, 30)];
            [playerBackgroundView setFrame:CGRectMake(10, 295, 748, 530)];
            [playerControl setFrame:CGRectMake(10, 840, 600, 160)];
        }

        
     
      
        headerImg.hidden = NO;
        backBtnView.hidden = NO;
        titleLabel.hidden = NO;
        NSLog(@"Portrait");
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"orientation changed");
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//- (NSUInteger)supportedInterfaceOrientations {
//    return ( UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationPortrait);
//}
@end
