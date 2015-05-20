//
//  LocationAndPriceDetailViewController.m
//  RapidRide
//
//  Created by Br@R on 08/10/14.
//  Copyright (c) 2014 krishna innovative software pvt ltd. All rights reserved.
//

#import "LocationAndPriceDetailViewController.h"
#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SBJSON.h"
#import "JSON.h"
@interface LocationAndPriceDetailViewController ()

@end

@implementation LocationAndPriceDetailViewController
@synthesize priceBackView,locationBackView,distanceLbl,priceLbl,requestBtn,startLocationView,destinationLocView,headerLbl,startLocAddressStr,endLocAddressStr,distanceStr,start_longitude,start_latitude,end_longitude,end_latitude,destinationNameLbl,startLocNameLbl,startLocNameStr,endLocNameStr,activityIndicatorObject,disableImg,price_per_minute,price_per_mile,base_fare,scrollView,driverIdStr,driverIdArray,vehicleType,isOneWay,isVIP,actualFare,isHalfDay,isFullday,surgeValue,isFavDriver,driverList,minPrice,fromEndView,pickupdatetimestrfromView;

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

    color=@"pink";
    self.colourLbl.text=color;
    self.colourView.layer.borderColor = [UIColor blackColor].CGColor;
    self.colourView.layer.borderWidth = 2.5;
    self.colourView.layer.cornerRadius = 10.0;
    [self.colourView setClipsToBounds:YES];
    
    currentDate = [NSDate date];
    NSTimeInterval afterOneHours= 1 * 60 * 60;
    dateAftrHours = [currentDate dateByAddingTimeInterval:afterOneHours];

    [self.datePicker setDate:dateAftrHours animated:NO];
    selectedDate = [self.datePicker date];
    
    [super viewDidLoad];
    NSLog(@"driverIdArray..%lu",(unsigned long)driverIdArray.count);
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    currentDateStr=[dateFormatter stringFromDate:now];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    trip_request_date= [dateFormatter stringFromDate:now];
    
    self.dateTimeLbl.text=[NSString stringWithFormat:@"NOW"];
    self.dateTimeLbl.textColor=[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1];
    
    if (fromEndView)
    {
        startEditBTn.hidden=YES;
        self.editDestinationBtn.hidden=YES;
        if ([pickupdatetimestrfromView isEqualToString:@"Now"])
        {
            self.dateTimeLbl.text=[NSString stringWithFormat:@"NOW"];
        }
        else{
            self.dateTimeLbl.text=[NSString stringWithFormat:@"%@",pickupdatetimestrfromView];
        }
        
    }

   
    UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"Helvetica-Bold"] size:16];
    self.dateTimeLbl.font = newFont;
    self.dateDoneBtn.hidden=YES;
    self.dateCancelBtn.hidden=YES;
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dataDict=[[NSMutableDictionary alloc]init];
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    userIdStr= [dataDict valueForKey:@"userid"];
    riderMobileNum=[dataDict valueForKey:@"phone"];
    riderDriverIdStr=[dataDict valueForKey:@"driverid"];

    driverMobileNum=@"";
    riderMobileNum=@"";
    //driverIdStr=[dataDict valueForKey:@"driverid"];
    [self.requestBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    [self.selectDriverBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:18]];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [self.destinationNameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.startLocNameLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:16]];
    [self.destinationLocView setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    [self.startLocationView setFont:[UIFont fontWithName:@"Myriad Pro" size:13]];
    [self.estimatedTimeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    [self.colourHeaderLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:22]];
    [self.colourLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    [self.pickupDateView setFrame:CGRectMake(10.0, 250.0, 300.0, 36.0)];
    [priceBackView setFrame:CGRectMake(10.0, 290.0, 300.0, priceBackView.frame.size.height)];
    [requestBtn setFrame:CGRectMake(self.requestBtn.frame.origin.x,456.0, self.requestBtn.frame.size.width, self.requestBtn.frame.size.height)];
    
    self.datePicker.hidden=YES;
    self.datePicker.userInteractionEnabled=NO;
    
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        scrollView.contentSize = CGSizeMake(320, 600);
        scrollView.scrollEnabled = YES;
       // scrollView.delegate = self;
        
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480){
        scrollView.contentSize = CGSizeMake(320, 600);
    }
    
    else{
        scrollView.contentSize = CGSizeMake(768, 1700);
        
    }
    scrollView.backgroundColor=[UIColor clearColor];
    
    if (isVIP)
    {
        self.priceLbl.text=[NSString stringWithFormat:@"$%@",actualFare];
        self.ownProceLbl.text=@"";
        self.destinationLocView.hidden=YES;
        self.destinationNameLbl.hidden=YES;
        self.destinationLocHeaderLabel.hidden=YES;
        self.editDestinationBtn.hidden=YES;
        self.editDestinationBtn.userInteractionEnabled=NO;
        self.nameurPriceLabel.hidden=YES;
        self.timeLabel.hidden=YES;
        self.estimatedTimeLbl.hidden=YES;
        self.distLabel.hidden=YES;
        self.estimatedTimeLbl.hidden=YES;
        self.mypriceLabel.hidden=YES;
    }
    else
    {
        NSString *url=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%f,%f&destinations=%f,%f&mode=driving&language=en-EN&sensor=false",start_latitude,start_longitude,end_latitude,end_longitude];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchData:data];
        });
    }
    
 
    start_loc=startLocAddressStr;
    destination_loc=endLocAddressStr;
    
    NSArray* startTempArray = [startLocAddressStr componentsSeparatedByString: @","];
    startLocNameStr =[NSString stringWithFormat:@"%@", [startTempArray objectAtIndex: 0]];
    
    for (int j=0;j<startTempArray.count; j++)
    {
        if (j!=0)
        {
            if (j==1)
            {
                startLocAddressStr=[NSString stringWithFormat:@"%@",[startTempArray objectAtIndex:j]];
            }
            else
            {
                startLocAddressStr=[NSString stringWithFormat:@"%@,%@",startLocAddressStr,[startTempArray objectAtIndex:j]];
            }
            
        }
    }
    
    NSArray* endTempArray = [endLocAddressStr componentsSeparatedByString: @","];
    endLocNameStr =[NSString stringWithFormat:@"%@", [endTempArray objectAtIndex: 0]];
    
    for (int j=0;j<endTempArray.count; j++)
    {
        if (j!=0)
        {
            if (j==1)
            {
                endLocAddressStr=[NSString stringWithFormat:@"%@",[endTempArray objectAtIndex:j]];
            }
            else
            {
                endLocAddressStr=[NSString stringWithFormat:@"%@,%@",endLocAddressStr,[endTempArray objectAtIndex:j]];
            }
        }
    }
    

    startLocNameLbl.text=[NSString stringWithFormat:@"%@",startLocNameStr];
    destinationNameLbl.text=[NSString stringWithFormat:@"%@",endLocNameStr];
    
    startLocationView.text=[NSString stringWithFormat:@"%@",startLocAddressStr];
    destinationLocView.text=[NSString stringWithFormat:@"%@",endLocAddressStr];

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
    activityIndicatorObject.color=[UIColor grayColor];
    [self.view addSubview:activityIndicatorObject];
    
}

