//
//  PersonalMessageViewCell.m
//  Finder_iPhoneApp
//
//  Created by Hema on 27/04/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "PersonalMessageViewCell.h"

@implementation PersonalMessageViewCell
//meCell
@synthesize userMessageConatinerView,meUserMessageLabel,incomingBubbleImage;
//otherUserCell
@synthesize otherUserMessageLabel,otherUserMessageConatinerView,outgoingBubbleImage;

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

#pragma mark - Display data
-(void)displayUserMessage:(MessageHistoryDataModel *)messageHistory indexPath:(int)indexPath rectSize:(CGSize)rectSize
{
   
    meUserMessageLabel.translatesAutoresizingMaskIntoConstraints=YES;
    incomingBubbleImage.translatesAutoresizingMaskIntoConstraints=YES;
    
    CGSize size = CGSizeMake(rectSize.width-50,999);
    CGRect textRect=[self setDynamicHeight:size textString:messageHistory.userMessage fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    meUserMessageLabel.numberOfLines = 0;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 5;
    CGFloat bubble_width = textRect.size.width;
    CGFloat bubble_height = textRect.size.height;
    meUserMessageLabel.text=messageHistory.userMessage;
    
    meUserMessageLabel.backgroundColor=[UIColor clearColor];
    
    bubble_x = ((rectSize.width)-(textRect.size.width+20));
    
    incomingBubbleImage.image = [[UIImage imageNamed:@"outgoing"]
                                 stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    
    bubble_width = textRect.size.width+20;
    
    incomingBubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height+20);
    meUserMessageLabel.frame=CGRectMake(bubble_x+5, bubble_y+5, bubble_width-10, textRect.size.height);
    incomingBubbleImage.autoresizingMask = meUserMessageLabel.autoresizingMask;
    
    
}
-(CGRect)setDynamicHeight:(CGSize)rectSize textString:(NSString *)textString fontSize:(UIFont *)fontSize{
    CGRect textHeight = [textString
                         boundingRectWithSize:rectSize
                         options:NSStringDrawingUsesLineFragmentOrigin
                         attributes:@{NSFontAttributeName:fontSize}
                         context:nil];
    return textHeight;
}

#pragma mark - end

-(void)displayOtherUserMessage:(MessageHistoryDataModel *)messageHistoryData indexPath:(int)indexPath rectSize:(CGSize)rectSize {
    otherUserMessageLabel.translatesAutoresizingMaskIntoConstraints=YES;
    outgoingBubbleImage.translatesAutoresizingMaskIntoConstraints=YES;
    CGSize size = CGSizeMake(rectSize.width-50,999);
    CGRect textRect=[self setDynamicHeight:size textString:messageHistoryData.userMessage fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    otherUserMessageLabel.numberOfLines = 0;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 5;
    CGFloat bubble_width = textRect.size.width;
    CGFloat bubble_height = textRect.size.height;
    otherUserMessageLabel.text=messageHistoryData.userMessage;
    
    otherUserMessageLabel.backgroundColor=[UIColor clearColor];
    
    bubble_x = 10;
    
    outgoingBubbleImage.image = [[UIImage imageNamed:@"incoming"]
                                 stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    
    bubble_width = textRect.size.width+20;
    
    outgoingBubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height+20);
    otherUserMessageLabel.frame=CGRectMake(bubble_x+10, bubble_y+5, bubble_width-10, textRect.size.height);
    incomingBubbleImage.autoresizingMask = otherUserMessageLabel.autoresizingMask;

}
@end
