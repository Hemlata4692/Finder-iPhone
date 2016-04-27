//
//  PersonalMessageViewCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalMessageViewCell : UITableViewCell
//meCell
@property (weak, nonatomic) IBOutlet UIView *userMessageConatinerView;
@property (weak, nonatomic) IBOutlet UILabel *meLabel;
@property (weak, nonatomic) IBOutlet UILabel *meUserMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *meUserDateLabel;

//otherCell
@property (weak, nonatomic) IBOutlet UIView *otherUserMessageConatinerView;
@property (weak, nonatomic) IBOutlet UILabel *otherUserName;
@property (weak, nonatomic) IBOutlet UILabel *otherUserMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherUserDateLabel;

@end
