
//
//  searchSongsViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_1 on 4/18/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "searchSongsViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "MySongsViewController.h"
#import "AvailableAlbums.h"
#import "AvailableSongs.h"
#import "AvailbleSongsCell.h"
#import "AvailableAlbumsCell.h"
#import "videosInAlbum.h"
#import "base64.h"
#import "SongsDetailViewController.h"
#import "MusicPlayerViewController.h"
#import "AccountDetailViewController.h"
#import "ZipArchive.h"
#import "FMDatabaseAdditions.h"
#import "AvailableSongsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoupnsViewController.h"
#import "requestSongViewController.h"

//#define kPayPalEnvironment PayPalEnvironmentNoNetwork
#define kPayPalEnvironment PayPalEnvironmentProduction

@interface searchSongsViewController ()
{
    NSString *triggerValue;
    NSMutableArray *videoArray;
    NSString *NextPage;
    NSString *HaveRecords;
    NSString *user_UDID_Str;
    int index;
    int progressStr;
     NSArray *subpaths,*date;
    unsigned long long bytes;
    NSString *videoName ,*albumLocalUrl, *songLocalUrl;
    NSArray*songsNameinAlbum;
    NSString *BuyDate;
    NSString *videoUrlinAlbum, *videoNameinAlbum;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation searchSongsViewController
@synthesize searchTextFeildImage,activityIndicatorObject,searchTriggerValue,searchUser_UDID_Str,searchTxt,songsTab,AlbumTab,songListView,albumList,songsList,button,menuView,albumsOBJ,songsOBJ,proView,progressBar,progressLabel,dataRecievedLbl,disabledImgView,songsArray,searchBtnOutlet;
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
    songListView.dataSource = self;
    songListView.delegate = self;
    

    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
      self.songListView.tableFooterView = [[UIView alloc] init];
    availableSongsObj=[[AvailableSongs alloc]init];
    availbleAlbumObj=[[AvailableAlbums alloc]init];
    videosInAlbumObj=[[videosInAlbum alloc]init];
    albumList=[[NSMutableArray alloc]init];
    songsList=[[NSMutableArray alloc]init];
    videoArray=[[NSMutableArray alloc]init];
    trackCodeArray = [[NSMutableArray alloc]init];
    [[proView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[proView layer] setBorderWidth:1.0];
    [[proView layer] setCornerRadius:5];
    
    pagging=1;
    [super viewDidLoad];
    searchUser_UDID_Str=@"1";
    songsList=[[NSMutableArray alloc]init];
    albumList=[[NSMutableArray alloc ]init];
    isSongsTab=YES;
    isAlbumsTab=NO;
    if (triggerValue==nil)
    {
        triggerValue=[NSString stringWithFormat:@"videos"];
    }
    
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 100);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 100);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];
    

    [[searchTextFeildImage layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[searchTextFeildImage layer] setBorderWidth:1.0];
    [[searchTextFeildImage layer] setCornerRadius:7];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [PayPalMobile preconnectWithEnvironment:self.environment];
    // Preconnect to PayPal early
    // [PayPalMobile preconnectWithEnvironment:self.environment];
}