-(void)addPickerView
{
    priceArray=[[NSMutableArray alloc]init];
    for (int j=[minimumPrice intValue]; j<=[maximumPrice intValue]; j++)
    {
        [priceArray addObject:[NSString stringWithFormat:@"%d",j]];
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(180, 10,85, 50)];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(180, 10,85, 50)];
        // this is iphone 4 xib
    }
 
    
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    [myPickerView selectRow:0  inComponent:0 animated:YES];
    [self.priceBackView addSubview:myPickerView];
    if (isVIP){
        myPickerView.userInteractionEnabled=NO;
    }
    else{
        myPickerView.userInteractionEnabled=YES;

    }
    NSString *suggestedFareStr=priceLbl.text;
    NSString *orgStr=[suggestedFareStr stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSInteger IntSuggestedFare= [orgStr integerValue];
    
    for (int i=0; i<[priceArray count]; i++)
    {
       NSString *str= [priceArray objectAtIndex:i];
        NSInteger arrayFareValue=[str integerValue];
        if (arrayFareValue==IntSuggestedFare)
        {
            [myPickerView selectRow:i inComponent:0 animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)editStartLocation:(id)sender {
    
    MapViewController *mapVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mapVC=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        mapVC=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    mapVC.isStartLoc=YES;
    mapVC.isEndLoc=NO;
    mapVC.startLatitude=start_latitude;
    mapVC.startLongitude=start_longitude;
    mapVC.endLattitude=end_latitude;
    mapVC.endLongitude=end_longitude;
    mapVC.destinationLocationStr=[NSString stringWithFormat:@"%@, %@",endLocNameStr,endLocAddressStr];
    mapVC.startLocationStr=[NSString stringWithFormat:@"%@, %@",startLocNameStr,startLocAddressStr];
    mapVC.vehicleType=vehicleType;
    mapVC.isVIP=isVIP;
    mapVC.isOneWay=isOneWay;
    mapVC.isHalfDay=isHalfDay;
    mapVC.isFullDay=isFullday;
    mapVC.isFavDriver=isFavDriver;
    mapVC.minPrice=minPrice;
    
    [self.navigationController pushViewController: mapVC animated:YES];
}

- (IBAction)editEndLocation:(id)sender {
    MapViewController *mapVC;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mapVC=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        mapVC=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }

    mapVC.isEndLoc=YES;
    mapVC.isStartLoc=NO;
    mapVC.endLattitude=end_latitude;
    mapVC.endLongitude=end_longitude;
    mapVC.startLatitude=start_latitude;
    mapVC.startLongitude=start_longitude;
    mapVC.startLocationStr=[NSString stringWithFormat:@"%@ ,%@",startLocNameStr,startLocAddressStr];
    mapVC.destinationLocationStr=[NSString stringWithFormat:@"%@ ,%@",endLocNameStr,endLocAddressStr];
    mapVC.price_per_minute=price_per_minute;
    mapVC.price_per_mile=price_per_mile;
    mapVC.driverIdStr=driverIdStr;
    mapVC.base_fare=base_fare;
    mapVC.driverIdArray=[driverIdArray copy];
    mapVC.vehicleType=vehicleType;
    mapVC.isVIP=isVIP;
    mapVC.isOneWay=isOneWay;
    mapVC.surgeValue=surgeValue;
    mapVC.minPrice=minPrice;

    [self.navigationController pushViewController: mapVC animated:YES];
    
}
- (IBAction)requestPickupBtn:(id)sender
{
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disableImg.hidden=NO;
    NSArray *driverTempArray ;
    NSLog(@"driverarray.. %@",[driverIdArray objectAtIndex:0]);
    
    if ( driverIdArray.count>0)
    {
        for (int k=0; k<driverIdArray.count; k++)
        {
            if (k==0)
            {
                driverList=[NSString stringWithFormat:@"%@",[driverIdArray objectAtIndex:k]];
            }
            else if(k>0)
            {
                driverList=[NSString stringWithFormat:@"%@,%@",driverList,[driverIdArray objectAtIndex:k]];
            }
        }
    }
    
    NSLog(@"driverTempArray.. %@",driverIdArray );
    NSLog(@"driverlist.. %@",driverList);
    NSString *vehicle_type=[[NSUserDefaults standardUserDefaults ]valueForKey:@"prefvehicletype"];
    
    if ([self.dateTimeLbl.text isEqualToString:@"Now"] || [self.dateTimeLbl.text isEqualToString:@"NOW"])
    {
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        trip_request_date= [dateFormatter stringFromDate:now];
    }
    NSDictionary *jsonDict;
    if(isVIP)
    {
        NSString *VipStr;
        if (isHalfDay)
        {
            VipStr=@"viphalf";
        }
        else{
            VipStr=@"vipfull";
        }
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:userIdStr,@"riderId",driverIdStr,@"driverId",@"",@"ending_loc",start_loc,@"starting_loc",[NSString stringWithFormat:@"%f",start_longitude],@"start_long",@"",@"end_long",[NSString stringWithFormat:@"%f",start_latitude],@"start_lat",@"",@"end_lat",currentDateStr,@"trip_request_date",trip_request_date,@"trip_request_pickup_date",@"",@"trip_miles_est",[NSString stringWithFormat:@""],@"trip_miles_act",@"",@"trip_time_est",[NSString stringWithFormat:@""],@"trip_time_act",actualFare,@"offered_fare",actualFare,@"setfare",driverList,@"DriverList",VipStr,@"requestType",vehicle_type,@"vehicle_type",@"",@"TripId",@"",@"driver",nil];
    }
    else if (isOneWay)
    {
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:userIdStr,@"riderId",driverIdStr,@"driverId",destination_loc,@"ending_loc",start_loc,@"starting_loc",[NSString stringWithFormat:@"%f",start_longitude],@"start_long",[NSString stringWithFormat:@"%.2f",end_longitude],@"end_long",[NSString stringWithFormat:@"%f",start_latitude],@"start_lat",[NSString stringWithFormat:@"%f",end_latitude],@"end_lat",currentDateStr,@"trip_request_date",trip_request_date,@"trip_request_pickup_date",[NSString stringWithFormat:@"%f",estimatedDistance],@"trip_miles_est",[NSString stringWithFormat:@""],@"trip_miles_act",estimatedTimeStr,@"trip_time_est",[NSString stringWithFormat:@""],@"trip_time_act",suggestedFare,@"offered_fare",actualFare,@"setfare",driverList,@"DriverList",@"oneway",@"requestType",vehicle_type,@"vehicle_type",@"",@"TripId",@"",@"driver",nil];
    }
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RequestRide",Kwebservices]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        if(webData==nil)
        {
            webData = [NSMutableData data] ;
            NSLog(@"data");
        }
        else
        {
            webData=nil;
            webData = [NSMutableData data] ;
        }
        NSLog(@"server connection made");
    }
    else
    {
        NSLog(@"connection is NULL");
    }
}



