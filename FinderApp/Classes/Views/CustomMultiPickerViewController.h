//
//  CustomMultiPickerViewController.h
//  CustomMultipickerProject
//
//  Created by Ranosys on 22/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomMultiPickerViewControllerDelegate <NSObject>
@optional
- (void)selectionDelegateAction:(NSMutableDictionary*)pickerDictData isOtherTrue:(BOOL)isOtherTrue selectedData:(NSMutableArray *)selectedData tag:(int)tag;
- (void)cancelDelegateMethod;
@end
@interface CustomMultiPickerViewController : UIViewController{
    
    id <CustomMultiPickerViewControllerDelegate> _delegate;
}
@property (strong, nonatomic) IBOutlet UIView *mainview;
@property (nonatomic,strong) id delegate;
@property (assign, nonatomic) float viewHeight;
@property (assign, nonatomic) int pickertag;
@property (strong, nonatomic) NSMutableDictionary *pickerDicData;
@property (strong, nonatomic) NSMutableArray *pickerArrayData;

@end
