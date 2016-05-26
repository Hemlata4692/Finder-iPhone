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
@synthesize userMessageConatinerView,meUserDateLabel,meUserMessageLabel,meLabel,incomingBubbleImage;
//otherUserCell
@synthesize otherUserName,otherUserDateLabel,otherUserMessageLabel,otherUserMessageConatinerView,outgoingBubbleImage;

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
-(void)layoutView : (CGRect )rect
{
    meUserDateLabel.translatesAutoresizingMaskIntoConstraints=YES;
    meUserMessageLabel.translatesAutoresizingMaskIntoConstraints=YES;
    incomingBubbleImage.translatesAutoresizingMaskIntoConstraints=YES;
  
    otherUserDateLabel.translatesAutoresizingMaskIntoConstraints=YES;
    otherUserMessageLabel.translatesAutoresizingMaskIntoConstraints=YES;
    outgoingBubbleImage.translatesAutoresizingMaskIntoConstraints=YES;
    
    
    CGFloat marginLeft = 5;
    CGFloat marginRight = 2;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 0;
    CGFloat bubble_width;
    CGFloat bubble_height = (meUserMessageLabel.frame.size.height);
    
    //    if (_message.sender == MessageSenderMyself)
    //    {
    
    bubble_x = (incomingBubbleImage.frame.origin.x -marginLeft);
    
    incomingBubbleImage.image = [[UIImage imageNamed:@"outgoing"]
                                stretchableImageWithLeftCapWidth:15 topCapHeight:14];
    
    
    bubble_width = meUserMessageLabel.frame.size.width - bubble_x - marginRight;
    //bubble_width -= [self isStatusFailedCase]?[self fail_delta]:0.0;
    // }
    // else
    //    {
    //        bubble_x = marginRight;
    //
    //        _bubbleImage.image = [[UIImage imageNamed:@"bubbleSomeone"]
    //                              stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    //
    //        bubble_width = MAX(_textView.frame.origin.x + _textView.frame.size.width + marginLeft,
    //                           _timeLabel.frame.origin.x + _timeLabel.frame.size.width + 2*marginLeft);
    //    }
    
    incomingBubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height);
     incomingBubbleImage.autoresizingMask = meUserMessageLabel.autoresizingMask;
    

}
@end
