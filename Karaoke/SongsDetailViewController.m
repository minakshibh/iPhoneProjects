//
//  SongsDetailViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 21/03/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "SongsDetailViewController.h"
#import "AvailableSongsViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "AvailableSongs.h"
#import "ZipArchive.h"
#import "FMDatabaseAdditions.h"
#import "Base64.h"
#import "MusicPlayerViewController.h"
#import "AvailbleSongsCell.h"
#import "AvailableSongs.h"
#import "videosInAlbum.h"
#import "AccountDetailViewController.h"
#import "MySongsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CoupnsViewController.h"
#define kPayPalEnvironment PayPalEnvironmentProduction
//#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface SongsDetailViewController ()
{
    NSString *videoIdStr;
    NSString *videoUrlinAlbum, *videoNameinAlbum;
    NSString *result,*message,*strEncodedImage,*filepath,*strEncodedSongImage;
    NSString *triggerValue,*videoURLStr;
    NSString *videoName ,*albumLocalUrl, *songLocalUrl;
    NSString *thumbnail, *artistName, *albumName, *albumServerUrl ,*buyDate ,*numbrOfSongsSongs,  *albumImage;
    NSArray *subpaths,*date;
    NSMutableString *tempString;
    int progressStr;
    NSTimer *timer;
    NSMutableData *receivedData;
    long long bytesReceived;
    long long expectedBytes;
    float percentComplete;
    unsigned long long bytes;
    NSMutableArray  *trackCodeArray,* songNameInAlbum;
}
@property (strong, nonatomic) IBOutlet UIButton *sampleVideoPlayBtn;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end

