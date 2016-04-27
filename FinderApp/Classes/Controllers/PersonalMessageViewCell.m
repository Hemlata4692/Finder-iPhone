//
//  PersonalMessageViewCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PersonalMessageViewCell.h"

@implementation PersonalMessageViewCell
//meCell
@synthesize userMessageConatinerView,meUserDateLabel,meUserMessageLabel,meLabel;
//userCell
@synthesize otherUserName,otherUserDateLabel,otherUserMessageLabel,otherUserMessageConatinerView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
