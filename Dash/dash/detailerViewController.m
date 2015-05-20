//
//  detailerViewController.m
//  dash
//
//  Created by Krishna_Mac_1 on 4/22/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "detailerViewController.h"
#import "AsyncImageView.h"
#import "workSampleTableViewCell.h"
#import "customerProfileViewController.h"
#import "loginViewController.h"
#import "homeViewViewController.h"
@interface detailerViewController ()

@end

@implementation detailerViewController
@synthesize fromView;

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [super viewDidLoad];
    NSLog(@"Name.... %@",self.mapDetailsOC.placeName);
    NSLog(@"Lats.... %@",self.mapDetailsOC.latitudeStr);
    nameLbl.text = self.mapDetailsOC.placeName;
    beforeImagesArray = [[NSMutableArray alloc] initWithObjects:@"http://rejuvenateauto.com/images/rja-00-car-wax-after.jpg",@"http://pearlwaterlessinternational.com/wp-content/uploads/2012/09/Before-and-After-Pearl-Waterless-Wash-Polish-and-Wax.jpg",@"http://i.ytimg.com/vi/tjI8_hKZMFg/hqdefault.jpg", nil];
    afterImageArrays = [[NSMutableArray alloc] initWithObjects:@"http://image.cpsimg.com/sites/carparts-mc/assets/carcare/images/waxing1.jpg",@"http://www.autogeekonline.net/gallery/data/500/2002ViperACR.jpg",@"http://www.detailedimage.com/photos/esoteric/claybar/IMG_3251.JPG", nil];
    AsyncImageView *itemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",self.mapDetailsOC.placeImage];
    itemImage.imageURL = [NSURL URLWithString:imageUrls];
    itemImage.showActivityIndicator = YES;
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 ) {
    itemImage.frame = CGRectMake(8 , 100,130 , 130);
    }else{
        itemImage.frame = CGRectMake(8 , 80,100 , 100);
    }
    //itemImage.contentMode = UIViewContentModeScaleAspectFill;
    itemImage.userInteractionEnabled = YES;
    itemImage.multipleTouchEnabled = YES;
    itemImage.layer.borderColor = [UIColor clearColor].CGColor;
    itemImage.layer.borderWidth = 1.5;
    itemImage.layer.cornerRadius = 4.0;
    [itemImage setClipsToBounds:YES];
    [self.view addSubview:itemImage];
    int x = 0;
    int rate = [self.mapDetailsOC.placeRatingStr intValue];
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 ) {
        x = 220;
    }else{
        x = 180;
    }
    for (int i = 0; i < 5; i++) {
        UIButton *rateButton;
        if ([[ UIScreen mainScreen ] bounds ].size.width == 414 ) {
            rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 158, 15, 15)];
        }else{
            rateButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 120, 15, 15)];
        }
        if (i < rate) {
            [rateButton setBackgroundImage:[UIImage imageNamed:@"yellow-star.png"] forState:UIControlStateNormal];
        }else{
            [rateButton setBackgroundImage:[UIImage imageNamed:@"gray-star.png"] forState:UIControlStateNormal];
        }
        [self.view addSubview:rateButton];
        x= x+15;
    }
    worksampleDetails = [[NSMutableArray alloc] init];
    for (int i =0 ; i < [beforeImagesArray count]; i++) {
        workSampleOC = [[workSampleObj alloc]init];
        workSampleOC.beforeServiceUrl = [NSString stringWithFormat:@"%@",[beforeImagesArray objectAtIndex:i]];
        workSampleOC.afterServiceUrl = [NSString stringWithFormat:@"%@",[afterImageArrays objectAtIndex:i]];
        [worksampleDetails addObject:workSampleOC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    homeViewViewController *homeVC = [[homeViewViewController alloc] initWithNibName:@"homeViewViewController" bundle:nil];
    [self.navigationController pushViewController:homeVC animated:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return [worksampleDetails count];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    workSampleTableViewCell *cell = (workSampleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"workSampleTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    workSampleOC = [worksampleDetails objectAtIndex:indexPath.row];
    AsyncImageView *beforetemImage = [[AsyncImageView alloc] init];
    NSString *imageUrls = [NSString stringWithFormat:@"%@",workSampleOC.beforeServiceUrl];
    beforetemImage.imageURL = [NSURL URLWithString:imageUrls];
    beforetemImage.showActivityIndicator = YES;
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 ) {
        beforetemImage.frame = CGRectMake(8 , 8, 191 , 120);
    }else{
        beforetemImage.frame = CGRectMake(5 , 5, 153 , 120);
    }
    
    //beforetemImage.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:beforetemImage];
    
    AsyncImageView *afterItemImage = [[AsyncImageView alloc] init];
    NSString *afterimageUrls = [NSString stringWithFormat:@"%@",workSampleOC.afterServiceUrl];
    afterItemImage.imageURL = [NSURL URLWithString:afterimageUrls];
    afterItemImage.showActivityIndicator = YES;
    if ([[ UIScreen mainScreen ] bounds ].size.width == 414 ) {
        afterItemImage.frame = CGRectMake(215 , 8, 191 , 120);
    }else{
        afterItemImage.frame = CGRectMake(163 , 5, 153 , 120);
    }
    //afterItemImage.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:afterItemImage];
        return cell;
}


- (IBAction)profileBttn:(id)sender {
    customerProfileViewController *profileVc = [[customerProfileViewController alloc] initWithNibName:@"customerProfileViewController" bundle:nil];
    profileVc.registrationType = @"detailer";
    [self.navigationController pushViewController:profileVc animated:NO];
}
@end
