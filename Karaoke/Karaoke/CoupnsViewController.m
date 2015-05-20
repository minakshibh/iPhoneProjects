//
//  CoupnsViewController.m
//  Karaoke
//
//  Created by Br@R on 11/09/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import "CoupnsViewController.h"
#import <StoreKit/StoreKit.h>
#import "CreditSongsCell.h"
#import "AvailableSongsViewController.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"

@interface CoupnsViewController ()

@end

@implementation CoupnsViewController
@synthesize productCode,creditTable,activityIndicatorObject,disableImg,fiftySongsAvailable,fiveSongsAvailable,tenSongsAvailable,hundredSongsAvailable,flag;

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
     self.creditTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    creditsArray=[[NSMutableArray alloc]init];
    tempPriceArray=[[NSMutableArray alloc]init];
    priceArray=[[NSMutableArray alloc]init];
    productIdArray=[[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

//    NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
//    NSLog(@"total songs %d",[totalSongsStr intValue]);
//
//    
//        fiveSongsAvailable.text=[NSString stringWithFormat:@"%d Songs",[totalSongsStr intValue]];
    [self addCredits:[NSString stringWithFormat:@"0"]];
    disableImg.hidden=YES;
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
    [self.view addSubview:activityIndicatorObject];
    
    
    creditTable.backgroundColor = [UIColor clearColor];

//    creditsArray=[NSArray arrayWithObjects:@"3 songs pack",@"10 songs pack",@"25 songs pack",@"50 songs pack",@"100 songs pack", nil];
//    songsInCreditArray=[NSArray arrayWithObjects:@"3",@"10",@"25",@"50",@"100", nil];
//    priceArray=[NSArray arrayWithObjects:@"3",@"9",@"21",@"27",@"60", nil];

  productCodeArray =[NSArray arrayWithObjects:@"KPaidSong3",@"KPaidSong10",@"KPaidSong25",@"KPaidSong50",@"KPaidSong100",nil];
     [self  fetchAvailableProducts];
    threeSongs=NO;
    tenSongs=NO;
    twentyFiveSongs=NO;
    fiftySongs=NO;
    hundrdSongs=NO;
   // [self fetchAvailableProducts];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender {
   // AvailableSongsViewController *avc=[[AvailableSongsViewController alloc]init];
   // avc.flag=flag;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2 && buttonIndex == 0) {
//        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//        [activityIndicatorObject startAnimating];
//        [self.view setUserInteractionEnabled:NO];
//         disableImg.hidden=NO;
//        [self  fetchAvailableProducts];
    }
}


-(void)fetchAvailableProducts
{
    disableImg.hidden=NO;
    self.view.userInteractionEnabled=NO;
    [activityIndicatorObject startAnimating];
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:@"KPaidSong3",@"KPaidSong10",@"KPaidSong25",@"KPaidSong50",@"KPaidSong100",nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}


- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}
- (void)purchaseMyProduct:(SKProduct*)product
{
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions
{

    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
               

                break;
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:productCode])
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    disableImg.hidden=YES;
//                    self.view.userInteractionEnabled=YES;
//                    [activityIndicatorObject stopAnimating];
                    NSLog(@"Purchased ");
                  //  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                              @"Purchase is completed succesfully" message:nil delegate:
                                              self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                    if (threeSongs)
                    {
                        creditToSave = 3;
                        NSString *songs = [defaults objectForKey:@"totalSongs"];
                        int five=3 +[songs intValue];
                        [defaults setObject:[NSString stringWithFormat:@"%d",five] forKey:@"totalSongs"];
                    }
                    if (tenSongs)
                    {
                        creditToSave = 10;
                        NSString *songs = [defaults objectForKey:@"totalSongs"];
                        int ten=10 +[songs intValue];
                        [defaults setObject:[NSString stringWithFormat:@"%d",ten] forKey:@"totalSongs"];
                    }
                    if (twentyFiveSongs)
                    {
                        creditToSave = 25;
                        NSString *songs = [defaults objectForKey:@"totalSongs"];
                        int twentyFive=25 +[songs intValue];
                        [defaults setObject:[NSString stringWithFormat:@"%d",twentyFive] forKey:@"totalSongs"];
                    }
                    if (fiftySongs)
                    {
                        creditToSave =50;
                        NSString *songs = [defaults objectForKey:@"totalSongs"];
                        int fifty=50 +[songs intValue];
                        [defaults setObject:[NSString stringWithFormat:@"%d",fifty] forKey:@"totalSongs"];
                    }
                    if (hundrdSongs)
                    {
                        creditToSave = 100;
                        NSString *songs = [defaults objectForKey:@"totalSongs"];
                        int hundrd=100 +[songs intValue];
                        [defaults setObject:[NSString stringWithFormat:@"%d",hundrd] forKey:@"totalSongs"];
                    }
                     [defaults synchronize];
                    
                    NSString *totalStr = [defaults objectForKey:@"totalSongs"];
                   
                    
                    if ([totalStr isEqualToString:@"1"] ) {
                        fiveSongsAvailable.text=[NSString stringWithFormat:@"%@ Song",totalStr];
                        
                    }
                    else{
                        fiveSongsAvailable.text=[NSString stringWithFormat:@"%@ Songs",totalStr];
                    }
                    
                    NSLog(@"total %@",totalStr);
                    
                   // [defaults setObject:[NSString stringWithFormat:@"%@",totalStr] forKey:@"totalSongs"];
                    [defaults synchronize];
                    [self addCredits:[NSString stringWithFormat:@"%d",creditToSave]];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
//                disableImg.hidden=YES;
//                self.view.userInteractionEnabled=YES;
//                [activityIndicatorObject stopAnimating];
               // [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
//                disableImg.hidden=YES;
//                self.view.userInteractionEnabled=YES;
//               // [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//                [activityIndicatorObject stopAnimating];
                NSLog(@"Purchase failed ");
                break;
            default:
                break;
        }
    }
    
    
}




-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
     [activityIndicatorObject stopAnimating];
    disableImg.hidden=YES;
    self.view.userInteractionEnabled=YES;

    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count>0) {
        validProducts = response.products;
       
        for (int i=0;i<validProducts.count; i++) {
            validProduct = [response.products objectAtIndex:i];
            
            productCode=[productCodeArray objectAtIndex:i];
            NSLog(@"product code..%@",productCode);
//            if ([validProduct.productIdentifier
//                 isEqualToString:productCode])
//            {
                NSLog(@"%@",[NSString stringWithFormat:
                         @"Product id..: %@",validProduct.productIdentifier]);
                NSLog(@"%@",[NSString stringWithFormat:
                             @"Product Title: %@",validProduct.localizedTitle]);
                NSLog(@"%@",[NSString stringWithFormat:
                             @"Product Desc: %@",validProduct.localizedDescription]);
                NSLog(@"%@",[NSString stringWithFormat:
                             @"Product Price: %@",validProduct.price]);
                NSLog(@"%@",[NSString stringWithFormat:
                         @"Product Price locale: %@",validProduct.priceLocale]);
           
//            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//            [numberFormatter setLocale:validProduct.priceLocale];
//            NSString *formattedString = [numberFormatter stringFromNumber:validProduct.price];
//            NSLog(@"price string %@",formattedString);
            
            
            [tempPriceArray addObject:validProduct.price];
            [creditsArray addObject:validProduct.localizedTitle];
            [productIdArray addObject:validProduct.productIdentifier];
            
            NSLog(@"price temp array..%@",tempPriceArray);
            
            NSLog(@"song name%@",creditsArray);
            NSLog(@"song price%@",priceArray);
           // }
        }
        
        NSSortDescriptor *highestToLowestPrice = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        [tempPriceArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowestPrice]];
      
