//
//  MySongsViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "MySongsViewController.h"
#import "AvailableAlbumsCell.h"
#import "AvailbleSongsCell.h"
#import "PlaylistCell.h"
#import "AvailableSongsViewController.h"
#import "PlaylistSongsViewController.h"
#import "MusicPlayerViewController.h"
#import "mySongs.h"
#import "AlbumSongsViewController.h"
#import "AppDelegate.h"
@interface MySongsViewController ()

@end

@implementation MySongsViewController
@synthesize songsTabOutlet,albumsTabOutlet,playListTabOutlet,mySongsTableView,isAlbumsTab,isSongsTab,isPlaylistTab,songNameArray,imageArray,viewAvailbleSongs,addBtnOultet,songCountArray,videoArray,albumArray,videoPassingArray,friendPickerController,playlistArray,playlistIndex;

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
    [super viewDidLoad];
    self.mySongsTableView.tableFooterView = [[UIView alloc] init] ;

    mySongsTableView.backgroundColor = [UIColor clearColor];
    playlistArray=[[NSMutableArray alloc]init];
    songNameArray=[[NSMutableArray alloc]init];
    imageArray=[[NSMutableArray alloc]init];
    songCountArray=[[NSMutableArray alloc]init];
    
    videoPassingArray = [[NSMutableArray alloc]init];
    songNameArray = [[NSMutableArray alloc] init];
    [self showSongs];
}

