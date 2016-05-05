//
//  SettingsViewCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 19/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSliderPopover.h"
#import "MyButton.h"
#import "ASValueTrackingSlider.h"

@interface SettingsViewCell : UITableViewCell
//settingsCell
@property (weak, nonatomic) IBOutlet UIView *settingsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet MyButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightKnob;
@property (weak, nonatomic) IBOutlet UIImageView *leftKnob;

//proximityCell
@property (weak, nonatomic) IBOutlet UIView *proximityRadiusView;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *sliderView;

@end
