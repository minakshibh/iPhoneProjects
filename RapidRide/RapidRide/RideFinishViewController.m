#import "RideFinishViewController.h"
#import "PaymentViewController.h"
#import "DriverFirstViewViewController.h"
#import "MapViewController.h"
#import "AddcardViewController.h"
#import "LocationAndPriceDetailViewController.h"

@interface RideFinishViewController ()

@end

@implementation RideFinishViewController
@synthesize fareLbl,tipLbl,finishBtnOutlet,backView,fareLblOutlet,tipLblOutlet,headerLbl,rideCompleteLbl,pickerView,activityIndicatorObject,tripId,DriverId,cancelride,FromNotification,rec_id,selectCardTableView,selectCardBackView,promocodesTableview,ratingDoneBtn,ratingDisableImage,prefVehicle,startLocStr,endLocStr,startLocLattiude,startLocLongitude,endLocLatitude,endLocLongitude,getETAstr,getFareStr,base_fare,minPrice,price_per_mile,price_per_minute,requestType,surgeValue,destinationTxtField,placesTableView,h_total_fare,f_total_fare;

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
    self.requestView.hidden=YES;
    [[NSUserDefaults standardUserDefaults]setValue:@"PayView" forKey:@"PayView"];
    ratingDoneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    ratingDoneBtn.layer.borderWidth = 1.5;
    ratingDoneBtn.layer.cornerRadius = 5.0;
    [ratingDoneBtn setClipsToBounds:YES];
    
    [self.requestBackLbl setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [backPickUpbtn setBackgroundColor:[UIColor colorWithRed:(67.0 / 255.0) green:(205.0 / 255.0) blue:(128.0 / 255.0) alpha:1]];
    [goHomeBtn setBackgroundColor:[UIColor colorWithRed:(135.0 / 255.0) green:(206.0 / 255.0) blue:(235.0 / 255.0) alpha:1]];
    
    
    self.requestBackLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    self.requestBackLbl.layer.borderWidth = 1.5;
    self.requestBackLbl.layer.cornerRadius = 5.0;
    [self.requestBackLbl setClipsToBounds:YES];
    
    backPickUpbtn.layer.borderColor = [UIColor clearColor].CGColor;
    backPickUpbtn.layer.borderWidth = 1.5;
    backPickUpbtn.layer.cornerRadius = 5.0;
    [backPickUpbtn setClipsToBounds:YES];
    
    goHomeBtn.layer.borderColor = [UIColor clearColor].CGColor;
    goHomeBtn.layer.borderWidth = 1.5;
    goHomeBtn.layer.cornerRadius = 5.0;
    [goHomeBtn setClipsToBounds:YES];
    
    self.requestView.layer.borderColor = [UIColor clearColor].CGColor;
    self.requestView.layer.borderWidth = 2.5;
    self.requestView.layer.cornerRadius = 5.0;
    
    
 
  
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"Queue"] isEqualToString:@"RiderSide"]) {
        DriverId= [[NSUserDefaults standardUserDefaults ]valueForKey:@"driverid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activeTripId"];
        tripId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"tripId"];
        tripId = [tripId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"activeTripId"];
        tripId = [tripId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    backView.hidden=NO;
    DriverId= [[NSUserDefaults standardUserDefaults] valueForKey:@"driverid"];
    //[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"driverid"];
    
    
    [self.starsBackView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    backView.hidden=YES;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"View"];
        ratingTrigger=@"Rider";
        self.addAsFavDriverbtn.hidden=NO;
    }else{
        ratingTrigger=@"Driver";
        
        FavDriver=0;
        self.addAsFavDriverbtn.hidden=YES;
    }
    RatingStatus=@"Good";
    RatingView.hidden= NO;
    [goodBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    BadBtn.backgroundColor=[UIColor lightGrayColor];
    
    [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
    [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
    [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
    [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
    [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
    
    //add rating view
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        RatingView.frame=CGRectMake(20, 90, 278, 300);
        self.disablImg.frame=CGRectMake(0, 69, 320, 500);
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        RatingView.frame=CGRectMake(20, 75, 278, 310);
        self.disablImg.frame=CGRectMake(0, 69, 320, 412);
        
    }
    
    cardNumLbl.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    
    
    RatingView.layer.cornerRadius=6.0;
    [self.view addSubview:RatingView];
    [self.view addSubview:self.disablImg];
    
    // [RatingView setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    
    [RatingStatusLabel setText:@"Good"];
    commentTextView.text=@"";
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    [self.headerView setBackgroundColor:[UIColor colorWithRed:(3.0 / 255.0) green:(15.0 / 255.0) blue:(51.0 / 255.0) alpha:1]];
    [self.addAsFavDriverbtn setBackgroundColor:[UIColor whiteColor]];
    FavDriver=0;
    
    ratingDoneBtn.backgroundColor=[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1];
    
    [ratingDoneBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:22]];
    
    
    [headerLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:30]];
    [finishBtnOutlet.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:25]];
    [rideCompleteLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:27]];
    [fareLblOutlet setFont:[UIFont fontWithName:@"Myriad Pro" size:22]];
    [fareLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:22]];
    [tipLblOutlet setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [tipLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [DiscountValueLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [self.tipAmountCalculatedLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [self.tipAmmountLabl setFont:[UIFont fontWithName:@"Myriad Pro" size:24]];
    [goHomeBtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    [backPickUpbtn.titleLabel setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
    
    tipArray=[[NSMutableArray alloc]init];
    for (int i=0;i<=200; i++)
    {
        [tipArray addObject:[NSString stringWithFormat:@"%d%%",i]];
    }
    NSString *fareString=[[NSUserDefaults standardUserDefaults] valueForKey:@"FareValueForTip"];
    if ([fareString rangeOfString:@"$"].location ==NSNotFound)
    {
        fareLbl.text=[NSString stringWithFormat:@"%@ %@",@"$",[[NSUserDefaults standardUserDefaults] valueForKey:@"FareValueForTip"]];
    }
    else
    {
        fareLbl.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FareValueForTip"]];
    }
    
    NSLog(@"tip array %@",tipArray);
    
    UIPickerView* myPickerView ;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        myPickerView= [[UIPickerView alloc] initWithFrame:CGRectMake(138, 12, 50.0, 250)];
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(138, 5, 50.0, 250)];
        // this is iphone 4 xib
    }
    
    
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator =YES;
    myPickerView.backgroundColor = [UIColor colorWithRed:(139.0/255.0) green:(139.0/255.0) blue:(139.0/255.0) alpha:1];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
    rotate = CGAffineTransformScale(rotate, 1.0, 1.0);
    [myPickerView setTransform:rotate];
    // myPickerView.frame = CGRectMake(55, 95, 215, 10);
    [myPickerView selectRow:10 inComponent:0 animated:YES];
    myPickerView.layer.cornerRadius=2.0;
    
    
    [UIView beginAnimations:@"SetSelectionBarAlpha" context:NULL];
    [UIView setAnimationDuration:0];
    backView.layer.cornerRadius = 10.0;
    
    [self.backView addSubview:myPickerView];
    
    activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        activityIndicatorObject.center = CGPointMake(160, 190);
        //this is iphone 5 xib
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480)
    {
        activityIndicatorObject.center = CGPointMake(160, 190);
        // this is iphone 4 xib
    }
    else
    {
        activityIndicatorObject.center = CGPointMake(374, 412);
    }
    activityIndicatorObject.color=[UIColor grayColor];
    [self.disablImg addSubview:activityIndicatorObject];
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"]){
        self.tipAmmountLabl.hidden=YES;
        self.tipAmountCalculatedLbl.hidden=YES;
        self.tipLbl.hidden=YES;
        self.tipLblOutlet.hidden=YES;
        DiscountValueLabel.hidden=YES;
        linELblOne.hidden=YES;
        lineLblTwo.hidden=YES;
        myPickerView.hidden=YES;
        myPickerView.userInteractionEnabled=NO;
    }
    
    
    [RatingView bringSubviewToFront:self.disablImg];
    [RatingView bringSubviewToFront:activityIndicatorObject];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *FairValue=fareLbl.text;
    NSString *clearFair=[FairValue  stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
    
    NSInteger totalFair=[clearFair integerValue];
    
    NSInteger discountedFair=totalFair*10/100;
    
    NSInteger FairValueAfterDiscounted=totalFair+discountedFair;
    
    self.tipAmountCalculatedLbl.text=[NSString stringWithFormat:@"%@%ld",@"$",(long)discountedFair];
    tipFare=[NSString stringWithFormat:@"%ld",(long)discountedFair];
    DiscountValueLabel.text=[NSString stringWithFormat:@"%@%ld",@"$",(long)FairValueAfterDiscounted];
    
    if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
    {
        [self fetchCardsAndPromo];
    }
    else
    {
        NSString*estimatedTimeStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"estimatedTimeStr"];
        if (estimatedTimeStr.length>0)
        {
            webservice=3;
            [self fetchVehicleList ];
        }
    }
    
}
- (IBAction)ratingOne:(id)sender
{
    if (giveRating!=1)
    {
        giveRating=1;
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"red_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
    else{
        giveRating=0;
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)ratingTwo:(id)sender {
    if (giveRating!=2)
    {
        giveRating=2;
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"red_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"red_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
    else{
        giveRating=0;
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)ratingThree:(id)sender {
    if (giveRating!=3)
    {
        giveRating=3;
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"red_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"red_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"red_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
    else{
        giveRating=0;
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)ratingFour:(id)sender {
    if (giveRating!=4)
    {
        giveRating=4;
        
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
        
        
    }
    else{
        giveRating=0;
        
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)ratingFive:(id)sender {
    if (giveRating!=5)
    {
        giveRating=5;
        
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"green_flag_white_trans.png"] forState:UIControlStateNormal];
    }
    else{
        giveRating=0;
        [self.ratingOneBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingTwoBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingThreeBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFourBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        [self.ratingFiveBtn setBackgroundImage:[UIImage imageNamed:@"black_flag_white_trans.png"] forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)finishBtn:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
    {
        if (rec_id.length==0)
        {
            
        }
        else
        {
            webservice=4;
            self.view.userInteractionEnabled=NO;
            [activityIndicatorObject startAnimating];
            //  disableImg.hidden=NO;
            
            tripId = [tripId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *riderIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"];
            urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://appba.riderapid.com/process/?tripid=%@&rec_id=%@&riderid=%@&tip_amount=%@&suggested_fare=%@",tripId,rec_id,riderIdStr,tipFare,[[NSUserDefaults standardUserDefaults] valueForKey:@"FareValueForTip"]]];
            
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
            
            NSLog(@"Request:%@",urlString);
            
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            // [request setHTTPBody: [jsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
            
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
    }
    else
    {
        

        CLLocationManager*locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
        
        float  current_long=locationManager.location.coordinate.longitude;
        float  current_latt=locationManager.location.coordinate.latitude;

       // tripId=[[NSUserDefaults standardUserDefaults] valueForKey:@"tripId"];
        tripId = [tripId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
       
        webservice=5;
        NSString *fareStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FareValueForTip"]];
        
        fareStr = [fareStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        
        fareStr=[fareStr stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        
        jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tripId,@"TripId",[NSString stringWithFormat:@"%f",current_latt],@"Latitude",[NSString stringWithFormat:@"%f",current_long],@"Longitude",fareStr,@"TripFinalFare",nil];
        
        
        jsonRequest = [jsonDict JSONRepresentation];
        NSLog(@"jsonRequest is %@", jsonRequest);
        urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/EndRide",Kwebservices]];
        
        [self postWebservices];

        
  
    }
}

- (IBAction)CloseButtonAction:(id)sender
{
    [RatingView removeFromSuperview];
}

- (IBAction)SelectRating:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
    {
        RatingTypeView.hidden=NO;
    }else{
        RatingTypeView.hidden =YES;
    }
    
}

- (IBAction)GoodBtn:(id)sender
{
    
    RatingStatus=@"Good";
    [goodBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    BadBtn.backgroundColor=[UIColor lightGrayColor];
    
}

#pragma mark - Bad Button Action

- (IBAction)BadBtn:(id)sender
{
       RatingStatus=@"Bad";
    [BadBtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    goodBtn.backgroundColor=[UIColor lightGrayColor];
    
    
}

#pragma mark - Done Button Action

- (IBAction)DoneButtonAction:(id)sender
{
    if (giveRating==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Please give Rating." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if (giveRating==5 )
    {
        [commentTextView resignFirstResponder];
        webservice=1;
        if (FavDriver==0)
        {
            jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tripId,@"TripId",[NSString stringWithFormat:@"%d",giveRating],@"Rating",commentTextView.text,@"Comments",@"",@"Favorite_driver",ratingTrigger,@"Trigger",nil];
        }
        else{
            jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tripId,@"TripId",[NSString stringWithFormat:@"%d",giveRating],@"Rating",commentTextView.text,@"Comments",DriverId,@"Favorite_driver",ratingTrigger,@"Trigger",nil];
        }
        
        jsonRequest = [jsonDict JSONRepresentation];
        
        NSLog(@"jsonRequest is %@", jsonRequest);
        
        urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RiderToDriverRating",Kwebservices]];
        [self postWebservices];
    }
    else
    {
        if ([commentTextView.text isEqualToString:@""])
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Rapid" message:@"Please Enter Comment." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [commentTextView becomeFirstResponder];
            
        }
        else
        {
            [commentTextView resignFirstResponder];
            webservice=1;
            jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:tripId,@"TripId",[NSString stringWithFormat:@"%d",giveRating],@"Rating",commentTextView.text,@"Comments",nil];
            jsonRequest = [jsonDict JSONRepresentation];
            
            NSLog(@"jsonRequest is %@", jsonRequest);
            
            urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/RiderToDriverRating",Kwebservices]];
            [self postWebservices];
        }
    }
}

- (IBAction)addAsFavDriverBtn:(id)sender {
    if (FavDriver==0)
    {
        FavDriver=1;
        
        [self.addAsFavDriverbtn setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
        return;
    }
    else
    {
        FavDriver=0;
        [self.addAsFavDriverbtn setBackgroundColor:[UIColor whiteColor]];
        return;
    }
}

- (IBAction)addNewCardBtn:(id)sender {
    
    AddcardViewController*addcardVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        addcardVc=[[AddcardViewController alloc]initWithNibName:@"AddcardViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        addcardVc=[[AddcardViewController alloc]initWithNibName:@"AddcardViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    
    
    
    [self.navigationController pushViewController:addcardVc animated:YES];
    
}
- (IBAction)changeCardBtn:(id)sender {
    finishBtnOutlet.userInteractionEnabled=NO;
    cardNumLbl.hidden=YES;
    cardSecltdIamge.hidden=YES;
    changeBtn.hidden=YES;
    //[selectCardTableView reloadData];
    self.selectCardTableView.hidden=NO;
}



- (void)textViewDidEndEditing:(UITextView *)textView
{
    [commentTextView resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}
#pragma mark - Post Web Service

-(void)postWebservices
{
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    [self.view bringSubviewToFront:self.disablImg];
    [RatingView bringSubviewToFront:self.disablImg];
    
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
#pragma mark - Response Delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received Response");
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;
    self.disablImg.hidden=YES;
    UIAlertView *alert;
    if (webservice==1)
    {
        alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag=2;
    }
    else
    {
        alert=[[UIAlertView alloc]initWithTitle:@"Rapid Ride" message:@"Intenet connection failed.. Try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    }
    
    if (webservice==3)
    {
        [self fetchVehicleList];
    }
    
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
    self.disablImg.hidden=YES;
    
    NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    
    NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    NSError *error;
    
    responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
    
    SBJsonParser *json = [[SBJsonParser alloc] init];
    
    NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
    
    if (webservice==1)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            NSString *messageStr=[userDetailDict valueForKey:@"message"];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            
            if (result ==1)
            {
                
                
            }
            else
            {
                
                if (cancelride && [[[NSUserDefaults standardUserDefaults ]valueForKey:@"Queue"] isEqualToString:@"DriverSide"])
                {
                    DriverFirstViewViewController*driverFirstVc;
                    if ([[UIScreen mainScreen] bounds].size.height == 568)
                    {
                        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480)
                    {
                        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
                        // this is iphone 4 xib
                    }
                    
                    driverFirstVc.driverIdStr=DriverId;
                    [self.navigationController pushViewController:driverFirstVc  animated:NO];
                }
                [RatingView removeFromSuperview];
                
                if ([[[NSUserDefaults standardUserDefaults ]valueForKey:@"Queue"] isEqualToString:@"RiderSide"])
                {
                    backView.hidden=NO;
                    
                    
                    if ([[UIScreen mainScreen] bounds].size.height == 568) {
                        [backView setFrame:CGRectMake(backView.frame.origin.x,backView.frame.origin.y, backView.frame.size.width, 435)];
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480)
                    {
                        [backView setFrame:CGRectMake(backView.frame.origin.x,backView.frame.origin.y, backView.frame.size.width, 406)];
                        
                    }
                    
                    // [self fetchCardsAndPromo];
                }
                else{
                    
                    backView.hidden=NO;
                    [backView setFrame:CGRectMake(backView.frame.origin.x,backView.frame.origin.y, backView.frame.size.width, 280)];
                    
                    promocodesTableview.hidden=YES;
                    usePromocodeHeadrLbl.hidden=YES;
                    userCreditCardHdrLbl.hidden=YES;
                    cardNumLbl.hidden=YES;
                    lineOne.hidden=YES;
                    selectCardTableView.hidden=YES;
                    lineTwo.hidden=YES;
                    lineThree.hidden=YES;
                    changeBtn.hidden=YES;
                    cardSecltdIamge.hidden=YES;
                    addCardBtn.hidden=YES;
                    [finishBtnOutlet setFrame:CGRectMake(finishBtnOutlet.frame.origin.x, 225, finishBtnOutlet.frame.size.width, finishBtnOutlet.frame.size.height)];
                }
            }
        }
    }
    else if(webservice==2)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            [finishBtnOutlet setTitle:@"PAY" forState:UIControlStateNormal];
            promocodesArray=[[NSMutableArray alloc]init];
            promocodeValueArray=[[NSMutableArray alloc]init];
            creditCardsNumArray =[[NSMutableArray alloc]init];
            
            NSString *card=[userDetailDict valueForKey:@"card"];
            NSString *promocode=[userDetailDict valueForKey:@"promocode"];
            NSString *value=[userDetailDict valueForKey:@"value"];
            NSString *promoname=[userDetailDict valueForKey:@"promoname"];
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            NSLog(@"promocode  %@",promocode);
            NSLog(@"value  %@",value);
            NSLog(@"promoname  %@",promoname);
            NSLog(@"card  %@",card);
            if(result ==0)
            {
                if (promocode.length==0)
                {
                    promocodesTableview.hidden=YES;
                    usePromocodeHeadrLbl.hidden=YES;
                    lineOne.hidden=YES;
                }
                else{
                    promocodesTableview.hidden=NO;
                    usePromocodeHeadrLbl.hidden=NO;
                    lineOne.hidden=NO;
                }
                NSArray* tempArray ;
                
                if (promoname.length!=0)
                {
                    [promocodesArray addObject:promoname];
                }
                if (value.length!=0)
                {
                    [promocodeValueArray addObject:value];
                }
                if (![card isEqualToString:@""]) {
                    tempArray = [card componentsSeparatedByString: @","];
                }
                NSLog(@"tempArray  %@",tempArray);
                
                if (tempArray.count>0)
                {
                    for (int j =0; j<tempArray.count; j++)
                    {
                        if (![[tempArray objectAtIndex:j]isEqualToString:@""])
                        {
                            [creditCardsNumArray addObject:[NSString stringWithFormat:@"%@", [tempArray objectAtIndex: j]]];
                            NSLog(@"cards array.. %@",creditCardsNumArray);
                            rec_id=[creditCardsNumArray objectAtIndex:0];
                            rec_id=[rec_id substringFromIndex:5];
                            rec_id=[[rec_id componentsSeparatedByString:@"--"]objectAtIndex:1];
                        }
                    }
                }
                
                else
                {
                    rec_id=@"";
                }
            }
            
            
            NSLog(@"creditCardsNumArray  %@",creditCardsNumArray);
            NSLog(@"rec id  %@",rec_id);
            [promocodesTableview reloadData];
            [selectCardTableView reloadData];
            //indxPath = 0;
            
        }
        self.selectCardTableView.delegate = self;
        self.selectCardTableView.dataSource = self;
           }
    else if (webservice==4)
    {
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            paymentResult=[[userDetailDict valueForKey:@"result" ]intValue];
            
            
            [self launchDialog:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"message"]]];
            
            if(paymentResult ==0)
            {
                
                // alertview.tag=6;
            }
            else{
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PayView"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"tripId"];
                
            }
        }
    }
    else if (webservice==3)
    {
        NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
        
        NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSLog(@"responseString:%@",responseString);
        NSError *error;
        
        responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
        
        SBJsonParser *json = [[SBJsonParser alloc] init];
        
        NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
        
        if (![userDetailDict isKindOfClass:[NSNull class]])
        {
            driverZoneDict =[[NSMutableDictionary alloc]init];
            
            int result=[[userDetailDict valueForKey:@"result" ]intValue];
            if (result ==0)
            {
                vehicleZoneListAray=[userDetailDict valueForKey:@"ListZoneInfo"];
            }
            [self showVehicles];
            
        }
    }
    if (webservice==5)
    {
        {
            NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
            
            NSString *responseString = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
            NSLog(@"responseString:%@",responseString);
            NSError *error;
            
            responseString= [responseString stringByReplacingOccurrencesOfString:@"{\"d\":null}" withString:@""];
            
            SBJsonParser *json = [[SBJsonParser alloc] init];
            
            NSMutableArray *userDetailDict=[json objectWithString:responseString error:&error];
            
            if (![userDetailDict isKindOfClass:[NSNull class]])
            {
                //driverZoneDict =[[NSMutableDictionary alloc]init];
                
                int result=[[userDetailDict valueForKey:@"result" ]intValue];
                if (result ==0)
                {
                    
                    
                    DriverFirstViewViewController*driverFirstVc;
                    if ([[UIScreen mainScreen] bounds].size.height == 568)
                    {
                        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
                    }
                    else if([[UIScreen mainScreen] bounds].size.height == 480)
                    {
                        driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
                        // this is iphone 4 xib
                    }
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"PayView"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"tripId"];
                    
                    driverFirstVc.driverIdStr=DriverId;
                    [self.navigationController pushViewController:driverFirstVc  animated:NO];

                }
            }
        }
    }
}

-(void) showVehicles

{
    
    if (vehicleZoneListAray.count>0 )
    {
        
        driverZoneDict=[vehicleZoneListAray objectAtIndex:0];
        
        driverIdArray=[[NSMutableArray alloc]init];
        if ([prefVehicle isEqualToString:@"1"])
        {
            price_per_minute=[driverZoneDict valueForKey:@"reg_min"];
            price_per_mile=[driverZoneDict valueForKey:@"reg_price"];
            base_fare=[driverZoneDict valueForKey:@"reg_base"];
            surgeValue=[driverZoneDict valueForKey:@"reg_surge"];
            h_total_fare=[driverZoneDict valueForKey:@"reg_hour"];
            f_total_fare=[driverZoneDict valueForKey:@"reg_hourfull"];
            minPrice=[[driverZoneDict valueForKey:@"reg_minbase"]doubleValue];
        }
        else if ([prefVehicle isEqualToString:@"2"])
        {
            price_per_minute=[driverZoneDict valueForKey:@"xl_min"];
            price_per_mile=[driverZoneDict valueForKey:@"xl_price"];
            base_fare=[driverZoneDict valueForKey:@"xl_base"];
            surgeValue=[driverZoneDict valueForKey:@"xl_surge"];
            h_total_fare=[driverZoneDict valueForKey:@"xl_hour"];
            f_total_fare=[driverZoneDict valueForKey:@"xl_hourfull"];
            minPrice=[[driverZoneDict valueForKey:@"xl_minbase"]doubleValue];
        }
        else if ([prefVehicle isEqualToString:@"3"])
        {
            price_per_minute=[driverZoneDict valueForKey:@"exec_min"];
            price_per_mile=[driverZoneDict valueForKey:@"exec_price"];
            base_fare=[driverZoneDict valueForKey:@"exec_base"];
            surgeValue=[driverZoneDict valueForKey:@"exec_surge"];
            h_total_fare=[driverZoneDict valueForKey:@"exec_hour"];
            f_total_fare=[driverZoneDict valueForKey:@"exec_hourfull"];
            minPrice=[[driverZoneDict valueForKey:@"exec_minbase"]doubleValue];
        }
        else if ([prefVehicle isEqualToString:@"4"])
        {
            price_per_minute=[driverZoneDict valueForKey:@"suv_min"];
            price_per_mile=[driverZoneDict valueForKey:@"suv_price"];
            base_fare=[driverZoneDict valueForKey:@"suv_base"];
            surgeValue=[driverZoneDict valueForKey:@"suv_surge"];
            h_total_fare=[driverZoneDict valueForKey:@"suv_hour"];
            f_total_fare=[driverZoneDict valueForKey:@"suv_hourfull"];
            minPrice=[[driverZoneDict valueForKey:@"suv_minbase"]doubleValue];
        }
        else if ([prefVehicle isEqualToString:@"5"])
        {
            price_per_minute=[driverZoneDict valueForKey:@"lux_min"];
            price_per_mile=[driverZoneDict valueForKey:@"lux_price"];
            base_fare=[driverZoneDict valueForKey:@"lux_base"];
            surgeValue=[driverZoneDict valueForKey:@"lux_surge"];
            h_total_fare=[driverZoneDict valueForKey:@"lux_hour"];
            f_total_fare=[driverZoneDict valueForKey:@"lux_hourfull"];
            minPrice=[[driverZoneDict valueForKey:@"lux_minbase"]doubleValue];
        }
        else {
            price_per_minute=[driverZoneDict valueForKey:@"truck_min"];
            price_per_mile=[driverZoneDict valueForKey:@"truck_price"];
            base_fare=[driverZoneDict valueForKey:@"truck_base"];
            surgeValue=[driverZoneDict valueForKey:@"truck_surge"];
            h_total_fare=[driverZoneDict valueForKey:@"truck_hour"];
            f_total_fare=[driverZoneDict valueForKey:@"truck_hourfull"];
            minPrice=[[driverZoneDict valueForKey:@"truck_minbase"]doubleValue];
            
        }
        //[driverIdArray addObject:DriverId];
    }
    
    self.requestView.userInteractionEnabled=YES;
    self.disablImg.hidden=YES;
    [activityIndicatorObject stopAnimating];
    
}



- (void)launchDialog:(NSString*)messagetext
{
    // Here we need to pass a full frame
    alertViewCustom = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertViewCustom setContainerView:[self createDemoView:messagetext]];
    
    // Modify the parameters
    [alertViewCustom setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",nil]];
    [alertViewCustom setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertViewCustom setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertViewCustom close];
    }];
    
    [alertViewCustom setUseMotionEffects:true];
    
    // And launch the dialog
    [alertViewCustom show];
}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    if(paymentResult ==1)
    {
        
        NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
        NSMutableDictionary*dataDict=[[NSMutableDictionary alloc]init];
        dataDict=[userdefaults valueForKey: @"TripDetail"];
        
        NSString*requstType=[dataDict valueForKey:@"requestType"];
        prefVehicle=[dataDict valueForKey:@"rider_prefer_vehicle"];
        
        if (![requstType isEqualToString:@"VIP"])
        {
            UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Do you wants to book another ride with the same driver?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alert show];
            alert.tag=1;
        }
        else
        {
            MapViewController*mapVc;
            
            if ([[UIScreen mainScreen] bounds].size.height == 568) {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480)
            {
                mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
            }
            [self.navigationController pushViewController:mapVc  animated:NO];
        }
    }
    [alertView close];
}

- (UIView *)createDemoView:(NSString*)message1
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 150)];
    [demoView setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(126.0 / 255.0) blue:(191.0 / 255.0) alpha:1]];
    demoView.layer.borderColor = [UIColor clearColor].CGColor;
    demoView.layer.borderWidth = 1.5;
    demoView.layer.cornerRadius = 6.0;
    [demoView setClipsToBounds:YES];
    
    UILabel*messageLbl=[[UILabel alloc] initWithFrame:CGRectMake(8, 8, 270, 100)];
    messageLbl.numberOfLines=3;
    messageLbl.text=message1;
    [demoView addSubview:messageLbl];
    messageLbl.textColor=[UIColor whiteColor];
    
    [messageLbl setBackgroundColor: [UIColor clearColor]];
    messageLbl.textAlignment = NSTextAlignmentCenter;
    [messageLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:20]];
    
    [demoView addSubview:messageLbl];
    
    return demoView;
}