- (void )showSongs{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    albumArray =[[NSMutableArray alloc]init];
    videoArray=[[NSMutableArray alloc]init];
    localUrlArray = [[NSMutableArray alloc] init];
    NSString *queryString ;
   
    if (isAlbumsTab)
    {
       queryString = [NSString stringWithFormat:@"Select * FROM Albums "];
    }
    else if(isPlaylistTab)
    {
        queryString  = [NSString stringWithFormat:@"Select * from PlayList ORDER BY id DESC"];
    }
    else
    {
         queryString = [NSString stringWithFormat:@"Select * FROM Songs "];
    }
        FMResultSet *results = [database executeQuery:queryString];
    
        while([results next]) {
            
             mySongs *mysongObj=[[mySongs alloc]init];
            if (isAlbumsTab) {
                mysongObj.AlbumId = [results intForColumn:@"albumId"];
                mysongObj.AlbumName = [results stringForColumn:@"albumName"];
                NSLog(@"albumName..%@",mysongObj.AlbumName);
                queryString = [NSString stringWithFormat:@"Select * FROM Songs where albumName = \"%@\" ",mysongObj.AlbumName];
                FMResultSet *results1 = [database executeQuery:queryString];
                while ([results1 next]) {
                    mysongObj.LocalUrl = [results1 stringForColumn:@"localUrl"];
                    [localUrlArray addObject:mysongObj.LocalUrl];
                }
                NSLog(@"Local Url of Song %@",localUrlArray);
                mysongObj.ThumbnailUrl = [results stringForColumn:@"thumbnail"];
                mysongObj.ArtistName = [results stringForColumn:@"artistName"];
                NSLog(@"artistName..%@",mysongObj.ArtistName);
                
                int Songs=[results intForColumn:@"numberOfSongs"];
                if ( Songs==1)
                {
                    mysongObj.Songs=[NSString stringWithFormat:@"%d Song",Songs];
                }
                else{
                    mysongObj.Songs=[NSString stringWithFormat:@"%d Songs",Songs];
                }
                mysongObj.serverUrl=[results stringForColumn:@"serverUrl"];
                mysongObj.albumBuydate = [results stringForColumn:@"albumBuyDate"];
                mysongObj.albumImage=[results stringForColumn:@"albumImage"];
                mysongObj.albumCode = [results stringForColumn:@"AlbumCode"];
                [albumArray addObject:mysongObj];

            }
           
           
            else if(isPlaylistTab)
            {
                mysongObj.playlistName=[results stringForColumn:@"playlistName"];
                [playlistArray addObject:mysongObj.playlistName];
            }
            else
            {
                mysongObj.VideoId = [results intForColumn:@"songId"];
                mysongObj.VideoName=[results stringForColumn:@"songName"];
                mysongObj.serverUrl=[results stringForColumn:@"serverUrl"];
                mysongObj.AlbumName = [results stringForColumn:@"albumName"];
                NSLog(@"Local URL %@",[results stringForColumn:@"localUrl"]);
                mysongObj.LocalUrl = [results stringForColumn:@"localUrl"];
                mysongObj.ThumbnailUrl = [results stringForColumn:@"thumbnail"];
                mysongObj.ArtistName = [results stringForColumn:@"artistName"];
                mysongObj.AlbumId = [results intForColumn:@"albumId"];
                mysongObj.AlbumName = [results stringForColumn:@"albumName"];
                mysongObj.songBuydate = [results stringForColumn:@"songBuyDate"];
                mysongObj.songImage=[results stringForColumn:@"songImage"];
                mysongObj.songTrackCode=[results stringForColumn:@"Trackcode"];
                mysongObj.songDuration=[results stringForColumn:@"Duration"];

                [videoArray addObject:mysongObj];
                [videoPassingArray addObject:mysongObj.LocalUrl];
                [songNameArray addObject:mysongObj.VideoName];
            }
    }
    NSLog(@"%@",albumArray);
    NSLog(@"%@",videoArray);
    //[database executeUpdate:insertSQL];
    [database close];
    [mySongsTableView reloadData];

    
    NSLog(@"Videos Passed %@",videoPassingArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addBtn:(id)sender {
  
        UIAlertView* dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setTitle:@"Enter Playlist Name"];
        [dialog setMessage:@" "];
        [dialog addButtonWithTitle:@"Cancel"];
        [dialog addButtonWithTitle:@"OK"];
        dialog.tag = 5;
        dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        [dialog textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
        CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 0.0);
        [dialog setTransform: moveUp];
        [dialog show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if(buttonIndex==1 && [title isEqualToString:@"OK"])
    {
        UITextField *playlistNameTxt = [alertView textFieldAtIndex:0];
        
        NSString *playlistName=[NSString stringWithFormat:@"%@", playlistNameTxt.text];
        if ([playlistName isEqualToString:@""]) {
            UIAlertView *alrt =[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Please enter playlist name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alrt show];
        }else{
             playlistArray =[[NSMutableArray alloc]init];
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            NSString *insertSQL  = [NSString stringWithFormat:@"INSERT INTO PlayList (playlistName) VALUES ( \"%@\")",playlistName];
            [database executeUpdate:insertSQL];
            
            [database close];
            [self showSongs];
            [mySongsTableView reloadData];
  
        }
    }
    else if(buttonIndex==1 && [title isEqualToString:@"OK"]){
        [self addBtn:NULL];
    }
    else if (buttonIndex==0 && alertView.tag == 11)
    {
        NSString *playlist= [playlistArray objectAtIndex: playlistIndex];
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        int   playListId;
        NSString *queryStr = [NSString stringWithFormat:@"Select * FROM PlayList where playlistName =\"%@\"",playlist];
        FMResultSet *results = [database executeQuery:queryStr];
        
        while([results next]) {
            playListId=[results intForColumn:@"id"];
            NSLog(@"playList id..%D",playListId);
        }
        
        NSString* queryString = [NSString stringWithFormat:@"DELETE FROM PlayList WHERE playlistName=\"%@\"",playlist];
        [database executeUpdate:queryString];
        
        NSString* queryString1 = [NSString stringWithFormat:@"DELETE FROM PlaylistData WHERE playlistId=%d",playListId];
        [database executeUpdate:queryString1];
        
        [database close];
        playlistArray=[[NSMutableArray alloc]init];
        [self showSongs];
        [mySongsTableView reloadData];
  
    }
}


- (IBAction)backBtn:(id)sender {
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    AvailableSongsViewController *AvailSongsvc = [self.navigationController.viewControllers objectAtIndex:index-1];
    [self.navigationController popToViewController:AvailSongsvc animated:YES];

}

- (IBAction)viewAvailbleSongs:(id)sender {
    NSLog(@"fkdghhvie songs");
}

- (IBAction)songsTab:(id)sender {
    viewAvailbleSongs.hidden=NO;
    addBtnOultet.hidden=YES;
    [addBtnOultet setUserInteractionEnabled:NO];
    isSongsTab=YES;
    isAlbumsTab=NO;
    isPlaylistTab=NO;
    [songsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tw3_left"] forState:UIControlStateNormal];
    [albumsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tb3_center"] forState:UIControlStateNormal];
    [playListTabOutlet setBackgroundImage:[UIImage imageNamed:@"tb3_right"] forState:UIControlStateNormal];

    [songsTabOutlet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [albumsTabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playListTabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self showSongs];
    [mySongsTableView reloadData];
}

- (IBAction)albumsTab:(id)sender {
    viewAvailbleSongs.hidden=NO;
    addBtnOultet.hidden=YES;
    [addBtnOultet setUserInteractionEnabled:NO];

    isSongsTab=NO;
    isAlbumsTab=YES;
    isPlaylistTab=NO;
    [songsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tb3_left"] forState:UIControlStateNormal];
    [albumsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tw3_center"] forState:UIControlStateNormal];
    [playListTabOutlet setBackgroundImage:[UIImage imageNamed:@"tb3_right"] forState:UIControlStateNormal];
    
    [songsTabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [albumsTabOutlet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playListTabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self showSongs];
    [mySongsTableView reloadData];

}

- (IBAction)playListTab:(id)sender {
    viewAvailbleSongs.hidden=YES;
    addBtnOultet.hidden=NO;
    [addBtnOultet setUserInteractionEnabled:YES];
    playlistArray=[[NSMutableArray alloc ]init];
    
    isSongsTab=NO;
    isAlbumsTab=NO;
    isPlaylistTab=YES;
    [songsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tb3_left"] forState:UIControlStateNormal];
    [albumsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tb3_center"] forState:UIControlStateNormal];
    [playListTabOutlet setBackgroundImage:[UIImage imageNamed:@"tw3_right"] forState:UIControlStateNormal];
    
    [songsTabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [albumsTabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playListTabOutlet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self showSongs];
    [mySongsTableView reloadData];
    

}

- (IBAction)inviteFriends:(id)sender {
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:[NSString stringWithFormat:@"Learn how to make your iOS apps social."]
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];

}


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isAlbumsTab) {
        return albumArray.count;
    }
    else if (isPlaylistTab)
    {
        return playlistArray.count;
    }
    else{
        return videoArray.count;

    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ArticleCellID";
     UIButton *playBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // UIButton *deleteBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        playBtn.frame = CGRectMake(260, 30.0f, 25.0f,25.0f);

    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        playBtn.frame = CGRectMake(250.0f, 30.0f, 25.0f, 25.0f);
    }
    else{
        playBtn.frame = CGRectMake(630.0f, 60.0f, 60.0f,60.0f);
    }
    
    playBtn.tag = indexPath.row;
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"social_facebook_box_blue.png"];
    UIImage *deleteIcon = [UIImage imageNamed:@"delete_icon"];
    
    AvailableAlbumsCell *cell;
    AvailbleSongsCell *songCell;
    PlaylistCell *playlistCell;
   

    if (isAlbumsTab)
    {
        mySongs * mysongobj = (mySongs *)[albumArray objectAtIndex:indexPath.row];

        cell = (AvailableAlbumsCell *)[mySongsTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSArray *nib;
        
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailableAlbumsCell" owner:self options:nil];
            
            
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailableAlbumsCell" owner:self options:nil];
            
        }
        else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailableAlbumsCell_ipad" owner:self options:nil];
            
        }

        
        
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        NSString *songs;
        if ([mysongobj.Songs isEqualToString:@"1"]) {
           songs=[NSString stringWithFormat:@"%@ Song",mysongobj.Songs];
        }else{
         songs=[NSString stringWithFormat:@"%@ Songs",mysongobj.Songs];
        }
        
        NSString *strPrice=@"";
        [cell setLabelText:mysongobj.AlbumName :@"" :mysongobj.ArtistName :songs :mysongobj.ThumbnailUrl];
    }
    else if (isPlaylistTab)
    {
        playlistCell = (PlaylistCell *)[mySongsTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSArray *nib;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell" owner:self options:nil];            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            nib = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell" owner:self options:nil];        }
        else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCell_ipad" owner:self options:nil];        }

        playlistCell = [nib objectAtIndex:0];
        playlistCell.selectionStyle = UITableViewCellSelectionStyleNone;
        playlistCell.backgroundColor=[UIColor clearColor];
        playlistCell.nameOfPlaylistLbl.backgroundColor=[UIColor clearColor];
        playlistCell.numbrOfSongsLbl.backgroundColor=[UIColor clearColor];
        if (playlistArray.count!=0)
        {
            playlistCell.nameOfPlaylistLbl.text = [playlistArray objectAtIndex:indexPath.row];
            UIImageView *deleteImg;
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                deleteImg = [[UIImageView alloc] initWithFrame:CGRectMake(260, 14, 15, 18)];
                 playBtn.frame = CGRectMake(250, 10.0f, 50.0f,50.0f);
                //this is iphone 5 xib
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480){
                deleteImg = [[UIImageView alloc] initWithFrame:CGRectMake(260, 14, 15, 18)];
                playBtn.frame = CGRectMake(250, 10.0f, 50.0f,50.0f);
            }
            else{
                deleteImg = [[UIImageView alloc] initWithFrame:CGRectMake(640,18, 34, 39)];
                playBtn.frame = CGRectMake(640, 40.0f,60.0f,60.0f);
            }

            deleteImg.image = deleteIcon;
            [playlistCell.contentView addSubview:deleteImg];
            [playlistCell.contentView addSubview:playBtn];
           
            [playBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];

        }
    }

    else{

        songCell = (AvailbleSongsCell *)[mySongsTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSArray *nib;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];            // this is iphone 4 xib
        }
        else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell_ipad" owner:self options:nil];
        }

        
        songCell = [nib objectAtIndex:0];
        songCell.selectionStyle = UITableViewCellSelectionStyleNone;
        songCell.backgroundColor=[UIColor clearColor];
        [playBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
        [songCell.contentView addSubview:playBtn];
        [playBtn addTarget:self action:@selector(PlayNow:) forControlEvents:UIControlEventTouchUpInside];
         mySongs *obj = (mySongs *)[videoArray objectAtIndex:indexPath.row];
        [songCell setLabelText2:obj.ArtistName :obj.songTrackCode:obj.VideoName :obj.ThumbnailUrl  :obj.songDuration ];
    }
    
   
    
    if (isAlbumsTab)
    {
        return cell;
        
    }
    else if (isPlaylistTab)
    {
        return playlistCell;
        
    }
    else
    {
        return songCell;
    }
}
//called when any cell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isPlaylistTab)
    {
        PlaylistSongsViewController *playlistVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            playlistVc=[[PlaylistSongsViewController alloc]initWithNibName:@"PlaylistSongsViewController" bundle:Nil];
            
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            playlistVc=[[PlaylistSongsViewController alloc]initWithNibName:@"PlaylistSongsViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else{
            playlistVc=[[PlaylistSongsViewController alloc]initWithNibName:@"PlaylistSongsViewController_ipad" bundle:nil];

        }
        

        
        NSString *str=[playlistArray objectAtIndex:indexPath.row];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"playlistName"];
        [defaults setObject:[NSString stringWithString:str ]forKey:@"playlistName"];

       // playlistVc.headerName=[NSString stringWithString:str];
        [self.navigationController pushViewController:playlistVc animated:YES];
    }
    else if (isAlbumsTab)
    {
        AlbumSongsViewController *albumSongsVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            albumSongsVc=[[AlbumSongsViewController alloc]initWithNibName:@"AlbumSongsViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            albumSongsVc=[[AlbumSongsViewController alloc]initWithNibName:@"AlbumSongsViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        else{
            albumSongsVc=[[AlbumSongsViewController alloc]initWithNibName:@"AlbumSongsViewController_ipad" bundle:nil];

        }

        
         mySongs *mysongsObj=[albumArray objectAtIndex:indexPath.row];
        albumSongsVc.albumName=mysongsObj.AlbumName ;
        albumSongsVc.albumId=[NSString stringWithFormat:@"%d",mysongsObj.AlbumId];
        albumSongsVc.artistName=mysongsObj.ArtistName;
        [self.navigationController pushViewController:albumSongsVc animated:YES];
    }
    else
    {
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
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"More" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        [self.mySongsTableView setEditing:NO];
    }];
    moreAction.backgroundColor = [UIColor lightGrayColor];
    
    UITableViewRowAction *blurAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Blur" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self.mySongsTableView setEditing:NO];
    }];
    blurAction.backgroundEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        mySongs *obj;
        mySongs * mysongobj;
        if (isAlbumsTab) {
            mysongobj = (mySongs *)[albumArray objectAtIndex:indexPath.row];
            [self.albumArray removeObjectAtIndex:indexPath.row];
        }else{
            obj = (mySongs *)[videoArray objectAtIndex:indexPath.row];
            [self.videoArray removeObjectAtIndex:indexPath.row];
        }
        [self.mySongsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (isAlbumsTab) {
            NSLog(@"Album Code %@",mysongobj.albumCode);
            NSLog(@"Song Url %@",mysongobj.LocalUrl);
            NSLog(@"Song Track %@",mysongobj.AlbumName);
            [self deleteAlbumItems:mysongobj.albumCode :mysongobj.LocalUrl :mysongobj.AlbumName];
            
        }else{
            NSLog(@"Song Name %@",obj.LocalUrl);
        [self deleteItems:obj.songTrackCode:obj.LocalUrl];
        }
    }];
    
    return @[deleteAction];
}
-(void) deleteAlbumItems: (NSString *)albumID: (NSString *)localUrl: (NSString *)albumName
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString ;
    NSString *songsQueryStr;
    
    queryString = [NSString stringWithFormat:@"DELETE FROM Albums where albumName = \"%@\"",albumName];
    songsQueryStr = [NSString stringWithFormat:@"DELETE FROM Songs where albumName = \"%@\"",albumName];
    [database executeUpdate:queryString];
    [database executeUpdate:songsQueryStr];
    [database close];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",localUrl]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // Need to check if the to be deleted file exists.
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        // This function also returnsYES if the item was removed successfully or if path was nil.
        // Returns NO if an error occurred.
        [manager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", [NSString stringWithFormat:@"%@",localUrl]);
    }
    
    NSLog(@"Videos Passed %@",videoPassingArray);
    
    
}
-(void) deleteItems: (NSString *)trackCode: (NSString *)localUrl
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString ;
    
    
        queryString = [NSString stringWithFormat:@"DELETE FROM Songs where Trackcode = \"%@\"",trackCode];
  
   [database executeUpdate:queryString];
    
    [database close];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",localUrl]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // Need to check if the to be deleted file exists.
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        // This function also returnsYES if the item was removed successfully or if path was nil.
        // Returns NO if an error occurred.
        [manager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", [NSString stringWithFormat:@"%@",localUrl]);
    }
    
    NSLog(@"Videos Passed %@",videoPassingArray);


}
// From Master/Detail Xcode template
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.videoArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (void)delete:(UIControl *)sender{
    
    NSLog(@"deleted");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    playlistIndex = indexPath.row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zoom Karaoke!" message:@"Are you sure you want to delete the playlist?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alert.tag = 11;
    [alert show];
}

