//
//  AccountDetailViewController.m
//  Karaoke
//
//  Created by Krishna_Mac_3 on 23/04/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "Base64.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
#import "accountDetail.h"
#import "ZipArchive.h"
#import "AvailableSongsViewController.h"
#import "MusicPlayerViewController.h"
#import "FMDatabaseAdditions.h"
#import "UIImageView+WebCache.h"

@interface AccountDetailViewController ()
{
    UIPickerView*myPickerView;
    UIDatePicker *pickdate;
    NSMutableArray *monthsArray,*yearsArray ,*songNameInAlbum;
    NSMutableString *yearString;
    NSDateComponents *currentDateComponents;
    NSString *monthStr,*yearStr,*monthYearStr;
    NSString *amountStr ,*cardTypeStr,*status, *videoIdstr,*message,*result,*videoURLStr,*filepath,*albumLocalUrl,*songLocalUrl,*albumSongsUrl , *videoNameinAlbum ,*videoUrlinAlbum,*strEncodedImage,*BuyDate,*SongImageUrl;
    NSMutableString *tempString;
    int progressStr;
    NSTimer *timer;
    NSArray *subpaths,*date;
    NSArray*songsNameinAlbum;
    NSMutableData *receivedData;
    long long bytesReceived;
    long long expectedBytes;
    float percentComplete;
    unsigned long long bytes;
    BOOL isNumberPad;
    UIButton *doneButton;

}
@end

@implementation AccountDetailViewController
@synthesize cardDateValidFromTxt,cardDateValidTo,cardHolderNameTxt,cardNumberTxt,cardTypeTxt,CVCNumberTxt,cardListArray,cardListCodeArray,cardTypeDropTable,isCardDateFrom,isCardDateTo,monthYearPickrView,viewPickr,songsOBJ,albumsOBJ,isSongs,isAlbum,songName,songImage,songPrice,artistname,accountDetailOBJ,progressBar,progressLabel,proView,dataRecievedLbl,activityIndicatorObject,scrollView,disabledimg,isresignTxt,songsArray,myPickerView, isCardTxt, useremailtxt,userNametxt;
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
    
    //scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        scrollView.contentSize = CGSizeMake(310, 520);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        scrollView.contentSize = CGSizeMake(310, 520);
        // this is iphone 4 xib
    }
    else
    {
        scrollView.contentSize = CGSizeMake(310, 1260);
    }

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    songNameInAlbum=[[NSMutableArray alloc]init];
    [self registerForKeyboardNotifications];
    songsArray=[[NSMutableArray alloc]init];
    if (isAlbum)
    {
        SongImageUrl=[NSString stringWithFormat:@"%@",albumsOBJ.ThumbnailUrl];
        songName.text=[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName];
        artistname.text=[NSString stringWithFormat:@"%@",albumsOBJ.ArtistName];
        songPrice.text=[NSString stringWithFormat:@"£ %@",albumsOBJ.AlbumPrice];
        amountStr=[NSString stringWithFormat:@"%@",albumsOBJ.AlbumPrice];
        videoIdstr=[NSString stringWithFormat:@"%d",albumsOBJ.AlbumId];
        videoURLStr=[NSString stringWithFormat:@"%@",albumsOBJ.AlbumUrl];
    }
    else
    {
        SongImageUrl=[NSString stringWithFormat:@"%@",songsOBJ.ThumbnailUrl];
        songName.text=[NSString stringWithFormat:@"%@",songsOBJ.VideoName];
        artistname.text=[NSString stringWithFormat:@"%@",songsOBJ.ArtistName];
        songPrice.text=[NSString stringWithFormat:@"£ %@",songsOBJ.VideoPrice];
        amountStr=[NSString stringWithFormat:@"%@",songsOBJ.VideoPrice];
        videoIdstr=[NSString stringWithFormat:@"%d",songsOBJ.VideoId];
        videoURLStr=[NSString stringWithFormat:@"%@",songsOBJ.VideoUrl];
    }
    
    
    SongImageUrl = [SongImageUrl stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];
    SongImageUrl = [SongImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:SongImageUrl];
    
    [self.songImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"stub.png"]];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.2f);// you can change the sy as you want
    progressBar.transform = transform;
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
 

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 160);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        activityIndicatorObject.center = CGPointMake(160, 160);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
   // activityIndicatorObject.color=[UIColor whiteColor];
    [self.view addSubview:activityIndicatorObject];