#pragma mark- Picker View Delegates and Data sources


// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView==myPickerView)
    {
        return 2;
        
    }
    else{
        return 1;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==myPickerView)
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
    else{
        NSString* tipStr =[tipArray objectAtIndex:[pickerView selectedRowInComponent:0]];
        
        NSString *clearStr=[tipStr  stringByReplacingOccurrencesOfString:@"%" withString:@""];
        
        NSInteger DiscountValue=[clearStr integerValue];
        
        NSString *FairValue=fareLbl.text;
        NSString *clearFair=[FairValue  stringByReplacingOccurrencesOfString:@"$" withString:@""];
        
        
        NSInteger totalFair=[clearFair integerValue];
        
        NSInteger discountedFair=totalFair*DiscountValue/100;
        
        NSInteger FairValueAfterDiscounted=totalFair+discountedFair;
        tipFare=[NSString stringWithFormat:@"%ld",(long)discountedFair];
        
        self.tipAmountCalculatedLbl.text=[NSString stringWithFormat:@"%@%ld",@"$",(long)discountedFair];
        
        
        DiscountValueLabel.text=[NSString stringWithFormat:@"%@%ld",@"$",(long)FairValueAfterDiscounted];
    }
    
    
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView==myPickerView)
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
    else{
        return 40;
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (pickerView==myPickerView)
    {
        return 35;
    }
    else{
        return 50;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if (pickerView==myPickerView)
    {
        returnStr = @"";
    }
    else{
        returnStr = [tipArray objectAtIndex:row];
        
        
    }
    return returnStr;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    if (pickerView==myPickerView)
    {
        
        if (component==0)
        {
            rowsInComponent=[monthsArray count];
        }
        else
        {
            rowsInComponent=[yearsArray count];
        }
        
        
    }
    else{
        rowsInComponent=tipArray.count;
        
        
    }
    return rowsInComponent;
}
-(UIView *) pickerView: (UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    if (pickerView==myPickerView)
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
    else{
        CGRect rect = CGRectMake(0, 0, 80, 50);
        UILabel * label = [[UILabel alloc]initWithFrame:rect];
        label.opaque = NO;
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.clipsToBounds = YES;
        label.transform = CGAffineTransformRotate(label.transform, M_PI/2);
        //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 70, 44)];
        //    label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Myriad Pro" size:20];
        label.text = [tipArray objectAtIndex:row];
        label.textColor = [UIColor blackColor];
        
        return label;
        
    }
}



#pragma mark - Alert View Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex{
    
    if (alertView.tag==6)
    {
        DriverFirstViewViewController*driverFirstVc;
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            driverFirstVc=[[DriverFirstViewViewController alloc]initWithNibName:@"DriverFirstViewViewController_iphone4" bundle:nil];
            // this is iphone 4 xib
        }
        driverFirstVc.driverIdStr=DriverId;
        [self.navigationController pushViewController:driverFirstVc  animated:NO];
    }
    if (alertView.tag==1 )
    {
        MapViewController*mapVc;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480)
        {
            mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
        }
        
        
        if (buttonIndex==[alertView cancelButtonIndex])
        {
            [self.navigationController pushViewController:mapVc  animated:NO];
        }
        else
        {
            [self fetchVehicleList];
            dateTimeLbl.text=@"Now";
            finishBtnOutlet.userInteractionEnabled=NO;
            if ([[UIScreen mainScreen] bounds].size.height == 568)
            {
                self.requestView.frame=CGRectMake(10, 115, 300, self.requestView.frame.size.height);
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480) {
                self.requestView.frame=CGRectMake(10, 85, 300, self.requestView.frame.size.height);
            }
            [self.view addSubview:self.requestView];
            self.requestView.hidden=NO;
            [self.requestView bringSubviewToFront:self.disablImg];
            [self.requestView bringSubviewToFront:activityIndicatorObject];
            
            NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
            NSMutableDictionary*dataDict=[[NSMutableDictionary alloc]init];
            dataDict=[userdefaults valueForKey: @"TripDetail"];
            
            NSString*startLocationStr=[dataDict valueForKey:@"starting_loc"];
            NSString*endLocationString=[dataDict valueForKey:@"ending_loc"];
            NSString*startLat=[dataDict valueForKey:@"start_lat"];
            NSString*startLong=[dataDict valueForKey:@"start_lon"];
            NSString*endlat=[dataDict valueForKey:@"end_lat"];
            NSString*endLong=[dataDict valueForKey:@"end_lon"];
            
            
            startLocStr=[NSString stringWithFormat:@"%@",endLocationString];
            endLocStr=[NSString stringWithFormat:@"%@",startLocationStr];
            destinationTxtField.text=[NSString stringWithFormat:@"%@",startLocationStr];
            startLocLongitude=[endLong doubleValue];
            endLocLongitude=[startLong doubleValue];
            startLocLattiude=[endlat doubleValue];
            endLocLatitude=[startLat doubleValue];
            getFareStr=[dataDict valueForKey:@"offered_fare"];
            getETAstr=[dataDict valueForKey:@"trip_time_est"];
            
        }
    }
}



