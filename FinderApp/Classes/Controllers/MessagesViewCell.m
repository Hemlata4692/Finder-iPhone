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

-(void)displayData:(ContactDataModel *)contactDetails indexPath:(int)indexPath {
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
@end