- (IBAction)backBtn:(id)sender {
    MapViewController *mapvc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mapvc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        mapvc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
    }

    [self.navigationController pushViewController:mapvc animated:NO];
}



#pragma mark- Picker View Delegates and Data sources


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// tell the picker how many rows are available for a given component


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    suggestedFare =[priceArray objectAtIndex:[pickerView selectedRowInComponent:0]];
    self.ownProceLbl.text=[NSString stringWithFormat:@"$%@",suggestedFare];

}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 85, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment=UITextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Myriad Pro" size:26];
    label.text = [priceArray objectAtIndex:row];
    label.textColor = [UIColor blackColor];
    
    return label;
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
       return 70;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if (pickerView == myPickerView)
    {
        returnStr = [priceArray objectAtIndex:row];
    }
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        return [priceArray count];
}




#pragma mark - Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    disableImg.hidden=YES;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"ERROR with the Connection ");
    webData =nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    disableImg.hidden=YES;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (![userDetailDict isKindOfClass:[NSNull class]])
    {
        NSString *messageStr=[userDetailDict valueForKey:@"message"];
        int result=[[userDetailDict valueForKey:@"result" ]intValue];
        if (result==1)
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
           
            [alert show];
        }
        else
        {
            NSString *tripid=[userDetailDict valueForKey:@"tripid"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:[NSString stringWithFormat:@"%@",messageStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
           // [alert show];
            
            MapViewController *mapVc;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            }


            [self.navigationController pushViewController: mapVc  animated:NO];
        }
    }
}

