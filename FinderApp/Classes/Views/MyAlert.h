//
//  MyAlert.h
//  CustomAlert
//
//  Created by Rohit Kumar Modi on 12/03/16.
//  Copyright © 2016 Rohit Kumar Modi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAlert.h"
@protocol MyAlertDelegate <NSObject>
@optional
- (void) myAlertDelegateAction:(CustomAlert*)myAlert option:(int)option reason:(NSString *)reason;
- (void) OncallDelegateMethod;
@end

@interface MyAlert : NSObject{
    id <MyAlertDelegate> _delegate;
    CustomAlert *customAlertObj;
    BOOL isTextViewCheck;
}
@property (nonatomic,strong) id delegate;
//- (void)callOptionalMethod:(UIView*)myView frame:(CGRect)myFrame;
- (void)dismissAlertView:(UIView*)myView;
- (instancetype)initWithTitle:(NSString*)titleText myView:(UIView*)myView delegate:(id)delegate message:(NSString*)messageText viewBtnText:(NSString*)viewBtnText acceptBtnText:(NSString*)acceptBtnText declineBtnText:(NSString*)declineBtnText isTextField:(BOOL)isTextField;
@property(nonatomic,retain)UIView *alertView;

@end
