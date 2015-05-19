

//
//  motivational_screenViewController.m
//  S.H.E.D
//
//  Created by Krishna_Mac on 12/19/13.
//  Copyright (c) 2013 Krishna_Mac. All rights reserved.
//

#import "motivational_screenViewController.h"
#import "AppDelegate.h"
#import "SHED_listViewController.h"
#import "createahabitViewController.h"
#import "motivational.h"
#import "WelcomeViewController.h"



#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 60
#define kColumnMargin 10


@interface motivational_screenViewController ()

@end

@implementation motivational_screenViewController
@synthesize  data,databasePath,authorview,titlelbl,motivationTxtView,createhabit,continuebtn,gratArchievArray;

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
    [super viewDidLoad];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHide:)];
    tap.delegate=self;
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
    
    NSDate *date1 = [NSDate date];
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString*todaysDate = [formatter1 stringFromDate:date1];
    NSUserDefaults * value = [NSUserDefaults standardUserDefaults];
    NSDate*currentDate=[formatter1 dateFromString:todaysDate];
    
    autoArchieve=[value valueForKey:@"autoArchieve"];
    keepHistry=[value valueForKey:@"keepArchieveHisty"];
    autoArchieveDate =[value valueForKey: @"autoArchivDate" ];
    emailid=[value valueForKey:@"Emailid"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *autoArcDate=[formatter1 dateFromString:autoArchieveDate];
    NSLog(@"autoarcDate..%@",autoArcDate);
    
    tenDaysAgo = [autoArcDate dateByAddingTimeInterval:+10*24*60*60];
    NSString *tenDaysStr=[formatter1 stringFromDate:tenDaysAgo];
    twentyDaysAgo = [autoArcDate dateByAddingTimeInterval:+20*24*60*60];
    NSString *twentyDaysStr=[formatter1 stringFromDate:twentyDaysAgo];
    thirtyDaysAgo = [autoArcDate dateByAddingTimeInterval:+30*24*60*60];
    NSString *thirtyDaysStr=[formatter1 stringFromDate:thirtyDaysAgo];
    
    NSLog(@"10 days ago: %@", tenDaysStr);
    NSLog(@"20 days ago: %@", twentyDaysStr);
    NSLog(@"30 days ago: %@", thirtyDaysStr);
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int numberDays;
    if(autoArcDate !=nil)
    {
        NSDateComponents *totaldays = [gregorianCalendar components:NSDayCalendarUnit
                                                           fromDate:autoArcDate
                                                             toDate:date1
                                                            options:0];
        numberDays=[totaldays day];
        NSLog(@"Number of work shed days %d",numberDays);
    }
   
    tenDaysLater = [currentDate dateByAddingTimeInterval:-10*24*60*60];
    twentyDaysLater = [currentDate dateByAddingTimeInterval:-20*24*60*60];
    thirtyDaysLater = [currentDate dateByAddingTimeInterval:-30*24*60*60];
 
    if ([autoArchieve isEqualToString:@"10 days"] && numberDays>=10)
    {
        UIAlertView *Alrt=[[UIAlertView alloc ]initWithTitle:@"Hello" message:[NSString stringWithFormat:@"It's been %@ since you've archived your Gratitudes. Do you want to archive your gratitudes now?",autoArchieve] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",  nil];
        Alrt.tag=1;
        [value setObject:todaysDate forKey:@"autoArchivDate"];
        [Alrt show];
    }
    if ([autoArchieve isEqualToString:@"20 days"] && numberDays>=20)
    {
        UIAlertView *Alrt=[[UIAlertView alloc ]initWithTitle:@"Hello" message:[NSString stringWithFormat:@"It's been %@ since you've archived your Gratitudes. Do you want to archive your gratitudes now?",autoArchieve] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",  nil];
        Alrt.tag=1;
        [value setObject:todaysDate forKey:@"autoArchivDate"];
        [Alrt show];
    }
    if ([autoArchieve isEqualToString:@"30 days"] && numberDays>=30)
    {
        UIAlertView *Alrt=[[UIAlertView alloc ]initWithTitle:@"Hello" message:[NSString stringWithFormat:@"It's been %@ since you've archived your Gratitudes. Do you want to archive your gratitudes now?",autoArchieve] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue",  nil];
        Alrt.tag=1;
        [value setObject:todaysDate forKey:@"autoArchivDate"];
        [Alrt show];
    }
    
    createhabit = [[createahabitViewController alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.navigator.navigationBarHidden = YES;
    if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480))
    {
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:28]];
        [continuebtn setFont: [UIFont fontWithName:@"Helvetica Neue" size:16]];
        authorview.font = [UIFont fontWithName:@"Lucida Sans" size:100];
    }
    else
    {
        [titlelbl setFont: [UIFont fontWithName:@"Helvetica Neue" size:85]];
        [continuebtn setFont: [UIFont fontWithName:@"Lucida Sans" size:35]];
        authorview.font = [UIFont fontWithName:@"Lucida Sans" size:200];
    }
    [[continuebtn layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[continuebtn layer] setBorderWidth:0.5];
    [[continuebtn layer] setCornerRadius:5];
    
    //[motivationView setFont: [UIFont fontWithName:@"NoticiaText-Bold" size:40]];
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Fetchin the Thoughts from the table ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    int randomNumber = [self getRandomNumberBetween:1 to:82];
    NSString *queryString = [NSString stringWithFormat:@"Select * FROM Thoughts where id= '%d'",randomNumber];
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"query %@", queryString);
    NSLog(@"path : %@", dbPath);
    [database open];
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        motivational *motiv_thought	= [[motivational alloc] init];
        motiv_thought.motivation = [results stringForColumn:@"motivational_thought"];
        motiv_thought.author = [results stringForColumn:@"author"];
        [motivationTxtView setText:[NSString stringWithFormat:@"""%@""",motiv_thought.motivation]];
        motivationTxtView.textAlignment = NSTextAlignmentCenter;
        
        [authorview setText:[NSString stringWithFormat:@"%@",motiv_thought.author]];
      
        if (([[UIScreen mainScreen] bounds].size.height == 568) ||([[UIScreen mainScreen] bounds].size.height == 480)) {
            [authorview setFont: [UIFont fontWithName:@"Lucida Sans" size:17]];
            motivationTxtView.font =[UIFont fontWithName:@"Lucida Sans" size:17];
        }
        else{
            [authorview setFont: [UIFont fontWithName:@"Lucida Sans" size:32]];
            motivationTxtView.font =[UIFont fontWithName:@"Lucida Sans" size:32];
        }
        authorview.textAlignment = NSTextAlignmentRight;
        NSLog(@"Motivational Aurhor: %@", authorview.text);
    }
    [database close];
}
- (void)showHide:(id)sender
{
    NSUserDefaults *value = [NSUserDefaults standardUserDefaults];
    NSString *str = [value objectForKey:@"usage"];
    
    if([str isEqualToString:@"used"]){
        
        SHED_listViewController *shedlistView;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];
            //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
        }
        else{
            shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:nil];
        }
     
        shedlistView.flag = 0;
        shedlistView.countFlag=1;
        shedlistView.sortingString=[NSString stringWithFormat:@"Cronological"];
        [self.navigationController pushViewController:shedlistView animated:NO];
    }
    else
    {
        NSString *str1 = [NSString stringWithFormat:@"used"];
        [value setObject:str1 forKey:@"usage"];
        WelcomeViewController *welcomeVc;
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            welcomeVc=[[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
                //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            welcomeVc=[[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
        }
        else{
            welcomeVc=[[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController_ipad" bundle:nil];
        }
        [self.navigationController pushViewController:welcomeVc animated:NO];
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    return (int)from + arc4random() % (to-from+1);
}


//-(void)presentnextView
//{
//    SHED_listViewController *shedlistView;
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];        //this is iphone 5 xib
//    }
//    else if([[UIScreen mainScreen] bounds].size.height == 480) {
//        shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
//        // this is iphone 4 xib
//    }
//    shedlistView.flag = 0;
//    shedlistView.sortingString=[NSString stringWithFormat:@"Cronological"];
//    [self.navigationController pushViewController:shedlistView animated:NO];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)archieveBtn
{
    gratArchievArray=[[NSMutableArray alloc]init];
    fileName = [self getPDFFileName];
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"select * from Gratitude "];
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        NSLog(@"I AM HERE");
        Gratitude *gratitudeoc	= [[Gratitude alloc] init];
        gratitudeoc.grat_id = [results intForColumn:@"id"];
        gratitudeoc.gratitude = [results stringForColumn:@"gratitude"];
        gratitudeoc.gratitudedate = [results stringForColumn:@"gratitude_date"];
        
        NSLog(@"grat id :: %d", gratitudeoc.grat_id);
        NSLog(@"grat name :: %@", gratitudeoc.gratitude);
        NSLog(@"grat date :: %@", gratitudeoc.gratitudedate);
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* gratDate = [dateFormatter dateFromString:gratitudeoc.gratitudedate];
        NSLog(@"date.%@",gratDate);
        NSLog(@"I AM HERE");
        
        if ([keepHistry isEqualToString:@"No History"])
        {
            [gratArchievArray addObject:gratitudeoc];
        }
        else if ([keepHistry isEqualToString:@"10 days"])
        {
            if ([gratDate compare:tenDaysLater] == NSOrderedAscending)
            {
                [gratArchievArray addObject:gratitudeoc];
            }
        }
        else if ([keepHistry isEqualToString:@"20 days"])
        {
            if([gratDate compare:twentyDaysLater]==NSOrderedAscending)
            {
                [gratArchievArray addObject:gratitudeoc];
            }
        }
        else if ([keepHistry isEqualToString:@"30 days"])
        {
            if([gratDate compare:thirtyDaysLater]==NSOrderedAscending)
            {
                [gratArchievArray addObject:gratitudeoc];
            }
        }
    }
    
    NSMutableArray *gratArray=[[NSMutableArray alloc]init];
    int gratCount=gratArchievArray.count;
    if ( gratCount==0) {
        if ([keepHistry isEqualToString:@"No History"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"There is no gratitude to archive." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:[NSString stringWithFormat:@"There is no gratitude to archive after %@.",keepHistry ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    else{
        for (int i=0; i<gratCount;i++)
        {
            Gratitude *myGrat =[gratArchievArray objectAtIndex:i];
            NSString *gratId=[NSString stringWithFormat:@"%d",myGrat.grat_id];
            NSArray *array=[NSArray arrayWithObjects:myGrat.gratitudedate,myGrat.gratitude, nil];
            [gratArray addObject:array];
            NSLog(@"gratId.%@",gratId);
            //NSString* queryString = [NSString stringWithFormat:@"DELETE FROM Gratitude WHERE id=%d" ,myGrat.grat_id];
            //[database executeUpdate:queryString];
        }
        [database close];
        UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
        CGContextRef context = UIGraphicsGetCurrentContext();
        int currentPage = 0;
        CGFloat maxWidth = kDefaultPageWidth - kMargin * 2;
        CGFloat maxHeight = kDefaultPageHeight - kMargin * 2;
        CGFloat classNameMaxWidth = maxWidth / 2;
        CGFloat gradeMaxWidth = (maxWidth / 2) - kColumnMargin;
        UIFont* gratitudeFont= [UIFont boldSystemFontOfSize:17];
        CGFloat currentPageY = 0;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        int yOrigin=currentPageY+90 ;
        NSDate *now=[NSDate date];
        NSDateFormatter *df=[[NSDateFormatter alloc]init];
        [df setDateFormat:@"MM/dd/yyyy"];
        NSString *date=[[NSString alloc]initWithString:[df stringFromDate:now]];
        NSString *ShedlblStr=[NSString stringWithFormat:@"SHEDs(List of gratitudes till %@)",date];
        UIFont* shedLblFont = [UIFont systemFontOfSize:25];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        
        [ShedlblStr drawInRect:CGRectMake(20,10, 600, 30) withFont:shedLblFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        int rowheight=90;
        for (int i=0;i<gratArray.count;i++)
        {
            currentPageY = kMargin;
            NSArray* name = [gratArray  objectAtIndex:i ];
            NSString* date = [name objectAtIndex:0];
            NSString* gratitude = [name objectAtIndex:1];
            CGSize size = [gratitude sizeWithFont:[UIFont fontWithName:@"Helvetica Neue" size:17]];
            NSString* gratitudesDate = @"Gratitude Date";
            NSString* gratitudes = @"Gratitude";
            
            [gratitudesDate drawAtPoint:CGPointMake(kMargin, currentPageY-5) forWidth:maxWidth withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping];
            [gratitudes drawAtPoint:CGPointMake(kMargin+280, currentPageY-5) forWidth:maxWidth withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping];
            currentPageY += size.height;
            
            CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
            CGContextMoveToPoint(context, kMargin, currentPageY);
            CGContextAddLineToPoint(context, kDefaultPageWidth - kMargin, currentPageY);
            CGContextStrokePath(context);
            
            size = [gratitude sizeWithFont:gratitudeFont constrainedToSize:CGSizeMake(classNameMaxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

            if (yOrigin > maxHeight) {
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
                currentPageY = kMargin;
                yOrigin=90;
            }

            //  int lngth=gratitude.length;
            double textLength=gratitude.length/100;
            double height =size.height;
            [self pdfFileHeight:gratitude heightForRow:&height font:gratitudeFont];
            rowheight=height;
            if (gratitude.length>50)
            {
                [date drawInRect:CGRectMake(kMargin, yOrigin, classNameMaxWidth, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
                [gratitude drawInRect:CGRectMake(kMargin + classNameMaxWidth + kColumnMargin-120, yOrigin, gradeMaxWidth+120, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
            }
            else
            {
                [date drawInRect:CGRectMake(kMargin, yOrigin, classNameMaxWidth, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
                [gratitude drawInRect:CGRectMake(kMargin + classNameMaxWidth + kColumnMargin-120, yOrigin, gradeMaxWidth+120, rowheight) withFont:gratitudeFont lineBreakMode:NSLineBreakByWordWrapping  alignment:NSTextAlignmentLeft];
            }
            currentPageY += size.height;
            yOrigin +=rowheight+20;
            // increment the page number.
            currentPage++;
        }

        // end and save the PDF.
        UIGraphicsEndPDFContext();
        UIActionSheet*actionsheet = [[UIActionSheet alloc] initWithTitle:@"Would you like to preview or email this PDF? Mailing the pdf would Archive your gratitudes." delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Preview",@"Email", nil];
        [actionsheet showInView:self.view];
    }
}


- (CGFloat)pdfFileHeight:(NSString *)text heightForRow:(double *)height font:(UIFont *)font {
    NSString *labelText = text;
    CGFloat labelWidth =*height ;
    CGSize constrainToSize = (CGSize){.width = labelWidth, .height = MAXFLOAT};
    CGSize textSize = [labelText sizeWithFont:font constrainedToSize:constrainToSize lineBreakMode: NSLineBreakByTruncatingTail];
    return textSize.height ;
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
        {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:@"Your mail sent successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertview show];
            docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentsDir = [docPaths objectAtIndex:0];
            dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
            
            database = [FMDatabase databaseWithPath:dbPath];
            [database open];
            NSString *queryString=[NSString stringWithFormat:@"DELETE FROM Gratitude"];
            [database executeUpdate:queryString];
            [database close];
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
        {
            UIAlertView *alertview1=[[UIAlertView alloc]initWithTitle:@"SHEDs" message:[NSString stringWithFormat:@"Mail sent failure: %@", [error localizedDescription]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertview1 show];
        }
            break;
        default:
            break;
    }
    [[NSFileManager defaultManager] removeItemAtPath:fileName error: NULL];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(NSString*)getPDFFileName
{
    fileName = @"Gratitudes.PDF";
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    return pdfFileName;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 1)
    {
        NSLog(@"%ld",(long)buttonIndex);
        [self archieveBtn];
    }
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:fileName];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Action Sheet button %ld", (long)buttonIndex);
    if (buttonIndex == 1) {
        // present a preview of this PDF File.
        QLPreviewController* preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        [self presentModalViewController:preview animated:YES];
    }
    else if(buttonIndex == 2)
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        NSMutableArray *toReceipents =[NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@",emailid]];
        [picker setToRecipients:toReceipents];
        [picker setSubject:[NSString stringWithFormat:@"Gratitudes List"]];
        [picker setMessageBody:@"Gratitudes List" isHTML:YES];
        NSData *fileData = [NSData dataWithContentsOfFile:fileName];
        NSString *mimeType = @"application/pdf";
        [picker addAttachmentData:fileData mimeType:mimeType fileName:@"Gratitudes"];
        
        if (picker != nil) {
            [self presentViewController:picker animated:YES completion:nil];
        }
        else{
            NSLog(@"hgjdhg");
        }
    }
}

@end
