//
//  MarketingTableViewCell.m
//  uco
//
//  Created by Br@R on 18/03/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "MarketingTableViewCell.h"

@implementation MarketingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)name :(NSString*)emailAddrss :(NSString*)contactNum :(NSString*)guestUser:(NSString*)imageUrlStr
{
    userNameLbl.text=name;
    userEmailLbl.text=[NSString stringWithFormat:@"%@",emailAddrss];
    userContactLbl.text=[NSString stringWithFormat:@"%@",contactNum];
    FrequentGuestLbl.text=[NSString stringWithFormat:@"%@",guestUser];
    userNameLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    userEmailLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    userContactLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    FrequentGuestLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    CALayer * l = [userImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:40.0];
    if (![imageUrlStr isEqualToString:@""])
    {
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        objactivityindicator.center = CGPointMake((userImageView.frame.size.width/2),(userImageView.frame.size.height/2));
        [userImageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            
        NSURL *imageURL=[NSURL URLWithString:[imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
        UIImage *imgData=[UIImage imageWithData:tempData];
        dispatch_async(dispatch_get_main_queue(), ^
                {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [userImageView setImage:imgData];
                                   [objactivityindicator stopAnimating];
                               }
                               else
                               {
                                   [objactivityindicator stopAnimating];
                                   
                               }
                           });
        });
    }
}



-(BOOL) textfieldShouldReturn :(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

@end