//        NSSortDescriptor *highestToLowestName = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
//        [creditsArray sortUsingDescriptors:[NSArray arrayWithObject:highestToLowestName]];
        creditsArray = [creditsArray sortedArrayUsingDescriptors:
                                 @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                                 ascending:YES]]];
        tempPriceArray = [tempPriceArray sortedArrayUsingDescriptors:
                        @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                        ascending:YES]]];
        
        validProducts = [response.products sortedArrayUsingDescriptors:
                          @[[NSSortDescriptor sortDescriptorWithKey:@"price"
                                                          ascending:YES]]];
        
       
        
        
        NSMutableArray *temparray=[[NSMutableArray alloc]init];
        for (int j=0; j<tempPriceArray.count;j++)
        {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:validProduct.priceLocale];
            NSString *formattedString = [numberFormatter stringFromNumber:[tempPriceArray objectAtIndex:j]];
            [priceArray addObject:formattedString];
           
            NSRange beginningOfNumber = [[productIdArray objectAtIndex:j] rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
            if (beginningOfNumber.location == NSNotFound)
            {
                return;
            }
            
            NSString *key           = [[productIdArray objectAtIndex:j] substringToIndex:beginningOfNumber.location];
            NSString *stringValue   = [[productIdArray objectAtIndex:j] substringFromIndex:beginningOfNumber.location];
            NSInteger value         = [stringValue integerValue];
            NSLog(@"Key.. %@",key);
            NSLog(@"String Value.. %@",stringValue);
            NSLog(@"Value.. %ld",(long)value);
            [temparray addObject:stringValue];
        }
        productIdArray = [temparray sortedArrayUsingDescriptors:
                          @[[NSSortDescriptor sortDescriptorWithKey:@"intValue"
                                                          ascending:YES]]];
        
        NSLog(@"Product code .. %@",productIdArray);
        NSLog(@"Product array %@",validProducts);
        NSLog(@"sorted credit array..%@",creditsArray);
        NSLog(@"sorted array..%@",priceArray);
        NSLog(@"sorted song name%@",tempPriceArray);

        [creditTable reloadData];
        
        //  [self purchaseMyProduct:[validProducts objectAtIndex:0]];
    }
    else {
         [activityIndicatorObject stopAnimating];
         disableImg.hidden=YES;
        self.view.userInteractionEnabled=YES;
       // [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"OK", nil];
        [tmp show];
    }
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return creditsArray.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    CreditSongsCell *cell;
   
    buyBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // UIButton *deleteBtn= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        buyBtn.frame = CGRectMake(245.0f, 20.0, 45.0f, 20.0f);
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 480) {
        buyBtn.frame = CGRectMake(239.0f, 20.0, 45.0f, 20.0f);
    }
    else{
        buyBtn.frame = CGRectMake(580.0f, 75.0, 105.0f, 40.0f);
    }
    
    buyBtn.tag = indexPath.row+1000;
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"buy-now-btn"];
    
    [buyBtn setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyNow:) forControlEvents:UIControlEventTouchUpInside];
    
   cell = (CreditSongsCell *)[creditTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        NSArray *nib;
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CreditSongsCell" owner:self options:nil];
            //this is iphone 5 xib
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 480) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CreditSongsCell" owner:self options:nil];
            //this is iphone 4 xib
        }
        else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"CreditSongsCell_ipad" owner:self options:nil];
        }
    cell = [nib objectAtIndex:0];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.backgroundColor=[UIColor clearColor];

    [cell setLabelText:[creditsArray objectAtIndex:indexPath.row] :[creditsArray objectAtIndex:indexPath.row] :[priceArray objectAtIndex:indexPath.row]];
    
    [cell.contentView addSubview:buyBtn];
        
    
return cell;

}

//called when any cell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Selected Value is %@",[creditsArray objectAtIndex:indexPath.row]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.tag=1;
    //[alertView show];
}

