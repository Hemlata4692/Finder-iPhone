//
//  SettingsViewCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESwitch.h"

@interface SettingsViewCell : UITableViewCell
//settingsCell
@property (weak, nonatomic) IBOutlet UIView *settingsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//proximityCell
@property (weak, nonatomic) IBOutlet UIView *proximityRadiusView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;

@end