#pragma mark - TableView field Delegates and Datasources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==promocodesTableview)
    {
        return [promocodesArray count];
    }
    if (tableView==selectCardTableView)
    {
        if (creditCardsNumArray.count>=2)
        {
            [selectCardTableView setFrame:CGRectMake(selectCardTableView.frame.origin.x, selectCardTableView.frame.origin.y, selectCardTableView.frame.size.width, 55)];
        }
        return [creditCardsNumArray count];
    }
    else if (tableView==self.placesTableView)
    {
        if (locationArray.count<=5)
        {
            
            placesTableView.frame = CGRectMake(placesTableView.frame.origin.x, placesTableView.frame.origin.y,placesTableView.frame.size.width, locationArray.count*30);
            
        }
        else{
            
            placesTableView.frame = CGRectMake(placesTableView.frame.origin.x, placesTableView.frame.origin.y,placesTableView.frame.size.width,  150);
        }
        return [locationArray count];
    }
    return YES;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor lightGrayColor];
    cell.textLabel.textColor=[UIColor blackColor];
    
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||  ([[UIScreen mainScreen] bounds].size.height == 480)) {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
        
        //this is iphone 5 xib
    }
    else
    {
        cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:30];
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    if (tableView==promocodesTableview)
    {
        if (promocodesArray.count>0)
        {
            UILabel *valueLbl=[[UILabel alloc] initWithFrame:CGRectMake(130, 8, 100, 20)];
            // PickUpStatusLabel.backgroundColor=[UIColor whiteColor];
            valueLbl.textColor=[UIColor blackColor];
            [valueLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:15]];
            valueLbl.text=[NSString stringWithFormat:@"(-$%@)",[promocodeValueArray objectAtIndex:indexPath.row]];
            [cell addSubview:valueLbl];
            cell.textLabel.text=[promocodesArray objectAtIndex:indexPath.row];
        }
    }
    if (tableView==selectCardTableView)
    {
        [tableView setAllowsSelection:YES];
        //cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:17];
        if (creditCardsNumArray.count>0)
        {
            
            //  cell.textLabel.text=[creditCardsNumArray objectAtIndex:indexPath.row];
            
            
            NSString *subStr =[creditCardsNumArray objectAtIndex:indexPath.row];
            if (![subStr isEqualToString:@"NO CARD"])
            {
                subStr=[subStr substringWithRange:NSMakeRange(0, 4)];
                subStr=[NSString stringWithFormat:@"****-%@",subStr];
                NSString*cardType=[creditCardsNumArray objectAtIndex:0];
                cardType=[cardType substringFromIndex:5];
                cardType=[[cardType componentsSeparatedByString:@"--"]objectAtIndex:0];
                subStr=[NSString stringWithFormat:@"%@ %@",cardType,subStr];
            }
            
            
            
            
            cell.textLabel.text=[NSString stringWithFormat:@"%@",subStr];
            
            
            
            if (![[creditCardsNumArray objectAtIndex:0] isEqualToString:@"NO CARD" ])
                
            {
                NSString*cardType=[creditCardsNumArray objectAtIndex:0];
                cardType=[cardType substringFromIndex:5];
                cardType=[[cardType componentsSeparatedByString:@"--"]objectAtIndex:0];
                
                
                cardNumLbl.text=[NSString stringWithFormat:@"%@  ****-%@",cardType,[[creditCardsNumArray objectAtIndex:0]substringWithRange:NSMakeRange(0, 4)] ];
            }
            
            NSLog(@"cardTxt:%@",cardNumLbl.text);
            NSLog(@"Cell text:%@", cell.textLabel.text);
            NSString *cardNumLblStr=cardNumLbl.text;
            NSString *cellStr=cell.textLabel.text;
            
                  }
        else
        {
            cell.textLabel.text=@"NO CARD";
        }
        cell.backgroundColor=[UIColor clearColor];
    }
    else if (tableView==placesTableView)
    {
        cell.backgroundColor=[UIColor clearColor];
        
        NSMutableArray *tempLocArray=[[NSMutableArray alloc]init];
        
        if (locationArray.count>0)
        {
            for (int i=0;i<locationArray.count;i++)
            {
                if (locationArray.count>0) {
                    NSMutableDictionary *tempDict=[locationArray objectAtIndex:i];
                    NSString *placesName = [tempDict objectForKey:@"description"];
                    [tempLocArray addObject:placesName];
                }
            }
            if (tempLocArray.count>0)
            {
                cell.textLabel.text=[tempLocArray objectAtIndex:indexPath.row];
            }
        }
    }
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath{
    
    if (tableView ==selectCardTableView)
    {
        finishBtnOutlet.userInteractionEnabled=YES;
        NSString*cardType;
        rec_id=[creditCardsNumArray objectAtIndex:indexPath.row];
        if (rec_id.length>5)
        {
            rec_id=[rec_id substringFromIndex:5];
            NSLog(@"card type..%@",rec_id);
            cardType=[[rec_id componentsSeparatedByString:@"--"]objectAtIndex:0];
            rec_id=[[rec_id componentsSeparatedByString:@"--"]objectAtIndex:1];
            
        }
        NSLog(@"card type..%@",cardType);
        NSLog(@"cardinfo... ..%@  ****-%@",cardType,[[creditCardsNumArray objectAtIndex:indexPath.row]substringWithRange:NSMakeRange(0, 4)] );
        cardNumLbl.text=[NSString stringWithFormat:@"%@  ****-%@",cardType,[[creditCardsNumArray objectAtIndex:indexPath.row]substringWithRange:NSMakeRange(0, 4)] ];
        selectCardTableView.hidden=YES;
        cardNumLbl.hidden=NO;
        cardSecltdIamge.hidden=NO;
        
        changeBtn.hidden=NO;
        
    }
    if (tableView==promocodesTableview)
    {
        NSLog(@"%@",promocodesArray);
        
        if(tripId.length!=0)
        {
            if (promocodesArray.count>0)
            {
                NSString *promocodeStr=[promocodesArray objectAtIndex: indexPath.row];
            }
        }
    }
    if (tableView==placesTableView)
    {
        [self.view endEditing:YES];
        
        NSDictionary *PlaceDict;
        if (locationArray .count>0) {
            PlaceDict = [locationArray objectAtIndex:indexPath.row];
            
        }
        
        destinationTxtField.text=[NSString stringWithFormat:@"%@",[PlaceDict objectForKey:@"description"]];
        
        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@",[PlaceDict objectForKey:@"description"],KgoogleMapApiKey];
        
        
        
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self fetchData:data];
                           });
        });
        
        placesTableView.hidden=YES;
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==selectCardTableView)
    {
        return 30.0;
    }
    if (tableView==placesTableView)
    {
        return 30.0;
    }
    else
    {
        return 35.0;
    }
    
}




