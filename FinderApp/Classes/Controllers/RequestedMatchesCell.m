//
//  RequestedMatchesCell.m
//  Finder_iPhoneApp
//
//  Created by Ranosys on 04/08/16.
//  Copyright © 2016 Ranosys. All rights reserved.
//

#import "RequestedMatchesCell.h"

@implementation RequestedMatchesCell
@synthesize name;
@synthesize companyName;
@synthesize cancelButton;
@synthesize containerView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)displayData :(MatchesDataModel *)allMatchesDetails {
    
    name.translatesAutoresizingMaskIntoConstraints=YES;
    companyName.translatesAutoresizingMaskIntoConstraints = YES;
    float nameHeight = [self getDynamicLabelHeight:[allMatchesDetails userName] font:[UIFont fontWithName:@"Roboto-Bold" size:16] widthValue:[[UIScreen mainScreen] bounds].size.width - 8 - 115]; //Here width = [[UIScreen mainScreen] bounds].size.width - 8(left padding) - 172(right padding)
    name.numberOfLines = 0;
    
//    name.backgroundColor = [UIColor redColor];
//    companyName.backgroundColor = [UIColor greenColor];
    float companyNameHeight = [self getDynamicLabelHeight:[allMatchesDetails userCompanyName] font:[UIFont fontWithName:@"Roboto-Regular" size:15] widthValue:[[UIScreen mainScreen] bounds].size.width - 8 - 115];//Here width = dynamicSize + 8(left space) + 115(right space)
    companyName.numberOfLines = 0;

    name.frame = CGRectMake(8, 20, [[UIScreen mainScreen] bounds].size.width - 8 - 115, nameHeight);
    companyName.frame = CGRectMake(8, name.frame.origin.y + name.frame.size.height, [[UIScreen mainScreen] bounds].size.width - 8 - 115, companyNameHeight);
    [name setLabelBorder:name color:[UIColor whiteColor]];
    name.text=allMatchesDetails.userName;
    
    companyName.text=allMatchesDetails.userCompanyName;
}

#pragma mark - Get dynamic label height according to given string
- (float)getDynamicLabelHeight:(NSString *)text font:(UIFont *)font widthValue:(float)widthValue{
    
    CGSize size = CGSizeMake(widthValue,500);
    CGRect textRect=[text
                     boundingRectWithSize:size
                     options:NSStringDrawingUsesLineFragmentOrigin
                     attributes:@{NSFontAttributeName:font}
                     context:nil];
    return textRect.size.height;
}
#pragma mark - end
@end
