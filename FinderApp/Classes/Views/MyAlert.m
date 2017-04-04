//
//  MyAlert.m
//  CustomAlert
//
//  Created by Rohit Kumar Modi on 12/03/16.
//  Copyright © 2016 Rohit Kumar Modi. All rights reserved.
//

#import "MyAlert.h"

@implementation MyAlert
@synthesize alertView;

- (instancetype)initWithTitle:(NSString*)titleText myView:(UIView*)myView delegate:(id)delegate message:(NSString*)messageText viewBtnText:(NSString*)viewBtnText acceptBtnText:(NSString*)acceptBtnText declineBtnText:(NSString*)declineBtnText isTextField:(BOOL)isTextField{
    isTextViewCheck = isTextField;
    _delegate = delegate;
    customAlertObj=[[CustomAlert alloc] initWithFrame:myView.frame title:titleText message:messageText viewBtnText:viewBtnText acceptBtnText:acceptBtnText declineBtnText:declineBtnText isTextField:isTextField];
    customAlertObj.mainView.backgroundColor = [UIColor clearColor];
    [customAlertObj.viewBtnAction addTarget:self action:@selector(viewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [customAlertObj.acceptBtnAction addTarget:self action:@selector(acceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [customAlertObj.declineBtnAction addTarget:self action:@selector(declineButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    alertView = myView;
    [alertView addSubview:customAlertObj.mainView];
    return self;
}

- (void)dismissAlertView:(UIView*)myView{
    customAlertObj.mainView.hidden = YES;
    [customAlertObj removeFromSuperview];
}

- (IBAction)viewButtonAction:(UIButton *)sender {
    if ([customAlertObj.messageTextView isFirstResponder]) {
        [customAlertObj.messageTextView resignFirstResponder];
    }
    [_delegate myAlertDelegateAction:customAlertObj option:0 reason:customAlertObj.messageTextView.text];
}

- (IBAction)acceptButtonAction:(UIButton *)sender {
    if ([customAlertObj.messageTextView isFirstResponder]) {
        [customAlertObj.messageTextView resignFirstResponder];
    }
    [_delegate myAlertDelegateAction:customAlertObj option:1 reason:customAlertObj.messageTextView.text];
}
- (IBAction)declineButtonAction:(UIButton *)sender {
    if ([customAlertObj.messageTextView isFirstResponder]) {
        [customAlertObj.messageTextView resignFirstResponder];
    }
    if (isTextViewCheck && ([customAlertObj.messageTextView.text isEqualToString:@""] || customAlertObj.messageTextView.text.length == 0)) {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:@"Ok" actionBlock:^(void) {
        }];
        [alert showWarning:nil title:@"Alert" subTitle:@"Please enter message for cancel." closeButtonTitle:nil duration:0.0f];
    }
    else {
        
        [_delegate myAlertDelegateAction:customAlertObj option:2 reason:customAlertObj.messageTextView.text];
    }
}
@end
