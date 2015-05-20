//
//  CoupnsViewController.h
//  Karaoke
//
//  Created by Br@R on 11/09/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface CoupnsViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSArray *validProducts ,*productCodeArray;
    BOOL threeSongs;
    BOOL tenSongs;
     BOOL twentyFiveSongs;
    BOOL fiftySongs;
    BOOL hundrdSongs;
    UIButton *buyBtn;
    NSMutableArray *creditsArray,*priceArray,*tempPriceArray,*productIdArray;
    int buyBtnIndex, flag;
    int creditToSave;
    NSMutableString *tempString;
    NSString *result,*message, *creditValue;
}
@property (strong, nonatomic) NSString *productCode;

- (IBAction)backBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *disableImg;

@property (assign) int flag;

@property (weak, nonatomic) IBOutlet UITableView *creditTable;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (weak, nonatomic) IBOutlet UILabel *fiveSongsAvailable;
@property (weak, nonatomic) IBOutlet UILabel *fiftySongsAvailable;
@property (weak, nonatomic) IBOutlet UILabel *hundredSongsAvailable;
@property (weak, nonatomic) IBOutlet UILabel *tenSongsAvailable;

@end
