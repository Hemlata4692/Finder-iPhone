//
//  CalendarTableViewCell.m
//  Finder_iPhoneApp
//
//  Created by Monika on 25/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "CalendarTableViewCell.h"

@implementation CalendarTableViewCell
@synthesize eventNameLabel,eventTimeLabel,viewAgendaButton,userImage,userImageClickAction;
#pragma mark - Load nib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
#pragma mark - end

#pragma mark - Display data
-(void)displayData :(EventDataModel *)eventDetails indexPath:(int)indexPath
{
    [userImage setCornerRadius:userImage.frame.size.width/2];
    [viewAgendaButton setViewBorder:viewAgendaButton color:[UIColor colorWithRed:79.0/255.0 green:206.0/255.0 blue:195.0/255.0 alpha:1.0]];
    if ([eventDetails.eventDescription isEqualToString:@""]) {
        viewAgendaButton.hidden=YES;
    }
    else
    {
        viewAgendaButton.hidden=NO;
    }
    eventNameLabel.text=[eventDetails.eventName uppercaseString];
    eventTimeLabel.text=eventDetails.eventTime;
    if ([eventDetails.userImage isEqualToString:@""]) {
        userImage.image=[UIImage imageNamed:@"meeting_iconCalendar.png"];
        userImageClickAction.hidden=YES;
    }
    else {
        userImageClickAction.hidden=NO;
     __weak UIImageView *weakRef = userImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:eventDetails.userImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    }

}
#pragma mark - end
@end