@implementation SongsDetailViewController
@synthesize headerLbl,videoNmaeLbl,albumNameLbl,artistNameLbl,priceLbl,imageView,songsOBJ,albumsOBJ,isAlbum,isVideos,user_UDID_Str,activityIndicatorObject,proView,progressBar,progressLbl,progressPercentlbl,scrollView,viewBgBlackImage,buyNowBtnOutlet,songHeaderLbl,songsTableview,downloadBtnOutlet,songsArray;

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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.songsTableview.tableFooterView = [[UIView alloc] init] ;
  
    [[proView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[proView layer] setBorderWidth:1.0];
    [[proView layer] setCornerRadius:5];
    
    availableSongsObj=[[AvailableSongs alloc]init];
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    songHeaderLbl.hidden=YES;
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.2f);
    progressBar.transform = transform;
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    NSLog(@"Status %@,%@",albumsOBJ.itemStatus,songsOBJ.itemStatus);
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 160);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 140);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(360, 320);
    }
    activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];
    
    if (isAlbum)
    {
        UIImage *lineImage;
        CGRect lineImageFrame;
        UIImageView *lineImageView;
        CGRect lineImageFrame2;
        UIImageView *lineImageView2;
        
        lineImage = [UIImage imageNamed:@"line.png"];
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            lineImageFrame = CGRectMake(10,330,300,2);
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            lineImageFrame = CGRectMake(10,310,300,2);
        }
        else{
            lineImageFrame = CGRectMake(0,607,758,2);
        }
        
        lineImageView = [[UIImageView alloc] initWithFrame:lineImageFrame];
        lineImageView.image=lineImage;
        [self.scrollView addSubview:lineImageView];
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            lineImageFrame2 = CGRectMake(10,375,300,2);
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            lineImageFrame2 = CGRectMake(10,355,300,2);
        }
        else{
            lineImageFrame2 = CGRectMake(0,690,758,2);
        }
        lineImageView2 = [[UIImageView alloc] initWithFrame:lineImageFrame2];
        lineImageView2.image=lineImage;
        [self.scrollView addSubview:lineImageView2];
        
        songsTableview.backgroundColor=[UIColor clearColor];
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            songsTableview.frame=CGRectMake(10,390, 300,128);
            buyNowBtnOutlet.frame=CGRectMake(29,555,262,30);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            songsTableview.frame=CGRectMake(10,370, 300,128);
            buyNowBtnOutlet.frame=CGRectMake(29,535,262,30);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        }
        else{
            songsTableview.frame=CGRectMake(5,710, 758,228);
            buyNowBtnOutlet.frame=CGRectMake(23, 616, 659, 63);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];
        }

       // viewBgBlackImage.frame=CGRectMake(10, 76, 300, 450);
       // viewBgBlackImage.frame=CGRectMake(10, 73, 300, 660);
       
        songHeaderLbl.hidden=NO;
        songsTableview.hidden=NO;
        videoNmaeLbl.text=[NSString stringWithFormat:@""];
        videoURLStr=[NSString stringWithFormat:@"%@",albumsOBJ.AlbumUrl];
        albumServerUrl=videoURLStr;
        albumName=albumsOBJ.AlbumName;
        videoIdStr=[NSString stringWithFormat:@"%d",albumsOBJ.AlbumId];
        headerLbl.text=[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName];
        artistNameLbl.text=[NSString stringWithFormat:@"%@",albumsOBJ.ArtistName];
        albumNameLbl.text=[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName];
        NSLog(@"%@",albumsOBJ.Songs);
        priceLbl.text = [NSString stringWithFormat:@"%@ Credits",albumsOBJ.Songs];
        thumbnail=[NSString stringWithFormat:@"%@",albumsOBJ.ThumbnailUrl];
        thumbnail = [thumbnail stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
        thumbnail = [thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:thumbnail];
        [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"player-text.png"]];
        numbrOfSongsSongs=[NSString stringWithFormat:@"%@",albumsOBJ.Songs];
        NSLog(@"%lu",(unsigned long)albumsOBJ.videoAlbumArray.count);
        NSLog(@"%@",albumsOBJ.videoAlbumArray);
        
        songNameInAlbum=albumsOBJ.videoAlbumArray;
        
        for (int i=0; i<albumsOBJ.videoAlbumArray.count; i++)
        {
             availableSongsObj.trackcode=[[albumsOBJ.videoAlbumArray valueForKey:@"TrackCode"] objectAtIndex:i];
            availableSongsObj.ArtistName=[[albumsOBJ.videoAlbumArray valueForKey:@"videoArtistName"]objectAtIndex:i];
            availableSongsObj.VideoName=[[albumsOBJ.videoAlbumArray valueForKey:@"VideoName"]objectAtIndex:i];
            availableSongsObj.ThumbnailUrl=[[albumsOBJ.videoAlbumArray valueForKey:@"videoThumbnailUrl"]objectAtIndex:i];
            
        }
      
        [songNameInAlbum arrayByAddingObject:availableSongsObj];
        
        
