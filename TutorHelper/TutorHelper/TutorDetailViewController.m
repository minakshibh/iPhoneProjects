//
//  TutorDetailViewController.m
//  TutorHelper
//
//  Created by Br@R on 05/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "TutorDetailViewController.h"
#import "StudentDetailTableViewCell.h"
#import "AddLessonViewController.h"

@interface TutorDetailViewController ()

@end

@implementation TutorDetailViewController
@synthesize tutorListObj;

- (void)viewDidLoad
{
    studentListArray=[[NSMutableArray alloc]init];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    nameLbl.text=tutorListObj.Name;
    tutorIdLbl.text=[NSString stringWithFormat:@"Tutor Id: %@",tutorListObj.TutorId];
    contactNumberLbl.text=tutorListObj.ContactNumber;
    emailAddressLbl.text=tutorListObj.Email;
    addressLbl.text=tutorListObj.Address;
    studentsLbl.text=[NSString stringWithFormat:@"%lu Students",(unsigned long)tutorListObj.feeDetailList.count];
    
    for ( int n=0;n<tutorListObj.feeDetailList.count;n++)
    {
        docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDir = [docPaths objectAtIndex:0];
        dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
        database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        
        NSString*studentId=[[tutorListObj. feeDetailList objectAtIndex:n]valueForKey:@"student_id"];

        NSString *queryString;
        
        NSString* parentId=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
        
        queryString = [NSString stringWithFormat:@"Select * FROM StudentList where parent_id=\"%@\"  and student_id=\"%@\"",parentId,studentId];
        
        
        FMResultSet *results = [database executeQuery:queryString];
       // studentListArray=[[NSMutableArray alloc]init];
            
        while([results next])
        {
            StudentList*StudentObj=[[StudentList alloc]init];
                
            StudentObj.studentId =[results stringForColumn:@"student_id"];
            StudentObj.parentId =[results stringForColumn:@"parent_id"];
            StudentObj.studentName =[results stringForColumn:@"name"];
            StudentObj.gender =[results stringForColumn:@"gender"];
            StudentObj.studentEmail =[results stringForColumn:@"email"];
            StudentObj.address =[results stringForColumn:@"address"];
            StudentObj.studentContact=[results stringForColumn:@"contact_info"];
            StudentObj.fees=[[tutorListObj.feeDetailList objectAtIndex:n]valueForKey:@"fee"];
            StudentObj.isActiveInMonth=[results stringForColumn:@"isActiveInMonth"];
            StudentObj.notes=[results stringForColumn:@"notes"];
            
            [studentListArray addObject:StudentObj];
        }
        [database close];
    }

    [studentsTableView reloadData];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBttn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)callBtn:(id)sender {
    NSString*contactNum=tutorListObj.ContactNumber;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contactNum ]];
    [[UIApplication sharedApplication] openURL:url];

}

- (IBAction)emailBttn:(id)sender {
    
    NSString*emailAddress=tutorListObj.Email;
    
    NSString * subject = @"";
    //email body
    NSString * body = @"";
    //recipient(s)
    NSArray * recipients = [NSArray arrayWithObjects:emailAddress, nil];
    
    //create the MFMailComposeViewController
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    if (composer==nil) {
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:@"Please configure you email id to send mail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    composer.mailComposeDelegate = self;
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:NO];
    [composer setToRecipients:recipients];
    [self presentViewController:composer animated:YES completion:NULL];}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [studentListArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"ArticleCellID";
    
    StudentDetailTableViewCell *cell = (StudentDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    studentListObj = [studentListArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    [cell setLabelText:studentListObj.studentName :[NSString stringWithFormat:@"Email     : %@",studentListObj.studentEmail] :[NSString stringWithFormat:@"Contact : %@",studentListObj.studentContact]:[NSString stringWithFormat:@"Fees      : $%@",studentListObj.fees]];
    
    
    /////// EDIT BUTTON //////////
//    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    if (IS_IPHONE_6P || IS_IPHONE_6)
//    {
//        editBtn.frame = CGRectMake(375.0f, 19.0f,20.0f,20.0f);
//    }
//    else{
//        editBtn.frame = CGRectMake(270.0f, 16.0f,20.0f,20.0f);
//    }
//    editBtn.tag = indexPath.row;
//    [editBtn addTarget:self action:@selector(EditActionBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImage *buttonBackgroundShowDetail= [UIImage imageNamed:@"edit-icon.png"];
//    [editBtn setBackgroundColor:[UIColor clearColor]];
//    [editBtn setBackgroundImage:buttonBackgroundShowDetail forState:UIControlStateNormal];
//    [cell.contentView addSubview:editBtn];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"newIndexPath: %ld", (long)indexPath.row);
    StudentList *studentObj ;
    
    studentObj = (StudentList *)[studentListArray objectAtIndex:indexPath.row];
    
    
//    StudentDetailViewController*studentDetailVc=[[StudentDetailViewController alloc]initWithNibName:@"StudentDetailViewController" bundle:[NSBundle mainBundle]];
//    studentDetailVc.StudentObj=studentObj;
//    studentDetailVc.parentObj=parentObj;
//    
//    [self.navigationController pushViewController:studentDetailVc  animated:YES];
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIAlertView *mailAlert = [[UIAlertView alloc] initWithTitle:@"Status:" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    switch (result)
    {
            
        case MFMailComposeResultSaved:
        {
            mailAlert.message = @"Message Saved";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
            // [mailAlert show];
        }
            break;
        case MFMailComposeResultSent:
        {
            mailAlert.message = @"Message Sent";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [[NSUserDefaults standardUserDefaults] setValue:@"Mail" forKey:@"Mail"];
            [Alert show];
            // [mailAlert show];
        }
            break;
        case MFMailComposeResultFailed:
        {
            mailAlert.message = @"Message Failed";
            UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:KalertTittle message:mailAlert.message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [Alert show];
            //[mailAlert show];
        }
            break;
        default:
            break;
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)addLessonBttn:(id)sender {
    
    AddLessonViewController*addLessonVc=[[AddLessonViewController alloc]initWithNibName:@"AddLessonViewController" bundle:[NSBundle mainBundle]];
    addLessonVc.trigger=@"Parent";
    addLessonVc.tutorIDstr=tutorListObj.TutorId;
    [self.navigationController pushViewController: addLessonVc animated:YES];
}

@end
