//
//  MySongsViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "mySongs.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SWTableViewCell.h"

@interface MySongsViewController : UIViewController<FBFriendPickerDelegate,FBLoginViewDelegate,SWTableViewCellDelegate>
{
    BOOL isSongsTab;
    BOOL isAlbumsTab;
    BOOL isPlaylistTab;
    NSMutableArray *artistNameArray;
    NSMutableArray *songNameArray;
    NSMutableArray *imageArray, *localUrlArray;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
}
- (IBAction)addBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)viewAvailbleSongs:(id)sender;
- (IBAction)songsTab:(id)sender;
- (IBAction)albumsTab:(id)sender;
- (IBAction)playListTab:(id)sender;
- (IBAction)inviteFriends:(id)sender;



@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) IBOutlet UIButton *viewAvailbleSongs;
@property (strong, nonatomic) NSMutableArray *albumArray;
@property (strong, nonatomic) NSMutableArray *videoArray;
@property (strong, nonatomic) NSMutableArray *imageArray,* videoPassingArray,* songsNameArray;


@property (strong, nonatomic) NSMutableArray *songNameArray;
@property (strong, nonatomic) NSMutableArray *songCountArray;
@property (strong, nonatomic) NSMutableArray *playlistArray;
@property (strong, nonatomic) IBOutlet UIButton *songsTabOutlet;
@property (strong, nonatomic) IBOutlet UIButton *albumsTabOutlet;
@property (strong, nonatomic) IBOutlet UIButton *playListTabOutlet;
@property (strong, nonatomic) IBOutlet UITableView *mySongsTableView;
@property (assign, nonatomic) BOOL isSongsTab;
@property (assign, nonatomic) BOOL isAlbumsTab;
@property (assign, nonatomic) BOOL isPlaylistTab;
@property (strong, nonatomic) IBOutlet UIButton *addBtnOultet;
@property (assign, nonatomic) int playlistIndex;

@end