-(void) fetchCardsAndPromo{
    
    [self.activityIndicatorObject startAnimating];
    self.view.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    webservice=2;
    
    NSString *riderIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"];
    urlString=[NSURL URLWithString:[NSString stringWithFormat:@"http://appba.riderapid.com/prepare_payment?tripid=%@&riderid=%@",tripId,riderIdStr]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlString cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    
    NSLog(@"Request:%@",urlString);
    
    
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
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


- (IBAction)changeDatetimeBtn:(id)sender
{
    NSDate*currentDate = [NSDate date];
    NSTimeInterval afterOneHours= 1 * 60 * 60;
    dateAftrHours = [currentDate dateByAddingTimeInterval:afterOneHours];
    
    [self.datePicker setDate:dateAftrHours animated:NO];
    selectedDate = [self.datePicker date];
    
    self.destinationTxtField.userInteractionEnabled=NO;
    self.pickupdatetimeView.hidden=NO;
    
    
}


- (IBAction)requestRideBtn:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults ]removeObjectForKey:@"TripDetail"];
    
    
    LocationAndPriceDetailViewController*detailVc;
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        detailVc=[[LocationAndPriceDetailViewController alloc]initWithNibName:@"LocationAndPriceDetailViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    detailVc.start_latitude=startLocLattiude;
    detailVc.start_longitude=startLocLongitude;
    detailVc.end_latitude=endLocLatitude;
    detailVc.end_longitude=endLocLongitude;
    detailVc.startLocAddressStr=startLocStr;
    detailVc.endLocAddressStr=endLocStr;
    
    detailVc.price_per_minute=price_per_minute;
    detailVc.price_per_mile=price_per_mile;
    detailVc.base_fare=base_fare;
    detailVc.driverIdStr=DriverId;
    
    
    detailVc.vehicleType=prefVehicle;
    [driverIdArray addObject:DriverId];
    
    if ([  detailVc.pickupdatetimestrfromView isEqual:@"Now"])
    {
        detailVc.pickupdatetimestrfromView=@"Now";
    }
    else
    {
        detailVc.pickupdatetimestrfromView=  dateTimeLbl.text;
    }
    detailVc.driverIdArray=[driverIdArray copy];
    detailVc.isVIP=NO;
    detailVc.isOneWay=YES;
    detailVc.fromEndView=YES;
    detailVc.surgeValue=surgeValue;
    detailVc.minPrice=minPrice;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (IBAction)backToPickUpBtn:(id)sender
{
    [backPickUpbtn setBackgroundColor:[UIColor colorWithRed:(67.0 / 255.0) green:(205.0 / 255.0) blue:(128.0 / 255.0) alpha:1]];
    [goHomeBtn setBackgroundColor:[UIColor colorWithRed:(135.0 / 255.0) green:(206.0 / 255.0) blue:(235.0 / 255.0) alpha:1]];
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary*dataDict=[[NSMutableDictionary alloc]init];
    dataDict=[userdefaults valueForKey: @"TripDetail"];
    
    NSString*startLocationStr=[dataDict valueForKey:@"starting_loc"];
    NSString*endLocationString=[dataDict valueForKey:@"ending_loc"];
    NSString*startLat=[dataDict valueForKey:@"start_lat"];
    NSString*startLong=[dataDict valueForKey:@"start_lon"];
    NSString*endlat=[dataDict valueForKey:@"end_lat"];
    NSString*endLong=[dataDict valueForKey:@"end_lon"];
    
    
    startLocStr=[NSString stringWithFormat:@"%@",endLocationString];
    endLocStr=[NSString stringWithFormat:@"%@",startLocationStr];
    destinationTxtField.text=[NSString stringWithFormat:@"%@",startLocationStr];
    startLocLongitude=[endLong doubleValue];
    endLocLongitude=[startLong doubleValue];
    startLocLattiude=[endlat doubleValue];
    endLocLatitude=[startLat doubleValue];
    getFareStr=[dataDict valueForKey:@"offered_fare"];
    getETAstr=[dataDict valueForKey:@"trip_time_est"];
    
    
    
    
}

- (IBAction)goHomeBtn:(id)sender
{
    [goHomeBtn setBackgroundColor:[UIColor colorWithRed:(67.0 / 255.0) green:(205.0 / 255.0) blue:(128.0 / 255.0) alpha:1]];
    [backPickUpbtn setBackgroundColor:[UIColor colorWithRed:(135.0 / 255.0) green:(206.0 / 255.0) blue:(235.0 / 255.0) alpha:1]];
    
    
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary*dataDict=[[NSMutableDictionary alloc]init];
    
    dataDict=[userdefaults valueForKey: @"riderInfo"];
    NSString *homeState=[dataDict valueForKey:@"state"];
    NSString *homeCity=[dataDict valueForKey:@"city"];
    NSString *homeZip=[dataDict valueForKey:@"zip"];
    NSString *homeAddress=[dataDict valueForKey:@"address"];
    homeFinalAddress=[NSString stringWithFormat:@"%@,%@,%@,%@",homeAddress,homeCity,homeState,homeZip];
    
    if (![homeAddress isEqualToString:@""])
    {
        NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", homeFinalAddress];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *queryUrl = [NSURL URLWithString:url];
        NSLog(@"query url%@",queryUrl);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            [self fetchLongitudeAndLattitude:data];
        });
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Home address is not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}