- (void)buyNow:(UIControl *)sender
{
    self.view.userInteractionEnabled=NO;
    disableImg.hidden=NO;
    [activityIndicatorObject startAnimating];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSNumber *selRow = [[NSNumber alloc] initWithInteger:indexPath.row];
    int index = [selRow integerValue];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    
    buyBtnIndex=[sender tag]-1000;
    NSLog(@"%d",buyBtnIndex);
    
    NSString *songsStr=[creditsArray objectAtIndex:buyBtnIndex];
    NSLog(@"song str.. %@",songsStr);
    if ([songsStr isEqualToString:@"3 Credits (3 Songs)"])
    {
        threeSongs=YES;
        tenSongs=NO;
        twentyFiveSongs=NO;
        fiftySongs=NO;
        hundrdSongs=NO;
    }
    if ([songsStr isEqualToString:@"10 Credits (10 Songs)"])
    {
        threeSongs=NO;
        tenSongs=YES;
        twentyFiveSongs=NO;
        fiftySongs=NO;
        hundrdSongs=NO;
    }
    if ([songsStr isEqualToString:@"25 Credits (25 Songs)"])
    {
        threeSongs=NO;
        twentyFiveSongs=YES;
        tenSongs=NO;
        fiftySongs=NO;
        hundrdSongs=NO;
    }
    if ([songsStr isEqualToString:@"50 Credits (50 Songs)"])
    {
        threeSongs=NO;
        tenSongs=NO;
        twentyFiveSongs=NO;
        fiftySongs=YES;
        hundrdSongs=NO;
    }
    if ([songsStr isEqualToString:@"100 Credits (100 Songs)"])
    {
        threeSongs=NO;
        tenSongs=NO;
        twentyFiveSongs=NO;
        fiftySongs=NO;
        hundrdSongs=YES;
    }

    //
    NSLog(@"index %d",index);
    productCode=[NSString stringWithFormat:@"KPaidSong%@",[productIdArray objectAtIndex:buyBtnIndex]];
    NSLog(@"product code %@",productCode);
       [self purchaseMyProduct:[validProducts objectAtIndex:buyBtnIndex]];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(EnableView:)
                                   userInfo:nil
                                    repeats:NO];
    
   


 }

-(IBAction)EnableView:(id)sender
{
    disableImg.hidden=YES;
    [activityIndicatorObject stopAnimating];
    self.view.userInteractionEnabled=YES;

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

-(void)addCredits:(NSString *)creditsValue
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/AddCredits",Kwebservices]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString *UDID;
    NSString *Credits;
   
    if(UDID==nil)
        UDID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Email"]];
    [request setPostValue:UDID forKey:@"user_email"];
    
    if(Credits==nil)
        Credits = [NSString stringWithString:creditsValue];
    [request setPostValue:Credits forKey:@"Credit"];
    
   
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
        
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
    
}

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI
  qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict

{
        if ([elementName isEqualToString:@"Result"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"Message"]){
            tempString = [[NSMutableString alloc] init];
        }else if ([elementName isEqualToString:@"TotalCredits"]){
            tempString = [[NSMutableString alloc] init];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      if ([elementName isEqualToString:@"Result"]){
          
            message = [NSString stringWithFormat:@"%@", tempString];
      }else if ([elementName isEqualToString:@"TotalCredits"])
      {
          creditValue = [NSString stringWithFormat:@"%@", tempString];
          [defaults setObject:creditValue forKey:@"totalSongs"];
          NSString *totalSongsStr = [defaults objectForKey:@"totalSongs"];
          NSLog(@"total songs %d",[totalSongsStr intValue]);
          fiveSongsAvailable.text=[NSString stringWithFormat:@"%d Songs",[totalSongsStr intValue]];
      }
    NSLog(@"MESSAGE %@",message);
    //[self viewDidLoad];
}

@end




