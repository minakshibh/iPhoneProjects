//
//  greetingTableViewCell.m
//  uco
//
//  Created by Krishna Mac Mini 2 on 01/04/15.
//  Copyright (c) 2015 Krishnais. All rights reserved.
//

#import "greetingTableViewCell.h"

@implementation greetingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabelText:(NSString*)name :(NSString*)table :(NSString*)people :(NSString*)specialRequest :(NSString*)timing :(NSString*)imageUrlStr
{
    nameLbl.text=name;
    tableLabl.text=table;
    specialReqstLbl.text=specialRequest;
    peopleLbl.text=people;
    
    timeLbl.text=timing;
    
    
    nameLbl.font = [UIFont fontWithName:@"Lovelo" size:15.0f];
    tableLabl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    specialReqstLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    peopleLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];
    timeLbl.font = [UIFont fontWithName:@"Lovelo" size:13.0f];

    
    
    
    if (![imageUrlStr isEqualToString:@""])
    {
        UIActivityIndicatorView *objactivityindicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        objactivityindicator.center = CGPointMake((imageView.frame.size.width/2),(imageView.frame.size.height/2));
        [imageView addSubview:objactivityindicator];
        [objactivityindicator startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            
            NSURL *imageURL=[NSURL URLWithString:[imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
            UIImage *imgData=[UIImage imageWithData:tempData];
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               if (tempData!=nil && [imgData isKindOfClass:[UIImage class]])
                               {
                                   [imageView setImage:imgData];
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
@end
