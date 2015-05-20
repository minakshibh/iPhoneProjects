//
//  AlbumSongsViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 02/04/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface AlbumSongsViewController : UIViewController
{
    NSString *albumName;
    NSString *albumId;
    NSString *artistName;
    NSArray *docPaths;
    NSString *documentsDir, *dbPath;
    FMDatabase *database;
}
- (IBAction)backBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *albumHeader;
@property (strong, nonatomic) IBOutlet UITableView *songsTableView;
@property (strong, nonatomic) IBOutlet NSString *albumName;
@property (strong, nonatomic) IBOutlet NSString *albumId;
@property (strong, nonatomic) IBOutlet NSString *artistName;

@end