-(void)fetchData:(NSData *)data
{
    NSError *error;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"rows"];
    NSLog(@"Data is:%@" ,results);
    
    for (int i = 0;i <[results count]; i++) {
        NSDictionary *result = [results objectAtIndex:i];
        NSLog(@"Data is %@", result);
        
        NSString *statusStr=[[[result objectForKey:@"elements"]valueForKey:@"status"]objectAtIndex:0];
        if ([statusStr isEqualToString:@"ZERO_RESULTS"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Invalid Request." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.tag=5;
            [alert show];
            self.requestBtn.userInteractionEnabled=NO;
            return;
        }
        NSString *tempdistaceStr = [[[[result objectForKey:@"elements"]valueForKey:@"distance"]valueForKey:@"text"]objectAtIndex:0];
        estimatedTimeStr = [[[[result objectForKey:@"elements"]valueForKey:@"duration"]valueForKey:@"text"]objectAtIndex:0];
        
        distanceStr =[NSString stringWithFormat:@"%@",tempdistaceStr];
        
        NSArray *distArray = [distanceStr componentsSeparatedByString:@" "];
        NSString *kmStr=[distArray objectAtIndex:1];
         distanceStr=[distanceStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        
        if( [kmStr caseInsensitiveCompare:@"KM"] == NSOrderedSame )
        {
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"km" withString:@""];
            
    
            estimatedDistance= [distanceStr floatValue]*0.62137*1000;
            estimatedDistance=estimatedDistance/1000;
        }
        else{
            distanceStr= [distanceStr stringByReplacingOccurrencesOfString:@"m" withString:@""];
            
            estimatedDistance= [distanceStr floatValue]* 0.00062137;
        }
      
        distanceLbl.text=[NSString stringWithFormat:@"%.2f Miles",estimatedDistance];
        
        if (estimatedTimeStr.length>7)
        {
            NSArray *timeArray = [estimatedTimeStr componentsSeparatedByString:@" "];
            int minutes=[[timeArray objectAtIndex:2]intValue];
            int hours=[[timeArray objectAtIndex:0]intValue];
            minutes=hours*60+minutes;
            estimatedTimeStr=[NSString stringWithFormat:@"%d",minutes];
            self.estimatedTimeLbl.text=[NSString stringWithFormat:@"%@ mins",estimatedTimeStr];
        }
        else{
            self.estimatedTimeLbl.text=[NSString stringWithFormat:@"%@",estimatedTimeStr];
        }
    }
    NSLog(@"base fare==%@",base_fare);
    NSLog(@"estTime==%@",estimatedTimeStr);
    NSLog(@"priceMinute ==%@",price_per_minute);
    NSLog(@"estDiastanc ==%f",estimatedDistance);
    NSLog(@" priceMile==%@",price_per_mile);
    NSLog(@"%f",([estimatedTimeStr intValue]*[price_per_minute floatValue]));
    NSLog(@"%f",(estimatedDistance *[price_per_mile floatValue]));
    NSLog(@"%@",[NSString stringWithFormat:@"%f",[surgeValue  floatValue]]);


    float actualPrice=[base_fare floatValue]+([estimatedTimeStr floatValue]*[price_per_minute floatValue])+(estimatedDistance *[price_per_mile floatValue]) ;
    if ([surgeValue floatValue]>0) {
        actualPrice=actualPrice*[surgeValue floatValue];
    }
 
    if (actualPrice<minPrice)
    {
        actualPrice=minPrice;
    }
    //NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", myFloat];
    int NewActualPrice = (int) actualPrice;

    actualFare=[NSString stringWithFormat:@"%.2f",actualPrice];
    priceLbl.text=[NSString stringWithFormat:@"$%d",NewActualPrice];
    minimumPrice =[NSString stringWithFormat:@"%.2f",actualPrice-actualPrice*20/100 ];
    maximumPrice =[NSString stringWithFormat:@"%.2f",actualPrice+actualPrice*500/100];
    suggestedFare=[NSString stringWithString:actualFare];
    self.ownProceLbl.text=[NSString stringWithFormat:@"$%d",NewActualPrice];
    [self addPickerView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    if (alertView.tag==2)
    {
        if (buttonIndex==0)
        {
            MapViewController *mapVc;
            
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            }


            [self.navigationController pushViewController: mapVc  animated:NO];
        }
    }
}
- (IBAction)editColourBtn:(id)sender
{
    self.colourView.hidden=NO;
}

