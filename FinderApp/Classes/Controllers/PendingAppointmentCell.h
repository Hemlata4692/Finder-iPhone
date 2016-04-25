//
//  PendingAppointmentTableViewCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 25/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyButton.h"

@interface PendingAppointmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *pendingViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet MyButton *meetingTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet MyButton *cancelButton;

@end
