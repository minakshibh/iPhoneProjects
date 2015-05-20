//
//  StudentDetailViewController.m
//  TutorHelper
//
//  Created by Br@R on 05/05/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "StudentDetailViewController.h"
#import "StudentList.h"
#import "AddStudentViewController.h"


@interface StudentDetailViewController ()

@end

@implementation StudentDetailViewController
@synthesize StudentObj,parentObj;

- (void)viewDidLoad {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    studentNameLbl.text=StudentObj.studentName;
    parentNameLbl.text=parentObj.parentName;
    studentIdLbl.text= [NSString stringWithFormat:@"Student Id : %@",StudentObj.studentId];
    emailAddressLbl.text=StudentObj.studentEmail;
    contactNumbrLbl.text=StudentObj.studentContact;
    feesLbl.text=StudentObj.fees;
    addressLbl.text=StudentObj.address;
    notesLbl.text=StudentObj.notes;
    if (parentObj==nil)
    {
        notes.hidden=YES;
        notesLbl.hidden=YES;
        [self getProfileDataFromDataBase];
        backView.frame=CGRectMake(backView.frame.origin.x,backView.frame.origin.y,backView.frame.size.width, backView.frame.size.height-40);

    }
    
    
    [super viewDidLoad];
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

- (IBAction)editBttn:(id)sender
{
    AddStudentViewController*addStdentVC=[[AddStudentViewController alloc]initWithNibName:@"AddStudentViewController" bundle:[NSBundle mainBundle]];
    if (parentObj==nil)
    {
        addStdentVC.trigger=@"Parent";
    }
    else{
        addStdentVC.trigger=@"Tutor";
        addStdentVC.parentListObj=parentObj;
    }

    addStdentVC.triggervalue= @"edit";
    addStdentVC.studentListObj= StudentObj;
    addStdentVC.fromView=@"studentDetail";
    
    [self.navigationController pushViewController:addStdentVC animated:YES];
}

- (IBAction)backBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)emailBttn:(id)sender {
    
    NSString*emailAddress=StudentObj.studentEmail;
    
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
    [self presentViewController:composer animated:YES completion:NULL];
}



- (IBAction)callBttn:(id)sender {
    
    NSString*contactNum=StudentObj.studentContact;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contactNum ]];
    [[UIApplication sharedApplication] openURL:url];

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


-(void)getProfileDataFromDataBase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"TutorHelper.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
   NSString* parentIdStr=[[NSUserDefaults standardUserDefaults ]valueForKey:@"pin"];
    NSString*queryString = [NSString stringWithFormat:@"Select * FROM ParentProfile where parentId=\"%@\" ",parentIdStr];
    
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        parentNameLbl.text =[results stringForColumn:@"name"];
    }
    [database close];
}




@end
