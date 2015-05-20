//
//  requestSongViewController.h
//  Karaoke
//
//  Created by Krishna_Mac_1 on 11/25/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface requestSongViewController : UIViewController<NSXMLParserDelegate>
{
    NSMutableString *tempString;
    NSString *message;
}
@property (weak, nonatomic) IBOutlet UITextField *requestedSongTxt;
- (IBAction)requestSongBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *disabledImgView;
@property (weak, nonatomic) IBOutlet UITextView *requestSongsTxtView;
- (IBAction)backBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLbl;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@end
