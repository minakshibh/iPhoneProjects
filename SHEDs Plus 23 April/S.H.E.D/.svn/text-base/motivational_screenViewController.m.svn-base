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

@interface motivational_screenViewController ()

@end

@implementation motivational_screenViewController
@synthesize  data,databasePath,authorview,titlelbl,motivationTxtView,createhabit,continuebtn;

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
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"shed_db.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"query %@", queryString);
    NSLog(@"path : %@", dbPath);
    [database open];
    
    FMResultSet *results = [database executeQuery:queryString];
    
    while([results next]) {
        motivational *motiv_thought	= [[motivational alloc] init];
        motiv_thought.motivation = [results stringForColumn:@"motivational_thought"];
        motiv_thought.author = [results stringForColumn:@"author"];
        [motivationTxtView setText:[NSString stringWithFormat:@"""%@""",motiv_thought.motivation]];
        //UIFont *font1 = [UIFont fontWithMarkupDescription:@"font-family: Lucida Sans; font-size: 17px; font-weight: italic;"];
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHide:)];
    
    
    tap.delegate=self;
    tap.cancelsTouchesInView = NO;
    tap.numberOfTapsRequired = 1;
    
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
}
- (void)showHide:(id)sender
{
    NSUserDefaults *value = [NSUserDefaults standardUserDefaults];
    NSString *str = [value objectForKey:@"usage"];
    
    if([str isEqualToString:@"used"]){
        
        SHED_listViewController *shedlistView;
        
       
        
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController" bundle:nil];        //this is iphone 5 xib
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480) {
            shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_iphone4" bundle:nil];
                // this is iphone 4 xib
        }
        else{
            shedlistView=[[SHED_listViewController alloc] initWithNibName:@"SHED_listViewController_ipad" bundle:nil];
        }
        
     
        shedlistView.flag = 0;
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

@end