-(void)fetchLongitudeAndLattitude:(NSData *)data{
    NSDictionary *gc;
    gc=nil;
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSLog(@"Data is:%@" ,results);
    NSString *addressStr;
    
    if (results.count>0)
    {
        for (int i = 0;i <[results count]; i++){
            NSDictionary *result = [results objectAtIndex:i];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
            NSDictionary*locationDict=[geometry objectForKey:@"location"];
            addressStr=[result objectForKey:@"formatted_address"];
            latitudeStr=[locationDict objectForKey:@"lat"];
            longitudeStr=[locationDict objectForKey:@"lng"];
        }
    }
    
    NSLog(@"latt of address.. %.2f",[latitudeStr doubleValue]);
    NSLog(@"long of address .. %.2f",[longitudeStr doubleValue]);
    
    endLocLatitude=[latitudeStr doubleValue];
    endLocLongitude=[longitudeStr doubleValue];
    
    
    if ([latitudeStr doubleValue]==0)
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Rapid" message:@"Home location not found ,please search on map" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alrt show];
        endLocLatitude=0;
        endLocLongitude=0;
        endLocStr= [NSString stringWithFormat:@""] ;
    }
    else
    {
        endLocLatitude=[latitudeStr doubleValue ];
        endLocLongitude=[longitudeStr doubleValue];
        endLocStr= [NSString stringWithFormat:@"%@",homeFinalAddress] ;
        destinationTxtField.text=[NSString stringWithFormat:@"%@",endLocStr];
    }
}