- (void)PlayNow:(UIControl *)sender
{
    NSLog(@"play Now");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"%@",videoArray);
    if (isAlbumsTab) {
        mySongs *mysongsObj=[albumArray objectAtIndex:indexPath.row];
        NSString *NameStr = [NSString stringWithFormat:@"%@",mysongsObj.VideoName];
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@",mysongsObj.ThumbnailUrl];
    }
    
    
    else if(isPlaylistTab)
    {
        
    }
    else
    {
        mySongs *mysongsObj=[videoArray objectAtIndex:indexPath.row];
        NSString *NameStr = [NSString stringWithFormat:@"%@",mysongsObj.VideoName];
        NSString *imageUrlStr = [NSString stringWithFormat:@"%@",mysongsObj.ThumbnailUrl];
        AppDelegate *appDelegate= [[UIApplication sharedApplication] delegate];
        appDelegate.facebookConnect=YES;
        [appDelegate facebookIntegration:NameStr :imageUrlStr ];
    }

   
    
   
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//size of row
    if (isAlbumsTab) {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            return 73.0;
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480){
            return 73.0;
        }
        else{
            return 138.0;
        }
    }
    else if(isPlaylistTab)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            return 45.0;
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480){
             return 45.0;
        }
        else{
             return 80.0;
        }
    }
    else
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
           return 73.0;
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480){
             return 77.0;
        }
        else{
            return 138.0;
        }
    }
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
}@end