- (void)logEnvironment {
    NSLog(@"Environment: %@. Accept credit cards? %d", self.environment, self.acceptCreditCards);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchSongs:(id)sender {
        [self search];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    proView.hidden=YES;
    [activityIndicatorObject stopAnimating];
    [self enable];
    NSError *error = [request error];
    NSLog(@"res error :%@",error.description);
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zoom Karaoke!" message:@"Connection failure. Please check your internet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    songsNameinAlbum = [[NSMutableArray alloc] init];
    songsArray= [[NSMutableArray alloc] init];
    NSString *responseString = [request responseString];
    NSLog(@"%@",responseString);
    [activityIndicatorObject stopAnimating];
    NSLog(@"res of webservice 2:%@",responseString);
    NSData *responseData = [request responseData];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES]; [xmlParser parse];
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
        
        if (ispaidSong)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
            
            int countSong=[songCount intValue];
            
            NSLog(@"total %@",totalSongsStr);
           if ([albumsOBJ.itemStatus isEqualToString:@"0"] ||[songsOBJ.itemStatus isEqualToString:@"0"])
            {
            if ([totalSongsStr intValue]>0)
            {
                if (isAlbumsTab) {
                    videoID= albumsOBJ.AlbumId;
                    creditsToSave = countSong;
                    [defaults setObject:[NSString stringWithFormat:@"%d",[totalSongsStr intValue] -countSong] forKey:@"totalSongs"];
                }
                else{
                    videoID=songsOBJ.VideoId;
                    creditsToSave = 1;
                    [defaults setObject:[NSString stringWithFormat:@"%d",[totalSongsStr intValue]-1] forKey:@"totalSongs"];
                }
                
                
                NSString *songs1 = [defaults objectForKey:@"totalSongs"];
                NSLog(@"songs %d", [songs1 intValue]);
                NSLog(@"%d",[songs1 intValue]);
            }
            }
            [defaults synchronize];

        }
      
        [self searchSongs:nil];
        //[self.songListView reloadData];
        if (isAlbumsTab) {
            if([albumsOBJ.itemStatus isEqualToString:@"0"]){
                [self saveTransaction:creditsToSave:videoID];
            }
        }else{
            if ([songsOBJ.itemStatus isEqualToString:@"0"]){
                [self saveTransaction:creditsToSave:videoID];
            }
        }
        [self viewDidLoad];
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
    [searchBtnOutlet setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    isSearchClicked = YES;
    [self enable];
}
- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict

{
    
    if (  webserviceCode == 2)
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
        }else if([elementName isEqualToString:@"Video"])
        {
            videosInAlbumObj=[videosInAlbum alloc];
        }
        else if([elementName isEqualToString:@"VideoID"]){
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
        }else if([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"NextPage"]){
            tempString = [[NSMutableString alloc] init];
        }
    }else if (webserviceCode == 3){
        if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }
        
    }
    else{
        if ([elementName isEqualToString:@"video"]){
            availableSongsObj = [AvailableSongs alloc];
        }else if ([elementName isEqualToString:@"Row"]){
            tempString = [[NSMutableString alloc] init];
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
        }else if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"NextPage"]){
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
            availbleAlbumObj.AlbumPrice =[NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"AlbumArtistName"]){
            availbleAlbumObj.ArtistName = [NSString stringWithFormat:@"%@", tempString];
            NSLog(@"%@",availbleAlbumObj.ArtistName);
        }else if ([elementName isEqualToString:@"ItemStatus"]){
            availbleAlbumObj.itemStatus = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"AlbumName"]){
            availbleAlbumObj.AlbumName = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"NoOfSongs"]){
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
        }
        else if ([elementName isEqualToString:@"NextPage"]){
            NextPage = [NSString stringWithFormat:@"%@", tempString];
            if ( [HaveRecords intValue]==1)
            {
                pagging=[NextPage intValue];
            }
            if (albumList.count==0)
            {
                self.songListView.tableFooterView = [[UIView alloc] init];
            }
            [self.songListView reloadData];        }
        else if([elementName isEqualToString:@"AlbumList"])
        {
            if (albumList.count==0)
            {
                self.songListView.tableFooterView = [[UIView alloc] init];
            }
           [self.songListView reloadData];
        }
    }if (webserviceCode == 3){
        if ([elementName isEqualToString:@"Result"]){
            message = [NSString stringWithFormat:@"%@", tempString];
            NSLog(@"Message %@",message);
        }
        
    }
    else
    {
        if([elementName isEqualToString:@"video"]){
            [songsList addObject:availableSongsObj];
        }else if ([elementName isEqualToString:@"Row"]){
            availableSongsObj.row = [tempString intValue];
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
                availableSongsObj.Songs = [NSString stringWithFormat:@"%@", tempString];
            }
            else{
                availableSongsObj.Songs = [NSString stringWithFormat:@"%@", tempString];
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
        }else if ([elementName isEqualToString:@"Message"]){
            message = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"HaveRecords"]){
            HaveRecords = [NSString stringWithFormat:@"%@", tempString];
        }else if ([elementName isEqualToString:@"NextPage"]){
            NextPage = [NSString stringWithFormat:@"%@", tempString];
            if ( [HaveRecords intValue]==1)
            {
                pagging=[NextPage intValue];
            }
            if (songsList.count==0)
            {
                songListView.tableFooterView = [[UIView alloc] init];
            }
            [self.songListView reloadData];
        }else if([elementName isEqualToString:@"DocumentElement"]){
            if (songsList.count==0)
            {
                songListView.tableFooterView = [[UIView alloc] init];
            }
             [self.songListView reloadData];
        }
    }

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

    [self.navigationController pushViewController:requestSongVC animated:YES];
}

