//
//  AvailableSongsViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 20/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "AvailableSongsViewController.h"
#import "MySongsViewController.h"
#import "AvailbleSongsCell.h"
#import "AvailableAlbumsCell.h"
#import "SongsDetailViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AvailableSongs.h"
#import "ZipArchive.h"
#import "FMDatabaseAdditions.h"
#import "Base64.h"
#import "MusicPlayerViewController.h"
#import "searchSongsViewController.h"
#import "AccountDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoupnsViewController.h"
#import "loginViewController.h"
#import "requestSongViewController.h"
#define kPayPalEnvironment PayPalEnvironmentProduction
//#define kPayPalEnvironment PayPalEnvironmentNoNetwork


@interface AvailableSongsViewController ()
{
    NSString *videoUrlinAlbum, *videoNameinAlbum;
    NSString *result,*message,*strEncodedImage,*filepath;
    NSString *videoURLStr;
    NSString *videoName ,*albumLocalUrl, *songLocalUrl;
    NSString *thumbnail, *artistName, *albumName, *albumServerUrl ,*buyDate ,*numbrOfSongsSongs,  *albumImage;
    NSArray *subpaths,*date;
    int progressStr;
    int index;
    NSTimer *timer;
    NSMutableData *receivedData;
    long long bytesReceived;
    long long expectedBytes;
    float percentComplete;
    unsigned long long bytes;
    NSMutableArray *videoArray;
    NSArray*songsNameinAlbum;
    NSString *NextPage;
    NSString *HaveRecords;
}

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation AvailableSongsViewController
@synthesize songstabOutlet,albumsTabOutlet,songTableView,isSongsTab,isAlbumsTab,isBuyBtn,activityIndicatorObject,progressBar,proView,progressLabel,DownloadVideo,dataRecievedLbl,triggerValue,user_UDID_Str,menuView,isAlbum,isSongs,albumsOBJ,songsArray,disabledImgView,songsOBJ,obj,freeMenuView, exitbtn,flag,button,isFree;

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
    
    
//    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
//    NSString *songs = [defaults1 objectForKey:@"fiveSongsCoupn"];
//    int five=5 +[songs intValue];
//    [defaults1 setObject:[NSString stringWithFormat:@"%d",five] forKey:@"fiveSongsCoupn"];
//    
//     NSString *songs1 = [defaults1 objectForKey:@"fiveSongsCoupn"];
//    
//    NSLog(@"%d",[songs1 intValue]);
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Karaoke Music";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
     [self logEnvironment];
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
    paging=1;
    
    self.songTableView.tableFooterView = [[UIView alloc] init] ;
    [[proView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[proView layer] setBorderWidth:1.0];
    [[proView layer] setCornerRadius:5];
    songsArray = [[NSMutableArray alloc]init];
    availableSongsObj=[[AvailableSongs alloc]init];
    availbleAlbumObj=[[AvailableAlbums alloc]init];
    videosInAlbumObj=[[videosInAlbum alloc]init];
    songNameInAlbum = [[NSMutableArray alloc]init];
    albumList=[[NSMutableArray alloc]init];
    trackCodeArray = [[NSMutableArray alloc]init];
    mySongs *mySongsOBJ = [[mySongs alloc] init];
    [songsArray removeAllObjects];
    [songNameInAlbum removeAllObjects];
    [albumList removeAllObjects];
    [trackCodeArray removeAllObjects];
    
    [super viewDidLoad];
    
    user_UDID_Str=[[NSUserDefaults standardUserDefaults]valueForKey:@"user_UDID_Str"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    condition = YES;
    if (flag == 1) {
        [songstabOutlet setTitle:@"Free Songs" forState:UIControlStateNormal];
        [albumsTabOutlet setTitle:@"Free Albums" forState:UIControlStateNormal];
        [exitbtn setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        
    }
    else{
        [songstabOutlet setTitle:@"Latest Songs" forState:UIControlStateNormal];
        [albumsTabOutlet setTitle:@"Latest Albums" forState:UIControlStateNormal];
    }
    [defaults setObject:user_UDID_Str forKey:@"user_UDID_Str"];
    bytes=0;
    isSongsTab=YES;
    isAlbumsTab=NO;
    webserviceCode = 1;
    if (triggerValue==nil)
    {
        webserviceCode = 1;
        triggerValue=[NSString stringWithFormat:@"videos"];
    }
    if ([triggerValue isEqualToString:@"albums"])
    {
        webserviceCode=2;
        isAlbumsTab=YES;
    }
    songsList=[[NSMutableArray alloc]init];
    albumList =[[NSMutableArray alloc]init];
    videoArray =[[NSMutableArray alloc]init];
    songTableView.backgroundColor = [UIColor clearColor];
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];
    [self fetchSongs];
    [songTableView reloadData];
    if (flag == 3)
    {
        [self fetchTopSellers];
    }
}

- (void)logEnvironment {
    NSLog(@"Environment: %@. Accept credit cards? %d", self.environment, self.acceptCreditCards);
}


- (void)viewWillAppear:(BOOL)animated {
//    CoupnsViewController *cvc=[[CoupnsViewController alloc]init];
//    flag=cvc.flag;
    [self fetchSongs];
    [super viewWillAppear:YES];
    if (flag == 1) {
        [songstabOutlet setTitle:@"Free Songs" forState:UIControlStateNormal];
        [albumsTabOutlet setTitle:@"Free Albums" forState:UIControlStateNormal];
        [exitbtn setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        
    }
    else{
        [songstabOutlet setTitle:@"Latest Songs" forState:UIControlStateNormal];
        [albumsTabOutlet setTitle:@"Latest Albums" forState:UIControlStateNormal];
    }
     [PayPalMobile preconnectWithEnvironment:self.environment];
}

- (void)loadmore
{
    [self fetchSongs];
    [songTableView reloadData];
    NSLog(@"load more");
}

- (void)fetchSongs{
    [self disabled];
    songsArray = [[NSMutableArray alloc]init];
    availableSongsObj=[[AvailableSongs alloc]init];
    availbleAlbumObj=[[AvailableAlbums alloc]init];
    videosInAlbumObj=[[videosInAlbum alloc]init];
    songNameInAlbum = [[NSMutableArray alloc]init];
    albumList=[[NSMutableArray alloc]init];
    trackCodeArray = [[NSMutableArray alloc]init];
    [activityIndicatorObject startAnimating];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/NewRelease",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *trigger;
    NSString *user_UDID;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(trigger==nil)
        trigger = [NSString stringWithFormat:@"%@",triggerValue];
    [request setPostValue:trigger forKey:@"Trigger"];
    
    if(user_UDID==nil)
        user_UDID = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Email"]];
    [request setPostValue:user_UDID forKey:@"user_email"];
    if (flag == 1) {
        [request setPostValue:@"Free" forKey:@"type"];
    }else{
    [request setPostValue:@"Paid" forKey:@"type"];
    }
     [request setPostValue:[NSString stringWithFormat:@"%d",paging] forKey:@"paging"];
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];

}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [activityIndicatorObject stopAnimating];
    [self enable];
    [songstabOutlet setUserInteractionEnabled:YES];
    [albumsTabOutlet setUserInteractionEnabled:YES];

    NSError *error = [request error];
    if (isDownloading)
    {UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Downloading Failed" message:@"Kindly check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        isDownloading=NO;
        [activityIndicatorObject stopAnimating];
        [self enable];
        proView.hidden=YES;
    }
    NSLog(@"res error :%@",error.description);
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSString *responseString = [request responseString];
    [songstabOutlet setUserInteractionEnabled:YES];
    [albumsTabOutlet setUserInteractionEnabled:YES];

    NSLog(@"response%@", responseString);
    if (isDownloading) {
        [activityIndicatorObject startAnimating];
        [self disabled];
      
    }else{
        [activityIndicatorObject stopAnimating];
        [self enable];
    }
    NSData *responseData = [request responseData];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    if (responseString ==nil) {
        
        if (isAlbumsTab) {
            [activityIndicatorObject stopAnimating];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, albumsOBJ.AlbumName];
              NSString *zipPath = [NSString stringWithFormat:@"%@/%@.zip", documentsDirectory, albumsOBJ.AlbumName];
            NSLog(@"filePath %@", filepath);
            videoID = albumsOBJ.AlbumId;
            ZipArchive *za = [[ZipArchive alloc] init];
            NSLog(@"zipPth..%@",zipPath);
            NSLog(@"filePath..%@",filepath);
            albumLocalUrl=filepath;
            
            if ([za UnzipOpenFile: zipPath])
            {
                BOOL ret = [za UnzipFileTo: filepath overWrite: YES];
                if (NO == ret){} [za UnzipCloseFile];
            }
            
            [[NSFileManager defaultManager] removeItemAtPath:zipPath error: NULL];
            BOOL isDir=NO;
            NSFileManager *manager = [NSFileManager defaultManager];
            if ([manager fileExistsAtPath:filepath isDirectory:&isDir] && isDir)
                subpaths = [manager subpathsAtPath:filepath];
            
            songsNameinAlbum = [manager subpathsAtPath:[NSString stringWithFormat:@"%@",filepath]];
            NSString *compresdFoldrPath=[[NSHomeDirectory()
                                          stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName]];
            
            for (int i=0; i<songsNameinAlbum.count; i++)
            {
                 NSString *str=[subpaths objectAtIndex:i];
                str = [str substringFromIndex: [str length] - 4];
                if ([str isEqualToString:@".mp4"]) {
                    NSString *songPath =[[NSHomeDirectory()
                                          stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",albumsOBJ.AlbumName,[songsNameinAlbum objectAtIndex:i]]];
                    
                    albumLocalUrl =[[NSHomeDirectory()
                                     stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[songsNameinAlbum objectAtIndex:i]]];
                    NSError *error;
                    
                    [[NSFileManager defaultManager] copyItemAtPath:songPath toPath:albumLocalUrl error:&error];
                   
                    NSString*albumLocalUrl1 =[NSString stringWithFormat:@"%@",[songsNameinAlbum objectAtIndex:i]];
                    [songsArray addObject:albumLocalUrl1];
                }
            }
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:compresdFoldrPath error: &error];
            
            NSLog(@"%@",filepath);
            NSLog(@"%@",albumsOBJ.AlbumName);
            NSLog(@"%@",albumLocalUrl);
            NSLog(@"%@",songsArray);
            NSLog(@"subPath..%@",subpaths);
        }
        self.progressLabel.text=@"100%";
        proView.hidden=YES;
        [self enable];
        [self saveSongs];
        
        if (flag==0) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
            
            int countSong=[songCount intValue];
            
            NSLog(@"total %@",totalSongsStr);
            NSLog(@"IDS %d,%d",albumsOBJ.AlbumId,songsOBJ.VideoId);
           
            
            
            if ([totalSongsStr intValue]>0)
            {
                if (isAlbumsTab) {
                    if([albumsOBJ.itemStatus isEqualToString:@"0"]){
                    videoID= albumsOBJ.AlbumId;
                    creditsToSave = countSong;
                    [defaults setObject:[NSString stringWithFormat:@"%d",[totalSongsStr intValue] -countSong] forKey:@"totalSongs"];
                    }
                }
                else{
                    if([obj.itemStatus isEqualToString:@"0"]){
                    videoID=songsOBJ.VideoId;
                    creditsToSave = 1;
                    [defaults setObject:[NSString stringWithFormat:@"%d",[totalSongsStr intValue]-1] forKey:@"totalSongs"];
                    }
                }
                
                
                NSString *songs1 = [defaults objectForKey:@"totalSongs"];
                NSLog(@"songs %d", [songs1 intValue]);
                NSLog(@"%d",[songs1 intValue]);
            }
           
            
            [defaults synchronize];

            
        }
        
        [activityIndicatorObject stopAnimating];
          isDownloading= NO;
        if (isAlbumsTab) {
            if([albumsOBJ.itemStatus isEqualToString:@"0"]){
                [self saveTransaction:creditsToSave:videoID];
            }
        }else{
            if ([obj.itemStatus isEqualToString:@"0"]){
                [self saveTransaction:creditsToSave:videoID];
            }
        }
        [self fetchSongs];
        if (isAlbumsTab) {
            UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Download Complete" message:@"Do you want to play this album?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Later", nil];
            alrt.tag = 5;
            [alrt show];
        }
        else{
            UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Download Complete" message:@"Do you want to play this song?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Later", nil];
            alrt.tag = 5;
            [alrt show];
        }
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if (alertView.tag == 10 && buttonIndex == 1)
    {
        CoupnsViewController *coupnVc;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            coupnVc=[[CoupnsViewController alloc]initWithNibName:@"CoupnsViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            coupnVc=[[CoupnsViewController alloc]initWithNibName:@"CoupnsViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else{
            coupnVc=[[CoupnsViewController alloc]initWithNibName:@"CoupnsViewController_ipad" bundle:Nil];
        }
        [self.navigationController pushViewController:coupnVc animated:YES];
        
    //  [self purchaseMyProduct:[validProducts objectAtIndex:0]];
    // [self downloadNow:nil];
    }
    else if(alertView.tag ==3 && buttonIndex == 1)
    {
        [self songDownloading];
    }
    else if(alertView.tag ==99 && buttonIndex == 0)
    {
        [self songDownloading];
    }

    else if(alertView.tag == 4 && buttonIndex == 1)
    {
        MySongsViewController*mySongsVC;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            mySongsVC=[[MySongsViewController alloc]initWithNibName:@"MySongsViewController" bundle:Nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            mySongsVC=[[MySongsViewController alloc]initWithNibName:@"MySongsViewController_iphone4" bundle:Nil];
            // this is iphone 4 xib
        }
        else{
            mySongsVC=[[MySongsViewController alloc]initWithNibName:@"MySongsViewController_ipad" bundle:Nil];
        }
        [self.navigationController pushViewController:mySongsVC animated:YES];
        self.menuView.hidden = YES;
        self.freeMenuView.hidden = YES;
    }
    else if(alertView.tag ==5 && buttonIndex == 0)
    {
        
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
        
        if (isAlbumsTab) {
            musicPlayerVc.isAlbumTab=YES;
            musicPlayerVc.songsList=songsArray;
            musicPlayerVc.songsNameList=songNameInAlbum;
        }
        else{
            [songsArray addObject:[NSString stringWithFormat:@"%@",songLocalUrl]];
            musicPlayerVc.songsList=songsArray;
            NSMutableArray *songNameArray=[[NSMutableArray alloc]init];
            NSLog(@"Name is %@",songsOBJ.VideoName);
            [songNameArray addObject:songsOBJ.VideoName];
            musicPlayerVc.songsNameList=songNameArray;
            musicPlayerVc.isAlbumTab=NO;
        }
        musicPlayerVc.isDownlodedSong=YES;
        [self.songTableView reloadData];
        [self.navigationController pushViewController:musicPlayerVc animated:YES];
    }
    else if(alertView.tag ==6 && buttonIndex == 1){
        [UIApplication sharedApplication].applicationIconBadgeNumber=0;
        exit(0);
        
    }
}
- (void)saveSongs{
    proView.hidden=YES;
    [self.view setUserInteractionEnabled:YES];
    
    [progressBar setProgress: 0.];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *insertSQLQuery;
    int albumid = -1;
    
    NSURL *bgImageURL = [NSURL URLWithString:songsOBJ.ThumbnailUrl];
    NSData *bgImageData = [NSData dataWithContentsOfURL:bgImageURL];
    UIImage *img = [UIImage imageWithData:bgImageData];
    
    CGSize size=[img size] ;
    NSLog(@"%f",size.width);
    NSLog(@"%f",size.height);
    
    CGRect rect = CGRectMake(0,0,50,50);
    UIGraphicsBeginImageContext(rect.size);
    [img drawInRect:rect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSDate *now = [NSDate date];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd/MM/yyyy"];
    BuyDate=[[NSString alloc]initWithString:[df stringFromDate:now]];
    UIImage *small = [UIImage imageWithCGImage:img.CGImage scale :0.25 orientation:img.imageOrientation];
    NSData* data = UIImageJPEGRepresentation(small,0.1f);
    strEncodedImage = [Base64 encode:data];
    
    if (isAlbumsTab)
    {
        NSString *insertSQL  = [NSString stringWithFormat:@"INSERT INTO Albums (albumName,albumImage,thumbnail,artistName,numberOfSongs,serverUrl,albumBuyDate,AlbumCode) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\",%d,\"%@\", \"%@\",\"%@\")",albumsOBJ.AlbumName,strEncodedImage,albumsOBJ.ThumbnailUrl,albumsOBJ.ArtistName,[albumsOBJ.Songs intValue],albumsOBJ.AlbumUrl ,BuyDate,albumsOBJ.AlbumCode];
        [database executeUpdate:insertSQL];
        NSString *queryStr = [NSString stringWithFormat:@"Select max(albumId) from Albums "];
        int count = [database intForQuery:queryStr];
        
        for ( int i=0;i<songsArray.count; i++)  {
            NSString *songTrackcode=[[albumsOBJ.videoAlbumArray valueForKey:@"TrackCode"] objectAtIndex:i];
            NSString *songArtistName=[[albumsOBJ.videoAlbumArray valueForKey:@"videoArtistName"]objectAtIndex:i];
            NSString *songDuration=[[albumsOBJ.videoAlbumArray valueForKey:@"Duration"]objectAtIndex:i];
            NSString *songThumnailUrl=[[albumsOBJ.videoAlbumArray valueForKey:@"videoThumbnailUrl"]objectAtIndex:i];
            
            videoUrlinAlbum=[NSString stringWithFormat:@"%@",[songsArray objectAtIndex:i]];
            videoNameinAlbum=[[albumsOBJ.videoAlbumArray valueForKey:@"VideoName"]objectAtIndex:i];
            [songNameInAlbum addObject:videoNameinAlbum];
            
            insertSQLQuery  = [NSString stringWithFormat:@"INSERT INTO Songs (songName,localUrl,thumbnail, songImage,artistName,albumId,albumName,songBuyDate,Trackcode,Duration) VALUES ( \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", %d,\"%@\",\"%@\",\"%@\",\"%@\")",videoNameinAlbum,videoUrlinAlbum,songThumnailUrl,strEncodedImage,songArtistName,count,albumsOBJ.AlbumName,BuyDate,songTrackcode,songDuration];
            [database executeUpdate:insertSQLQuery];
        
        }

    }
    else
    {
        insertSQLQuery  = [NSString stringWithFormat:@"INSERT INTO Songs (songName,serverUrl,localUrl,thumbnail, songImage,artistName,albumId,albumName,songBuyDate,Trackcode,Duration) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", %d,\"%@\",\"%@\",\"%@\",\"%@\")",songsOBJ.VideoName,songsOBJ.VideoUrl,songLocalUrl,songsOBJ.ThumbnailUrl,strEncodedImage,songsOBJ.ArtistName,albumid,songsOBJ.AlbumName,BuyDate,songsOBJ.trackcode,songsOBJ.duration];
        [database executeUpdate:insertSQLQuery];
    }
    [database close];
}

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict
{
    if (webserviceCode == 2)
    {
        if ([elementName isEqualToString:@"Album"]){
            availbleAlbumObj =[[AvailableAlbums alloc]init];
            videoArray =[[NSMutableArray alloc]init];
        }  else if ([elementName isEqualToString:@"AlbumID"]){
            tempString = [[NSMutableString alloc] init];
        }  else if ([elementName isEqualToString:@"AlbumCode"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AlbumUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AlbumThumbnailUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AlbumPrice"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AlbumArtistName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AlbumName"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"NoOfSongs"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"Type"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"UploadDate"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"VideoList"]){
            //tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"Video"]){
            videosInAlbumObj=[videosInAlbum alloc];
        }else if([elementName isEqualToString:@"VideoID"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"TrackCode"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"AlbumId"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"VideoUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"SampleVideoUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"VideoName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ThumbnailUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"ArtistName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Duration"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"NextPage"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }
    }else if (webserviceCode == 3){
        if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }

    }else if (webserviceCode == 4){
        if ([elementName isEqualToString:@"video"]){
            availableSongsObj = [AvailableSongs alloc];
        }else if ([elementName isEqualToString:@"VideoId"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"TrackCode"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"VideoUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"SampleVideoUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"VideoName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"VideoPrice"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ThumbnailUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ArtistName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AlbumName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Duration"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Songs"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"Type"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"IsActive"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"UploadDate"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"NextPage"]){
            tempString = [[NSMutableString alloc] init];
        }
        
    }
    else
    {
        if ([elementName isEqualToString:@"video"]){
            availableSongsObj = [AvailableSongs alloc];
        }else if ([elementName isEqualToString:@"VideoId"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"TrackCode"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"VideoUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"SampleVideoUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"VideoName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ThumbnailUrl"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ArtistName"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Duration"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"IsActive"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"UploadDate"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"TransDate"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"user_email"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            tempString = [[NSMutableString alloc] init];
        }
    }
}



//---when the text in an element is found---
- (void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    [tempString appendString:string];
}
//---when the end of element is found---
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (webserviceCode==2)
    {
        if([elementName isEqualToString:@"Album"]){
            [albumList addObject:availbleAlbumObj];
        } else if ([elementName isEqualToString:@"AlbumID"]){
            availbleAlbumObj.AlbumId = [tempString intValue];
        } else if ([elementName isEqualToString:@"AlbumCode"]){
            availbleAlbumObj.AlbumCode=  [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"AlbumUrl"]){
            availbleAlbumObj.AlbumUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"AlbumThumbnailUrl"]){
            availbleAlbumObj.ThumbnailUrl = [NSString stringWithFormat:@"%@", tempString];
        } else if ([elementName isEqualToString:@"AlbumPrice"]){
            availbleAlbumObj.AlbumPrice = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"AlbumArtistName"]){
            availbleAlbumObj.ArtistName = [NSString stringWithFormat:@"%@", tempString];
            NSLog(@"%@",availbleAlbumObj.ArtistName);
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            availbleAlbumObj.itemStatus = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"AlbumName"]){
            availbleAlbumObj.AlbumName = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"NoOfSongs"]){
            if ([tempString isEqualToString:@"1"])
            {
                availbleAlbumObj.Songs = [NSString stringWithFormat:@"%@", tempString];
            }
            else{
                availbleAlbumObj.Songs = [NSString stringWithFormat:@"%@", tempString];
            }
        }else if ([elementName isEqualToString:@"Type"]){
           availbleAlbumObj.type = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"UploadDate"]){
            availbleAlbumObj.albumUploadDate= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoList"]){
          // NSString *videoList= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Video"]){
            [videoArray  addObject:videosInAlbumObj];
            availbleAlbumObj.videoAlbumArray=videoArray;
        }else if ([elementName isEqualToString:@"VideoID"]){
          videosInAlbumObj.videoId = [tempString intValue];
        }else if ([elementName isEqualToString:@"TrackCode"]){
           videosInAlbumObj.TrackCode= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoUrl"]){
           videosInAlbumObj.VideoUrl= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"SampleVideoUrl"]){
            videosInAlbumObj.SampleVideoUrl= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoName"]){
          videosInAlbumObj.VideoName=[NSString stringWithFormat:@"%@", tempString];
        } else if ([elementName isEqualToString:@"ThumbnailUrl"]){
          videosInAlbumObj.videoThumbnailUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"ArtistName"]){
          videosInAlbumObj.videoArtistName = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Duration"]){
           videosInAlbumObj.Duration = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Result"]){
            result = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Message"]){
            message = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            HaveRecords = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"NextPage"]){
            NextPage = [NSString stringWithFormat:@"%@", tempString];
            if ( [HaveRecords intValue]==1)
            {
                paging=[NextPage intValue];
            }
            if (albumList.count==0)
            {
                songTableView.tableFooterView = [[UIView alloc] init];
            }
            [songTableView reloadData];
        }else if([elementName isEqualToString:@"AlbumList"])
        {
           
                songTableView.tableFooterView = [[UIView alloc] init];
            [songTableView reloadData];
        }
    }else if (webserviceCode == 3){
        if ([elementName isEqualToString:@"Result"]){
            message = [NSString stringWithFormat:@"%@", tempString];
            NSLog(@"Message %@",message);
        }

    }else if (webserviceCode == 4){
        if([elementName isEqualToString:@"video"]){
            [songsList addObject:availableSongsObj];
        }else if ([elementName isEqualToString:@"VideoId"]){
            availableSongsObj.VideoId = [tempString intValue];
        }else if ([elementName isEqualToString:@"TrackCode"]){
            availableSongsObj.trackcode = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoUrl"]){
            availableSongsObj.VideoUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"SampleVideoUrl"]){
            availableSongsObj.samplevideoUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoName"]){
            availableSongsObj.VideoName = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"ThumbnailUrl"]){
            availableSongsObj.ThumbnailUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"ArtistName"]){
            availableSongsObj.ArtistName = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Duration"]){
            availableSongsObj.duration= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"IsActive"]){
            availableSongsObj.IsActive = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"UploadDate"]){
            availableSongsObj.UploadDate= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"TransDate"]){
            availableSongsObj.transactionDate = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"user_email"]){
            availableSongsObj.email= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            availableSongsObj.itemStatus = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Result"]){
            result = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            HaveRecords = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"NextPage"]){
            NextPage = [NSString stringWithFormat:@"%@", tempString];
            if ( [HaveRecords intValue]==1)
            {
                paging=[NextPage intValue];
            }
            if (songsList.count==0)
            {
                songTableView.tableFooterView = [[UIView alloc] init];
            }
            [self moveTable];
            [songTableView reloadData];
            
        }else if ([elementName isEqualToString:@"Message"]){
            message = [NSString stringWithFormat:@"%@", tempString];
        }else if([elementName isEqualToString:@"DocumentElement"]){
            if (songsList.count==0)
            {
                songTableView.tableFooterView = [[UIView alloc] init];
            }
            [self moveTable];
            
            [songTableView reloadData];
        }
    }
    else
    {
        if([elementName isEqualToString:@"video"]){
            [songsList addObject:availableSongsObj];
        }else if ([elementName isEqualToString:@"VideoId"]){
            availableSongsObj.VideoId = [tempString intValue];
        }else if ([elementName isEqualToString:@"TrackCode"]){
            availableSongsObj.trackcode = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoUrl"]){
            availableSongsObj.VideoUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"SampleVideoUrl"]){
           availableSongsObj.samplevideoUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoName"]){
            availableSongsObj.VideoName = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"VideoPrice"]){
            availableSongsObj.VideoPrice = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"ThumbnailUrl"]){
            availableSongsObj.ThumbnailUrl = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"ArtistName"]){
            availableSongsObj.ArtistName = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"AlbumName"]){
            availableSongsObj.AlbumName = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Duration"]){
            availableSongsObj.duration= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Songs"]){
            if ([tempString isEqualToString:@"1"])
            {
                availableSongsObj.Songs = [NSString stringWithFormat:@"%@ Song", tempString];
            }
            else{
                availableSongsObj.Songs = [NSString stringWithFormat:@"%@ Songs", tempString];
            }
        }else if ([elementName isEqualToString:@"Type"]){
            availableSongsObj.Type = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"IsActive"]){
            availableSongsObj.IsActive = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"UploadDate"]){
            availableSongsObj.UploadDate= [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            availableSongsObj.itemStatus = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"Result"]){
            result = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            HaveRecords = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"NextPage"]){
            NextPage = [NSString stringWithFormat:@"%@", tempString];
            if ( [HaveRecords intValue]==1)
            {
                paging=[NextPage intValue];
            }
            if (songsList.count==0)
            {
                songTableView.tableFooterView = [[UIView alloc] init];
            }
            [songTableView reloadData];

        }else if ([elementName isEqualToString:@"Message"]){
            message = [NSString stringWithFormat:@"%@", tempString];
        }else if([elementName isEqualToString:@"DocumentElement"]){
            if (songsList.count==0)
            {
                songTableView.tableFooterView = [[UIView alloc] init];
            }
            [songTableView reloadData];
        }
    }
}

