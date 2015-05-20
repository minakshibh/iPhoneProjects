//
//  HistoryDetailViewController.m
//  TutorHelper
//
//  Created by Br@R on 30/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "HistoryTableViewCell.h"

@interface HistoryDetailViewController ()

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    historyListArray=[[NSMutableArray alloc]init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    for (int k=0;k<2;k++)
    {
        HistoryList*historyobj=[[HistoryList alloc]init];
        
        historyobj.month=@"March";
        historyobj.parent_id=@"123";
        historyobj.numbrOfLessons=@"10";
        historyobj.balance=@"$1234";
        historyobj.feesColllected=@"$1234";
        historyobj.feesDue=@"$122";
        [historyListArray addObject:historyobj];
    }
   
    totalOutstndngBalancLbl.text=@"$111111";
    feesCollectedLbl.text=@"$100";
    feesDueLbl.text=@"$200";
    
    sortByStr=@"month";
    [byMonthSortBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
    [byParentSortBtn setBackgroundColor:[UIColor whiteColor]];
    [byParentSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [byMonthSortBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    
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
    //    int row = indexPath.row;
    //    int section = indexPath.section;
    //    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
  //  HistoryList *histryObj = (HistoryList *)[historyListArray objectAtIndex:indexPath.row];
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)byMonthSortBtn:(id)sender {
    sortByStr=@"month";
    [byMonthSortBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
    [byParentSortBtn setBackgroundColor:[UIColor whiteColor]];
    [byParentSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [byMonthSortBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (IBAction)byParentSortBtn:(id)sender {
    sortByStr=@"parent";
    [byParentSortBtn setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:185.0f/255.0f blue:204.0f/255.0f alpha:1.0]];
    [byMonthSortBtn setBackgroundColor:[UIColor whiteColor]];
    [byMonthSortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [byParentSortBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    
}

- (IBAction)addCreditBtn:(id)sender {
}

- (IBAction)statementBtn:(id)sender {
}

- (IBAction)invoiceBtn:(id)sender {
}

- (IBAction)paymentBtn:(id)sender {
}
@end
