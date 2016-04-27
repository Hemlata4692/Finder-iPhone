//
//  MessagesViewCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 26/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MessagesViewCell.h"

@implementation MessagesViewCell
//messgeCell
@synthesize messageViewContainer,userImage,userNameLabel,dateLabel,messageLabel,messageCountLabel;
//newMessageCell
@synthesize messageContainerView,userImageView,nameLabel,comapnyNameLabel;

#pragma mark - Laod nib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - end
@end
