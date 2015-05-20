//
//  AlbumSongsViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 02/04/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "AlbumSongsViewController.h"
#import "mySongs.h"
#import "AvailbleSongsCell.h"
#import "MySongsViewController.h"
#import "MusicPlayerViewController.h"
#import "AppDelegate.h"

@interface AlbumSongsViewController ()
{
    NSMutableArray *videoArray, *songNameArray, *videoList;
}
@end

@implementation AlbumSongsViewController
@synthesize albumHeader,songsTableView,albumId,albumName,artistName;
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
    songsTableView.backgroundColor=[UIColor clearColor];
    self.songsTableView.tableFooterView = [[UIView alloc] init] ;
    self.albumHeader.text=albumName;
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    videoArray=[[NSMutableArray alloc]init];
    songNameArray=[[NSMutableArray alloc]init];
    videoList=[[NSMutableArray alloc]init];
    
    NSString *queryString ;
    queryString = [NSString stringWithFormat:@"Select * FROM Songs where albumId=%d and albumName=\"%@\" ",[albumId intValue],albumName];
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

        [videoArray addObject:mysongObj];
        [songNameArray addObject:mysongObj.VideoName];
        [videoList addObject:mysongObj.LocalUrl];
    }
    NSLog(@"%@",videoArray);
    [database close];

    // Do any additional setup after loading the view from its nib.
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



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return videoArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UIButton *playBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        playBtn.frame = CGRectMake(260.0f, 35.0f, 25.0f,25.0f);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        playBtn.frame = CGRectMake(250.0f, 35.0f, 25.0f, 25.0f);
    }
    else{
        playBtn.frame = CGRectMake(630.0f, 60.0f, 60.0f,60.0f);
    }

    playBtn.tag = indexPath.row;
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"social_facebook_box_blue.png"];
    
    AvailbleSongsCell *songCell;
    songCell = (AvailbleSongsCell *)[songsTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSArray *nib;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
    }
    else{
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell_ipad" owner:self options:nil];
    }
    
    songCell = [nib objectAtIndex:0];
    songCell.selectionStyle = UITableViewCellSelectionStyleNone;
    songCell.backgroundColor=[UIColor clearColor];
    [playBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [songCell.contentView addSubview:playBtn];
    [playBtn addTarget:self action:@selector(shareNow:) forControlEvents:UIControlEventTouchUpInside];
    mySongs *obj = (mySongs *)[videoArray objectAtIndex:indexPath.row];
    NSString *strPrice=@"";
    [songCell setLabelText2:obj.ArtistName :obj.songTrackCode  :obj.VideoName :obj.ThumbnailUrl:obj.songDuration ];
    return songCell;
}
//called when any cell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mySongs *obj=(mySongs *)[videoArray objectAtIndex:indexPath.row];
    NSLog(@"%@",videoArray);
    NSMutableArray *songName=[[NSMutableArray alloc]init];
    MusicPlayerViewController *musicPlayerVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
       musicPlayerVc=[[MusicPlayerViewController alloc]initWithNibName:@"MusicPlayerViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        musicPlayerVc=[[MusicPlayerViewController alloc]initWithNibName:@"MusicPlayerViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        musicPlayerVc=[[MusicPlayerViewController alloc]initWithNibName:@"MusicPlayerViewController_ipad" bundle:Nil];
    }
    [songName addObject:[[videoArray valueForKey:@"LocalUrl"]  objectAtIndex:indexPath.row]];
    
    musicPlayerVc.songsList=songName;
    musicPlayerVc.isAlbumSongs=YES;
     musicPlayerVc.songsNameList = songNameArray;
     musicPlayerVc.index = indexPath.row;
    musicPlayerVc.counter = indexPath.row;
    musicPlayerVc.songsList= videoList;
    [self.navigationController pushViewController:musicPlayerVc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        return 78.0;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        return 78.0;
    }
    else{
        return 138.0;
    }
}
- (void)shareNow:(UIControl *)sender
{
    NSLog(@"play Now");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"%@",videoArray);
    
    mySongs *mysongsObj=[videoArray objectAtIndex:indexPath.row];
    NSString *NameStr = [NSString stringWithFormat:@"%@",mysongsObj.VideoName];
    NSString *imageUrlStr = [NSString stringWithFormat:@"%@",mysongsObj.ThumbnailUrl];
    AppDelegate *appDelegate= [[UIApplication sharedApplication] delegate];
    appDelegate.facebookConnect=YES;
    [appDelegate facebookIntegration:NameStr :imageUrlStr ];
    
    
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