- (IBAction)topSellerbtn:(id)sender {
    AvailableSongsViewController *availableSongsVC ;
    
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        availableSongsVC = [[AvailableSongsViewController alloc] initWithNibName:@"AvailableSongsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        availableSongsVC = [[AvailableSongsViewController alloc] initWithNibName:@"AvailableSongsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        availableSongsVC = [[AvailableSongsViewController alloc] initWithNibName:@"AvailableSongsViewController_ipad" bundle:nil];
        
    }
    
    availableSongsVC.flag = 3;
    
    [self.navigationController pushViewController:availableSongsVC animated:YES];
}

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mySondBtn:(id)sender {
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
}


- (IBAction)SongsTabBtn:(id)sender {
    pagging=1;
    isSongsTab=YES;
    isAlbumsTab=NO;
    albumList=Nil;
    songsList=Nil;
    songsList=[[NSMutableArray alloc]init];
    webserviceCode = 1;
    triggerValue=@"videos";
    [songsTab setBackgroundImage:[UIImage imageNamed:@"tw2_left"] forState:UIControlStateNormal];
    [AlbumTab setBackgroundImage:[UIImage imageNamed:@"tb2_right"] forState:UIControlStateNormal];
    [songsTab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AlbumTab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
    [songListView reloadData];
    if (searchBtnOutlet.currentImage == [UIImage imageNamed:@"cross.png"]) {
        isSearchClicked = NO;
    }else{
        isSearchClicked = YES;
    }
    [self searchSongs:searchTxt.text];

}

- (IBAction)albumTabBtn:(id)sender {
    pagging=1;
    
    isSongsTab=NO;
    isAlbumsTab=YES;
    albumList=Nil;
    songsList=Nil;
    albumList=[[NSMutableArray alloc]init];
   // songListView=[[UITableView alloc]init];
    webserviceCode = 2;
    triggerValue=@"albums";
    [AlbumTab setBackgroundImage:[UIImage imageNamed:@"tw2_right"] forState:UIControlStateNormal];
    [songsTab setBackgroundImage:[UIImage imageNamed:@"tb2_left"] forState:UIControlStateNormal];
    [songsTab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [AlbumTab setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    if (searchBtnOutlet.currentImage == [UIImage imageNamed:@"cross.png"]) {
        isSearchClicked = NO;
    }else{
        isSearchClicked = YES;
    }
    [self searchSongs:searchTxt.text];
    [self.songListView reloadData];
}

- (IBAction)menuBtn:(id)sender {
    if (menuView.hidden==NO)
    {
        menuView.hidden=YES;
    }
    else{
        menuView.hidden=NO;
        
    }

}

- (IBAction)freeSongs:(id)sender {
    AvailableSongsViewController *availableSongsVC ;
    
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        availableSongsVC = [[AvailableSongsViewController alloc] initWithNibName:@"AvailableSongsViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
       availableSongsVC = [[AvailableSongsViewController alloc] initWithNibName:@"AvailableSongsViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        availableSongsVC = [[AvailableSongsViewController alloc] initWithNibName:@"AvailableSongsViewController_ipad" bundle:nil];
        
    }

    availableSongsVC.flag = 1;
   
    [self.navigationController pushViewController:availableSongsVC animated:YES];
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isAlbumsTab) {
        return albumList.count;}
    else{
        return songsList.count;}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"haverecords..%@",HaveRecords);
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    UIButton *buyBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *buyBtn1= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        buyBtn.frame = CGRectMake(245.0f, 40.0f, 45.0f, 20.0f);
        buyBtn1.frame = CGRectMake(10.0f, 6.0f, 60.0f, 52.0f);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        buyBtn.frame = CGRectMake(235.0f, 40.0f, 45.0f, 20.0f);
        buyBtn1.frame = CGRectMake(10.0f, 6.0f, 60.0f, 52.0f);
        //this is iphone 4 xib
    }
    else{
        buyBtn.frame = CGRectMake(600.0f, 70.0, 105.0f, 45.0f);

        buyBtn1.frame = CGRectMake(10.0f, 11.0f,107.0f,107.0f);
        //this is ipad xib
    }
    
    buyBtn.tag = indexPath.row;
    buyBtn1.tag = indexPath.row;

    UIImage *buttonBackgroundImage;
    AvailableAlbums *albumobj;
    AvailableSongs *songsobj ;
  
    if (albumList.count>0)
    {
        albumobj = (AvailableAlbums *)[albumList objectAtIndex:indexPath.row];

    }
    if (songsList.count>0) {
        songsobj = (AvailableSongs *)[songsList objectAtIndex:indexPath.row];
    }
 
    if ([songsobj.VideoPrice isEqualToString:@"0"]|| [albumobj.AlbumPrice isEqualToString:@"0"]||[songsobj.itemStatus isEqualToString:@"0"] || [albumobj.itemStatus isEqualToString:@"0"]) {
        buttonBackgroundImage = [UIImage imageNamed:@"buy-now-btn"];
    }else{
        buttonBackgroundImage = [UIImage imageNamed:@"Download-btn.png"];
    }
    [buyBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];

    
    AvailableAlbumsCell *cell;
    AvailbleSongsCell *cell1;
    
    if (isAlbumsTab)
    {
        cell = (AvailableAlbumsCell *)[songListView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSArray *nib ;
        
        
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
            //this is ipad xib
        }

        
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
       // AvailableAlbums *obj = (AvailableAlbums *)[albumList objectAtIndex:indexPath.row];

        if ([albumobj.AlbumPrice isEqualToString:@"0"]) {
            [cell setLabelText:albumobj.AlbumName :@"" :albumobj.ArtistName :albumobj.Songs :albumobj.ThumbnailUrl ];
        }else{
            if ([albumobj.Songs isEqualToString:@"1"]) {
                [cell setLabelText:albumobj.AlbumName :[NSString stringWithFormat:@"%@ Credit",albumobj.Songs] :albumobj.ArtistName :[NSString stringWithFormat:@"%@ Song",albumobj.Songs] :albumobj.ThumbnailUrl ];
            }else{
            [cell setLabelText:albumobj.AlbumName :[NSString stringWithFormat:@"%@ Credits",albumobj.Songs ]:albumobj.ArtistName :[NSString stringWithFormat:@"%@ Songs",albumobj.Songs] :albumobj.ThumbnailUrl ];
            }
        }
        
        [cell.contentView addSubview:buyBtn];
        [cell.contentView addSubview:buyBtn1];
        
    }
    else{
        cell1 = (AvailbleSongsCell *)[songListView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
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
            //this is ipad xib
        }

        cell1 = [nib objectAtIndex:0];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.backgroundColor=[UIColor clearColor];
        [cell1.contentView addSubview:buyBtn];
      //  AvailableSongs *obj = (AvailableSongs *)[songsList objectAtIndex:indexPath.row];
       
        if ([songsobj.VideoPrice isEqualToString:@"0"]) {
            [cell1 setLabelText:songsobj.ArtistName :songsobj.trackcode :songsobj.VideoName :songsobj.duration:@""];
        }else{
            [cell1 setLabelText:songsobj.ArtistName :songsobj.trackcode :songsobj.VideoName :songsobj.duration:songsobj.VideoPrice ];
        }
        [cell1.contentView addSubview:buyBtn];
        [cell1.contentView addSubview:buyBtn1];
        
    }
    
    
    
    [buyBtn1 addTarget:self action:@selector(sampleVideo:) forControlEvents:UIControlEventTouchUpInside];
    if ([songsobj.VideoPrice isEqualToString:@"0"] || [albumobj.AlbumPrice isEqualToString:@"0"])
    {
        [buyBtn addTarget:self action:@selector(freeSongDownload:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [buyBtn addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    }

    if ([HaveRecords isEqualToString:@"1"]) {
      
        
            UIView *footerView  = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 280, 70)];
            
            //create the button
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            //the button should be as big as a table view cell
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                [button setFrame:CGRectMake(0, 0, 300, 50)];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
                
                //this is iphone 5 xib
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 480) {
                [button setFrame:CGRectMake(0, 0, 300, 50)];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
                
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
            self.songListView.tableFooterView = footerView;
            self.songListView.tableFooterView.userInteractionEnabled = YES;
        }
    
    else{
        isloadMore=NO;
        tableView.tableFooterView = nil;
    }
    
    if ([searchTxt.text isEqualToString:@""]) {
        isloadMore=NO;
        tableView.tableFooterView = nil;
    }
    if (isAlbumsTab)
    {
        return cell;
    }else{
        return cell1;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    AvailableSongs *songsObj;
    AvailableAlbums *albumsObj;
    SongsDetailViewController *songDetailVc;
    
    if(isAlbumsTab){
        albumsObj = (AvailableAlbums *)[albumList objectAtIndex:indexPath.row];
    }else{
        songsObj = (AvailableSongs *)[songsList objectAtIndex:indexPath.row];
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
        songDetailVc.albumsOBJ=albumsObj;
    }else{
        songDetailVc.isVideos=YES;
        songDetailVc.isAlbum=NO;
        songDetailVc.songsOBJ=songsObj;
        NSLog(@"%@",songsObj.AlbumName);
    }
    songDetailVc.user_UDID_Str=user_UDID_Str;
    [self.navigationController pushViewController:songDetailVc animated:YES];
    self.menuView.hidden = YES;

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


- (void)buyNow:(UIControl *)sender{
    
    ispaidSong=YES;
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSString *queryString ;
    index = indexPath.row;
    if (isAlbumsTab) {
        albumsOBJ = (AvailableAlbums *)[albumList objectAtIndex:indexPath.row];
    }else{
        songsOBJ=(AvailableSongs *)[songsList objectAtIndex:indexPath.row];
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
        queryString = [NSString stringWithFormat:@"Select * FROM Songs where Trackcode = \"%@\"",songsOBJ.trackcode];
    }
    FMResultSet *results = [database executeQuery:queryString];
    trackCodeArray = [[NSMutableArray alloc] init];
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
    
    
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"Track Code is %@", trackCodeArray);
    AvailableAlbums *albumobj;
    AvailableSongs *songsobj;
    if (isAlbumsTab) {
        albumobj = (AvailableAlbums*)[albumList objectAtIndex:indexPath.row];
    }else{
        songsobj = (AvailableSongs*)[songsList objectAtIndex:indexPath.row];
    }

    if(isAlbumsTab){
        albumsOBJ = (AvailableAlbums *)[albumList objectAtIndex:index];
        songCount=albumsOBJ.Songs;
    }else{
        songsOBJ = (AvailableSongs *)[songsList objectAtIndex:index];
    }
    NSLog(@"Table songs Track code %@",songsOBJ.trackcode);
    
    
    if ([trackCodeArray containsObject:songsOBJ.trackcode] || [trackCodeArray containsObject:albumsOBJ.AlbumCode] ) {
        NSString *message1;
        if (isAlbumsTab) {
            message1 = @"You've already purchased this album.";
        }else{
            message1 = @"You've already purchased this song.";
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 4;
        [alert show];
        
    }
    else if ([albumobj.itemStatus isEqualToString:@"1"] ||[songsobj.itemStatus isEqualToString:@"1"])
    {
        [self songDownloading];
    }
    else{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
       
        NSLog(@"totalSongsStr %d",[totalSongsStr intValue]);
        
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
            if ([totalSongsStr intValue]>=[songCount intValue])
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message2 ]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 10;
            }
            else
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ]   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 3;
            }

        }
        else{
            if ([totalSongsStr intValue]>0)
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message2 ]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 10;
            }
            else
            {
                alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ]   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
                alert.tag = 3;
            }

        }
    [alert show];
        
    }

  
}






