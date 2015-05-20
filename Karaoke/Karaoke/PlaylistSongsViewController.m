//
//  PlaylistSongsViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "PlaylistSongsViewController.h"
#import "AvailbleSongsCell.h"
#import "MySongsViewController.h"
#import "MusicPlayerViewController.h"
#import "AppDelegate.h"

@interface PlaylistSongsViewController ()

@end

@implementation PlaylistSongsViewController
@synthesize SongsTaleView,playlistHeader,headerName,playlistArray,videoIdArray,allSongsTableView,allSongView,isAllSongs,allSongHeader,editBtn,isEditSongs;

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
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [SongsTaleView reloadData];
    videoIdArray=[[NSMutableArray alloc]init];
    songNameArray=[[NSMutableArray alloc]init];
    playlistArray=[[NSMutableArray alloc]init];
    tempSongArray=[[NSMutableArray alloc]init];
    videoPassingArray=[[NSMutableArray alloc]init];
    indexes = [[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    headerName = [defaults objectForKey:@"playlistName"];
    self.SongsTaleView.tableFooterView = [[UIView alloc] init] ;
    playlistHeader.text=[NSString stringWithFormat:@"%@",headerName];
    allSongHeader.text=[NSString stringWithFormat:@"%@",headerName];
    SongsTaleView.backgroundColor = [UIColor clearColor];
    [SongsTaleView setSeparatorInset:UIEdgeInsetsZero];
    allSongsTableView.backgroundColor = [UIColor clearColor];
    [allSongsTableView setSeparatorInset:UIEdgeInsetsZero];
    self.allSongsTableView.tableFooterView = [[UIView alloc] init] ;

    
   // isEditSongs=NO;
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
     NSString *queryString = [NSString stringWithFormat:@"Select * FROM PlayList where playlistName =\"%@\"",headerName];
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        playListId=[results intForColumn:@"id"];
        NSLog(@"playList id..%D",playListId);
        
    }
    
    NSString *queryStr = [NSString stringWithFormat:@"Select * FROM PlaylistData where playlistId =%d",playListId];
    FMResultSet *result = [database executeQuery:queryStr];
    
    while([result next])
    {
       videoId=[result intForColumn:@"videoId"];
        [videoIdArray addObject:[NSString stringWithFormat:@"%d",videoId]];
        NSString *songsQueryStr = [NSString stringWithFormat:@"Select * FROM Songs where songId =%d",videoId];
        FMResultSet *resultSongs = [database executeQuery:songsQueryStr];
        
        while([resultSongs next])
        {
            playlistObj=[[Playlist alloc]init];
            playlistObj.playlistId=playListId;
            playlistObj.playlistName=headerName;
            playlistObj.VideoId = [resultSongs intForColumn:@"songId"];
            playlistObj.VideoName=[resultSongs stringForColumn:@"songName"];
            playlistObj.serverUrl=[resultSongs stringForColumn:@"serverUrl"];
            playlistObj.LocalUrl = [resultSongs stringForColumn:@"localUrl"];
            playlistObj.ThumbnailUrl = [resultSongs stringForColumn:@"thumbnail"];
            playlistObj.ArtistName = [resultSongs stringForColumn:@"artistName"];
            playlistObj.AlbumId = [resultSongs intForColumn:@"albumId"];
            playlistObj.AlbumName = [resultSongs stringForColumn:@"albumName"];
            playlistObj.songBuydate = [resultSongs stringForColumn:@"songBuyDate"];
            playlistObj.songImage=[resultSongs stringForColumn:@"songImage"];
            playlistObj.songTrackCode=[resultSongs stringForColumn:@"Trackcode"];
            playlistObj.songDuration=[resultSongs stringForColumn:@"Duration"];
            [videoPassingArray addObject:playlistObj.LocalUrl];
            [songNameArray addObject:playlistObj.VideoName];
            NSLog(@"%@",playlistObj);
            [playlistArray addObject:playlistObj];
        }
    }
    NSLog(@"playList id..%D",playListId);
    NSLog(@"playlistArray..%@",playlistArray);
    [SongsTaleView reloadData];
    [database close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender {
      NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    MySongsViewController *mySongsvc = [self.navigationController.viewControllers objectAtIndex:index-1];
    [self.navigationController popToViewController:mySongsvc animated:YES];

}

- (IBAction)editBtn:(id)sender {
    NSLog(@"edit songs");
    isEditSongs=YES;
    allSongView.hidden=NO;
    editBtn.hidden=YES;
    [allSongsTableView reloadData];
    

}

- (IBAction)addBtn:(id)sender {
    allSongView.hidden=NO;
    isAllSongs=YES;
    
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    videoArray=[[NSMutableArray alloc]init];
    
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM Songs "];
    FMResultSet *results = [database executeQuery:queryString];
    while([results next]) {
        mySongs *mysongObj=[[mySongs alloc]init];
        mysongObj.VideoId = [results intForColumn:@"songId"];
        mysongObj.VideoName=[results stringForColumn:@"songName"];
        mysongObj.serverUrl=[results stringForColumn:@"serverUrl"];
        mysongObj.LocalUrl = [results stringForColumn:@"localUrl"];
        mysongObj.ThumbnailUrl = [results stringForColumn:@"thumbnail"];
        mysongObj.ArtistName = [results stringForColumn:@"artistName"];
        mysongObj.AlbumId = [results intForColumn:@"albumId"];
        mysongObj.AlbumName = [results stringForColumn:@"albumName"];
        mysongObj.songBuydate = [results stringForColumn:@"songBuyDate"];
        mysongObj.songImage=[results stringForColumn:@"songImage"];
        mysongObj.songTrackCode=[results stringForColumn:@"Trackcode"];
        mysongObj.songDuration=[results stringForColumn:@"Duration"];
        
        if (![videoIdArray containsObject:[NSString stringWithFormat:@"%d",mysongObj.VideoId]]) {
            [videoArray addObject:mysongObj];
        }
    }
    [database close];
    [allSongsTableView reloadData];

}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isAllSongs)
    {
        return videoArray.count;

    }else
    {
        NSLog(@"%lu",(unsigned long)playlistArray.count);
        return playlistArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        return 73.0;

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)  {
        return 76.0;
    }
    else{
        return 138.0;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    AvailbleSongsCell *cell;
    mySongs *songsObj;
    NSString *indexStr = [NSString stringWithFormat:@"%lu", (long)indexPath.row];
    if (isAllSongs)
    {
       cell = (AvailbleSongsCell *)[allSongsTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        songsObj = (mySongs *)[videoArray objectAtIndex:indexPath.row];
    }
    else{
       cell = (AvailbleSongsCell *)[SongsTaleView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSLog(@"index path ..%ld",(long)indexPath.row);
        if (indexPath.row<playlistArray.count)
        {
            if (playlistArray.count==1) {
                playlistObj=[playlistArray objectAtIndex:0];
            }
            else
            {
                playlistObj=[playlistArray objectAtIndex:indexPath.row];
            }
        }
    }
    NSArray *nib;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
    }
    else  if ([[UIScreen mainScreen] bounds].size.height == 480) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
    }
    else{
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell_ipad" owner:self options:nil];
    }
    
    cell = [nib objectAtIndex:0];
    cell.artistNameLbl.backgroundColor=[UIColor clearColor];
    cell.songNameLbl.backgroundColor=[UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
   
    if (isAllSongs)
    {
        [cell setLabelText2:songsObj.ArtistName :songsObj.songTrackCode:songsObj.VideoName :songsObj.ThumbnailUrl  :songsObj.songDuration ];

    }
    else{
        [cell setLabelText2:playlistObj.ArtistName :playlistObj.songTrackCode:playlistObj.VideoName :playlistObj.ThumbnailUrl  :playlistObj.songDuration ];

    }
    UIButton *playBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
       playBtn.frame = CGRectMake(260.0f, 30.0f, 25.0f,25.0f);
        if (!isSelectSong) {
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(260, 30, 25, 25)];
            if (![indexes containsObject:indexStr]) {
                
                checkmark.image = [UIImage imageNamed:@"checkbox_unchecked.png"];
            }else{
                checkmark.image = [UIImage imageNamed:@"checkbox_checked.png"];
            }
        }
        

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        
        playBtn.frame = CGRectMake(250.0f, 30.0f, 25.0f,25.0f);
        if (!isSelectSong) {
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(250, 30, 25, 25)];
            if (![indexes containsObject:indexStr]) {
                
                checkmark.image = [UIImage imageNamed:@"checkbox_unchecked.png"];
            }else{
                checkmark.image = [UIImage imageNamed:@"checkbox_checked.png"];
            }
        }

    }
    else{
        playBtn.frame = CGRectMake(630.0f, 60.0f, 60.0f,60.0f);
        if (!isSelectSong) {
            checkmark = [[UIImageView alloc] initWithFrame:CGRectMake(660, 60, 36, 36)];
            if (![indexes containsObject:indexStr]) {
                
                checkmark.image = [UIImage imageNamed:@"checkbox_unchecked.png"];
            }else{
                checkmark.image = [UIImage imageNamed:@"checkbox_checked.png"];
            }
        }
        

    }
    
    playBtn.tag = indexPath.row;
   
    
    
    [checkmark setTag:indexPath.row +100];
    if (isAllSongs)
    {
        [cell.contentView addSubview:checkmark];

    }
    else if (isEditSongs)
    {
        UIImage *buttonBackgroundImage = [UIImage imageNamed:@"remove_icon.png"];
        [playBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        [cell.contentView addSubview:playBtn];
        [playBtn addTarget:self action:@selector(deleteSong:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        UIImage *buttonBackgroundImage = [UIImage imageNamed:@"social_facebook_box_blue.png"];
        [playBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        [cell.contentView addSubview:playBtn];
        [playBtn addTarget:self action:@selector(shareNow:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
//called when any cell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( isAllSongs)
    {
        NSLog(@"indexrow %ld", (long)indexPath.row);
        NSString *indexStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        UITableViewCell *cell = [allSongsTableView cellForRowAtIndexPath:indexPath];
        UIImageView *check = (UIImageView*)[cell.contentView viewWithTag:indexPath.row+100];
        
        NSData *img1Data = UIImageJPEGRepresentation(check.image, 1.0);
        NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"checkbox_unchecked.png"], 1.0);
        

        NSLog(@"subviews %@", check .image);
         if ([img1Data isEqualToData:img2Data])
        {
            check.image = [UIImage imageNamed:@"checkbox_checked.png"];
            [tempSongArray addObject:[videoArray objectAtIndex:indexPath.row ]];
            [indexes addObject:indexStr];
        }
        else
            
        {
            check.image = [UIImage imageNamed:@"checkbox_unchecked.png"];
            [tempSongArray removeObject:[videoArray objectAtIndex:indexPath.row ]];
            [indexes removeObject:indexStr];
        }

    }
    else if (isEditSongs){
        
    }
    else {
        NSLog(@"%@",videoArray);
        //mySongs *mysongsObj=[videoArray objectAtIndex:indexPath.row];
        MusicPlayerViewController *musicPlayerVc;
        
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            musicPlayerVc=[[MusicPlayerViewController alloc]initWithNibName:@"MusicPlayerViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            musicPlayerVc=[[MusicPlayerViewController alloc]initWithNibName:@"MusicPlayerViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else{
            musicPlayerVc=[[MusicPlayerViewController alloc]initWithNibName:@"MusicPlayerViewController_ipad" bundle:nil];

        }

        
        musicPlayerVc.index = indexPath.row;
        musicPlayerVc.counter = indexPath.row;
        musicPlayerVc.songsList= videoPassingArray;
        musicPlayerVc.songsNameList = songNameArray;
        [self.navigationController pushViewController:musicPlayerVc animated:YES];
    }
    
}
- (void)shareNow:(UIControl *)sender
{
    NSLog(@"play Now");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"%@",playlistArray);
    
        mySongs *mysongsObj=[playlistArray objectAtIndex:indexPath.row];
        NSString *NameStr = [NSString stringWithFormat:@"%@",mysongsObj.VideoName];
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@",mysongsObj.ThumbnailUrl];
        AppDelegate *appDelegate= [[UIApplication sharedApplication] delegate];
        appDelegate.facebookConnect=YES;
        [appDelegate facebookIntegration:NameStr :imageUrlStr ];


}
- (void)deleteSong:(UIControl *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    UITableViewCell *cell = [SongsTaleView cellForRowAtIndexPath:indexPath];
    
    
    playlistObj=[playlistArray objectAtIndex:indexPath.row];
    
    NSLog(@"videoId..%d",playlistObj.VideoId);
    NSLog(@"playlistId..%d",playlistObj.playlistId);
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString* queryString = [NSString stringWithFormat:@"DELETE FROM PlayListData WHERE playlistId=%d and videoId=%d" ,playlistObj.playlistId,playlistObj.VideoId];
    [database executeUpdate:queryString];
    [database close];
    [self viewDidLoad];
    [allSongsTableView reloadData];
    

  
}
- (IBAction)doneBtn:(UIControl *)sender
{
    playlistArray=[[NSMutableArray alloc]init];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    UITableViewCell *cell = [allSongsTableView cellForRowAtIndexPath:indexPath];

    for(playlistObj in tempSongArray)
    {
        NSLog(@"playlist obj,%d",playlistObj.VideoId);
        [videoArray removeObject:playlistObj];
        
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        NSString *insertSQL  = [NSString stringWithFormat:@"INSERT INTO PlaylistData (playlistId,videoId) VALUES ( %d,%d)",playListId,playlistObj.VideoId];
        [database executeUpdate:insertSQL];
        
        [database close];
    }

    [allSongsTableView reloadData];
    isAllSongs=NO;
    isEditSongs = NO;
    editBtn.hidden=NO;
    allSongView.hidden=YES;
    [self viewDidLoad];
    [SongsTaleView reloadData];
}
- (IBAction)allSongsBackBtn:(id)sender{
    allSongView.hidden=YES;
    isAllSongs=NO;
    editBtn.hidden = NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ||[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationPortrait;
}
@end