//    cardNumberTxt.text=@"5404000000000001";
    cardListArray=[NSArray arrayWithObjects:@"Select Card Type",@"VISA Credit",@"VISA Debit",@"VISA Electron",@"MasterCard Credit",@"MasterCard Debit", nil];
    cardListCodeArray=[NSArray arrayWithObjects:@"Select Card Type",@"VISA",@"DELTA",@"UKE",@"MC",@"MCDEBIT", nil];
    
    [[cardTypeDropTable layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[cardTypeDropTable layer] setBorderWidth:1.0];
    [[cardTypeDropTable layer] setCornerRadius:5];
    
    [[viewPickr layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[viewPickr layer] setBorderWidth:1.5];
    [[viewPickr layer] setCornerRadius:7];
 
    [[proView layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[proView layer] setBorderWidth:1.5];
    [[proView layer] setCornerRadius:7];
    
    NSCalendar *currentDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    //Array for picker view
    monthsArray=[[NSMutableArray alloc]initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
    yearsArray=[[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
  
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM"];
    monthStr=[dateFormatter1 stringFromDate:now];
  
    yearString = [dateFormatter stringFromDate:now];
    yearStr=[yearString substringFromIndex:[yearString length]-2];
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
  myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 62,250, 170)];        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
  myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 62,250, 170)];        // this is iphone 4 xib
    }
    else
    {
  myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 82,650, 270)];
    }
    

  
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    viewPickr.backgroundColor=[UIColor grayColor];
    [myPickerView selectRow:6 inComponent:1 animated:YES];
    [myPickerView selectRow:[monthStr intValue]-1  inComponent:0 animated:YES];

   //[myPickerView selectRow:[currentDateComponents month]-1 inComponent:0 animated:YES];
    [self.viewPickr addSubview:myPickerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender {
    viewPickr.hidden=YES;
    cardTypeDropTable.hidden=YES;
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)cardtypeBtn:(id)sender
{
    if (cardTypeDropTable.hidden==YES) {
        cardTypeDropTable.hidden=NO;
    }else if (cardTypeDropTable.hidden ==NO)
    {
        cardTypeDropTable.hidden=YES;
    }
    viewPickr.hidden=YES;
    
    [self.view endEditing:YES];
}

- (IBAction)dateValidFromBtn:(id)sender
{

    yearsArray=[[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];

    
    yearString = [dateFormatter stringFromDate:now];
    yearStr=[yearString substringFromIndex:[yearString length]-2];
    int year=[yearString intValue];
    yearString=[NSString stringWithFormat:@"%d",year-10];
    
    for (int i=0; i<11; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"%d",[yearString intValue]+i]];
    }
    
    
    
    [self.view endEditing:YES];
    viewPickr.hidden=NO;
    cardTypeDropTable.hidden=YES;
    isCardDateFrom=YES;
    isCardDateTo=NO;
    [myPickerView reloadAllComponents];
    [self.myPickerView selectRow:yearsArray.count-1 inComponent:1 animated:YES];
   // [myPickerView reloadComponent:IndexOfReloadComponent];
}

- (IBAction)dateValidToBtn:(id)sender
{
    
    yearsArray=[[NSMutableArray alloc]init];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    yearString = [dateFormatter stringFromDate:now];
    yearStr=[yearString substringFromIndex:[yearString length]-2];
    int year=[yearString intValue];
    yearString=[NSMutableString stringWithFormat:@"%d",year];
    
    for (int i=0; i<11; i++)
    {
        [yearsArray addObject:[NSString stringWithFormat:@"%d",[yearString intValue]+i]];
    }
    

    [self.view endEditing:YES];
    viewPickr.hidden=NO;
    cardTypeDropTable.hidden=YES;
    isCardDateFrom=NO;
    isCardDateTo=YES;
    [myPickerView reloadAllComponents];
    [myPickerView selectRow:0 inComponent:1 animated:YES];
//    [myPickerView reloadComponent:IndexOfReloadComponent];
//    NSDate *now = [NSDate date];
//    NSLog(@"now: %@", now);
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM"];
//    monthStr = [dateFormatter stringFromDate:now];
//    NSLog(@"month..%@",monthStr);
}

