//
//  InstructionsViewController.m
//  TutorHelper
//
//  Created by Br@R on 16/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "InstructionsViewController.h"
#import "SplashViewController.h"
@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    self.navigationController.navigationBar.hidden=YES;
    imagCount=0;
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

- (IBAction)skipActionBtn:(id)sender
{
    SplashViewController*splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController: splashVc animated:YES];
}

- (IBAction)nextActionBtn:(id)sender {
    imagCount++;
    if (imagCount==4)
    {
        SplashViewController*splashVc=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController: splashVc animated:YES];
        return;
    }
    instructionImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"instruction%d",imagCount]];
   
}
@end
