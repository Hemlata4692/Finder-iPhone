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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)displayConferenceListData :(ConferenceListDataModel *)conferenceList indexPath:(int)indexPath rectSize:(CGSize)rectSize
{
//    CGSize size = CGSizeMake(rectSize.width-105,300);
//    CGRect textRect = [conferenceList.conferenceName
//                       boundingRectWithSize:size
//                       options:NSStringDrawingUsesLineFragmentOrigin
//                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:16.0]}
//                       context:nil];
//    conferenceNameLabel.numberOfLines = 0;
//    conferenceNameLabel.frame = textRect;
//    //dynamic framing of objects
//    conferenceNameLabel.frame =CGRectMake(97, conferenceNameLabel.frame.origin.y, rectSize.width-105, textRect.size.height);
    
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

@end
