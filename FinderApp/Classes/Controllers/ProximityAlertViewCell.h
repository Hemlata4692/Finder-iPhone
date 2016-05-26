//
//  ProximityAlertViewCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 13/05/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"

@interface ProximityAlertViewCell : UITableViewCell

//proximityRadiusCell
@property (weak, nonatomic) IBOutlet UIView *delegateRangeView;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *sliderView;

//proximityListCell
@property (weak, nonatomic) IBOutlet UIView *proximityListContainerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comapanyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *scheduleMeetingBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageBtn;

@end