- (void)buyNow:(UIControl *)sender{
    
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSString *queryString ;
    index = indexPath.row;
    if (isAlbumsTab) {
        albumsOBJ = (AvailableAlbums *)[albumList objectAtIndex:indexPath.row];
    }else{
        obj=(AvailableSongs *)[songsList objectAtIndex:indexPath.row];
    }
    
    mySongs *mysongObj=[[mySongs alloc]init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    if (isAlbumsTab)
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Albums where AlbumCode = \"%@\"",albumsOBJ.AlbumCode];
    }
    else
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Songs where Trackcode = \"%@\"",obj.trackcode];
    }
    FMResultSet *results = [database executeQuery:queryString];
    trackCodeArray = [[NSMutableArray alloc]init];
    while([results next]) {
        
        if (isAlbumsTab) {
            mysongObj.AlbumId = [results intForColumn:@"albumId"];
            mysongObj.AlbumName = [results stringForColumn:@"albumName"];
            NSLog(@"albumName..%@",mysongObj.AlbumName);
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
            mysongObj.albumCode=[results stringForColumn:@"AlbumCode"];
            [trackCodeArray addObject:mysongObj.albumCode];
        }
        else
        {
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
            [trackCodeArray addObject:mysongObj.songTrackCode];
        }
    }
    
    NSLog(@"Track Code is %@", trackCodeArray);
    NSLog(@"Track the URL %@", videoURLStr);
    NSLog(@"Table songs Track code %@",obj.trackcode);

    
    if ([trackCodeArray containsObject:obj.trackcode] || [trackCodeArray containsObject:albumsOBJ.AlbumCode] ) {
        NSString *message1;
        if (isAlbumsTab) {
            message1 = @"You already have this  Album";
        }else{
            message1 = @"You already have this  Song";
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 4;
        [alert show];
        
    }else if([obj.itemStatus isEqualToString:@"1"] || [albumsOBJ.itemStatus isEqualToString:@"1"]){
        [self songDownloading];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
        
        NSLog(@"totalSongs %d",[totalSongsStr intValue]);
        
        
        NSString *message1 ,*message2;
        UIAlertView *alert;
        if (isAlbumsTab) {
            message1 = @"You don't have enough credits to buy this album.";
            message2= @"Do you want to purchase this album?";
        }else{
            message1 = @"You don't have enough credits to buy this track.";
            message2= @"Do you want to purchase this track?";
        }
        
        if (isAlbumsTab)
        {
            if ([totalSongsStr intValue] >[songCount intValue])
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message2 ]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 3;
            }
            else
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ]   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 10;
            }
            
        }
        else{
            if ([totalSongsStr intValue] >0)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message2 ]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 3;
            }
            else
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ]   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 10;
            }
            
        }
        
        [alert show];
    }
    
}





