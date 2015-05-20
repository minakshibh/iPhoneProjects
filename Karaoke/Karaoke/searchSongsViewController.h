//
//  searchSongsViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_1 on 4/18/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AvailableAlbums.h"
#import "videosInAlbum.h"
#import "FMDatabase.h"
#import "AvailableSongs.h"
#import "PayPalMobile.h"

@interface searchSongsViewController : UIViewController<PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate, UIPopoverControllerDelegate, UITableViewDataSource,UITableViewDelegate>
{
    AvailableSongs *availableSongsObj;
    AvailableAlbums *availbleAlbumObj;
    videosInAlbum *videosInAlbumObj;
    NSMutableString *tempString;
    BOOL isAlbumsTab;
    NSString *videoURLStr;
    BOOL isSongsTab;
     BOOL isloadMore;
    BOOL isSearchClicked;
    NSString *result,*message,*strEncodedImage,*filepath;
    NSMutableArray *songsList, *trackCodeArray,*songNameInAlbum;
    NSMutableArray *albumList;
    int webserviceCode;
    int pagging;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath ,*songCount;
    FMDatabase *database;
     NSString *searchParameter;
    BOOL ispaidSong;
    int creditsToSave, videoID;


}
- (IBAction)requestSongBtn:(id)sender;
- (IBAction)topSellerbtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)mySondBtn:(id)sender;
- (IBAction)SongsTabBtn:(id)sender;
- (IBAction)albumTabBtn:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)freeSongs:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong ,nonatomic )  NSMutableArray *songsList;
@property (strong, nonatomic ) NSMutableArray *albumList;
@property (retain, nonatomic) UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataRecievedLbl;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UIView *proView;
@property (strong, nonatomic) IBOutlet UIImageView *disabledImgView;
@property (nonatomic, strong) NSMutableArray *songsArray;
@property (strong, nonatomic) IBOutlet UIImageView *searchTextFeildImage;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic)  NSString *searchUser_UDID_Str;
@property (strong, nonatomic) IBOutlet UITextField *searchTxt;
@property (strong, nonatomic) NSString *searchTriggerValue;
@property (strong, nonatomic) IBOutlet UITableView *songListView;
@property (strong, nonatomic) IBOutlet UIButton *songsTab;
@property (strong, nonatomic) IBOutlet UIButton *AlbumTab;
@property (nonatomic, retain) IBOutlet AvailableAlbums *albumsOBJ;
@property (nonatomic, retain) IBOutlet AvailableSongs *songsOBJ;
@property (strong, nonatomic) IBOutlet UIButton *searchBtnOutlet;

- (IBAction)creditButton:(id)sender;

// PayPAL
@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@end