- (IBAction)payNowBtn:(id)sender
{
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailReg];

    [self.view endEditing:YES];
    viewPickr.hidden=YES;
    cardTypeDropTable.hidden=YES;
    
    if ([cardTypeTxt.text isEqualToString:@""] && [cardNumberTxt.text isEqualToString:@""] && [cardHolderNameTxt.text isEqualToString:@""] && [cardDateValidFromTxt.text isEqualToString:@""] && [cardDateValidTo.text isEqualToString:@""]&& [CVCNumberTxt.text isEqualToString:@""] )
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter details.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([cardTypeTxt.text isEqualToString:@""] || [cardTypeTxt.text isEqualToString: @"Select Card Type"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Select Card Type" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else if([cardNumberTxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter card number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([userNametxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter Your Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if([useremailtxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter Your Email Address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([emailTest evaluateWithObject:useremailtxt.text] != YES)
    {
        UIAlertView *loginalert = [[UIAlertView alloc] initWithTitle:@"Zoom Karaoke" message:@"Please enter valid user email" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [loginalert show];
    }
    else if ([cardHolderNameTxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter card holder name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([cardDateValidFromTxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter Start validity date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([cardDateValidTo.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter end validity date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if ([CVCNumberTxt.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Enter CVC number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Your Card Will Be Charged £0.99 British Pounds" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        [alertview show];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return cardListArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *av;

    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 277, 58)];
         cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 277, 58)];
       cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        // this is iphone 4 xib
    }
    else
    {
        av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 694, 200)];
         cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    }

    
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = [UIImage imageNamed:@"greyBg.jpeg"];
    cell.backgroundView = av;
    cell.textLabel.text=[cardListArray objectAtIndex:indexPath.row];
   

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    cardTypeTxt.text=[cardListArray objectAtIndex:indexPath.row];
    cardTypeStr=[cardListCodeArray objectAtIndex:indexPath.row];
    cardTypeDropTable.hidden=YES;
}


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    if (component==0)
    {
        rowsInComponent=[monthsArray count];
    }
    else
    {
        rowsInComponent=[yearsArray count];
    }
    return rowsInComponent;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component==0) {
        NSLog(@"[currentDateComponents month]-->%ld<--",(long)[currentDateComponents month]);
        NSLog(@"%@",[monthsArray objectAtIndex: row]);
        monthStr= [NSString stringWithFormat:@"%d",row+1];
        NSLog(@"-->%d<--",row+1);
        NSLog(@"-->%@<--",[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]);
        yearStr=[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]];
        NSLog(@"%lu",(unsigned long)[monthStr length]);
        if ( [monthStr length]<2) {
            monthStr =[NSString stringWithFormat:@"0%@",monthStr];
        }

    }
    else{
        NSLog(@"-->%@<--",[monthsArray objectAtIndex:[pickerView selectedRowInComponent:0]]);
       // monthStr=[monthsArray objectAtIndex:[pickerView selectedRowInComponent:1]];
        NSLog(@"%ld",(long)row);
        yearStr=[yearsArray objectAtIndex: row];
        
        NSLog(@"%@",[yearsArray objectAtIndex:row]);
    }
    
       yearStr=[yearStr substringFromIndex:[yearStr length]-2];
    
//    NSLog(@"[currentDateComponents month]-->%d<--",[currentDateComponents month]);
//    NSLog(@"-->%d<--",row);
//    NSLog(@"row->%@<--",[yearsArray objectAtIndex:row]);
    NSLog(@"-->%@<--",[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]]);
//    NSLog(@"%@",[monthsArray objectAtIndex: row]);
 
    if ([pickerView selectedRowInComponent:0]+1<[currentDateComponents month] && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
    {
        [pickerView selectRow:[currentDateComponents month]-1 inComponent:0 animated:YES];
        
        NSLog(@"Need to shift");
    }
    if (component==1) {
        [myPickerView reloadAllComponents];
        [myPickerView reloadComponent:0];
    }
    if (component==0) {
        [myPickerView reloadAllComponents];
        [myPickerView reloadComponent:1];

    }
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    label.text = component==0?[monthsArray objectAtIndex:row]:[yearsArray objectAtIndex:row];
    
    if (component==0)
    {
        if (row+1<[currentDateComponents month] && [[yearsArray objectAtIndex:[pickerView selectedRowInComponent:1]] intValue]==[currentDateComponents year])
        {
            label.textColor = [UIColor grayColor];
        }
    }
    return label;
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth ;
    
    if (component==0)
    {
        componentWidth = 80;
    }
    else  {
        componentWidth = 80;
    }
    
    return componentWidth;
}

