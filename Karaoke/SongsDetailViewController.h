//
//  SongsDetailViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvailableAlbums.h"
#import "AvailableSongs.h"
#import "FMDatabase.h"
#import "PayPalMobile.h"

@interface SongsDetailViewController : UIViewController<NSXMLParserDelegate,UIScrollViewDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPopoverControllerDelegate>
{
    AvailableSongs *availableSongsObj;
    NSString *user_UDID_Str ,*songCount;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    NSMutableArray *son;
    int webserviceCode;
    BOOL ispaidSongs;
    int creditsToSave, videoID;
}

@property (strong, nonatomic) IBOutlet UITableView *songsTableview;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *viewBgBlackImage;
@property (strong, nonatomic) IBOutlet UIButton *buyNowBtnOutlet;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtnOutlet;

@property (strong, nonatomic) IBOutlet UILabel *songHeaderLbl;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet NSString *user_UDID_Str;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
@property (strong, nonatomic) IBOutlet UILabel *videoNmaeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *albumNameLbl;
@property (strong, nonatomic) IBOutlet UIView *proView;
@property (strong, nonatomic) IBOutlet UILabel *artistNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *priceLbl;
@property (nonatomic, retain) IBOutlet AvailableSongs *songsOBJ;
@property (nonatomic, retain) IBOutlet AvailableAlbums *albumsOBJ;
@property (assign ,nonatomic) BOOL isVideos;
@property (assign ,nonatomic) BOOL isAlbum;
- (IBAction)backBtn:(id)sender;
- (IBAction)buyNowBtn:(id)sender;
- (IBAction)downloadBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *disableImg;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *progressPercentlbl;
@property (strong, nonatomic) IBOutlet UILabel *progressLbl;
@property (nonatomic, strong) NSMutableArray *songsArray;


- (IBAction)playSampleVideoBtn:(id)sender;


// PayPAL
@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property (strong, nonatomic) IBOutlet UIImageView *sampleVideoButtonImage;


@end