-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}




-(void)fetchLocaotionList:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"predictions"];
    NSLog(@"Data is:%@" ,results);
    
    locationArray=[[NSMutableArray alloc]init];
    
    
    if (results.count>0) {
        for (int i = 0;i <[results count]; i++) {
            
            NSDictionary *result = [results objectAtIndex:i];
            NSString *placesName = [result objectForKey:@"description"];
            NSArray* tempArray = [placesName componentsSeparatedByString: @","];
            if (tempArray.count>0) {
                placesName =[NSString stringWithFormat:@"%@", [tempArray objectAtIndex: 0]];
                
            }
            
            [locationArray addObject:result];
        }
        
    }
    NSLog(@"places Array ..%@",locationArray);
    [self.placesTableView reloadData];
}
#pragma mark - Text field Delegates


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    self.placesTableView.hidden=YES;
    
    [destinationTxtField resignFirstResponder];
    
    NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@",destinationTxtField.text,KgoogleMapApiKey];
    
    
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        NSData *data = [NSData dataWithContentsOfURL:queryUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self fetchData:data];
                       });
    });
    
    
    [textField resignFirstResponder];
    
    return  YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange: (NSRange)range replacementString: (NSString *)string
{
    self.placesTableView.hidden=NO;
    NSString *substring;
    substring = [NSString stringWithString:destinationTxtField.text];
    
    // NSString *substring = [NSString stringWithString:locationSearchTxt.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    CLLocationManager*locationManager = [[CLLocationManager alloc] init];
    
    
    
    if (substring.length >=4)
    {
        NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%f,%f&radius=5000&key=%@",substring,locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude,KgoogleMapApiKey];
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            NSURL *queryUrl = [NSURL URLWithString:url];
            NSData *data = [NSData dataWithContentsOfURL:queryUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [self fetchLocaotionList:data];
                           });
        });
        
    }
    return  YES;
}



