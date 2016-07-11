//
//  PersonalMessageViewCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageHistoryDataModel.h"

@interface PersonalMessageViewCell : UITableViewCell
//meCell
@property (weak, nonatomic) IBOutlet UIView *userMessageConatinerView;
@property (weak, nonatomic) IBOutlet UILabel *meLabel;
@property (weak, nonatomic) IBOutlet UILabel *meUserMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *meUserDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *incomingBubbleImage;
-(void)displayUserMessage:(MessageHistoryDataModel *)messageHistory indexPath:(int)indexPath rectSize:(CGSize)rectSize;

//otherCell
@property (weak, nonatomic) IBOutlet UIView *otherUserMessageConatinerView;
@property (weak, nonatomic) IBOutlet UILabel *otherUserName;
@property (weak, nonatomic) IBOutlet UILabel *otherUserMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherUserDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *outgoingBubbleImage;
-(void)displayOtherUserMessage:(MessageHistoryDataModel *)messageHistoryData indexPath:(int)indexPath rectSize:(CGSize)rectSize;
@end
