//
//  feedbackViewController.m
//  uco
//
//  Created by Krishna_Mac_1 on 4/2/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "feedbackViewController.h"
#import "AddBookingViewController.h"
#import "DashboardViewController.h"
#import "feedbakTableViewCell.h"
@interface feedbackViewController ()

@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateTitle.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    self.customerTitle.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    self.commentTitle.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    testimonialsLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    reviews.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    newLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    readLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    
    testimonialsLbl.layer.borderColor = [UIColor clearColor].CGColor;
    testimonialsLbl.layer.borderWidth = 1.5;
    testimonialsLbl.layer.cornerRadius = 16.0;
    [testimonialsLbl setClipsToBounds:YES];
    
    reviews.layer.borderColor = [UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0].CGColor;
    reviews.layer.borderWidth = 1.5;
    reviews.layer.cornerRadius = 16.0;
    [reviews setClipsToBounds:YES];
    
    newLbl.layer.borderColor = [UIColor clearColor].CGColor;
    newLbl.layer.borderWidth = 1.5;
    newLbl.layer.cornerRadius = 16.0;
    [newLbl setClipsToBounds:YES];
    
    readLbl.layer.borderColor = [UIColor clearColor].CGColor;
    readLbl.layer.borderWidth = 1.5;
    readLbl.layer.cornerRadius = 16.0;
    [readLbl setClipsToBounds:YES];
    
    feedbackArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        feedbackOC = [[feedbackObj alloc] init];
        feedbackOC.dateStr = @"2/12/2015";
        feedbackOC.customerName = @"Ms John";
        feedbackOC.commentStr = @"Hello really enjoy the food, its awsome.";
        [feedbackArray addObject:feedbackOC];
    }
    
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
    
    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"feedback" delegate:self];
    
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
    
    return [feedbackArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    feedbakTableViewCell *cell = (feedbakTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"feedbakTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    feedbackOC = [feedbackArray objectAtIndex:indexPath.row];
    
    [cell setLabelText:feedbackOC.dateStr: feedbackOC.customerName :feedbackOC.commentStr];
    
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
//    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
//    Payment*paymntObj= (Payment *)[paymentListArray objectAtIndex:indexPath.row];
}


@end