-(void)fetchData:(NSData *)data
{
    NSDictionary *gc;
    gc=nil;
    searchResults=0;
    
    
    NSString *str=[gc objectForKey:@"address"];
    NSLog(@"%@",str);
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray* results =[json objectForKey:@"results"];
    NSString *latitudeStr;
    NSString *longitudeStr;
    NSLog(@"Data is:%@" ,results);
    NSString *addressStr;
    
    
    
    if (results.count>0) {
        for (int i = 0;i <[results count]; i++)
        {
            searchResults= searchResults+1;
            NSDictionary *result = [results objectAtIndex:i];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
            NSDictionary*locationDict=[geometry objectForKey:@"location"];
            addressStr=[result objectForKey:@"formatted_address"];
            latitudeStr=[locationDict objectForKey:@"lat"];
            longitudeStr=[locationDict objectForKey:@"lng"];
            NSLog(@"Data is %@", result);
            NSString *address = [result objectForKey:@"formatted_address"];
            NSLog(@"Address is %@", address);
            NSString *name = [result objectForKey:@"name"];
            NSLog(@"name is %@", name);
            NSDictionary *locations = [geometry objectForKey:@"location"];
            NSString *lat =[locations objectForKey:@"lat"];
            NSString *lng =[locations objectForKey:@"lng"];
            NSLog(@"longitude is %@", lng);
            
            if (name.length>0)
            {
                address =[NSString stringWithFormat:@"%@ , %@",name,address];
                
            }
            gc = [[NSDictionary alloc]initWithObjectsAndKeys:lat,@"lat",lng,@"lng",address,@"address" ,nil];
            if(i == 0)
            {
                destinationTxtField.text=[NSString stringWithFormat:@"%@",address];
                destinationTxtField.userInteractionEnabled=NO;
                endLocLatitude=[latitudeStr doubleValue];
                endLocLongitude=[longitudeStr doubleValue];
                endLocStr=[NSString stringWithFormat:@"%@",address];
                
            }
        }
    }
}



