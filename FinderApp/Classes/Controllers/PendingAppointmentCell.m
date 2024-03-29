//
//  PendingAppointmentTableViewCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 25/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PendingAppointmentCell.h"


@implementation PendingAppointmentCell
@synthesize pendingViewContainer,userImageView,userName,meetingTitle,cancelButton,timeLabel,pendingUserName;

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
//display data
- (void)displayData :(PendingAppointmentDataModel *)data indexPath:(int)indexPath rectSize:(CGSize)rectSize{
    [userImageView setCornerRadius:userImageView.frame.size.width/2];
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:data.meetingPersonImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
    pendingUserName.text=data.meetingPerson;
    userName.text=data.meetingPerson;
    [meetingTitle setTitle:data.meetingDescription forState:UIControlStateNormal];
    NSArray *tempArray=[data.meetingTime componentsSeparatedByString:@"-"];
    NSMutableString *string = [[NSMutableString alloc]init];
    [string appendString:[NSString stringWithFormat:@"%@ - %@",[tempArray objectAtIndex:0],[tempArray objectAtIndex:1]]];
    timeLabel.text=string;
}
#pragma mark - end
@end
