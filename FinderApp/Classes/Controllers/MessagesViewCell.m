//
//  MessagesViewCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 26/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "MessagesViewCell.h"

@implementation MessagesViewCell
//messgeCell
@synthesize messageViewContainer,userImage,userNameLabel,dateLabel,messageLabel,messageCountLabel;
//newMessageCell
@synthesize messageContainerView,userImageView,nameLabel,comapnyNameLabel;

#pragma mark - Laod nib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - end

#pragma mark - Messages
- (void)displayMessageData:(MessagesDataModel *)messageDetails indexPath:(int)indexPath rectSize:(CGSize)rectSize {
    [userImage setCornerRadius:userImage.frame.size.width/2];
    [messageCountLabel setCornerRadius:messageCountLabel.frame.size.width/2];
    userNameLabel.text=messageDetails.userName;
    messageLabel.text=messageDetails.lastMessage;
    if ([messageDetails.messageCount isEqualToString:@"0"]) {
        messageCountLabel.hidden=YES;
    }
    else {
        messageCountLabel.hidden=NO;
        messageCountLabel.text=messageDetails.messageCount;
    }
    
    __weak UIImageView *weakRef = userImage;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:messageDetails.userProfileImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userImage setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    NSDate *date = [dateFormatter dateFromString:messageDetails.messageDate];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd/mm/yy"];
    NSString *newDateString = [dateFormatter2 stringFromDate:date];
    dateLabel.text=newDateString;

}
#pragma mark - ends

#pragma mark - Display contacts
- (void)displayData:(ContactDataModel *)contactDetails indexPath:(int)indexPath {
//    nameLabel.translatesAutoresizingMaskIntoConstraints=YES;
//    CGSize size = CGSizeMake(rectSize.width-157,100);
//    CGRect textRect = [contactDetails.contactName
//                       boundingRectWithSize:size
//                       options:NSStringDrawingUsesLineFragmentOrigin
//                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Bold" size:14.0]}
//                       context:nil];
//    nameLabel.numberOfLines = 0;
//    nameLabel.frame = textRect;
//    nameLabel.frame =CGRectMake(78, 13, textRect.size.width, textRect.size.height);
//    [nameLabel setLabelBorder:nameLabel color:[UIColor whiteColor]];
    
    nameLabel.text=contactDetails.contactName;
    comapnyNameLabel.text=contactDetails.companyName;
    [userImageView setCornerRadius:userImageView.frame.size.width/2];
    __weak UIImageView *weakRef = userImageView;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:contactDetails.userImage]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [userImageView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"user_thumbnail.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakRef.contentMode = UIViewContentModeScaleAspectFill;
        weakRef.clipsToBounds = YES;
        weakRef.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];

}
#pragma mark - end
@end