#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    [self songDownloading];

}

- (void)paymentFailedWithCorrelationID:(NSString *)correlationID andErrorCode:(NSString *)errorCode andErrorMessage:(NSString *)errorMessage {
    UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"We're Sorry" message:@"System error.Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    
    NSLog(@"PAYMENTSTATUS_FAILED");
}


- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"We're Sorry" message:@"You cancelled the transaction." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    //self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}


- (void)downloadNow:(UIControl *)sender{
    self.resultText = nil;
    PayPalItem *song;
    PayPalPayment *payment = [[PayPalPayment alloc] init];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    if(isAlbumsTab){
        albumsOBJ = (AvailableAlbums *)[albumList objectAtIndex:index];
        song = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName]
                           withQuantity:1
                              withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumPrice]]
                           withCurrency:@"GBP"
                                withSku:[NSString stringWithFormat:@"%@",albumsOBJ.TrackCode]];
        payment.shortDescription =[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName];
    }
    else{
        songsOBJ = (AvailableSongs *)[songsList objectAtIndex:index];
        NSLog(@"%@", songsOBJ.AlbumName);
        song = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@",songsOBJ.VideoName]
                           withQuantity:1
                              withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",songsOBJ.VideoPrice]]
                           withCurrency:@"GBP"
                                withSku:[NSString stringWithFormat:@"%@",songsOBJ.trackcode]];
        payment.shortDescription =[NSString stringWithFormat:@"%@",songsOBJ.VideoName];
    }
    
    
    NSArray *items = @[song];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    payment.amount = total;
    payment.currencyCode = @"GBP";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfig delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
    AccountDetailViewController *accountVc;
   
    if(isAlbumsTab){
        accountVc.isSongs=NO;
        accountVc.isAlbum=YES;
        accountVc.albumsOBJ=albumsOBJ;
    }else{
        accountVc.isSongs=YES;
        accountVc.isAlbum=NO;
        accountVc.songsOBJ=songsOBJ;
        NSLog(@"%@",songsOBJ.AlbumName);
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isAlbumsTab) {
        return albumList.count;
    }
    else{
         return songsList.count;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       static NSString *simpleTableIdentifier = @"ArticleCellID";
    UIButton *buyBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *samplevideoBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        if (flag == 1) {
            buyBtn.frame = CGRectMake(245.0f, 38.0, 45.0f, 20.0f);
        }else{
        buyBtn.frame = CGRectMake(245.0f, 30.0, 45.0f, 20.0f);
        }
        samplevideoBtn.frame = CGRectMake(10.0f, 6.0f, 60.0f, 52.0f);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        if (flag == 1) {
            buyBtn.frame = CGRectMake(239.0f, 35.0, 45.0f, 20.0f);
        }else{
        buyBtn.frame = CGRectMake(239.0f, 30.0f, 45.0f, 20.0f);
        }
        samplevideoBtn.frame = CGRectMake(10.0f, 6.0f, 60.0f, 52.0f);
        //this is iphone 4 xib
    }
    else{
        if (flag == 1) {
            buyBtn.frame = CGRectMake(600.0f, 65.0, 105.0f, 45.0f);
        }else{
            buyBtn.frame = CGRectMake(600.0f, 65.0, 105.0f, 40.0f);
        }
        samplevideoBtn.frame = CGRectMake(10.0f, 11.0f,107.0f,107.0f);
    
    }
    NSLog(@"Items Status %@",availableSongsObj.itemStatus);
    buyBtn.tag = indexPath.row;
    samplevideoBtn.tag = indexPath.row;
    UIImage *buttonBackgroundImage;
    AvailableAlbums *albumsOBJ1;
    AvailableSongs *obj1;
    NSLog(@"IndexPath %ld",(long)indexPath.row);
   
    if (isAlbumsTab) {
         NSLog(@"Album %@",[albumList objectAtIndex:indexPath.row]);
   albumsOBJ1 =(AvailableAlbums*) [albumList objectAtIndex:indexPath.row];
    }else{
   obj1=(AvailableSongs*)[songsList objectAtIndex:indexPath.row];
    }
    
    songsStatus = [NSString stringWithFormat:@"%@",obj1.itemStatus];
    albumStatus = [NSString stringWithFormat:@"%@",albumsOBJ1.itemStatus];
    if  ([obj1.itemStatus isEqualToString:@"0"]||[albumsOBJ1.itemStatus isEqualToString:@"0"]) {
        buttonBackgroundImage = [UIImage imageNamed:@"buy-now-btn.png"];
    }else{
        buttonBackgroundImage = [UIImage imageNamed:@"Download-btn.png"];
    }
    
        [buyBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
   

    AvailableAlbumsCell *cell;
    AvailbleSongsCell *cell1;
    
    if (isAlbumsTab)
    {
        cell = (AvailableAlbumsCell *)[songTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSArray *nib;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
           nib = [[NSBundle mainBundle] loadNibNamed:@"AvailableAlbumsCell" owner:self options:nil];
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailableAlbumsCell" owner:self options:nil];
            //this is iphone 4 xib
        }
        else{
           nib = [[NSBundle mainBundle] loadNibNamed:@"AvailableAlbumsCell_ipad" owner:self options:nil];
        }
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        AvailableAlbums *obj1 = (AvailableAlbums *)[albumList objectAtIndex:indexPath.row];
        if (flag == 1) {
            if ([obj1.Songs isEqualToString:@"1"]) {
                [cell setLabelText:obj1.AlbumName :[NSString stringWithFormat:@"(%@ Credit)",obj1.Songs] :obj1.ArtistName :[NSString stringWithFormat:@"%@ Song",obj1.Songs] :obj1.ThumbnailUrl ];
            }else{
            [cell setLabelText:obj1.AlbumName :[NSString stringWithFormat:@"(%@ Credits)",obj1.Songs] :obj1.ArtistName :[NSString stringWithFormat:@"%@ Songs",obj1.Songs] :obj1.ThumbnailUrl ];
            }
        }else{
            if ([obj1.Songs isEqualToString:@"1"]) {
                [cell setLabelText:obj1.AlbumName :[NSString stringWithFormat:@"(%@ Credit)",obj1.Songs] :obj1.ArtistName :[NSString stringWithFormat:@"%@ Song",obj1.Songs] :obj1.ThumbnailUrl ];
            }else{
         [cell setLabelText:obj1.AlbumName :[NSString stringWithFormat:@"(%@ Credits)",obj1.Songs] :obj1.ArtistName :[NSString stringWithFormat:@"%@ Songs",obj1.Songs]  :obj1.ThumbnailUrl ];
            }
        }
        [cell.contentView addSubview:buyBtn];
    }
    else{
        cell1 = (AvailbleSongsCell *)[songTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
        NSArray *nib;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
          nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
          nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
            //this is iphone 4 xib
        }
        else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell_ipad" owner:self options:nil];
        }
        cell1 = [nib objectAtIndex:0];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.backgroundColor=[UIColor clearColor];
        [cell1.contentView addSubview:buyBtn];
        obj = (AvailableSongs *)[songsList objectAtIndex:indexPath.row];
        if (flag == 1) {
        [cell1 setLabelText:obj.ArtistName :obj.trackcode :obj.VideoName :obj.duration :@""];
        }else{
        [cell1 setLabelText:obj.ArtistName :obj.trackcode :obj.VideoName :obj.duration :obj.VideoPrice];
        }
        [cell1.contentView addSubview:samplevideoBtn];
    }
    
    [samplevideoBtn addTarget:self action:@selector(sampleVideo:) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![HaveRecords isEqualToString:@"0"])
    {
        UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 70)];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            [button setFrame:CGRectMake(0, 0, 300, 50)];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            [button setFrame:CGRectMake(0, 0, 300, 50)];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
                // this is iphone 4 xib
        }
        else{
            [button setFrame:CGRectMake(8, 0, 732, 60)];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];
        }
        
        //set title, font size and font color
        [button setBackgroundImage:[UIImage imageNamed:@"readMoreBtn.png"] forState:UIControlStateNormal];
        [button setTitle:@"Load more" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loadmore) forControlEvents:UIControlEventTouchUpInside];
            
        UIImageView *cellGradient = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellGradient.png"]];
        cellGradient.frame = CGRectMake(0, 0, 320, 0);
        [footerView addSubview:cellGradient];
        //add the button to the view
        [footerView addSubview:button];
        footerView.userInteractionEnabled = YES;
        self.songTableView.tableFooterView = footerView;
        self.songTableView.tableFooterView.userInteractionEnabled = YES;
    }
    else{
        tableView.tableFooterView = nil;
    }

    if (isAlbumsTab){
        return cell;
    }else{
        return cell1;
    }
}
- (void)sampleVideo:(UIControl *)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    AvailableSongs *songsObj;
    
    songsObj = (AvailableSongs *)[songsList objectAtIndex:indexPath.row];
    
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
    
    musicPlayerVc.sampleVideoUrl=[NSString stringWithFormat:@"%@",songsObj.samplevideoUrl];
    NSLog(@"%@",musicPlayerVc.sampleVideoUrl);
    musicPlayerVc.SongNameStr=songsObj.VideoName;
        musicPlayerVc.isAlbumTab=NO;
    [self.navigationController pushViewController:musicPlayerVc animated:YES];
}
- (void)conversionImage:(NSString *)imageUrl
{
    NSString *Str=[NSString stringWithFormat:@"%@",imageUrl];
    NSURL *bgImageURL = [NSURL URLWithString:Str];
    NSData *bgImageData = [NSData dataWithContentsOfURL:bgImageURL];
    UIImage *img = [UIImage imageWithData:bgImageData];
    
    CGSize size=[img size] ;
    NSLog(@"%f",size.width);
    NSLog(@"%f",size.height);
    CGRect rect = CGRectMake(0,0,50,50);
    UIGraphicsBeginImageContext(rect.size);
    [img drawInRect:rect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *small = [UIImage imageWithCGImage:img.CGImage scale :0.25 orientation:img.imageOrientation];
    NSData* data = UIImageJPEGRepresentation(small,0.1f);
    strEncodedImage = [Base64 encode:data];
    NSLog(@"%@",strEncodedImage);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SongsDetailViewController *songDetailVc;
    if(isAlbumsTab){
        albumsOBJ = (AvailableAlbums *)[albumList objectAtIndex:indexPath.row];
    }else{
        songsOBJ = (AvailableSongs *)[songsList objectAtIndex:indexPath.row];
    }
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        songDetailVc=[[SongsDetailViewController alloc]initWithNibName:@"SongsDetailViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480){
       songDetailVc=[[SongsDetailViewController alloc]initWithNibName:@"SongsDetailViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        songDetailVc=[[SongsDetailViewController alloc]initWithNibName:@"SongsDetailViewController_ipad" bundle:Nil];
    }
    if(isAlbumsTab){
        songDetailVc.isVideos=NO;
        songDetailVc.isAlbum=YES;
        songDetailVc.albumsOBJ=albumsOBJ;
    }else{
        songDetailVc.isVideos=YES;
        songDetailVc.isAlbum=NO;
        songDetailVc.songsOBJ=songsOBJ;
        NSLog(@"%@",songsOBJ.AlbumName);
    }
    songDetailVc.user_UDID_Str=user_UDID_Str;
    [self.navigationController pushViewController:songDetailVc animated:YES];
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
         return 73.0;
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480){
         return 70.0;
    }
    else{
        return 138.0;
    }
}

- (IBAction)freeSongsbtn:(id)sender {
    flag = 1;
    [self viewDidLoad];
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
    [exitbtn setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
}

- (IBAction)topSellersBtn:(id)sender {
    flag = 0;
    [self fetchTopSellers];
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
}

-(void)fetchTopSellers
{
    [self disabled];
    [activityIndicatorObject startAnimating];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/GetTopSellers",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    songsList = [[NSMutableArray alloc]init];
    NSString *user_email;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    webserviceCode = 4;
    if(user_email==nil)
        user_email = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"Email"]];
    [request setPostValue:user_email forKey:@"User_email"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];

}
- (IBAction)backBtn:(id)sender {
    if (flag == 1){
    flag = 0;
    [self viewDidLoad];
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
    [exitbtn setBackgroundImage:[UIImage imageNamed:@"exit_btn.png"] forState:UIControlStateNormal];
        [self resetTable];
    }
    else{
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Do you want to close the application?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alrt.tag = 6;
        [alrt show];
    }
}

