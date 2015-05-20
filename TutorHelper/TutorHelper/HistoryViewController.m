//
//  HistoryViewController.m
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryDetailViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    historyListArray=[[NSMutableArray alloc]init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    for (int k=0;k<3;k++)
    {
        HistoryList*historyobj=[[HistoryList alloc]init];
       
        historyobj.month=@"JAN";
        historyobj.parent_id=@"123";
        historyobj.numbrOfLessons=@"10";
        historyobj.balance=@"$1234";
        historyobj.feesColllected=@"$1234";
        historyobj.feesDue=@"$122";
        [historyListArray addObject:historyobj];
    }

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [historyListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 122;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    historyListObj=[[HistoryList alloc]init];
    
    historyListObj = [historyListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:historyListObj.month :historyListObj.numbrOfLessons :historyListObj.balance :historyListObj.feesColllected :historyListObj.feesDue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    
    HistoryDetailViewController *histryDetailVc=[[HistoryDetailViewController alloc]initWithNibName:@"HistoryDetailViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:histryDetailVc animated:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end
