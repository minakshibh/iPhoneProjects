//
//  PlaylistSongsViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "Playlist.h"
@interface PlaylistSongsViewController : UIViewController
{
    NSMutableArray *artistNameArray;
    NSMutableArray *songNameArray,*playlistArray;
    NSMutableArray *imageArray ,*videoArray ,*tempSongArray,*videoPassingArray, *indexes;
    UIImageView *checkmark;
    NSString *headerName;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
    int playListId;
    int videoId;
    Playlist *playlistObj;
    BOOL isAllSongs;
    BOOL isEditSongs;
    BOOL isSelectSong;

}
- (IBAction)backBtn:(id)sender;
- (IBAction)editBtn:(id)sender;
- (IBAction)addBtn:(id)sender;
@property (strong, nonatomic) NSString *headerName;
@property (strong, nonatomic) IBOutlet UITableView *SongsTaleView;
@property (strong, nonatomic) IBOutlet UILabel *playlistHeader;
@property (strong, nonatomic) NSMutableArray *playlistArray ,*videoIdArray;
@property (strong, nonatomic) IBOutlet UIView *allSongView;
@property (assign, nonatomic) BOOL isAllSongs;
@property (assign, nonatomic) BOOL isEditSongs;

@property (strong, nonatomic) IBOutlet UITableView *allSongsTableView;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;

@property (strong, nonatomic) IBOutlet UILabel *allSongHeader;
- (IBAction)doneBtn:(id)sender;
- (IBAction)allSongsBackBtn:(id)sender;
@end
