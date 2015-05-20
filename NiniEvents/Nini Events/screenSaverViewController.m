//
//  screenSaverViewController.m
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/24/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import "screenSaverViewController.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"


@interface screenSaverViewController ()

@end

@implementation screenSaverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.navigator.navigationBarHidden = YES;
    //[self fetchImages];
    screenSaverImages = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    imagesUrlArray = [[NSMutableArray alloc] initWithObjects:[defaults valueForKey:@"ImageArray"], nil];
    imageNameStringsArray =[imagesUrlArray objectAtIndex:0];
   
    scr=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scr.tag = 1;
    [scr setUserInteractionEnabled:NO];
    scr.autoresizingMask=UIViewAutoresizingNone;
    [self.view addSubview:scr];
    [self setupScrollView:scr];
    pgCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 600, 1024, 150)];
    [pgCtr setTag:12];
    [pgCtr setBackgroundColor:[UIColor clearColor]];
    pgCtr.autoresizingMask=UIViewAutoresizingNone;
    pgCtr.numberOfPages=[imageNameStringsArray count];
    [self.view addSubview:pgCtr];
    
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:letterTapRecognizer];
    
    
}
- (void)highlightLetter:(UITapGestureRecognizer*)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    [appdelegate.navigator dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"Tap detected on the view");//By tag, you can find out where you had typed.
}
- (void)setupScrollView:(UIScrollView*)scrMain {
    // we have 10 images here.
    // we will add all images into a scrollView & set the appropriate size.
    
    for (int i=0; i<[imageNameStringsArray count]; i++) {
        // create image
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageNameStringsArray objectAtIndex:i]]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img1 = [UIImage imageWithData:data];
        // create imageView
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((i)*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height)];
        // set scale to fill
        imgV.contentMode=UIViewContentModeScaleToFill;
        // set image
        imgV.image = img1;
        // apply tag to access in future
        imgV.tag=i+1;
        // add to scrollView
        [scrMain addSubview:imgV];
    }
    // set the content size to 10 image width
    [scrMain setContentSize:CGSizeMake(scrMain.frame.size.width * [imageNameStringsArray count], scrMain.frame.size.height)];
    // enable timer after each 2 seconds for scrolling.
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
    // access the scroll view with the tag
    UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    // same way, access pagecontroll access
    UIPageControl *pgCtr1 = (UIPageControl*) [self.view viewWithTag:12];
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrMain.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/scrMain.frame.size.width) + 1 ;
    // if page is not 10, display it
    if( nextPage!=[imageNameStringsArray count] )  {
        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr1.currentPage=nextPage;
        // else start sliding form 1 :)
    } else {
        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pgCtr1.currentPage=0;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Json Delegate

@end