-(void)fetchVehicleList
{
    self.requestView.userInteractionEnabled=NO;
    self.disablImg.hidden=NO;
    [activityIndicatorObject startAnimating];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate*now = [NSDate date];
    NSString*currentTime= [dateFormatter stringFromDate:now];
    
    
    CLLocationManager*locationManager = [[CLLocationManager alloc] init];
    
    NSString*userIdStr= [[NSUserDefaults standardUserDefaults ]valueForKey:@"riderId"];
    jsonDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude],@"longitude",[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude],@"latitude",currentTime,@"currenttime",@"10",@"distance",userIdStr,@"riderid",nil];
    
    webservice=3;
    
    NSString *jsonRequest = [jsonDict JSONRepresentation];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSURL *urlString=[NSURL URLWithString:[NSString stringWithFormat:@"%@/FetchVehicleList",Kwebservices]];
    
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





- (IBAction)cancelRideBtn:(id)sender
{
    self.requestView.hidden=YES;
    MapViewController*mapVc;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480)
    {
        mapVc=[[MapViewController alloc]initWithNibName:@"MapViewController_iphone4" bundle:nil];
    }
    
    [self.navigationController pushViewController:mapVc  animated:NO];
    
}

- (IBAction)donePickupDateEdittingBtn:(id)sender {
    
    self.destinationTxtField.userInteractionEnabled=YES;
    self.pickupdatetimeView.hidden=YES;
    
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    dateTimeLbl.text=[dateFormatter2 stringFromDate:selectedDate];
    
    dateTimeLbl.textColor=[UIColor blackColor];
    [dateTimeLbl setFont:[UIFont fontWithName:@"Myriad Pro" size:14]];
    
}

- (IBAction)cancelDateSelectingBtn:(id)sender
{
    
    self.destinationTxtField.userInteractionEnabled=YES;
    self.pickupdatetimeView.hidden=YES;
    
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
    else
    {
        UIAlertView *alert=[[UIAlertView alloc ]initWithTitle:@"Rapid" message:@"Select correct pick up date." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self.datePicker setDate:dateAftrHours animated:NO];
    }
}



@end









