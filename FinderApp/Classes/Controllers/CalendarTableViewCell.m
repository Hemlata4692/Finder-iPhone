//
//  CalendarTableViewCell.m
//  Finder_iPhoneApp
//
//  Created by Monika on 25/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "CalendarTableViewCell.h"

@implementation CalendarTableViewCell
@synthesize eventNameLabel,eventTimeLabel;
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
    eventNameLabel.text=[eventDetails.eventName uppercaseString];
    eventTimeLabel.text=eventDetails.eventTime;
}
#pragma mark - end
@end