//        if ([[UIScreen mainScreen] bounds].size.height == 568) {
//            
//            scrollView.contentSize = CGSizeMake(320, 73.0 - 100);
//
//        }
//        else if([[UIScreen mainScreen] bounds].size.height == 480){
//            scrollView.contentSize = CGSizeMake(320, 750 + songsTableview.frame.size.height - 100);
//
//        }
//        else{
//            scrollView.contentSize = CGSizeMake(320, 1050 + songsTableview.frame.size.height);
//
//            
//        }
        

      }
    else
    {
        songHeaderLbl.hidden=YES;
        songsTableview.hidden=YES;
        videoNmaeLbl.text=[NSString stringWithFormat:@"%@",songsOBJ.VideoName];
        videoName=songsOBJ.VideoName;
        videoURLStr=[NSString stringWithFormat:@"%@",songsOBJ.VideoUrl];
        videoIdStr=[NSString stringWithFormat:@"%d",songsOBJ.VideoId];
        headerLbl.text=[NSString stringWithFormat:@"%@",songsOBJ.VideoName];
        albumNameLbl.text=[NSString stringWithFormat:@"%@",songsOBJ.ArtistName];
        artistNameLbl.text = [NSString stringWithFormat:@"TrackCode - %@",songsOBJ.trackcode];
        priceLbl.text = [NSString stringWithFormat:@"%@ Credits",songsOBJ.Songs];
        thumbnail=[NSString stringWithFormat:@"%@",songsOBJ.ThumbnailUrl];
        thumbnail = [thumbnail stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
        
        thumbnail = [thumbnail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:thumbnail];
        [self.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"player-text.png"]];
        

    }

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        
        [songsTableview setFrame:CGRectMake(10, 390, 300, 128 + songNameInAlbum.count*75 )];

    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        [songsTableview setFrame:CGRectMake(10, 390, 300, 128 + songNameInAlbum.count*75 )];
        
    }
    else{
        [songsTableview setFrame:CGRectMake(5, 700, 748, 128 + songNameInAlbum.count*75 )];
    
    }

    downloadBtnOutlet= [[UIButton alloc]init];
    if(isAlbum){
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            
            downloadBtnOutlet.frame = CGRectMake(29,73.0*[songNameInAlbum count] +  410, 262, 30);
            [downloadBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            downloadBtnOutlet.frame = CGRectMake(29,70.0*[songNameInAlbum count] +  430, 262, 30);
            [downloadBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

        }
        else{
            downloadBtnOutlet.frame = CGRectMake(25,140.0*[songNameInAlbum count] +  720, 659, 63);
            [downloadBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];

        }

    }
    else{
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
           
            downloadBtnOutlet.frame = CGRectMake(29, 345, 262, 30);
            [downloadBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            downloadBtnOutlet.frame = CGRectMake(29, 294, 262, 25);
            [downloadBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

        }
        else{
            downloadBtnOutlet.frame = CGRectMake(23, 616, 659, 63);
            [downloadBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];

        }

    }
    downloadBtnOutlet.hidden = NO;
    
    [downloadBtnOutlet setBackgroundImage:[UIImage imageNamed:@"download-btn_480-1.png" ] forState:UIControlStateNormal];
    [downloadBtnOutlet setTitle:@"Download" forState:UIControlStateNormal];
    [downloadBtnOutlet setTitleColor:[UIColor colorWithRed:195/255.0f green:252/255.0f blue:0/255.0f alpha:1] forState:UIControlStateNormal];
    [downloadBtnOutlet addTarget:self action:@selector(downloadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:downloadBtnOutlet];
    
    buyNowBtnOutlet = [[UIButton alloc]init];
    if (isAlbum) {
        
        self.sampleVideoPlayBtn.hidden = YES;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            
            scrollView.contentSize = CGSizeMake(320, 73.0*[songNameInAlbum count] +  460);
            
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            scrollView.contentSize = CGSizeMake(320,70.0*[songNameInAlbum count] +  480);
            
        }
        else{
            scrollView.contentSize = CGSizeMake(320,140.0*[songNameInAlbum count] +  800);
            
            
        }
        
        NSLog(@"Array .... %lu",(unsigned long)songNameInAlbum.count);
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            
            buyNowBtnOutlet.frame = CGRectMake(29,73.0*[songNameInAlbum count] +  410, 262, 30);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

            
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            buyNowBtnOutlet.frame = CGRectMake(29,70.0*[songNameInAlbum count] +  430, 262, 30);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

            
        }
        else{
            buyNowBtnOutlet.frame = CGRectMake(25,140.0*[songNameInAlbum count] +  550, 659, 63);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];

            
        }

        
    }else{
        
        self.sampleVideoPlayBtn.hidden = NO;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            
            buyNowBtnOutlet.frame = CGRectMake(29, 340, 262, 30);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

        }
        else if([[UIScreen mainScreen] bounds].size.height == 480){
            buyNowBtnOutlet.frame = CGRectMake(29, 290, 262, 25);
            [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];

        }
        else{
            buyNowBtnOutlet.frame = CGRectMake(23, 600, 659, 63);
             [buyNowBtnOutlet.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];

        }
    }
    buyNowBtnOutlet.hidden = NO;
    [buyNowBtnOutlet setBackgroundImage:[UIImage imageNamed:@"download-btn_480-1.png" ] forState:UIControlStateNormal];
    buyNowBtnOutlet.backgroundColor = [UIColor clearColor];
    [buyNowBtnOutlet setTitle:@"Buy Now " forState:UIControlStateNormal];
    [buyNowBtnOutlet setTitleColor:[UIColor colorWithRed:195/255.0f green:252/255.0f blue:0/255.0f alpha:1] forState:UIControlStateNormal];
    [buyNowBtnOutlet addTarget:self action:@selector(buyNowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:buyNowBtnOutlet];
    
    if (isAlbum) {

    if ([albumsOBJ.AlbumPrice isEqualToString:@"0"]){
        priceLbl.text=[NSString stringWithFormat:@"Free"];
        downloadBtnOutlet.hidden = NO;
        buyNowBtnOutlet.hidden = YES;
    }
    else{
        priceLbl.text=[NSString stringWithFormat:@""];
       // priceLbl.text=[NSString stringWithFormat:@"£ %@",albumsOBJ.AlbumPrice];

        downloadBtnOutlet.hidden = YES;
        buyNowBtnOutlet.hidden = NO;
    }
    }else{
    if ([songsOBJ.VideoPrice isEqualToString:@"0"]){
        priceLbl.text=[NSString stringWithFormat:@"Free"];
        downloadBtnOutlet.hidden = NO;
        buyNowBtnOutlet.hidden = YES;
    }
    else{
      //  priceLbl.text=[NSString stringWithFormat:@"£ %@",songsOBJ.VideoPrice];
        priceLbl.text=[NSString stringWithFormat:@""];

        downloadBtnOutlet.hidden = YES;
        buyNowBtnOutlet.hidden = NO;
    }
    }
    [songsTableview reloadData];

    if ([albumsOBJ.itemStatus isEqualToString:@"1"] || [songsOBJ.itemStatus isEqualToString:@"1"]) {
        buyNowBtnOutlet.hidden = YES;
        downloadBtnOutlet.hidden = NO;
    }else{
        buyNowBtnOutlet.hidden = NO;
        downloadBtnOutlet.hidden = YES;
    }
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


- (IBAction)backBtn:(id)sender {
      NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    AvailableSongsViewController *AvailSongsvc = [self.navigationController.viewControllers objectAtIndex:index-1];
    [self.navigationController popToViewController:AvailSongsvc animated:YES];
}

- (IBAction)buyNowBtn:(id)sender {
    ispaidSongs=YES;
    trackCodeArray = [[NSMutableArray alloc]init];
    NSString *queryString ;
    mySongs *mysongObj=[[mySongs alloc]init];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    if (isAlbum)
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Albums "];
    }
    else
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Songs "];
    }
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        
        if (isAlbum) {
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
    NSLog(@"Table songs Track code %@",songsOBJ.trackcode);
   
    songCount=nil;
    songCount=albumsOBJ.Songs;
    
    if ([trackCodeArray containsObject:songsOBJ.trackcode] || [trackCodeArray containsObject:albumsOBJ.AlbumCode] ) {
        NSString *message1;
        if (isAlbum) {
            message1 = @"You already have this  Album";
        }else{
            message1 = @"You already have this  Song";
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 4;
        [alert show];
        
    }else if([songsOBJ.itemStatus isEqualToString:@"1"] || [albumsOBJ.itemStatus isEqualToString:@"1"]){
        [self songDownloading];
    }
    
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
      
        NSLog(@"totalSongs %d",[totalSongsStr intValue]);
        
        
        NSString *message1 ,*message2;
        UIAlertView *alert;
        if (isAlbum) {
            message1 = @"You don't have enough credits to buy this album.";
            message2= @"Do you want to purchase this album?";
        }else{
            message1 = @"You don't have enough credits to buy this track.";
            message2= @"Do you want to purchase this track?";
        }
        
        if (isAlbum)
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


- (IBAction)downloadBtn:(id)sender {
    ispaidSongs=NO;
    trackCodeArray = [[NSMutableArray alloc]init];
    NSString *queryString ;
    mySongs *mysongObj=[[mySongs alloc]init];

    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"ZoomKaraoke_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    if (isAlbum)
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Albums "];
    }
    else
    {
        queryString = [NSString stringWithFormat:@"Select * FROM Songs "];
    }
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        
        if (isAlbum) {
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
    NSLog(@"Table songs Track code %@",songsOBJ.trackcode);
    
    
    
    if ([trackCodeArray containsObject:songsOBJ.trackcode] || [trackCodeArray containsObject:albumsOBJ.AlbumCode] ) {
        NSString *message1;
        if (isAlbum) {
            message1 = @"You've already purchased this album.";
        }else{
            message1 = @"You've already purchased this song.";
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@",message1 ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 4;
        [alert show];
        
    }else{
        [self songDownloading];
    }
}


- (void)payPalPayment{
    self.resultText = nil;
    PayPalItem *song;
    PayPalPayment *payment = [[PayPalPayment alloc] init];

    if(isAlbum)
    {
        song = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName]
                           withQuantity:1
                              withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumPrice]]
                           withCurrency:@"GBP"
                                withSku:[NSString stringWithFormat:@"%@",albumsOBJ.TrackCode]];
        payment.shortDescription =[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName];

        
    }
    else{
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
    AvailableSongs *songsObj;
    AvailableAlbums *albumsObj;
    
    if(isAlbum){
        albumsObj = albumsOBJ;
    }else{
        songsObj = songsOBJ;
    }
    if(isAlbum){
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


- (void)songDownloading
{
    bytes=0;
    self.progressLbl.text=@"0%";
    ASIHTTPRequest *request;
    
    if(isAlbum){
        NSLog(@"%@", albumsOBJ.AlbumName);
        videoURLStr=albumsOBJ.AlbumUrl;
    }else{
        NSLog(@"%@", songsOBJ.VideoName);
        videoURLStr=songsOBJ.VideoUrl;
    }
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",videoURLStr]]];
    
    if (isAlbum)
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
        self.progressPercentlbl.text=[NSString stringWithFormat:@"%llukb/%llukb",bytes/1024,totalData];
        NSLog(@"%@",self.progressPercentlbl.text);
        NSString *str = [NSString stringWithFormat:@"%f",(progressBar.progress)*100];
        progressStr =[str intValue];
        self.progressLbl.text=[NSString stringWithFormat:@"%d%%",progressStr];
    }];
    [request setDownloadProgressDelegate:progressBar];
    [request setDelegate:self];
    [request startAsynchronous];
   // [self viewDidLoad];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    [activityIndicatorObject stopAnimating];
    NSError *error = [request error];
    NSLog(@"res error :%@",error.description);
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Downloading Failed" message:@"Kindly check your internet connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [activityIndicatorObject stopAnimating];
    proView.hidden=YES;
    [self enable];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    songsArray = [[NSMutableArray alloc] init];
    NSString *responseString = [request responseString];
    NSLog(@"response%@", responseString);
    [activityIndicatorObject stopAnimating];
    NSData *responseData = [request responseData];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    
    if (responseString ==nil) {
        self.progressLbl.text=@"100%";
        
        if (isAlbum) {
            NSString *zipPath=[[NSHomeDirectory()
                                stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",albumsOBJ.AlbumName]];
            filepath =[[NSHomeDirectory()
                        stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName]];
            
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
            
            
            songNameInAlbum = [manager subpathsAtPath:[NSString stringWithFormat:@"%@",filepath]];
            NSString *compresdFoldrPath=[[NSHomeDirectory()
                                          stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName]];
            for (int i=0; i<songNameInAlbum.count; i++)
            {
                
                NSString *str=[subpaths objectAtIndex:i];
                str = [str substringFromIndex: [str length] - 4];
                if ([str isEqualToString:@".mp4"]){

                NSString *songPath =[[NSHomeDirectory()
                                      stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",albumsOBJ.AlbumName,[songNameInAlbum objectAtIndex:i]]];
                albumLocalUrl =[[NSHomeDirectory()
                                 stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[songNameInAlbum objectAtIndex:i]]];
                NSString *songName=[songNameInAlbum objectAtIndex:i];
                NSError *error;
                
                [[NSFileManager defaultManager] copyItemAtPath:songPath toPath:albumLocalUrl error:&error];
                //  BOOL sucess=[manager copyItemAtPath:strpath toPath:songPath error:&error];
                // NSLog(@"%@",sucess);
                NSString*albumLocalUrl1 =[NSString stringWithFormat:@"%@",[songNameInAlbum objectAtIndex:i]];
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
        
        proView.hidden=YES;
        [self enable];
        [self saveSongs];
        
        if (ispaidSongs)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
            
            int countSong=[songCount intValue];
            
            NSLog(@"total %@",totalSongsStr);
            if([songsOBJ.itemStatus isEqualToString:@"0"] || [albumsOBJ.itemStatus isEqualToString:@"0"]){
            if ([totalSongsStr intValue]>0)
            {
                if (isAlbum) {
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
            
            [defaults synchronize];

            }if (isAlbum) {
                if([albumsOBJ.itemStatus isEqualToString:@"0"]){
                    [self saveTransaction:creditsToSave:videoID];
                }
            }else{
                if ([songsOBJ.itemStatus isEqualToString:@"0"]){
                    [self saveTransaction:creditsToSave:videoID];
                }
            }
        }
        //[self viewDidLoad];
        if (isAlbum) {
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
    buyDate=[[NSString alloc]initWithString:[df stringFromDate:now]];
    UIImage *small = [UIImage imageWithCGImage:img.CGImage scale :0.25 orientation:img.imageOrientation];
    NSData* data = UIImageJPEGRepresentation(small,0.1f);
    strEncodedImage = [Base64 encode:data];
    
    if (isAlbum)
    {
        NSString *insertSQL  = [NSString stringWithFormat:@"INSERT INTO Albums (albumName,albumImage,thumbnail,artistName,numberOfSongs,serverUrl,albumBuyDate,AlbumCode) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\",%d,\"%@\", \"%@\",\"%@\")",albumsOBJ.AlbumName,strEncodedImage,albumsOBJ.ThumbnailUrl,albumsOBJ.ArtistName,[albumsOBJ.Songs intValue],albumsOBJ.AlbumUrl ,buyDate,albumsOBJ.AlbumCode];
        [database executeUpdate:insertSQL];
        NSString *queryStr = [NSString stringWithFormat:@"Select max(albumId) from Albums "];
        int count = [database intForQuery:queryStr];
        NSLog(@"%@",songNameInAlbum);
        
        for ( int i=0;i<songsArray.count; i++)  {
            NSString *songTrackcode=[[albumsOBJ.videoAlbumArray valueForKey:@"TrackCode"] objectAtIndex:i];
            NSString *songArtistName=[[albumsOBJ.videoAlbumArray valueForKey:@"videoArtistName"]objectAtIndex:i];
            NSString *songDuration=[[albumsOBJ.videoAlbumArray valueForKey:@"Duration"]objectAtIndex:i];
            NSString *songThumnailUrl=[[albumsOBJ.videoAlbumArray valueForKey:@"videoThumbnailUrl"]objectAtIndex:i];
            videoUrlinAlbum=[NSString stringWithFormat:@"%@",[songsArray objectAtIndex:i]];
            videoNameinAlbum=[[albumsOBJ.videoAlbumArray valueForKey:@"VideoName"]objectAtIndex:i];
            [songNameInAlbum addObject:videoNameinAlbum];
            insertSQLQuery  = [NSString stringWithFormat:@"INSERT INTO Songs (songName,localUrl,thumbnail, songImage,artistName,albumId,albumName,songBuyDate,Trackcode,Duration) VALUES ( \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", %d,\"%@\",\"%@\",\"%@\",\"%@\")",videoNameinAlbum,videoUrlinAlbum,songThumnailUrl,strEncodedImage,songArtistName,count,albumsOBJ.AlbumName,buyDate,songTrackcode,songDuration];
            [database executeUpdate:insertSQLQuery];
        }
    }
    else
    {
        insertSQLQuery  = [NSString stringWithFormat:@"INSERT INTO Songs (songName,serverUrl,localUrl,thumbnail, songImage,artistName,albumId,albumName,songBuyDate,Trackcode,Duration) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", %d,\"%@\",\"%@\",\"%@\",\"%@\")",songsOBJ.VideoName,songsOBJ.VideoUrl,songLocalUrl,songsOBJ.ThumbnailUrl,strEncodedImage,songsOBJ.ArtistName,albumid,songsOBJ.AlbumName,buyDate,songsOBJ.trackcode,songsOBJ.duration];
        [database executeUpdate:insertSQLQuery];
        //  songsList =[[NSMutableArray alloc]init];
    }
    [database close];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    [self enable];

    if (alertView.tag == 3 && buttonIndex == 1) {
        [activityIndicatorObject startAnimating];
        [self songDownloading];
    }
    else if (alertView.tag == 10 && buttonIndex == 1) {
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
      //  [self payPalPayment];
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
        if (isAlbum) {
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

- (void) saveVideos{
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
    NSString *Str=[NSString stringWithFormat:@"%@",thumbnail];
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
    
    if (isAlbum)
    {
        NSString *insertSQL  = [NSString stringWithFormat:@"INSERT INTO Albums (albumName,albumImage,thumbnail,artistName,numberOfSongs,serverUrl,albumBuyDate) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\",%d,\"%@\", \"%@\")",albumNameLbl.text,strEncodedImage,thumbnail,artistNameLbl.text,[numbrOfSongsSongs intValue] ,albumServerUrl,date];
        [database executeUpdate:insertSQL];
        NSString *queryStr = [NSString stringWithFormat:@"Select max(albumId) from Albums "];
        int count = [database intForQuery:queryStr];
        for (NSString *item in subpaths)
        {
            videoNameinAlbum=[NSString stringWithFormat:@"%@",item];
            videoUrlinAlbum=[NSString stringWithFormat:@"%@/%@",filepath,item];
            videoNameinAlbum=[videoNameinAlbum stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
            insertSQLQuery  = [NSString stringWithFormat:@"INSERT INTO Songs (songName,localUrl,thumbnail, songImage,artistName,albumId,albumName,songBuyDate) VALUES ( \"%@\", \"%@\", \"%@\",\"%@\", \"%@\", %d,\"%@\",\"%@\")",videoNameinAlbum,videoUrlinAlbum,thumbnail,strEncodedImage,artistNameLbl.text,count,albumNameLbl.text,date];
            [database executeUpdate:insertSQLQuery];
        }
    }
    else
    {
        insertSQLQuery  = [NSString stringWithFormat:@"INSERT INTO Songs (songName,serverUrl,localUrl,thumbnail, songImage,artistName,albumId,albumName,songBuyDate) VALUES ( \"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\", %d,\"%@\",\"%@\")",videoNmaeLbl.text,videoURLStr,songLocalUrl,thumbnail,strEncodedImage,artistNameLbl.text,albumid,albumNameLbl.text,date];
        [database executeUpdate:insertSQLQuery];
    }
    [database close];
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
    if (webserviceCode == 3){
        if ([elementName isEqualToString:@"Result"]){
            message = [NSString stringWithFormat:@"%@", tempString];
            NSLog(@"Message %@",message);
        }
        
    }else{
    if ([elementName isEqualToString:@"Result"]){
        result = [NSString stringWithFormat:@"%@", tempString];
    }else if ([elementName isEqualToString:@"Message"]){
        message = [NSString stringWithFormat:@"%@", tempString];
    }else if([elementName isEqualToString:@"Data"]){
        if ([message isEqualToString:@"success"])
        {
            NSDate *now = [NSDate date];
            NSDateFormatter *df=[[NSDateFormatter alloc]init];
            [df setDateFormat:@"dd/MM/yyyy"];
            date=[[NSString alloc]initWithString:[df stringFromDate:now]];
            ASIHTTPRequest *request;
                
            request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",videoURLStr]]];
                
            if (isAlbum)
            {
                [request setDownloadDestinationPath:[[NSHomeDirectory()
                                                          stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",albumName]]];
            }
            else
            {
                NSString *str=[[NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videoName]];
                songLocalUrl=str;
                [request setDownloadDestinationPath:[[NSHomeDirectory()
                                                          stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videoName]]];
            }
            
            [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
                bytes= bytes+size;
                unsigned long long totalData=total/1024;
                self.progressLbl.text=[NSString stringWithFormat:@"%llukb/%llukb",bytes/1024,totalData];
                NSLog(@"%@",self.progressLbl.text);
                NSString *str = [NSString stringWithFormat:@"%f",(progressBar.progress)*100];
                progressStr =[str intValue];
                self.progressPercentlbl.text=[NSString stringWithFormat:@"%d%%",progressStr];
            }];
            proView.hidden=NO;
            [request setDownloadProgressDelegate:progressBar];
            [request setDelegate:self];
            [request startAsynchronous];
        }
    }
    }
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return songNameInAlbum.count ;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    UIButton *samplevideoBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        samplevideoBtn.frame = CGRectMake(10.0f, 6.0f, 60.0f, 52.0f);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        samplevideoBtn.frame = CGRectMake(10.0f, 6.0f, 60.0f, 52.0f);
        //this is iphone 4 xib
    }
    else{
        samplevideoBtn.frame = CGRectMake(10.0f, 6.0f, 60.0f, 52.0f);
        //this is ipad xib
    }
    
    samplevideoBtn.tag = indexPath.row;

    AvailbleSongsCell *cell1;
    cell1 = (AvailbleSongsCell *)[songsTableview dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
    NSArray *nib ;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell" owner:self options:nil];
        //this is iphone 4 xib
    }
    else{
        nib = [[NSBundle mainBundle] loadNibNamed:@"AvailbleSongsCell_ipad" owner:self options:nil];
        //this is ipad xib
    }
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        
//        scrollView.contentSize = CGSizeMake(320, 73.0*[songNameInAlbum count] +  490);
//        
//    }
//    else if([[UIScreen mainScreen] bounds].size.height == 480){
//        scrollView.contentSize = CGSizeMake(320,70.0*[songNameInAlbum count] +  510);
//        
//    }
//    else{
//        scrollView.contentSize = CGSizeMake(320,140.0*[songNameInAlbum count] +  490);
//        
//        
//    }
    cell1 = [nib objectAtIndex:0];
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.backgroundColor=[UIColor clearColor];
    videosInAlbum*obj = (videosInAlbum *)[songNameInAlbum objectAtIndex:indexPath.row];
    NSLog(@"%@",obj.videoThumbnailUrl);
    [cell1 setLabelText:obj.videoArtistName :obj.TrackCode :obj.VideoName :obj.Duration :[NSString stringWithFormat:@""] ];
    [cell1.contentView addSubview:samplevideoBtn];
    
    [samplevideoBtn addTarget:self action:@selector(sampleVideo:) forControlEvents:UIControlEventTouchUpInside];

    return cell1;
}


- (void)sampleVideo:(UIControl *)sender{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    videosInAlbum *songsObj;
    
    songsObj = (videosInAlbum *)[songNameInAlbum objectAtIndex:indexPath.row];
    //NSMutableArray*samplevideoArray=[[NSMutableArray alloc]init];
    NSLog(@"%@",songsObj.SampleVideoUrl);
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
    musicPlayerVc.sampleVideoUrl=[NSString stringWithFormat:@"%@",songsObj.SampleVideoUrl];
    musicPlayerVc.isAlbumTab=NO;
    musicPlayerVc.SongNameStr=songsObj.VideoName;
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
    strEncodedSongImage = [Base64 encode:data];
    NSLog(@"%@",strEncodedSongImage);
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
        return 140.0;
    }
}

- (void) disabled
{
    [activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled = NO;
    self.disableImg.hidden = NO;
}
- (void) enable
{
    [activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled = YES;
    self.disableImg.hidden = YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ||[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskPortrait;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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

- (IBAction)playSampleVideoBtn:(id)sender {
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
    
    musicPlayerVc.sampleVideoUrl=[NSString stringWithFormat:@"%@",self.songsOBJ.samplevideoUrl];
    NSLog(@"%@",musicPlayerVc.sampleVideoUrl);
    musicPlayerVc.SongNameStr=songsOBJ.VideoName;
    musicPlayerVc.isAlbumTab=NO;
    [self.navigationController pushViewController:musicPlayerVc animated:YES];

}
@end
