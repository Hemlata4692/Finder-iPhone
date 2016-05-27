//
//  SettingsViewCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "SettingsViewCell.h"

@implementation SettingsViewCell

@synthesize proximityRadiusView,sliderView,leftKnob,rightKnob,switchBtn;

@synthesize settingsContainerView,nameLabel;
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
@end
