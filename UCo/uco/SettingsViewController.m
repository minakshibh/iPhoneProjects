//
//  SettingsViewController.m
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
#import "settingsTableViewCell.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden=YES;
    [super viewDidLoad];
    addUserBtn.layer.borderColor = [UIColor clearColor].CGColor;
    addUserBtn.layer.borderWidth = 1.5;
    addUserBtn.layer.cornerRadius = 16.0;
   [addUserBtn setClipsToBounds:YES];
    
    manageUsersBtn.layer.borderColor = [UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0].CGColor;
    manageUsersBtn.layer.borderWidth = 1.5;
    manageUsersBtn.layer.cornerRadius = 15.0;
    [manageUsersBtn setClipsToBounds:YES];
    
   
    changePassword.layer.borderWidth = 1.5;
    changePassword.layer.cornerRadius = 15.0;
    [changePassword setClipsToBounds:YES];
    changePassword.layer.borderColor = [UIColor clearColor].CGColor;
    
    securityQuestionBtn.layer.borderWidth = 1.5;
    securityQuestionBtn.layer.cornerRadius = 15.0;
    [securityQuestionBtn setClipsToBounds:YES];
    securityQuestionBtn.layer.borderColor = [UIColor clearColor].CGColor;
    
    submitBtn.layer.borderWidth = 1.5;
    submitBtn.layer.cornerRadius = 15.0;
    [submitBtn setClipsToBounds:YES];
    submitBtn.layer.borderColor = [UIColor clearColor].CGColor;
    
    securitySubmitBtn.layer.borderWidth = 1.5;
    securitySubmitBtn.layer.cornerRadius = 15.0;
    [securitySubmitBtn setClipsToBounds:YES];
    securitySubmitBtn.layer.borderColor = [UIColor clearColor].CGColor;
    
    firstQuestionLbl.layer.borderWidth = 1.5;
    firstQuestionLbl.layer.cornerRadius = 15.0;
    [firstQuestionLbl setClipsToBounds:YES];
    firstQuestionLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    
    secondQuestionLbl.layer.borderWidth = 1.5;
    secondQuestionLbl.layer.cornerRadius = 15.0;
    [secondQuestionLbl setClipsToBounds:YES];
    secondQuestionLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    
    manageUsersBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    changePassword.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    securityQuestionBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    submitBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    addUserBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    
    oldPasswordTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    newPasswordTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    confirmPasswordtxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    
    firstQuestionLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    firstAnswerTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    firstHintTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    secondQuestionLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    secondAnswerTxt.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    secondHint.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    securitySubmitBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    
    settingsListArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 8; i++) {
        settingsOC = [[settingsObj alloc] init];
        settingsOC.name = @"Mr. Peter ";
        settingsOC.email = @"john123@gmail.com";
        settingsOC.phoneNumber = @"7652389854";
        [settingsListArray addObject:settingsOC];
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
    
    
//    Leftsideview = [[LeftSideBarView alloc] initWithFrame:CGRectMake(0, 90, 300,self.view.frame.size.height-90) fontName:@"Helvetica" delegate:self];
//    
//    [self.view addSubview: Leftsideview];
//    Leftsideview.hidden=YES;

    upparView = [[UpparBarView alloc] initWithFrame:CGRectMake(0, 0, 1024,95) HeaderName:@"Setting" delegate:self];
    
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
    
    return [settingsListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    settingsTableViewCell *cell = (settingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"settingsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    settingsOC = [settingsListArray objectAtIndex:indexPath.row];
    if (indexPath.row%2 == 0 || indexPath.row == 0) {
        cell.backgroundColor=[UIColor colorWithRed:27/255.0f green:32/255.0f blue:68/255.0f alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell setLabelText:settingsOC.name : settingsOC.email : settingsOC.phoneNumber];
    
    
    
    ///////  Edit BUTTON //////////
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [editBtn setTitle: @"Edit" forState: UIControlStateNormal];
    
    editBtn.frame = CGRectMake(750.0f, 35.0f,80.0f,30.0f);
    editBtn.tag = indexPath.row;
    editBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    [editBtn setTintColor:[UIColor whiteColor]] ;
    [editBtn addTarget:self action:@selector(editActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"Pending arrival"];
    [editBtn setBackgroundColor:[UIColor colorWithRed:13/255.0f green:54/255.0f blue:108/255.0f alpha:1.0]];
    [editBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
    editBtn.layer.borderColor = [UIColor clearColor].CGColor;
    editBtn.layer.borderWidth = 1.5;
    editBtn.layer.cornerRadius = 16.0;
    [cell.contentView addSubview:editBtn];
    
    ///////  Delete BUTTON //////////
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteBtn setTitle: @"Delete" forState: UIControlStateNormal];
    
    deleteBtn.frame = CGRectMake(850.0f, 35.0f,80.0f,30.0f);
    deleteBtn.tag = indexPath.row;
    deleteBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    [deleteBtn setTintColor:[UIColor blackColor]] ;
   // [deleteBtn addTarget:self action:@selector(deleteBtnActionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *deleteBtnBackgroundShowDetail= [UIImage imageNamed:@"Pending arrival"];
    [deleteBtn setBackgroundColor:[UIColor colorWithRed:207/255.0f green:191/255.0f blue:142/255.0f alpha:1.0]];
    [deleteBtn setBackgroundImage:deleteBtnBackgroundShowDetail forState:UIControlStateNormal];
    deleteBtn.layer.borderColor = [UIColor clearColor].CGColor;
    deleteBtn.layer.borderWidth = 1.5;
    deleteBtn.layer.cornerRadius = 16.0;
    [cell.contentView addSubview:deleteBtn];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
   
}
- (IBAction)editActionBtn:(UIControl *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSLog(@"indexrow %ld", (long)indexPath.row);
    settingTableView.hidden = YES;
    addUserBtn.hidden = YES;
    settingsOC= (settingsObj *)[settingsListArray objectAtIndex:indexPath.row];
    [createUserView setFrame:CGRectMake(77, 150, 871, 425)];
    [self.view addSubview:createUserView];
}
- (IBAction)createUserAction:(id)sender {
    settingTableView.hidden = NO;
    addUserBtn.hidden = NO;
    [self setCreateView];
    [createUserView removeFromSuperview];
}

- (IBAction)addUserAction:(id)sender {
    settingTableView.hidden = YES;
    addUserBtn.hidden = YES;
    [self setCreateView];
    [createUserView setFrame:CGRectMake(77, 150, 871, 425)];
    [self.view addSubview:createUserView];
}

- (IBAction)changePasswordAction:(id)sender {
    manageUsersBtn.layer.borderColor = [UIColor clearColor].CGColor;
    changePassword.layer.borderColor = [UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0].CGColor;
    securityQuestionBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [securityQuestionBtn setBackgroundColor:[UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0]];
    [manageUsersBtn setBackgroundColor:[UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0]];
    [changePassword setBackgroundColor:[UIColor clearColor]];
    [securityQuestionview removeFromSuperview];
    [createUserView removeFromSuperview];
    settingTableView.hidden = YES;
    addUserBtn.hidden = YES;
    [changePasswordView setFrame:CGRectMake(77, 150, 871, 425)];
    [self.view addSubview:changePasswordView];

}


- (IBAction)securityQuestionAction:(id)sender {
    manageUsersBtn.layer.borderColor = [UIColor clearColor].CGColor;
    changePassword.layer.borderColor = [UIColor clearColor].CGColor;
    securityQuestionBtn.layer.borderColor = [UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0].CGColor;
    [manageUsersBtn setBackgroundColor:[UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0]];
    [changePassword setBackgroundColor:[UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0]];
    [securityQuestionBtn setBackgroundColor:[UIColor clearColor]];
    [changePasswordView removeFromSuperview];
    [createUserView removeFromSuperview];
    settingTableView.hidden = YES;
    addUserBtn.hidden = YES;
    [securityQuestionview setFrame:CGRectMake(77, 150, 871, 425)];
    [self.view addSubview:securityQuestionview];
}

- (IBAction)manageUsersAction:(id)sender {
    securityQuestionBtn.layer.borderColor = [UIColor clearColor].CGColor;
    changePassword.layer.borderColor = [UIColor clearColor].CGColor;
    manageUsersBtn.layer.borderColor = [UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0].CGColor;
    [changePassword setBackgroundColor:[UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0]];
    [securityQuestionBtn setBackgroundColor:[UIColor colorWithRed:165/255.0 green:18/255.0 blue:47/255.0 alpha:1.0]];
    [manageUsersBtn setBackgroundColor:[UIColor clearColor]];
    settingTableView.hidden = NO;
    addUserBtn.hidden = NO;
    [changePasswordView removeFromSuperview];
    [createUserView removeFromSuperview];
    [securityQuestionview removeFromSuperview];
    
}

- (IBAction)submitAction:(id)sender {
}

- (IBAction)securitySubmitAction:(id)sender {
}

-(void) setCreateView{
    mrMrsLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    manageVenuesLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    myBookingLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    myfeedbackLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    paymentLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    importLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    specialOfferLbl.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    firstNameTxt.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
     lastNameTxt.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
     emailTxt.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
     phoneTxt.font = [UIFont fontWithName:@"Lovelo" size:11.0f];
    createUserBtn.titleLabel.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    
    mrMrsLbl.layer.borderColor = [UIColor whiteColor].CGColor;
    mrMrsLbl.layer.borderWidth = 1.5;
    mrMrsLbl.layer.cornerRadius = 16.0;
    [mrMrsLbl setClipsToBounds:YES];
    
    createUserBtn.layer.borderColor = [UIColor clearColor].CGColor;
    createUserBtn.layer.borderWidth = 1.5;
    createUserBtn.layer.cornerRadius = 16.0;
    [createUserBtn setClipsToBounds:YES];
}
@end