- (void)paypalPurchase:(UIControl *)sender{

    self.resultText = nil;
    PayPalItem *song;
    PayPalPayment *payment = [[PayPalPayment alloc] init];

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
        NSLog(@"%@", songsOBJ.VideoName);
        song = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@",songsOBJ.VideoName]
                           withQuantity:1
                              withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",songsOBJ.VideoPrice]]
                           withCurrency:@"GBP"
                                withSku:[NSString stringWithFormat:@"%@",songsOBJ.trackcode]];
        
        payment.shortDescription =[NSString stringWithFormat:@"%@",songsOBJ.VideoName];
}
    
    NSArray *items = @[song];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    payment.amount = total;
    payment.currencyCode = @"GBP";
    payment.items = items;
    // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails;
    // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
    }
    
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
    AccountDetailViewController *accountVc;
    AvailableSongs *songsObj;
    AvailableAlbums *albumsObj;
    if(isAlbumsTab){
        accountVc.isSongs=NO;
        accountVc.isAlbum=YES;
        accountVc.albumsOBJ=albumsObj;
    }else{
        accountVc.isSongs=YES;
        accountVc.isAlbum=NO;
        accountVc.songsOBJ=songsObj;
        NSLog(@"%@",songsObj.AlbumName);
    }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    [self sendCompletedPaymentToServer:completedPayment];
    // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
    [self songDownloading];
}

