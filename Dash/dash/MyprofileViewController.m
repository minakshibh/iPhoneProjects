//
//  MyprofileViewController.m
//  dash
//
//  Created by Br@R on 08/05/15.
//  Copyright (c) 2015 Krishna_Mac_1. All rights reserved.
//

#import "MyprofileViewController.h"
#import "registerViewController.h"
#import "customerProfileViewController.h"

@interface MyprofileViewController ()

@end

@implementation MyprofileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    profileImg.layer.borderColor = [UIColor grayColor].CGColor;
    profileImg.layer.borderWidth = 1.5;
    profileImg.layer.cornerRadius = 10.0;
    [profileImg setClipsToBounds:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchProfileInfoFromDatabase];
}
-(void) fetchProfileInfoFromDatabase
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"Dash.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    NSString *queryString;
    queryString = [NSString stringWithFormat:@"Select * FROM userProfile where userId=\"%@\" ",[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    
    FMResultSet *results = [database executeQuery:queryString];
    while([results next])
    {
        nameLbl.text =[results stringForColumn:@"name"];
        emailLbl.text =[NSString stringWithFormat:@"%@",[results stringForColumn:@"email"]];
        contactLbl.text =[NSString stringWithFormat:@"%@",[results stringForColumn:@"contact"]];
        NSString*imgUrl=[results stringForColumn:@"image"];
        creditCardLbl.text=[NSString stringWithFormat:@"%@",[results stringForColumn:@"creditCardNumber"]];
        
        NSURL *imageURL = [NSURL URLWithString:imgUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                profileImg.image = [UIImage imageWithData:imageData];
            });
        });
    }
    [database close];
}

- (IBAction)profileImageEditBttn:(id)sender
{
    customerProfileViewController *vehiclelistVC = [[customerProfileViewController alloc] initWithNibName:@"customerProfileViewController" bundle:nil];
    vehiclelistVC.registrationType = @"customer";
    vehiclelistVC.backBtnHiden=@"NO";
    
    [self.navigationController pushViewController:vehiclelistVC animated:NO];
 }

- (IBAction)profileEditBttn:(id)sender {
    registerViewController *registerVC = [[registerViewController alloc] initWithNibName:@"registerViewController" bundle:nil];
    registerVC.trigger=@"edit";

    [self.navigationController pushViewController:registerVC animated:NO];
}

- (IBAction)BackBttn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
