//
//  splashScreenViewController.h
//  Nini Events
//
//  Created by Krishna_Mac_1 on 12/8/14.
//  Copyright (c) 2014 Krishna_Mac_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "menuOC.h"
#import "FMDatabase.h"
#import <MediaPlayer/MediaPlayer.h>

@interface splashScreenViewController : UIViewController
{
    NSMutableData *webData;
    UIActivityIndicatorView *activityIndicator;
    NSString *result, *message, *lastUpdatedCities, *supportEmail, *categoryType;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    int webServiceCode;
    menuOC * menuObj;
    NSMutableArray *menuDetails, *menuCategoryIdsArray;
    FMDatabase *database;
}
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end