- (IBAction)mySongs:(id)sender {
    MySongsViewController*mySongsVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mySongsVC=[[MySongsViewController alloc]initWithNibName:@"MySongsViewController" bundle:Nil];
        
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        mySongsVC=[[MySongsViewController alloc]initWithNibName:@"MySongsViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        mySongsVC=[[MySongsViewController alloc]initWithNibName:@"MySongsViewController_ipad" bundle:Nil];

    }
    [self.navigationController pushViewController:mySongsVC animated:YES];
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
}

- (IBAction)songsTabBtn:(id)sender {
    paging=1;
    obj= [[AvailableSongs alloc] init];
    albumsOBJ = [[AvailableAlbums alloc] init];
    isSongsTab=YES;
    isAlbumsTab=NO;
    albumList=Nil;
    songsList=Nil;
    songsList=[[NSMutableArray alloc]init];
    webserviceCode = 1;
    triggerValue=@"videos";
    [songstabOutlet setBackgroundImage:[UIImage imageNamed:@"tw2_left"] forState:UIControlStateNormal];
    [albumsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tb2_right"] forState:UIControlStateNormal];
    [songstabOutlet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [albumsTabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [songstabOutlet setUserInteractionEnabled:NO];
    [self fetchSongs];
    [songTableView reloadData];
}

- (IBAction)albumsTabBtn:(id)sender{
    isSongsTab=NO;
    paging=1;
    isAlbumsTab=YES;
    albumList=Nil;
    songsList=Nil;
    obj= [[AvailableSongs alloc] init];
    albumsOBJ = [[AvailableAlbums alloc] init];
    albumList=[[NSMutableArray alloc]init];
    webserviceCode = 2;
    triggerValue=@"albums";
    [albumsTabOutlet setBackgroundImage:[UIImage imageNamed:@"tw2_right"] forState:UIControlStateNormal];
    [songstabOutlet setBackgroundImage:[UIImage imageNamed:@"tb2_left"] forState:UIControlStateNormal];
    [songstabOutlet setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [albumsTabOutlet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [albumsTabOutlet setUserInteractionEnabled:NO];
    [self fetchSongs];
    [songTableView reloadData];
}

- (IBAction)logoutBtn:(id)sender {
    
    loginViewController *loginVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        loginVC =[[loginViewController alloc] initWithNibName:@"loginViewController_ipad" bundle:Nil];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"YES"] forKey:@"isLogedOut"];
    [self.navigationController pushViewController:loginVC animated:YES];

    
}

- (IBAction)requestSongBtn:(id)sender {
    requestSongViewController *requestSongVC ;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        requestSongVC = [[requestSongViewController alloc] initWithNibName:@"requestSongViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        requestSongVC = [[requestSongViewController alloc] initWithNibName:@"requestSongViewController_iphone4" bundle:nil];
        
        // this is iphone 4 xib
    }
    else{
        requestSongVC = [[requestSongViewController alloc] initWithNibName:@"requestSongViewController_ipad" bundle:nil];
        
    }
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
    [self.navigationController pushViewController:requestSongVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)menubtn:(id)sender
{
    if (flag == 1)
    {
        if (freeMenuView.hidden==NO){
            freeMenuView.hidden=YES;
        }
        else{
            freeMenuView.hidden=NO;
        }
    }
    else
    {
        if (menuView.hidden==NO){
            menuView.hidden=YES;
        }else{
            menuView.hidden=NO;
        }
    }
}


- (IBAction)searchBtn:(id)sender {
    searchSongsViewController*searchSongsVC;
   
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        searchSongsVC=[[searchSongsViewController alloc]initWithNibName:@"searchSongsViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        searchSongsVC=[[searchSongsViewController alloc]initWithNibName:@"searchSongsViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        searchSongsVC=[[searchSongsViewController alloc]initWithNibName:@"searchSongsViewController_ipad" bundle:Nil];
    }
    
    [self.navigationController pushViewController:searchSongsVC animated:YES];
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
}
- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone || [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationPortrait;
}

- (void)songDownloading
{
    self.dataRecievedLbl.text=nil;
    bytes=0;
    self.progressLabel.text=@"0%";
    ASIHTTPRequest *request;
    isDownloading = YES;
    if(isAlbumsTab){
        albumsOBJ = (AvailableAlbums *)[albumList objectAtIndex:index];
        videoURLStr=albumsOBJ.AlbumUrl;
    }else{
        songsOBJ = (AvailableSongs *)[songsList objectAtIndex:index];
        NSLog(@"%@", songsOBJ.AlbumName);
        videoURLStr=songsOBJ.VideoUrl;
    }
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",videoURLStr]]];
    
    if (isAlbumsTab)
    {
        [request setDownloadDestinationPath:[[NSHomeDirectory()
                                              stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",albumsOBJ.AlbumName]]];
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%@.mp4",songsOBJ.VideoName];
        NSLog(@"%@",str);
        songLocalUrl=str;
        [request setDownloadDestinationPath:[[NSHomeDirectory()
                                              stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",songsOBJ.VideoName]]];
    }
    proView.hidden=NO;
    [self disabled];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        bytes= bytes+size;
        unsigned long long totalData=total/1024;
        self.dataRecievedLbl.text=[NSString stringWithFormat:@"%llukb/%llukb",bytes/1024,totalData];
        NSLog(@"%@",self.dataRecievedLbl.text);
        NSString *str = [NSString stringWithFormat:@"%f",(progressBar.progress)*100];
        progressStr =[str intValue];
        self.progressLabel.text=[NSString stringWithFormat:@"%d%%",progressStr];
    }];
    
    [request setDownloadProgressDelegate:progressBar];
    [request setDelegate:self];
    [request startAsynchronous];
    //[self viewDidLoad];
}

- (IBAction)creditButton:(id)sender {
    
    NSLog(@"flag== %d",flag);
    CoupnsViewController *coupnVc;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        coupnVc=[[CoupnsViewController alloc]initWithNibName:@"CoupnsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        coupnVc=[[CoupnsViewController alloc]initWithNibName:@"CoupnsViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        coupnVc=[[CoupnsViewController alloc]initWithNibName:@"CoupnsViewController_ipad" bundle:Nil];
    }
    coupnVc.flag=1;
    [self.navigationController pushViewController:coupnVc animated:YES];
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
    
}
-(void)saveTransaction:(int)creditsUsed: (int)videosID
{
    webserviceCode = 3;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/InsertVideoTransaction",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *UDID;
    NSString *Credits;
    NSString *videoIDToPass;
    
    if(UDID==nil)
        UDID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Email"]];
    [request setPostValue:UDID forKey:@"user_email"];
    
    if(Credits==nil)
        Credits = [NSString stringWithFormat:@"%d",creditsUsed];
    [request setPostValue:Credits forKey:@"CreditUsed"];
    
    if(videoIDToPass==nil)
        videoIDToPass = [NSString stringWithFormat:@"%d",videosID];
    [request setPostValue:videoIDToPass forKey:@"VideoID"];
    
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void) moveTable
{
    songstabOutlet.hidden = YES;
    albumsTabOutlet.hidden = YES;
    flag = 1;
    self.menuView.hidden = YES;
    self.freeMenuView.hidden = YES;
    [exitbtn setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [songTableView setFrame:CGRectMake(10, 78, 299, 483)];
        [self.tableBg setFrame:CGRectMake(10, 74, 300, 490)];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        [songTableView setFrame:CGRectMake(10, 78, 299, 395)];
        [self.tableBg setFrame:CGRectMake(10, 74, 300, 403)];
        // this is iphone 4 xib
    }
    else{
        [songTableView setFrame:CGRectMake(25, 155, 718, 836)];
        [self.tableBg setFrame:CGRectMake(20, 147, 728, 853)];
    }

    
}

-(void)resetTable
{
    songstabOutlet.hidden = NO;
    albumsTabOutlet.hidden = NO;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [songTableView setFrame:CGRectMake(10, 125, 299, 436)];
        [self.tableBg setFrame:CGRectMake(10, 121, 300, 443)];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        [songTableView setFrame:CGRectMake(10, 126, 299, 343)];
        [self.tableBg setFrame:CGRectMake(10, 123, 300, 353)];
        // this is iphone 4 xib
    }
    else{
        [songTableView setFrame:CGRectMake(25, 305, 718, 683)];
        [self.tableBg setFrame:CGRectMake(20, 297, 728, 700)];
    }

}
@end




