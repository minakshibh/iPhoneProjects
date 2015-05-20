//
//  manageRestaurantViewController.m
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "DashboardViewController.h"
#import "GreetingsViewController.h"
#import "AllBookingsViewController.h"
#import "MarketingViewController.h"
#import "ReportingViewController.h"
#import "SettingsViewController.h"
#import "PaymentViewController.h"
#import "manageRestaurantViewController.h"
#import "ManageRestaurantTableViewCell.h"
#import "AddBookingViewController.h"
#import "SpecialOffersViewController.h"


@interface manageRestaurantViewController ()

@end

@implementation manageRestaurantViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden=YES;
    
    restaurantListArray=[[NSMutableArray alloc]init];
    
    for (int k=0;k<3;k++)
    {
        Restaurant*restaurantObj=[[Restaurant alloc]init];
        
        restaurantObj.name=@"abc";
        restaurantObj.address=@"ncvhg hhskh jkljkjxkjk ifsfff";
   
        [restaurantListArray addObject:restaurantObj];
    }
    
 upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Manage Restaurant" delegate:self];
    
    manageRestaurantLbl.font =[UIFont fontWithName:@"Lovelo" size:20.0f];
    nameheaderTitle.font =[UIFont fontWithName:@"Lovelo" size:13.0f];
    addressHeaderTitle.font =[UIFont fontWithName:@"Lovelo" size:13.0f];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    // get pointer to app delegate, which contains property for menu pointer
    
    
    Leftsideview = [[LeftSideBarView alloc] initWithFrame:CGRectMake(0, 90, 300,self.view.frame.size.height-90) fontName:@"Helvetica" delegate:self];
    
  //  [self.view addSubview: Leftsideview];
    Leftsideview.hidden=YES;

    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Manage Restaurant" delegate:self];
    
    [self.view addSubview: upparView];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [restaurantListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    ManageRestaurantTableViewCell *cell = (ManageRestaurantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ManageRestaurantTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    restaurantListObj = [restaurantListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:restaurantListObj.name :restaurantListObj.address];
    
    
    /////// CALL BUTTON //////////
    UIButton *tableViewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tableViewBtn setTitle: @"TABLE VIEW" forState: UIControlStateNormal];
    
    tableViewBtn.frame = CGRectMake(690.0f,5.0f,80.0f,27.0f);
    tableViewBtn.tag = indexPath.row;
    tableViewBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    
    [tableViewBtn setTintColor:[UIColor whiteColor]] ;
    [tableViewBtn addTarget:self action:@selector(tableViewActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"VIEW"];
    [tableViewBtn setBackgroundColor:[UIColor colorWithRed:208/255.0f green:125/255.0f blue:29/255.0f alpha:1]];
    [tableViewBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    tableViewBtn.layer.borderColor = [UIColor clearColor].CGColor;
    tableViewBtn.layer.borderWidth = 1.5;
    tableViewBtn.layer.cornerRadius = 4.0;
    [tableViewBtn setClipsToBounds:YES];

    [cell.contentView addSubview:tableViewBtn];
    
    
    UIButton *specialOffersBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [specialOffersBtn setTitle: @"SPECIAL OFFERS" forState: UIControlStateNormal];
    
    specialOffersBtn.frame = CGRectMake(790.0f, 5.0f,120.0f,27.0f);
    specialOffersBtn.tag = indexPath.row;
    specialOffersBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    [specialOffersBtn setTintColor:[UIColor whiteColor]] ;
    [specialOffersBtn addTarget:self action:@selector(specialOffersBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackground= [UIImage imageNamed:@"VIEW"];
    [specialOffersBtn setBackgroundColor:[UIColor colorWithRed:2223/255.0f green:44/255.0f blue:21/255.0f alpha:1]];
    [specialOffersBtn setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    specialOffersBtn.layer.borderColor = [UIColor clearColor].CGColor;
    specialOffersBtn.layer.borderWidth = 1.5;
    specialOffersBtn.layer.cornerRadius = 4.0;
    [specialOffersBtn setClipsToBounds:YES];

    [cell.contentView addSubview:specialOffersBtn];

    
    
        cell.backgroundColor = [UIColor whiteColor];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    Restaurant*restaurantObj= (Restaurant *)[restaurantListArray objectAtIndex:indexPath.row];
}




- (IBAction)tableViewActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    Restaurant*restaurantObj= (Restaurant *)[restaurantListArray objectAtIndex:indexPath.row];
}

- (IBAction)specialOffersBtnActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    Restaurant*restaurantObj= (Restaurant *)[restaurantListArray objectAtIndex:indexPath.row];
    
    SpecialOffersViewController*specialOffersVC=[[SpecialOffersViewController alloc]initWithNibName:@"SpecialOffersViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:specialOffersVC animated:NO];
    
    NSLog(@"specialOffers Pressed ");
}


- (void)mainMenuBtnPressed{
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
    NSLog(@"dashboard preesed");
}
- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:addBookingVC animated:NO];
    
    NSLog(@"addBookingBtn Pressed ");
    
}

@end
