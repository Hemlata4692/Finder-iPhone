//
//  CalendarTableViewCell.h
//  Finder_iPhoneApp
//
//  Created by Monika on 25/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@end
