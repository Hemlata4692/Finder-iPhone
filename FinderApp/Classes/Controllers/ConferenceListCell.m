//
//  ConferenceListCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 23/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ConferenceListCell.h"

@implementation ConferenceListCell
@synthesize conferenceStartDate,conferenceStartMonth,conferenceEndDate,conferenceEndMonth,conferenceNameLabel;

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

#pragma mark - Display data in cell
-(void)displayConferenceListData :(ConferenceListDataModel *)conferenceList indexPath:(int)indexPath rectSize:(CGSize)rectSize{
    conferenceNameLabel.text=conferenceList.conferenceName;
    NSArray *dateStrings = [conferenceList.conferenceDate componentsSeparatedByString:@" - "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:[dateStrings objectAtIndex:0]];
    NSDate *endDate = [dateFormatter dateFromString:[dateStrings objectAtIndex:1]];
    [dateFormatter setDateFormat:@"MMM"];
    conferenceStartMonth.text=[[dateFormatter stringFromDate:startDate] uppercaseString];
    conferenceEndMonth.text=[[dateFormatter stringFromDate:endDate]uppercaseString];
    [dateFormatter setDateFormat:@"dd"];
    conferenceStartDate.text=[dateFormatter stringFromDate:startDate];
    conferenceEndDate.text=[dateFormatter stringFromDate:endDate];
}
#pragma mark - end
@end
