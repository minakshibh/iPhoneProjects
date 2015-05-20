//
//  MarketingViewController.m
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
#import "MarketingTableViewCell.h"
#import "AddBookingViewController.h"

@interface MarketingViewController ()

@end

@implementation MarketingViewController
- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden=YES;
    
    membersListArray=[[NSMutableArray alloc]init];
    
    for (int k=0;k<3;k++)
    {
        MarketDetail*marketObj=[[MarketDetail alloc]init];
        
        marketObj.name=@"abc";
        marketObj.emailAddress=@"navbrar27@gmail.com";
        marketObj.ContactNum=@"+918872120230";
        marketObj.frequentGuest=@"FREQUENT GUEST";
        marketObj.imageUrl=@"http://3.bp.blogspot.com/-NRCD3j0Fbi4/TkDf2p9OkkI/AAAAAAAAB2M/UN5HxVl4Pks/s320/Cute+baby+animal+wallpaper-1.jpg";
        [membersListArray addObject:marketObj];
    }

    sendNewsLetterOutlet.layer.borderColor = [UIColor clearColor].CGColor;
    sendNewsLetterOutlet.layer.borderWidth = 1.5;
    sendNewsLetterOutlet.layer.cornerRadius = 17.0;
   
    
    sendTextMessage.layer.borderColor = [UIColor clearColor].CGColor;
    sendTextMessage.layer.borderWidth = 1.5;
    sendTextMessage.layer.cornerRadius = 17.0;
    
    mailchimpOutlet.layer.borderColor = [UIColor clearColor].CGColor;
    mailchimpOutlet.layer.borderWidth = 1.5;
    mailchimpOutlet.layer.cornerRadius = 17.0;
    
    titleLbl.font = [UIFont fontWithName:@"Lovelo" size:16.0f];
    filterTitle.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    firstNameTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    secontTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    thirdTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    contrySelectBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    recentBookingLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    filterResultBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    
    filterResultBtn.layer.borderColor = [UIColor clearColor].CGColor;
    filterResultBtn.layer.borderWidth = 1.5;
    filterResultBtn.layer.cornerRadius = 17.0;
    
    
    contrySelectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    contrySelectBtn.layer.borderWidth = 1.5;
    contrySelectBtn.layer.cornerRadius = 17.0;
    
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

    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Marketing" delegate:self];
    
    [self.view addSubview: upparView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [membersListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    MarketingTableViewCell *cell = (MarketingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MarketingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    marketListObj = [membersListArray objectAtIndex:indexPath.row];
    if (indexPath.row%2 == 0 || indexPath.row == 0) {
        cell.backgroundColor=[UIColor colorWithRed:27/255.0f green:32/255.0f blue:68/255.0f alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
   
    [cell setLabelText:marketListObj.name :marketListObj.ContactNum :marketListObj.emailAddress :marketListObj.frequentGuest :marketListObj.imageUrl];
    
    
    /////// CALL BUTTON //////////
    UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [viewBtn setTitle: @"call" forState: UIControlStateNormal];
    
    viewBtn.frame = CGRectMake(710.0f, 35.0f,80.0f,30.0f);
    viewBtn.tag = indexPath.row;
    viewBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    [viewBtn setTintColor:[UIColor whiteColor]] ;
    [viewBtn addTarget:self action:@selector(viewActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"VIEW"];
    [viewBtn setBackgroundColor:[UIColor colorWithRed:13/255.0f green:54/255.0f blue:108/255.0f alpha:1.0]];
    [viewBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    viewBtn.layer.borderColor = [UIColor clearColor].CGColor;
    viewBtn.layer.borderWidth = 1.5;
    viewBtn.layer.cornerRadius = 17.0;
    [cell.contentView addSubview:viewBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    MarketDetail *marketObj = (MarketDetail *)[membersListArray objectAtIndex:indexPath.row];
}




- (IBAction)viewActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    MarketDetail *marketObj = (MarketDetail *)[membersListArray objectAtIndex:indexPath.row];
}



- (void)mainMenuBtnPressed{
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
    NSLog(@"dashboard preesed");
}
- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:addBookingVC animated:NO];
    NSLog(@"addBookingBtn Pressed ");
    
}
@end
