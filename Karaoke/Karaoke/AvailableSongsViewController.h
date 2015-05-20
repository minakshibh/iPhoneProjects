//
//  AvailableSongsViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 20/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvailableSongs.h"
#import "AvailableAlbums.h"
#import "videosInAlbum.h"
#import "FMDatabase.h"
#import "ZipArchive.h"
#import "PayPalMobile.h"



@interface AvailableSongsViewController : UIViewController<NSXMLParserDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPopoverControllerDelegate>
{

    
    AvailableSongs *availableSongsObj;
    AvailableAlbums *availbleAlbumObj;
    videosInAlbum *videosInAlbumObj;
    BOOL isAlbumsTab;
    BOOL isSongsTab;
    NSMutableString *tempString;
    NSMutableArray *songsList;
    NSMutableArray *albumList,*songNameInAlbum, *trackCodeArray,* videoPassingArray;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath, *songsStatus, *albumStatus;
    FMDatabase *database;
    NSString *user_UDID_Str;
    NSString *triggerValue,*BuyDate;
     int webserviceCode;
    int paging;
    BOOL condition;
    NSString *songCount;
    BOOL isDownloading;
    int creditsToSave, videoID;
}
- (IBAction)freeSongsbtn:(id)sender;
- (IBAction)topSellersBtn:(id)sender;

- (IBAction)backBtn:(id)sender;
- (IBAction)mySongs:(id)sender;
- (IBAction)songsTabBtn:(id)sender;
- (IBAction)albumsTabBtn:(id)sender;
- (IBAction)logoutBtn:(id)sender;
- (IBAction)requestSongBtn:(id)sender;


@property (strong, nonatomic) IBOutlet NSString *triggerValue;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) IBOutlet UILabel *dataRecievedLbl;
@property (strong, nonatomic) IBOutlet NSString *user_UDID_Str;
@property (strong, nonatomic) IBOutlet UIButton *songstabOutlet;
@property (strong, nonatomic) IBOutlet UITableView *songTableView;
@property (strong, nonatomic) IBOutlet UIButton *albumsTabOutlet;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (assign, nonatomic) BOOL isAlbumsTab;
@property (assign, nonatomic) BOOL isSongsTab;
@property (assign, nonatomic) BOOL isBuyBtn;
@property (assign, nonatomic) BOOL DownloadVideo;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic, assign) BOOL isSongs;
@property (nonatomic, assign) BOOL isAlbum;
@property (nonatomic, assign) BOOL isFree;

@property (nonatomic, assign) int flag;
@property (nonatomic, retain) IBOutlet AvailableAlbums *albumsOBJ;
@property (nonatomic, retain) IBOutlet AvailableSongs *songsOBJ;
@property (nonatomic, strong) NSMutableArray *songsArray;
- (IBAction)menubtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *disabledImgView;
@property (strong, nonatomic) IBOutlet UIView *proView;
@property (strong, nonatomic) AvailableSongs *obj;
- (IBAction)searchBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *freeMenuView;
@property (strong, nonatomic) IBOutlet UIButton *exitbtn;
@property (retain, nonatomic) UIButton *button;
- (IBAction)creditButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *tableBg;



// PayPAL
@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@end
