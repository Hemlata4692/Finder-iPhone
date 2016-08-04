//
//  CustomAlert.m
//  CustomAlert
//
//  Created by Rohit Kumar Modi on 12/03/16.
//  Copyright © 2016 Rohit Kumar Modi. All rights reserved.
//

#import "CustomAlert.h"
#import "MyAlert.h"

@interface CustomAlert(){
    
    float scrollTextView;
}

@end
@implementation CustomAlert
@synthesize mainView, title, viewBtnAction, acceptBtnAction,declineBtnAction, messageLabel, backView, myAlertBackView,reason;
//done=acceptBtnAction
-(id)initWithFrame:(CGRect)frame title:(NSString*)titleText message:(NSString*)messageText viewBtnText:(NSString*)viewBtnText acceptBtnText:(NSString*)acceptBtnText declineBtnText:(NSString*)declineBtnText isTextField:(BOOL)isTextField
{
    self=[super initWithFrame:frame];
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:@"CustomAlert" owner:self options:nil];
        mainView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        NSLog(@"%f",self.mainView.frame.size.height);
        
        backView.translatesAutoresizingMaskIntoConstraints = YES;
        myAlertBackView.translatesAutoresizingMaskIntoConstraints = YES;
        title.translatesAutoresizingMaskIntoConstraints = YES;
        messageLabel.translatesAutoresizingMaskIntoConstraints = YES;
        viewBtnAction.translatesAutoresizingMaskIntoConstraints = YES;
        acceptBtnAction.translatesAutoresizingMaskIntoConstraints = YES;
        declineBtnAction.translatesAutoresizingMaskIntoConstraints = YES;
        reason.translatesAutoresizingMaskIntoConstraints = YES;
        backView.frame = CGRectMake(0, 0, mainView.frame.size.width, mainView.frame.size.height);
        myAlertBackView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 300);
        title.frame = CGRectMake(0, 30, myAlertBackView.frame.size.width, 30);
        title.text = titleText;
        if ([messageText isEqualToString:@""]) {
            
             messageLabel.frame = CGRectMake(10, title.frame.origin.y + title.frame.size.height + 8, myAlertBackView.frame.size.width - 20, 0);
            messageLabel.text = messageText;
            messageLabel.hidden = YES;
        }
        else{
        
            CGSize size = CGSizeMake(myAlertBackView.frame.size.width - 20,165);
            CGRect textRect = [messageText
                               boundingRectWithSize:size
                               options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Regular" size:14]}
                               context:nil];
            messageLabel.numberOfLines = 0;
            
            if (textRect.size.height < 26) {
                textRect.size.height = 25;
            }
            messageLabel.frame = CGRectMake(10, title.frame.origin.y + title.frame.size.height + 8, myAlertBackView.frame.size.width - 20, textRect.size.height);
            messageLabel.text = messageText;
            messageLabel.hidden = NO;
        }
        
        if (isTextField) {
             reason.frame = CGRectMake(10, messageLabel.frame.origin.y + messageLabel.frame.size.height + 8, myAlertBackView.frame.size.width - 20, 30);
        }
        else {
             reason.frame = CGRectMake(10, messageLabel.frame.origin.y + messageLabel.frame.size.height + 8, myAlertBackView.frame.size.width - 20, 0);
        }
        if ([acceptBtnText isEqualToString:@""] ) {
            
            viewBtnAction.frame = CGRectMake(10, reason.frame.origin.y + reason.frame.size.height + 14,(myAlertBackView.frame.size.width-40)/2, 40);
            viewBtnAction.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:139.0/255.0 blue:37.0/255.0 alpha:1.0];
            declineBtnAction.frame = CGRectMake(viewBtnAction.frame.origin.x+viewBtnAction.frame.size.width+15, reason.frame.origin.y + reason.frame.size.height + 14, (myAlertBackView.frame.size.width-40)/2, 40);
            acceptBtnAction.hidden = YES;
        }
        else{
        
            viewBtnAction.frame = CGRectMake(10, reason.frame.origin.y + reason.frame.size.height + 14,(myAlertBackView.frame.size.width-20)/3-10, 40);
            acceptBtnAction.frame = CGRectMake(viewBtnAction.frame.origin.x+viewBtnAction.frame.size.width + 15, reason.frame.origin.y + reason.frame.size.height + 14, (myAlertBackView.frame.size.width-20)/3-10, 40);
            declineBtnAction.frame = CGRectMake(acceptBtnAction.frame.origin.x+acceptBtnAction.frame.size.width + 15, reason.frame.origin.y + reason.frame.size.height + 14, (myAlertBackView.frame.size.width-20)/3-10, 40);
           // acceptBtnAction.hidden = NO;
        }
        
        if ([acceptBtnText isEqualToString:@""]) {
            [viewBtnAction setTitle:viewBtnText forState:UIControlStateNormal];
            [declineBtnAction setTitle:declineBtnText forState:UIControlStateNormal];
        }
        else{
        
            [viewBtnAction setTitle:viewBtnText forState:UIControlStateNormal];
            [acceptBtnAction setTitle:acceptBtnText forState:UIControlStateNormal];
            [declineBtnAction setTitle:declineBtnText forState:UIControlStateNormal];
        }
        
        float alertViewHeight = viewBtnAction.frame.origin.y + viewBtnAction.frame.size.height + 20;
         myAlertBackView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, alertViewHeight);
        viewBtnAction.layer.cornerRadius =  acceptBtnAction.layer.cornerRadius = declineBtnAction.layer.cornerRadius = 2.0f;
        viewBtnAction.layer.masksToBounds =  acceptBtnAction.layer.masksToBounds =declineBtnAction.layer.masksToBounds = YES;
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CustomAlert" owner:self options:nil];
        
    }
    return self;
}
@end
