//
//  MoreTableViewCell.h
//  Finder_iPhoneApp
//
//  Created by Monika on 14/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowIcon;
@property (strong, nonatomic) IBOutlet UILabel *badgeIcon;
@end
