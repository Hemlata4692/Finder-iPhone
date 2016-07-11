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

#pragma mark - Display data
-(void)displayUserMessage:(MessageHistoryDataModel *)messageHistory indexPath:(int)indexPath rectSize:(CGSize)rectSize
{
    meUserDateLabel.translatesAutoresizingMaskIntoConstraints=YES;
    meUserMessageLabel.translatesAutoresizingMaskIntoConstraints=YES;
    incomingBubbleImage.translatesAutoresizingMaskIntoConstraints=YES;
  //outgoing
    
    CGFloat marginLeft = 20;
    CGFloat marginRight = 20;
    
   CGSize size = CGSizeMake(rectSize.width-20,999);
   CGRect textRect=[self setDynamicHeight:size textString:@"gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer hema" fontSize:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    meUserMessageLabel.numberOfLines = 0;
    
    //Bubble positions
    CGFloat bubble_x;
    CGFloat bubble_y = 5;
    CGFloat bubble_width = textRect.size.width;
    CGFloat bubble_height = textRect.size.height;
    meUserMessageLabel.text=@"gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer gv erger grg grgher gu ergrgr ghev erhyergv ergvhrugv ergvugvu gvyv v rjrgvu erhvergvuer hvrug ruhverug verhverv ierhvyerg vergvuy evehrvyg vuervgef vgv erhveruvregi fyer erg erygr erer hema";
    meUserMessageLabel.textColor=[UIColor redColor];
    meUserMessageLabel.backgroundColor=[UIColor clearColor];
    
    bubble_x = (rectSize.width-textRect.size.width)+marginLeft;
    
    incomingBubbleImage.image = [[UIImage imageNamed:@"outgoing"]
                                stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
    
    bubble_width = (textRect.size.width - bubble_x )+marginRight;
    
    incomingBubbleImage.frame = CGRectMake(bubble_x, bubble_y, bubble_width, bubble_height+20);
    meUserMessageLabel.frame=CGRectMake(bubble_x+5, bubble_y+5, bubble_width-5, textRect.size.height);
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
    otherUserDateLabel.translatesAutoresizingMaskIntoConstraints=YES;
    otherUserMessageLabel.translatesAutoresizingMaskIntoConstraints=YES;
    outgoingBubbleImage.translatesAutoresizingMaskIntoConstraints=YES;
}
@end
