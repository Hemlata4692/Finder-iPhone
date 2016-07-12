//
//  ProximityAlertViewCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 13/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "ProximityAlertViewCell.h"

@implementation ProximityAlertViewCell

#pragma mark - Load nib
@synthesize nameLabel,comapanyNameLabel;
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
-(void)displayData:(ContactDataModel *)proximityDetails indexPath:(int)indexPath
{
    nameLabel.text=proximityDetails.contactName;
    comapanyNameLabel.text=proximityDetails.companyName;
}

#pragma mark - end
@end