- (IBAction)doneBtn:(id)sender {
    
    monthYearStr=[NSString stringWithFormat:@"%@%@",monthStr,yearStr];
    
    NSLog(@"%@",monthYearStr);
    if ( isCardDateFrom) {
        cardDateValidFromTxt.text=monthYearStr;
    }
    else if (isCardDateTo){
        cardDateValidTo.text=monthYearStr;

    }
    viewPickr.hidden=YES;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    proView.hidden=YES;
    [self enable];

    [activityIndicatorObject stopAnimating];
    [self.view setUserInteractionEnabled:YES];

    NSError *error = [request error];
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:@"Connection error..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertview show];
    NSLog(@"res error :%@",error.description);
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
//    [songstabOutlet setUserInteractionEnabled:YES];
//    [albumsTabOutlet setUserInteractionEnabled:YES];
    
    NSLog(@"response%@", responseString);
   [activityIndicatorObject stopAnimating];
    
    NSData *responseData = [request responseData];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    
        if (responseString ==nil) {
            self.progressLabel.text=@"100%";
          
            if (isAlbum) {

//                NSString *zipPath=[[NSHomeDirectory()
//                                    stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",albumsOBJ.AlbumName]];
//                filepath =[[NSHomeDirectory()
//                            stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",albumsOBJ.AlbumName]];

                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                filepath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, albumsOBJ.AlbumName];
                NSString *zipPath = [NSString stringWithFormat:@"%@/%@.zip", documentsDirectory, albumsOBJ.AlbumName];
                NSLog(@"filePath %@", filepath);
                
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
               
                
                // NSString *str=[subpaths objectAtIndex:0];
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
                        
                        //  BOOL sucess=[manager copyItemAtPath:strpath toPath:songPath error:&error];
                        // NSLog(@"%@",sucess);
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
            
            proView.hidden=YES;
            [self enable];
            [self insrtTransectionService];
          
    }
}

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict

{
    if (webserviceCode==1)
    {
        if ([elementName isEqualToString:@"Status"]){
            accountDetailOBJ = [accountDetail alloc];
            tempString = [[NSMutableString alloc] init];
            
        }else if ([elementName isEqualToString:@"StatusDetail"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"VPSTxId"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"SecurityKey"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"TxAuthNo"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AVSCV2"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"AddressResult"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"PostCodeResult"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"CV2Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"SecureStatus"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"FraudResponse"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"ExpiryDate"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"BankAuthCode"]){
            tempString = [[NSMutableString alloc] init];
        }else if([elementName isEqualToString:@"DeclineCode"]){
            tempString = [[NSMutableString alloc] init];
        }
 
    }
    else{
        
        if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Message"]){
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
    if (webserviceCode==1) {
        if ([elementName isEqualToString:@"Status"]){
            status=[NSString stringWithFormat:@"%@",tempString];
            accountDetailOBJ=[[accountDetail alloc]init];
            accountDetailOBJ.Status=[NSString stringWithFormat:@"%@",tempString];
        }else if ([elementName isEqualToString:@"StatusDetail"]){
            accountDetailOBJ.StatusDetail=[NSString stringWithFormat:@"%@",tempString];
        }
        else if ([elementName isEqualToString:@"VPSTxId"]){
            accountDetailOBJ.VPSTxId = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"SecurityKey"]){
            accountDetailOBJ.SecurityKey = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"TxAuthNo"]){
            accountDetailOBJ.TxAuthNo = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"AVSCV2"]){
            accountDetailOBJ.AVSCV2 = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"AddressResult"]){
            accountDetailOBJ.AddressResult = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"PostCodeResult"]){
            accountDetailOBJ.PostCodeResult = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"CV2Result"]){
            accountDetailOBJ.CV2Result = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"SecureStatus"]){
            accountDetailOBJ.SecureStatus = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"FraudResponse"]){
            accountDetailOBJ.FraudResponse = [NSString stringWithFormat:@"%@", tempString];
        }
        else if([elementName isEqualToString:@"ExpiryDate"]){
            accountDetailOBJ.ExpiryDate = [NSString stringWithFormat:@"%@", tempString];
        }
        else if ([elementName isEqualToString:@"BankAuthCode"]){
            accountDetailOBJ.BankAuthCode = [NSString stringWithFormat:@"%@", tempString];
        }
        else if([elementName isEqualToString:@"DeclineCode"]){
            accountDetailOBJ.DeclineCode = [NSString stringWithFormat:@"%@", tempString];
        }
        else if([elementName isEqualToString:@"SagePayResponse"]){
            if ([status isEqualToString:@"OK"]) {
                NSLog(@"start downloading");
                
                
                NSDate *now = [NSDate date];
                NSDateFormatter *df=[[NSDateFormatter alloc]init];
                [df setDateFormat:@"dd/MM/yyyy"];
               BuyDate=[[NSString alloc]initWithString:[df stringFromDate:now]];
                ASIHTTPRequest *request;
                
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
                    self.dataRecievedLbl.text=[NSString stringWithFormat:@"%llukb/%llukb",bytes/1024,totalData];
                    NSLog(@"%@",self.dataRecievedLbl.text);
                    NSString *str = [NSString stringWithFormat:@"%f",(progressBar.progress)*100];
                    progressStr =[str intValue];
                    self.progressLabel.text=[NSString stringWithFormat:@"%d%%",progressStr];
                }];
                [request setDownloadProgressDelegate:progressBar];
                [request setDelegate:self];
                [request startAsynchronous];
                
            }
            else
            {
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Zoom Karaoke" message:[NSString stringWithFormat:@"%@", accountDetailOBJ.StatusDetail] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertview show];
                [self enable];
                [self.view setUserInteractionEnabled:YES];
            }
        }
    }
    else{
        if ([elementName isEqualToString:@"Result"]){
            result = [NSString stringWithFormat:@"%@", tempString];
            if ([result isEqualToString:@"0"])
            {
                [self saveSongs];
                UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Download Complete" message:@"Do you want to play this song?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Later", nil];
                [alrt show];
            }
        }
        else if ([elementName isEqualToString:@"Message"]){
            message = [NSString stringWithFormat:@"%@", tempString];
        }
    }
}

