//
//  UIView+RoundedCorner.m
//  WheelerButler
//
//  Created by Ashish A. Solanki on 24/01/15.
//
//

#import "UIView+RoundedCorner.h"

@implementation UIView (RoundedCorner)

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)setTextBorder:(UITextField *)textField color:(UIColor *)color
{
    textField.layer.borderWidth = 1.0f;
    textField.layer.borderColor = color.CGColor;
}

- (void)setTextViewBorder:(UITextView *)textView color:(UIColor *)color
{
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = color.CGColor;
}

- (void)setViewBorder: (UIView *)view  color:(UIColor *)color {
   
    view.layer.borderColor =color.CGColor;
    view.layer.borderWidth = 1.5f;
}

- (void)setLabelBorder: (UIView *)view  color:(UIColor *)color {
    
    view.layer.borderColor =color.CGColor;
    view.layer.borderWidth = 0.5f;
}

-(void)setBottomBorder: (UIView *)view color:(UIColor *)color
{
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 2.0f);
    
    bottomBorder.backgroundColor = color.CGColor;
    
    [view.layer addSublayer:bottomBorder];
}
-(void)addShadow: (UIView *)view color:(UIColor *)color
{
    view.layer.shadowColor =color.CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowOpacity = 1;
    view.layer.shadowRadius = 1.0;

}
-(void)addShadowWithCornerRadius: (UIView *)view color:(UIColor *)color
{
    [view.layer setCornerRadius:view.frame.size.width/2];
    [view.layer setShadowOffset:CGSizeMake(0, 3)];
    [view.layer setShadowOpacity:0.4];
    [view.layer setShadowRadius:3.0f];
    [view.layer setShouldRasterize:YES];
    
    
}
@end
