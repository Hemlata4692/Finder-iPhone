//
//  MessagesViewCell.h
//  Finder_iPhoneApp
//
//  Created by Hema on 26/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDataModel.h"
#import "MessagesDataModel.h"

@interface MessagesViewCell : UITableViewCell
//messageCell
@property (weak, nonatomic) IBOutlet UIView *messageViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageCountLabel;

-(void)displayMessageData:(MessagesDataModel *)messageDetails indexPath:(int)indexPath rectSize:(CGSize)rectSize;

//newMessageCell
@property (weak, nonatomic) IBOutlet UIView *messageContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *comapnyNameLabel;

-(void)displayData:(ContactDataModel *)contactDetails indexPath:(int)indexPath;
@end