- (void)insrtTransectionService
{
    [activityIndicatorObject startAnimating];
    [self disabled];
    [self.view setUserInteractionEnabled:NO];
    webserviceCode=2;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/InsertTransaction",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSString *video_ID;
    NSString *user_UDID;
    NSString *Status;
    NSString *StatusDetail;
    NSString *VPSTxId;
    NSString *SecurityKey;
    NSString *TxAuthNo;
    NSString *AVSCV2;
    NSString *AddressResult;
    NSString *PostCodeResult;
    NSString *CV2Result;
    NSString *FraudResponse;
    NSString *ExpiryDate;
    NSString *BankAuthCode;
    NSString *SecureStatus;
    NSString *DeclineCode;
    NSString *transaction_date;
    NSString *UserName;
    NSString *UserEmail;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userUDIDStr = [defaults objectForKey:@"user_UDID_Str"];
    
    if(video_ID==nil)
        video_ID = [NSString stringWithFormat:@"%@",videoIdstr];
    [request setPostValue:video_ID forKey:@"video_ID"];
    
    if(user_UDID==nil)
        
        user_UDID = [NSString stringWithFormat:@"%@",userUDIDStr];
    [request setPostValue:user_UDID forKey:@"user_UDID"];
    
    if(Status==nil)
        Status = [NSString stringWithFormat:@"%@",accountDetailOBJ.Status];
    [request setPostValue:Status forKey:@"Status"];
    
    if(StatusDetail==nil)
        StatusDetail = [NSString stringWithFormat:@"%@",accountDetailOBJ.StatusDetail];
    [request setPostValue:StatusDetail forKey:@"StatusDetail"];
    
    if(VPSTxId==nil)
        VPSTxId = [NSString stringWithFormat:@"%@",accountDetailOBJ.VPSTxId];
    [request setPostValue:VPSTxId forKey:@"VPSTxId"];
    
    if(SecurityKey==nil)
        SecurityKey = [NSString stringWithFormat:@"%@",accountDetailOBJ.SecurityKey];
    [request setPostValue:SecurityKey forKey:@"SecurityKey"];
    
    if(TxAuthNo==nil)
        TxAuthNo = [NSString stringWithFormat:@"%@",accountDetailOBJ.TxAuthNo];
    [request setPostValue:TxAuthNo forKey:@"TxAuthNo"];
    
    if(AVSCV2==nil)
        AVSCV2 = [NSString stringWithFormat:@"%@",accountDetailOBJ.AVSCV2];
    [request setPostValue:AVSCV2 forKey:@"AVSCV2"];
    
    if(AddressResult==nil)
        AddressResult = [NSString stringWithFormat:@"%@",accountDetailOBJ.AddressResult];
    [request setPostValue:AddressResult forKey:@"AddressResult"];
    
    if(PostCodeResult==nil)
        PostCodeResult = [NSString stringWithFormat:@"%@",accountDetailOBJ.PostCodeResult];
    [request setPostValue:PostCodeResult forKey:@"PostCodeResult"];
    
    if(CV2Result==nil)
        CV2Result = [NSString stringWithFormat:@"%@",accountDetailOBJ.CV2Result];
    [request setPostValue:CV2Result forKey:@"CV2Result"];
    
    if(FraudResponse==nil)
        FraudResponse = [NSString stringWithFormat:@"%@",accountDetailOBJ.FraudResponse];
    [request setPostValue:FraudResponse forKey:@"FraudResponse"];
    
    if(ExpiryDate==nil)
        ExpiryDate = [NSString stringWithFormat:@"%@",accountDetailOBJ.ExpiryDate];
    [request setPostValue:ExpiryDate forKey:@"ExpiryDate"];
    
    if(BankAuthCode==nil)
        BankAuthCode = [NSString stringWithFormat:@"%@",accountDetailOBJ.BankAuthCode];
    [request setPostValue:BankAuthCode forKey:@"BankAuthCode"];
    
    if(SecureStatus==nil)
        SecureStatus = [NSString stringWithFormat:@"%@",accountDetailOBJ.SecureStatus];
    [request setPostValue:SecureStatus forKey:@"SecureStatus"];
    
    if(DeclineCode==nil)
        DeclineCode = [NSString stringWithFormat:@"%@",accountDetailOBJ.DeclineCode];
    [request setPostValue:DeclineCode forKey:@"DeclineCode"];
    
    if(transaction_date==nil)
        transaction_date = [NSString stringWithFormat:@"abc"];
    [request setPostValue:transaction_date forKey:@"transaction_date"];
    
    if(UserName==nil)
        UserName = [NSString stringWithFormat:@"%@",userNametxt.text];
    [request setPostValue:UserName forKey:@"name"];
    
    if(UserEmail==nil)
        UserEmail = [NSString stringWithFormat:@"%@",useremailtxt.text];
    [request setPostValue:UserEmail forKey:@"email"];
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
     if([title isEqualToString:@"Continue"]){
        NSLog(@"continue");
         subpaths=nil;
         [self disabled];
        [activityIndicatorObject startAnimating];
        [self.view setUserInteractionEnabled:NO];

        webserviceCode=1;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/SagePayDirect",Kwebservices]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSString *amount;
        NSString *Description;
        NSString *CardType;
        NSString *CardNumber;
        NSString *CardHolderName;
        NSString *StartDate;
        NSString *CardExpiryDate;
        NSString *CvcNumber;
        NSString *UserName;
         NSString *UserEmail;
        if(amount==nil)
            amount = [NSString stringWithFormat:@"%@",amountStr];
        [request setPostValue:amount forKey:@"amount"];
        
        if(Description==nil)
            Description = [NSString stringWithFormat:@"%@",songName.text];
        [request setPostValue:Description forKey:@"Description"];
        
        if(CardType==nil)
            CardType = [NSString stringWithFormat:@"%@",cardTypeStr];
        [request setPostValue:CardType forKey:@"CardType"];
        
        if(CardNumber==nil)
            CardNumber = [NSString stringWithFormat:@"%@",cardNumberTxt.text];
        [request setPostValue:CardNumber forKey:@"CardNumber"];
        
        if(CardHolderName==nil)
            CardHolderName = [NSString stringWithFormat:@"%@",cardHolderNameTxt.text];
        [request setPostValue:CardHolderName forKey:@"CardHolderName"];
        
        if(StartDate==nil)
            StartDate = [NSString stringWithFormat:@"%@",cardDateValidFromTxt.text];
        [request setPostValue:StartDate forKey:@"StartDate"];
        
        if(CardExpiryDate==nil)
            CardExpiryDate = [NSString stringWithFormat:@"%@",cardDateValidTo.text];
        [request setPostValue:CardExpiryDate forKey:@"CardExpiryDate"];
        
        if(CvcNumber==nil)
            CvcNumber = [NSString stringWithFormat:@"%@",CVCNumberTxt.text];
        [request setPostValue:CvcNumber forKey:@"CvcNumber"];
        
         if(UserName==nil)
             UserName = [NSString stringWithFormat:@"%@",userNametxt.text];
         [request setPostValue:UserName forKey:@"Name"];
         
         if(UserEmail==nil)
             UserEmail = [NSString stringWithFormat:@"%@",useremailtxt.text];
         [request setPostValue:UserEmail forKey:@"Email"];
         
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request startAsynchronous];
        

     }
     else if([title isEqualToString:@"YES"]){
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
             [songNameArray addObject:songName.text];
             musicPlayerVc.songsNameList=songNameArray;

             musicPlayerVc.isAlbumTab=NO;
         }
         musicPlayerVc.isDownlodedSong=YES;

         [self.navigationController pushViewController:musicPlayerVc animated:YES];
         
     }
     else if([title isEqualToString:@"NO"])
     {
         AvailableSongsViewController *availSongsVc;
         if ([[UIScreen mainScreen] bounds].size.height == 568) {

         availSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController" bundle:Nil];
         
         //this is iphone 5 xib
         }
         else if([[UIScreen mainScreen] bounds].size.height == 480){
             availSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_iphone4" bundle:Nil];
         // this is iphone 4 xib
         }
         else{
              availSongsVc=[[AvailableSongsViewController alloc]initWithNibName:@"AvailableSongsViewController_ipad" bundle:Nil];
         }
         
         
         if (isAlbum) {
             availSongsVc.triggerValue=@"albums";
         }
         else{
             availSongsVc.triggerValue=@"videos";
         }
         CATransition *transition = [CATransition animation];
         transition.duration = 0.3;
         transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
         transition.type = kCATransitionPush;
         transition.subtype = kCATransitionFromLeft;
         [self.navigationController.view.layer addAnimation:transition
                                                     forKey:kCATransition];
         [self.navigationController pushViewController:availSongsVc animated:YES];
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
    NSURL *bgImageURL = [NSURL URLWithString:SongImageUrl];
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
    }
    [database close];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    isNumberPad=NO;
    [textField resignFirstResponder];
    return YES;
}