- (IBAction)pinkColorBtn:(id)sender {
   
    self.colourView.hidden=YES;
    color=@"pink";
     self.colourLbl.text=color;
}

- (IBAction)redColorBtn:(id)sender {
    color=@"red";
    self.colourView.hidden=YES;
    self.colourLbl.text=color;
}

- (IBAction)greenColorBtn:(id)sender {
    color=@"green";
    self.colourView.hidden=YES;
    self.colourLbl.text=color;
}

- (IBAction)yellowColorBtn:(id)sender {
    color=@"yellow";
    self.colourView.hidden=YES;
    self.colourLbl.text=color;
}

- (IBAction)orangeColorBtn:(id)sender {
    color=@"orange";
    self.colourView.hidden=YES;
    self.colourLbl.text=color;

}

- (IBAction)whiteColorBtn:(id)sender {
    color=@"white";
    self.colourView.hidden=YES;
    self.colourLbl.text=color;
}

- (IBAction)blueColorBtn:(id)sender {
    color=@"blue";
    self.colourView.hidden=YES;
    self.colourLbl.text=color;
}

- (IBAction)closeBtn:(id)sender {
    self.colourView.hidden=YES;
    self.colourLbl.text=color;
}

- (IBAction)donePickupDateEdittingBtn:(id)sender {
     scrollView.scrollEnabled = YES;
    self.dateDoneBtn.hidden=NO;
    self.dateCancelBtn.hidden=NO;
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.dateTimeLbl.text=[dateFormatter2 stringFromDate:selectedDate];
    [self.pickupDateView setFrame:CGRectMake(10.0, 250.0, 300.0, 36.0)];
    [priceBackView setFrame:CGRectMake(10.0, 290, 300.0, priceBackView.frame.size.height)];
    [requestBtn setFrame:CGRectMake(self.requestBtn.frame.origin.x,456.0, self.requestBtn.frame.size.width, self.requestBtn.frame.size.height)];
      [self.selectColorBackView setFrame:CGRectMake(self.selectColorBackView.frame.origin.x,455.0, self.selectColorBackView.frame.size.width, self.selectColorBackView.frame.size.height)];
    self.dateTimeLbl.textColor=[UIColor blackColor];
    [self.dateTimeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    self.datePicker.hidden=YES;
    self.datePicker.userInteractionEnabled=NO;
}

- (IBAction)cancelDateSelectingBtn:(id)sender {
     scrollView.scrollEnabled = YES;
    self.dateDoneBtn.hidden=YES;
    self.dateCancelBtn.hidden=YES;
    [self.pickupDateView setFrame:CGRectMake(10.0, 250.0, 300.0, 36.0)];
    [priceBackView setFrame:CGRectMake(10.0, 290, 300.0, priceBackView.frame.size.height)];
    [requestBtn setFrame:CGRectMake(self.requestBtn.frame.origin.x,456.0, self.requestBtn.frame.size.width, self.requestBtn.frame.size.height)];
    [self.selectColorBackView setFrame:CGRectMake(self.selectColorBackView.frame.origin.x,455.0, self.selectColorBackView.frame.size.width, self.selectColorBackView.frame.size.height)];
    
    self.datePicker.hidden=YES;
    self.datePicker.userInteractionEnabled=NO;
}

- (IBAction)changeDateTime:(id)sender {
    
    selectedDate = [self.datePicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString* timeSelectd= [dateFormatter stringFromDate:selectedDate];
    
    NSComparisonResult result;
    
    result = [dateAftrHours compare:selectedDate];
    
     if(result == NSOrderedAscending )
     {
         NSLog(@"newDate is less");
         trip_request_date=[NSString stringWithFormat:@"%@",timeSelectd];
     }
     else {
         UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"Rapid" message:@"Select correct pick up date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
         [self.datePicker setDate:dateAftrHours animated:NO];
     }
}
- (IBAction)editPickupTimeBtn:(id)sender {
    scrollView.scrollEnabled = NO;
    self.dateCancelBtn.hidden=NO;
    self.dateDoneBtn.hidden=NO;
    self.datePicker.hidden=NO;
    self.datePicker.userInteractionEnabled=YES;;
    
      [self.pickupDateView setFrame:CGRectMake(10.0, 250.0, 300.0, 260.0)];
    [priceBackView setFrame:CGRectMake(10.0, 556.0, 300.0, priceBackView.frame.size.height)];
      [requestBtn setFrame:CGRectMake(self.requestBtn.frame.origin.x,800.0, self.requestBtn.frame.size.width, self.requestBtn.frame.size.height)];
      [self.selectColorBackView setFrame:CGRectMake(self.selectColorBackView.frame.origin.x,730.0, self.selectColorBackView.frame.size.width, self.selectColorBackView.frame.size.height)];
    
}
@end
