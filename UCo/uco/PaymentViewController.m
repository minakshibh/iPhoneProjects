//
//  PaymentViewController.m
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
#import "AddBookingViewController.h"
#import "Payment.h"
#import "PaymentTableViewCell.h"


@interface PaymentViewController ()

@end

@implementation PaymentViewController


- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden=YES;
    
    paymentListArray=[[NSMutableArray alloc]init];
    dueDateLabl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    amountLabl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    idLabl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    dateLabl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    for (int k=0;k<5;k++)
    {
        Payment*paymentObj=[[Payment alloc]init];
        
        paymentObj.date=@"05/12/2015";
        paymentObj.customerId=@"55";
        paymentObj.amount=@"100";
        paymentObj.dueDate=@"07/05/2015";
        [paymentListArray addObject:paymentObj];
    }
    

    
    
    
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
    
//    
//    Leftsideview = [[LeftSideBarView alloc] initWithFrame:CGRectMake(0, 90, 300,self.view.frame.size.height-90) fontName:@"Helvetica" delegate:self];
//    
//    [self.view addSubview: Leftsideview];
//    Leftsideview.hidden=YES;

    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Payment" delegate:self];
    
    [self.view addSubview: upparView];
}


- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:addBookingVC animated:NO];
    NSLog(@"addBookingBtn Pressed ");
    
}

- (void)mainMenuBtnPressed
{
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [paymentListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    PaymentTableViewCell *cell = (PaymentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    paymentListObj = [paymentListArray objectAtIndex:indexPath.row];
    
    [cell setLabelText:paymentListObj.date: paymentListObj.customerId :paymentListObj.amount :paymentListObj.dueDate];
    
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    Payment*paymntObj= (Payment *)[paymentListArray objectAtIndex:indexPath.row];
}






@end
