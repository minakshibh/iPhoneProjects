//
//  SpecialOffersViewController.m
//  uco
//
//  Created by Br@R on 23/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "SpecialOffersViewController.h"
#import "SpecialOffrsTableViewCell.h"
#import "DashboardViewController.h"
#import "AddBookingViewController.h"
#import "UpparBarView.h"
@interface SpecialOffersViewController ()

@end

@implementation SpecialOffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    specialOffersTableView.hidden = NO;
    specialOffersArray=[[NSMutableArray alloc]init];
    for (int k=0;k<3;k++)
    {
        Restaurant*restaurantObj=[[Restaurant alloc]init];
        
        restaurantObj.name=@"abc";
        restaurantObj.address=@"ncvhg hhskh jkljkjxkjk ifsfff";
        
        [specialOffersArray addObject:restaurantObj];
    }
    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Marketing" delegate:self];
    
    [self.view addSubview: upparView];
    
    
    [self roundCornersOfAllButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addOffers:(id)sender {
    
    [addOffersBtn setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    [specialOffersBtn setBackgroundColor:[UIColor clearColor]];
    
    offerTitleTxt.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    descriptionLbl.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    priceTxt.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    termsLbl.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    startDateLbl.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    startDate.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    endDateLbl.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    endDate.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    feturedLbl.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    createOfferBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    
    startDate.layer.borderColor = [UIColor whiteColor].CGColor;
    startDate.layer.borderWidth = 1.5;
    startDate.layer.cornerRadius = 13.0;
    [startDate setClipsToBounds:YES];
    
    endDate.layer.borderColor = [UIColor whiteColor].CGColor;
    endDate.layer.borderWidth = 1.5;
    endDate.layer.cornerRadius = 13.0;
    [endDate setClipsToBounds:YES];
    
    createOfferBtn.layer.borderColor = [UIColor clearColor].CGColor;
    createOfferBtn.layer.borderWidth = 1.5;
    createOfferBtn.layer.cornerRadius = 13.0;
    [createOfferBtn setClipsToBounds:YES];
    
    descriptiontxtView.layer.borderColor = [UIColor clearColor].CGColor;
    descriptiontxtView.layer.borderWidth = 1.5;
    descriptiontxtView.layer.cornerRadius = 8.0;
    [descriptiontxtView setClipsToBounds:YES];
    
    termsAndConditionTxtView.layer.borderColor = [UIColor clearColor].CGColor;
    termsAndConditionTxtView.layer.borderWidth = 1.5;
    termsAndConditionTxtView.layer.cornerRadius = 8.0;
    [termsAndConditionTxtView setClipsToBounds:YES];
    
    specialOffersTableView.hidden = YES;
    [addOfferView setFrame:CGRectMake(52, 162, 920, 565)];
    [self.view addSubview:addOfferView];
    
}

- (IBAction)specialOffersBtn:(id)sender {
    [specialOffersBtn setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    [addOffersBtn setBackgroundColor:[UIColor clearColor]];
    [addOfferView removeFromSuperview];
    specialOffersTableView.hidden = NO;
    [specialOffersTableView reloadData];
}


-(void)roundCornersOfAllButton
{
    
    [specialOffersBtn setBackgroundColor:[UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1]];
    [addOffersBtn setBackgroundColor:[UIColor clearColor]];
    
    addOffersBtn.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    addOffersBtn.layer.borderWidth = 1.4;
    addOffersBtn.layer.cornerRadius = 12.0;
    [addOffersBtn setClipsToBounds:YES];
    
    specialOffersBtn.layer.borderColor = [UIColor colorWithRed:166.0/255.0f green:18.0f/255.0f blue:44.0f/255.0f alpha:1].CGColor;
    specialOffersBtn.layer.borderWidth = 1.5;
    specialOffersBtn.layer.cornerRadius = 17.0;
    [specialOffersBtn setClipsToBounds:YES];
    
    specialOffersBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:15.0f];
    addOffersBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:15.0f];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [specialOffersArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    SpecialOffrsTableViewCell *cell = (SpecialOffrsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SpecialOffrsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    restaurantListObj = [specialOffersArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:restaurantListObj.name :restaurantListObj.address];
    
    
    /////// MODIFY BUTTON //////////
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [modifyBtn setTitle: @"MODIFY" forState: UIControlStateNormal];
    
    modifyBtn.frame = CGRectMake(810.0f, 15.0f,80.0f,30.0f);
    modifyBtn.tag = indexPath.row;
    modifyBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    [modifyBtn setTintColor:[UIColor whiteColor]] ;
    [modifyBtn addTarget:self action:@selector(modifyActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"VIEW"];
    [modifyBtn setBackgroundColor:[UIColor colorWithRed:186.0f/255.0f green:109.0f/255.0f blue:5.0f/255.0f alpha:1.0]];
    [modifyBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    modifyBtn.layer.borderWidth = 1.4;
    modifyBtn.layer.cornerRadius = 4.0;
    [modifyBtn setClipsToBounds:YES];
    modifyBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [cell.contentView addSubview:modifyBtn];
    
    
    UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [emailBtn setTitle: @"EMAIL" forState: UIControlStateNormal];
    
    emailBtn.frame = CGRectMake(810.0f, 55.0f,80.0f,30.0f);
    emailBtn.tag = indexPath.row;
    emailBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    [emailBtn setTintColor:[UIColor whiteColor]] ;
    [emailBtn addTarget:self action:@selector(emailActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackground= [UIImage imageNamed:@"VIEW"];
    [emailBtn setBackgroundColor:[UIColor colorWithRed:16.0f/255.0f green:22.0f/255.0f blue:38.0f/255.0f alpha:1.0]];
    [emailBtn setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    emailBtn.layer.borderWidth = 1.4;
    emailBtn.layer.cornerRadius = 4.0;
    emailBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [emailBtn setClipsToBounds:YES];
    [cell.contentView addSubview:emailBtn];
    
    //cell.backgroundColor=[UIColor colorWithRed:23.0f/255.0f green:32.0f/255.0f blue:57.0f/255.0f alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    Restaurant*restaurantObj= (Restaurant *)[specialOffersArray objectAtIndex:indexPath.row];
}




- (IBAction)modifyActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    Restaurant*restaurantObj= (Restaurant *)[specialOffersArray objectAtIndex:indexPath.row];
}

- (IBAction)emailActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    Restaurant*restaurantObj= (Restaurant *)[specialOffersArray objectAtIndex:indexPath.row];
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