- (void) disabled
{
    self.view.userInteractionEnabled = NO;
    self.disabledimg.hidden = NO;
    
}
- (void) enable
{
    self.view.userInteractionEnabled = YES;
    self.disabledimg.hidden = YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ((textField ==CVCNumberTxt) || (textField == cardNumberTxt))
    {
        doneButton.hidden=NO;

        isNumberPad=YES;
        if (textField == cardNumberTxt) {
            isCardTxt = YES;
        }else{
            isCardTxt = NO;
        }
    }
    else{
        doneButton.hidden=YES;
        isNumberPad=NO;
        if ((textField == cardHolderNameTxt) || (textField == userNametxt)) {
            isCardTxt = YES;
        }else{
            isCardTxt = NO;
        }
    }
    viewPickr.hidden=YES;
    cardTypeDropTable.hidden=YES;

          return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField ==CVCNumberTxt)
    {
        isNumberPad=NO;
 
    }
       return YES;
}


 //Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
 if (![[UIDevice currentDevice] userInterfaceIdiom] ==  UIUserInterfaceIdiomPad)
 {
        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // exactly of image size
        doneButton.frame = CGRectMake(0, 163, 106, 53);
        
        doneButton.adjustsImageWhenHighlighted = NO;
        
        [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
        
        [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
        
        [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // locate keyboard view
        
        UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
        
        UIView* keyboard;
        
        for(int i=0; i<[tempWindow.subviews count]; i++) {
            
            keyboard = [tempWindow.subviews objectAtIndex:i];
        }
        
        // keyboard view found; add the custom button to it
        
        [keyboard addSubview:doneButton];
        
    if (isNumberPad) {
        doneButton.hidden=NO;
    }
    else{
        doneButton.hidden=YES;
    }
    isNumberPad=NO;
    
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
     
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        CGPoint scrollPoint;
    
        if (isCardTxt) {
            scrollPoint = CGPointMake(0.0, 0.0);
            isCardTxt = NO;
        }else{
        scrollPoint = CGPointMake(0.0, cardDateValidTo.frame.origin.y-kbSize.height+80);
        }
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (IBAction) doneButton:(id) sender

{
    [CVCNumberTxt resignFirstResponder];
    [cardNumberTxt resignFirstResponder];
    //objNumberPad is the Keyboard
    NSLog(@"jghjfhdgf");
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
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
@end
