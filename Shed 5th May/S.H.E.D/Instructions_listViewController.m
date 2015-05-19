//
//  Instructions_listViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac_3 on 08/01/14.
//  Copyright (c) 2014 Krishna_Mac. All rights reserved.
//

#import "Instructions_listViewController.h"
#import "homescreenViewController.h"
#import "AppDelegate.h"
#import "instruction_objectclass.h"
#import "FMDatabase.h"
#import "instructionDetailViewController.h"
@interface Instructions_listViewController ()

@end

@implementation Instructions_listViewController
@synthesize instruction_table,instructionObj,inst_list,instructLabel;

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
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [instructLabel setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];

    }
    else{
        [instructLabel setFont: [UIFont fontWithName:@"Helvetica Neue" size:65]];

    }
  
    inst_list=[[NSMutableArray alloc]init];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM instruction"];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSLog(@"query %@", queryString);
    FMResultSet *results = [database executeQuery:queryString];
    while([results next]) {
        instructionObj	= [[instruction_objectclass alloc] init];
        instructionObj.instruction_id = [results stringForColumn:@"instruction_id"];
        instructionObj.instruction_list = [results stringForColumn:@"instruction_list"];
        instructionObj.instruction_detail = [results stringForColumn:@"instruction_detail"];

        [inst_list addObject:instructionObj.instruction_list];
    }
    NSLog(@"list.. %@",inst_list);
    [database close];

//instructionObj =[[instruction_objectclass alloc]init];
//    instructionObj.instruction_id=[results stringForColumn:@"instruction_id"];
//    NSLog(@"%@",instructionObj.instruction_id);
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [inst_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       // cell=[[UITableViewCell alloc]initWithFrame:CGRectMake(100,0,cell.frame.size.width,cell.frame.size.height)];
        
    }
    UIImageView *gratimgup;

  
   
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)){
        [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:17]];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(300, 18,7, 10)];

    }
    else{
        [cell.textLabel setFont:[UIFont fontWithName:@"Lucida Sans" size:35]];
        gratimgup = [[UIImageView alloc] initWithFrame:CGRectMake(700, 35,16, 27)];
       
    }
    
      cell.textLabel.text=[inst_list objectAtIndex:indexPath.row];
    gratimgup.image = [UIImage imageNamed:@"arrow.png"];

    [cell.contentView addSubview:gratimgup];

    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundView =[[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"list-bg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    
        return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    instructionDetailViewController *instDetailVC;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        instDetailVC = [[instructionDetailViewController alloc]initWithNibName:@"instructionDetailViewController" bundle:Nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        instDetailVC = [[instructionDetailViewController alloc]initWithNibName:@"instructionDetailViewController_iphone4" bundle:Nil];
        // this is iphone 4 xib
    }
    else{
        instDetailVC = [[instructionDetailViewController alloc]initWithNibName:@"instructionDetailViewController_ipad" bundle:Nil];
        // this is ipad xib

    }
    instDetailVC.insObjClass=[inst_list objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:instDetailVC animated:YES];
    
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender
{
    homescreenViewController *home;
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController" bundle:nil];
        //this is iphone 5 xib
    }
    else if([[UIScreen mainScreen] bounds].size.height == 480) {
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_iphone4" bundle:nil];
        // this is iphone 4 xib
    }
    else{
        home = [[homescreenViewController alloc] initWithNibName:@"homescreenViewController_ipad" bundle:nil];
        // this is iphone 4 xib
   
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [self.navigationController pushViewController:home animated:NO];

}

- (IBAction)postToFacebook:(id)sender {
    AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.facebookConnect=YES;
    [appDelegate facebookIntegration];
}
@end
