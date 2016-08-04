//
//  CustomAlert.h
//  CustomAlert
//
//  Created by Rohit Kumar Modi on 12/03/16.
//  Copyright © 2016 Rohit Kumar Modi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface CustomAlert : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewBtnAction;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtnAction;
@property (strong, nonatomic) IBOutlet UIView *myAlertBackView;
@property (weak, nonatomic) IBOutlet UIButton *declineBtnAction;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *messageTextView;

-(id)initWithFrame:(CGRect)frame title:(NSString*)titleText message:(NSString*)messageText viewBtnText:(NSString*)viewBtnText acceptBtnText:(NSString*)acceptBtnText declineBtnText:(NSString*)declineBtnText isTextField:(BOOL)isTextField;
@end