- (void)paymentFailedWithCorrelationID:(NSString *)correlationID andErrorCode:(NSString *)errorCode andErrorMessage:(NSString *)errorMessage {
    UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"We're Sorry" message:@"System error.Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"PAYMENTSTATUS_FAILED");
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"We're Sorry" message:@"You cancelled the transaction." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    self.resultText = nil;
    //self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
  //  [activityIndicatorObject stopAnimating];
    
    if (alertView.tag == 3 && buttonIndex == 1) {
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
        

    }
    else if (alertView.tag == 10 && buttonIndex == 1) {
        [self songDownloading];
    }
    else if(alertView.tag == 4 && buttonIndex == 0)
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
        
    }else if(alertView.tag ==5 && buttonIndex == 0)
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
        
        [self.navigationController pushViewController:musicPlayerVc animated:YES];
        
    }
}


- (void)songDownloading
{
    self.dataRecievedLbl.text=nil;
    bytes=0;
    self.progressLabel.text=@"0%";
    ASIHTTPRequest *request;
    
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
  //  [self viewDidLoad];
    
    
}

- (void) disabled
{
   // proView.hidden=YES;
    [activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled = NO;
    self.disabledImgView.hidden = NO;
    
}
- (void) enable
{
    [activityIndicatorObject stopAnimating];

    self.view.userInteractionEnabled = YES;
    self.disabledImgView.hidden = YES;
}
- (void) search{
    NSData *img1Data = UIImageJPEGRepresentation(self.searchBtnOutlet.currentImage, 1.0);
    NSData *img2Data = UIImageJPEGRepresentation([UIImage imageNamed:@"search_bar_icon.png"], 1.0);
    NSLog(@"Button Image %@", img1Data);
    NSLog(@"Image Data %@", img2Data);
    if (isSearchClicked && !(img1Data == img2Data)  && !isloadMore) {
        
        [searchBtnOutlet setImage:[UIImage imageNamed:@"search_bar_icon.png"] forState:UIControlStateNormal];
        isSearchClicked = NO;
        searchTxt.text = @"";
        
    }else{
        isloadMore=NO;
        [searchTxt resignFirstResponder];

        if (![searchTxt.text isEqualToString:@""]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Search",Kwebservices]];
            // [activityIndicatorObject startAnimating];
            [self disabled];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user_UDID_Str = [defaults objectForKey:@"user_UDID_Str"];
            //[activityIndicatorObject startAnimating];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            NSString *trigger;
            NSString *user_UDID;
            NSString *paging;
            if (![searchParameter isEqualToString:[NSString stringWithFormat:@"%@",searchTxt.text]])
            {
                albumList =[[NSMutableArray alloc]init];
                songsList=[[NSMutableArray alloc]init];
                pagging=1;
            }
        
            if(trigger==nil)
                trigger = [NSString stringWithFormat:@"%@",triggerValue];
            [request setPostValue:trigger forKey:@"Trigger"];
        
            if(paging==nil)
                paging = [NSString stringWithFormat:@"%d",pagging];
            [request setPostValue:paging forKey:@"paging"];
        
            if(user_UDID==nil)
                user_UDID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Email"]];
            [request setPostValue:user_UDID forKey:@"user_email"];
         
            NSLog(@"search text..%@",searchTxt.text);
              
            searchParameter = [NSString stringWithFormat:@"%@",searchTxt.text];
            NSLog(@"search Parameter %@",searchParameter);
            searchParameter = [searchParameter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [request setPostValue:searchParameter forKey:@"searchParameter"];
        
            [request setRequestMethod:@"POST"];
            [request setDelegate:self];
            [request startAsynchronous];
        }
    }
}



- (void)freeSongDownload:(UIControl *)sender
{
    ispaidSong=NO;
    NSString *queryString ;
    mySongs *mysongObj=[[mySongs alloc]init];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    if (isAlbumsTab)
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Albums "];
    }
    else
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Songs "];
    }
    FMResultSet *results = [database executeQuery:queryString];
    
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSNumber *selRow = [[NSNumber alloc] initWithInteger:indexPath.row];
    index = [selRow integerValue];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    NSLog(@"Track Code is %@", trackCodeArray);
    AvailableAlbums *albumobj;
    AvailableSongs *songsobj;
    if (isAlbumsTab) {
        albumobj = (AvailableAlbums*)[albumList objectAtIndex:indexPath.row];
    }else{
        songsobj = (AvailableSongs*)[songsList objectAtIndex:indexPath.row];
    }

    if(isAlbumsTab){
        albumsOBJ = (AvailableAlbums *)[albumList objectAtIndex:index];
    }else{
        songsOBJ = (AvailableSongs *)[songsList objectAtIndex:index];
    }
    NSLog(@"Table songs Track code %@",songsOBJ.trackcode);
  
    if ([trackCodeArray containsObject:songsOBJ.trackcode] || [trackCodeArray containsObject:albumsOBJ.AlbumCode])
    {
        NSString *message1;
        if (isAlbumsTab) {
            message1 = @"You've already purchased this album.";
        }else{
            message1 = @"You've already purchased this song.";
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 4;
        [alert show];
        
    }else if ([albumobj.itemStatus isEqualToString:@"1"] ||[songsobj.itemStatus isEqualToString:@"1"])
    {
        [self songDownloading];
    }
    else{
        NSString *message1;
        if (isAlbumsTab) {
            message1 = @"Do you want to purchase this album?";
        }else{
            message1 = @"Do you want to purchase this track?";
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES",nil];
        alert.tag = 10;
        [alert show];
    }
}


- (void)sampleVideo:(UIControl *)sender
{
    NSLog(@"samplevideo");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    AvailableSongs *songsObj;
    
    songsObj = (AvailableSongs *)[songsList objectAtIndex:indexPath.row];
    NSMutableArray*samplevideoArray=[[NSMutableArray alloc]init];
    
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
    //[samplevideoArray addObject:[NSString stringWithFormat:@"%@",songsObj.samplevideoUrl]];
    
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
- (void)loadmore
{
    isloadMore=YES;
    NSString *srchStr=searchTxt.text;
    if (![srchStr isEqualToString:@""]) {
        [self disabled];
        [self searchSongs:searchTxt.text];
    }
    else {
        [self enable];
    }
    [self.songListView reloadData];
    
    NSLog(@"load more");
}
- (void)saveSongs{
    proView.hidden=YES;
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
        NSLog(@"%@",songsNameinAlbum);
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
        //  songsList =[[NSMutableArray alloc]init];
    }
    [database close];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search];
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [searchBtnOutlet setImage:[UIImage imageNamed:@"search_bar_icon.png"] forState:UIControlStateNormal];
    isSearchClicked = NO;
    return YES;
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


- (IBAction)creditButton:(id)sender {
    
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

@end
