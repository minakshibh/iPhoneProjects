//
//  GreetingsViewController.m
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
#import "greetingTableViewCell.h"

@interface GreetingsViewController ()

@end

@implementation GreetingsViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden=YES;
    
    greetingListArray=[[NSMutableArray alloc]init];
    
    for (int k=0;k<3;k++)
    {
        Greeting*greetingObj=[[Greeting alloc]init];
        
        greetingObj.name=@"abc";
        greetingObj.tableNumbr=@"Table 5";
        greetingObj.peapleNumbr=@"3 people";
        greetingObj.specialReqst=@"SpecialRequest:";
        greetingObj.timing=@"06:00-09:00";
        greetingObj.imageUrl=@"http://3.bp.blogspot.com/-NRCD3j0Fbi4/TkDf2p9OkkI/AAAAAAAAB2M/UN5HxVl4Pks/s320/Cute+baby+animal+wallpaper-1.jpg";
        [greetingListArray addObject:greetingObj];
    }
    

    printPageBttn.layer.borderColor = [UIColor clearColor].CGColor;
    printPageBttn.layer.borderWidth = 1.5;
    printPageBttn.layer.cornerRadius = 16.0;
    
    emailPageBttn.layer.borderColor = [UIColor clearColor].CGColor;
    emailPageBttn.layer.borderWidth = 1.5;
    emailPageBttn.layer.cornerRadius = 16.0;
    
    emailPageBttn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:12.0f];
    printPageBttn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:12.0f];

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Greeting" delegate:self];
    
    [self.view addSubview: upparView];
}

- (void)mainMenuBtnPressed
{
    DashboardViewController*dashboardView=[[DashboardViewController alloc]initWithNibName:@"DashboardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashboardView animated:NO];
}
- (void)addBookingBtnPressed{
    AddBookingViewController*addBookingVC=[[AddBookingViewController alloc]initWithNibName:@"AddBookingViewController" bundle:[NSBundle mainBundle]];
    [self .navigationController pushViewController:addBookingVC animated:NO];
    NSLog(@"addBookingBtn Pressed ");
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [greetingListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    greetingTableViewCell *cell = (greetingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"greetingTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    greetingListObj = [greetingListArray objectAtIndex:indexPath.row];
    if (indexPath.row%2 == 0 || indexPath.row == 0) {
        cell.backgroundColor=[UIColor colorWithRed:27/255.0f green:32/255.0f blue:68/255.0f alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell setLabelText:greetingListObj.name :greetingListObj.tableNumbr :greetingListObj.peapleNumbr :greetingListObj.specialReqst :greetingListObj.timing :greetingListObj.imageUrl];
    
    
    
    ///////  BUTTON //////////
    UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [viewBtn setTitle: @"Pending arrival" forState: UIControlStateNormal];
    
    viewBtn.frame = CGRectMake(800.0f, 35.0f,130.0f,30.0f);
    viewBtn.tag = indexPath.row;
    viewBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:10.0f];
    [viewBtn setTintColor:[UIColor whiteColor]] ;
    [viewBtn addTarget:self action:@selector(cellActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"Pending arrival"];
    [viewBtn setBackgroundColor:[UIColor colorWithRed:13/255.0f green:54/255.0f blue:108/255.0f alpha:1.0]];
    [viewBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    viewBtn.layer.borderColor = [UIColor clearColor].CGColor;
    viewBtn.layer.borderWidth = 1.5;
    viewBtn.layer.cornerRadius = 16.0;
    [cell.contentView addSubview:viewBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    Greeting *greetObj = (Greeting *)[greetingListArray objectAtIndex:indexPath.row];
}




- (IBAction)cellActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    
    Greeting *greetObj = (Greeting *)[greetingListArray objectAtIndex:indexPath.row];
}






- (IBAction)printPageBtn:(id)sender {
}

- (IBAction)emailPageBttn:(id)sender {
}
@end
