//
//  AccountDetailViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 23/04/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvailableSongs.h"
#import "AvailableAlbums.h"
#import "accountDetail.h"
#import "FMDatabase.h"

@interface AccountDetailViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
{

    NSArray *cardListArray;
    NSArray *cardListCodeArray;
    int webserviceCode;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;

}
@property (strong, nonatomic) IBOutlet UIImageView *disabledimg;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (strong, nonatomic) NSArray *cardListArray;
@property (strong, nonatomic) NSArray *cardListCodeArray;
@property (strong, nonatomic) IBOutlet UIImageView *songImage;
@property (strong, nonatomic) IBOutlet UILabel *songName;
@property (strong, nonatomic) IBOutlet UILabel *artistname;
@property (strong, nonatomic) IBOutlet UILabel *songPrice;
@property (strong, nonatomic) IBOutlet UITextField *cardTypeTxt;
@property (strong, nonatomic) IBOutlet UITextField *cardNumberTxt;
@property (strong, nonatomic) IBOutlet UITextField *cardHolderNameTxt;
@property (strong, nonatomic) IBOutlet UITextField *cardDateValidFromTxt;
@property (strong, nonatomic) IBOutlet UITextField *cardDateValidTo;
@property (strong, nonatomic) IBOutlet UITextField *CVCNumberTxt;
@property (nonatomic, retain) IBOutlet AvailableSongs *songsOBJ;
@property (nonatomic, retain) IBOutlet AvailableAlbums *albumsOBJ;
@property (nonatomic, retain) IBOutlet accountDetail *accountDetailOBJ;

@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataRecievedLbl;
@property (strong, nonatomic) IBOutlet UIView *proView;

@property (strong, nonatomic) IBOutlet UITableView *cardTypeDropTable;
@property (strong, nonatomic) IBOutlet UIPickerView *monthYearPickrView, *myPickerView;
@property (strong, nonatomic) IBOutlet UIView *viewPickr;
@property (nonatomic, assign) BOOL isCardDateFrom;
@property (nonatomic, assign) BOOL isCardDateTo;
@property (nonatomic, assign) BOOL isSongs;
@property (nonatomic, assign) BOOL isAlbum;
@property (nonatomic, assign) BOOL isresignTxt;
@property (nonatomic, assign) BOOL isCardTxt;
@property (strong, nonatomic) IBOutlet UITextField *userNametxt;
@property (strong, nonatomic) IBOutlet UITextField *useremailtxt;
@property (nonatomic, strong) NSMutableArray *songsArray;
- (IBAction)cardtypeBtn:(id)sender;
- (IBAction)dateValidFromBtn:(id)sender;
- (IBAction)dateValidToBtn:(id)sender;
- (IBAction)payNowBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)doneBtn:(id)sender;

@end
